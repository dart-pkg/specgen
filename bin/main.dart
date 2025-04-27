#! /usr/bin/env my-dart

import 'dart:core';
import 'dart:io' as io__;
import 'package:dart_scan/dart_scan.dart' as dart_scan__;
import 'package:sys/sys.dart' as sys__;
import 'package:std/command_runner.dart' as run__;

//import 'package:yaml_edit/yaml_edit.dart' as yaml_edit__;
import 'package:yaml_magic/yaml_magic.dart' as yaml_magic__;
import 'package:output/output.dart';

final String yamlTemplate = '''
name:
description:
version: 0.0.1
homepage:
repository:
environment:
  sdk: ^3.7.2
dependencies:
dev_dependencies:
''';

// extension on yaml_edit__.YamlEditor {
//   bool hasPath(List<String> $path) {
//     try {
//       parseAt($path);
//       return true;
//     } catch ($e) {
//       return false;
//     }
//   }
// }

Future<void> main(List<String> args) async {
  String? version;
  if (args.isNotEmpty) {
    version = args[0];
  }
  String cwd = sys__.getCwd();
  String fn = sys__.pathFileName(cwd);
  if (fn == 'bin' || fn == 'lib' || fn == 'test') {
    cwd = sys__.pathDirectoryName(cwd);
    sys__.setCwd(cwd);
  }
  echo(cwd, 'cwd');
  bool isFlutter = false;
  String dart = 'dart';
  // yaml_edit__.YamlEditor $ye = yaml_edit__.YamlEditor(yamlTemplate);
  String defaultProjectName = sys__.pathFileName(cwd);
  defaultProjectName = defaultProjectName
      .replaceAll('.', '_')
      .replaceAll('-', '_');
  // $ye.update(['name'], defaultProjectName);
  // $ye.update(['description'], '$defaultProjectName project');
  yaml_magic__.YamlMagic yamlMagic;
  if (sys__.fileExists('pubspec.yaml')) {
    yamlMagic = yaml_magic__.YamlMagic.load('pubspec.yaml');
  } else {
    yamlMagic = yaml_magic__.YamlMagic.fromString(
      content: yamlTemplate,
      path: 'pubspec.yaml',
    );
    yamlMagic['name'] = defaultProjectName;
    yamlMagic['description'] = '$defaultProjectName project';
  }
  if (yamlMagic['flutter'] != null) {
    isFlutter = true;
    dart = 'flutter';
  }
  if (version != null) {
    yamlMagic['version'] = version;
  }
  String yaml = yamlMagic.toString();
  List<String> lines1 = sys__.textToLines(yaml);
  List<String> lines2 = <String>[];
  for (int i = 0; i < lines1.length; i++) {
    if (i > 0) {
      if (lines1[i] == '' && lines1[i - 1] == '') {
        continue;
      }
    }
    lines2.add(lines1[i]);
  }
  echo(lines2, r'lines2');
  //yaml = '${lines2.join('\n')}\n';
  yaml = lines2.join('\n');
  sys__.writeFileString('pubspec.yaml', yaml);
  // String projectName = $ye.parseAt(['name']).value;
  final $run = run__.CommandRunner();
  String projectName = yamlMagic['name'];
  List<String> packageList = dart_scan__.packagesInSourceDirectory([
    '*.',
    './bin',
    './lib',
  ], './test');
  echo(packageList, r'packageList');
  List<String> existingPackageList = dart_scan__
      .findHostedDependenciesInPubspecYaml('pubspec.yaml');
  echo(existingPackageList, r'existingPackageList');
  existingPackageList =
      existingPackageList.where((x) => !packageList.contains(x)).toList();
  existingPackageList =
      existingPackageList.map((x) => x.replaceFirst('dev:', '')).toList();
  existingPackageList.remove('cupertino_icons');
  if (existingPackageList.isNotEmpty) {
    await $run.run$([
      dart,
      'pub',
      'remove',
      '--offline',
      '--no-precompile',
      ...existingPackageList,
    ], autoQuote: false);
  }
  packageList.remove(projectName);
  packageList.remove('dev:$projectName');
  packageList.remove('flutter');
  packageList.remove('dev:flutter_test');
  packageList.add(isFlutter ? 'dev:flutter_lints' : 'dev:lints');
  if (packageList.contains('embed_annotation')) {
    packageList.add('dev:embed');
    packageList.add('dev:build_runner');
  }
  await $run.run$([dart, 'pub', 'add', ...packageList], autoQuote: false);
  if (packageList.contains('embed_annotation')) {
    List<String> $generatedFiles = sys__.pathFiles('.', true);
    $generatedFiles =
        $generatedFiles.where(($x) => $x.endsWith('.g.dart')).toList();
    for (int $i = 0; $i < $generatedFiles.length; $i++) {
      io__.File($generatedFiles[$i]).deleteSync();
    }
    await $run.run('$dart run build_runner build');
  }
  List<String> protos = sys__.pathFiles('.', true);
  protos = protos.where((x) => x.endsWith('.proto')).toList();
  echo(protos, 'protos');
  if (protos.isNotEmpty) {
    await io__.Directory('./lib/src/generated').create(recursive: true);
    for (int i = 0; i < protos.length; i++) {
      String proto = protos[i];
      $run.run(
        'protoc --dart_out=grpc:lib/src/generated -I"${sys__.pathDirectoryName(proto)}" "${sys__.pathFileName(proto)}"',
      );
    }
  }
}
