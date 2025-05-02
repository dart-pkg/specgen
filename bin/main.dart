#! /usr/bin/env my-dart

import 'dart:core';
import 'dart:io' as dart_io;
import 'package:dart_scan/dart_scan.dart' as dart_scan;
import 'package:sys/sys.dart' as sys_sys;
import 'package:std/command_runner.dart' as std_command_runner;
import 'package:yaml_magic/yaml_magic.dart' as yaml_magic;
//import 'package:output/output.dart';

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
  String cwd = sys_sys.getCwd();
  String fn = sys_sys.pathFileName(cwd);
  if (fn == 'bin' || fn == 'lib' || fn == 'test') {
    cwd = sys_sys.pathDirectoryName(cwd);
    sys_sys.setCwd(cwd);
  }
  //echo(cwd, 'cwd');
  bool isFlutter = false;
  String dart = 'dart';
  // yaml_edit__.YamlEditor $ye = yaml_edit__.YamlEditor(yamlTemplate);
  String defaultProjectName = sys_sys.pathFileName(cwd);
  defaultProjectName = sys_sys.adjustPackageName(defaultProjectName);
  yaml_magic.YamlMagic yamlMagic;
  if (sys_sys.fileExists('pubspec.yaml')) {
    yamlMagic = yaml_magic.YamlMagic.load('pubspec.yaml');
  } else {
    yamlMagic = yaml_magic.YamlMagic.fromString(
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
  sys_sys.writeFileString('pubspec.yaml', yaml);
  final $run = std_command_runner.CommandRunner();
  String projectName = yamlMagic['name'];
  List<String> hostedPackageList = dart_scan
      .findHostedDependenciesInPubspecYaml('pubspec.yaml');
  List<String> gitPackageList = dart_scan.findGitDependenciesInPubspecYaml(
    'pubspec.yaml',
  );
  List<String> pathPackageList = dart_scan.findPathDependenciesInPubspecYaml(
    'pubspec.yaml',
  );
  List<String> packageList = dart_scan.packagesInSourceDirectory([
    '*.',
    './bin',
    './lib',
  ], './test');
  packageList =
      packageList
          .where(
            (x) => !gitPackageList.contains(x) && !pathPackageList.contains(x),
          )
          .toList();
  hostedPackageList =
      hostedPackageList.where((x) => !packageList.contains(x)).toList();
  hostedPackageList =
      hostedPackageList.map((x) => x.replaceFirst('dev:', '')).toList();
  hostedPackageList.remove('cupertino_icons');
  if (hostedPackageList.isNotEmpty) {
    await $run.run$([
      dart,
      'pub',
      'remove',
      ...hostedPackageList,
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
  sys_sys.reformatUglyYamlFile('pubspec.yaml');
  await $run.run$([dart, 'pub', 'get'], autoQuote: false);
  if (packageList.contains('embed_annotation')) {
    List<String> $generatedFiles = sys_sys.pathFiles('.', true);
    $generatedFiles =
        $generatedFiles.where(($x) => $x.endsWith('.g.dart')).toList();
    for (int $i = 0; $i < $generatedFiles.length; $i++) {
      dart_io.File($generatedFiles[$i]).deleteSync();
    }
    await $run.run('$dart run build_runner build');
  }
  List<String> protos = sys_sys.pathFiles('.', true);
  protos = protos.where((x) => x.endsWith('.proto')).toList();
  //echo(protos, 'protos');
  if (protos.isNotEmpty) {
    await dart_io.Directory('./lib/src/generated').create(recursive: true);
    for (int i = 0; i < protos.length; i++) {
      String proto = protos[i];
      $run.run(
        'protoc --dart_out=grpc:lib/src/generated -I"${sys_sys.pathDirectoryName(proto)}" "${sys_sys.pathFileName(proto)}"',
      );
    }
  }
}
