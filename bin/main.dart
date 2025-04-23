import 'dart:core';
import 'dart:io' as io__;
import 'package:dart_scan/dart_scan.dart' as dart_scan__;
import 'package:sys/sys.dart' as sys__;
import 'package:run/run.dart' as run__;
import 'package:yaml_edit/yaml_edit.dart' as yaml_edit__;

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

extension on yaml_edit__.YamlEditor {
  bool hasPath(List<String> $path) {
    try {
      parseAt($path);
      return true;
    } catch ($e) {
      return false;
    }
  }
}

Future<void> main(List<String> args) async {
  String? version;
  if (args.isNotEmpty) {
    version = args[0];
  }
  String cwd = sys__.getCwd();
  bool isFlutter = false;
  String dart = 'dart';
  yaml_edit__.YamlEditor $ye = yaml_edit__.YamlEditor(yamlTemplate);
  String defaultProjectName = sys__.pathFileName(cwd);
  defaultProjectName = defaultProjectName
      .replaceAll('.', '_')
      .replaceAll('-', '_');
  $ye.update(['name'], defaultProjectName);
  $ye.update(['description'], '$defaultProjectName project');
  if (sys__.fileExists('pubspec.yaml')) {
    String content = sys__.readFileString('pubspec.yaml');
    $ye = yaml_edit__.YamlEditor(content);
    if ($ye.hasPath(['flutter'])) {
      isFlutter = true;
      dart = 'flutter';
    }
  }
  if (version != null) {
    $ye.update(['version'], version);
  }
  String projectName = $ye.parseAt(['name']).value;
  List<String> packageList = dart_scan__.packagesInSourceDirectory([
    './bin',
    './lib',
  ], './test');
  packageList.remove(projectName);
  packageList.remove('dev:$projectName');
  packageList.remove('flutter');
  packageList.remove('dev:flutter_test');
  packageList.add(isFlutter ? 'dev:flutter_lints' : 'dev:lints');
  if (packageList.contains('embed_annotation')) {
    packageList.add('dev:embed');
    packageList.add('dev:build_runner');
  }
  if ($ye.hasPath(['dependencies'])) {
    if (!isFlutter) {
      $ye.remove(['dependencies']);
    } else {
      dynamic $dep = $ye.parseAt(['dependencies']).value;
      List<dynamic> $keys = $dep.keys.toList();
      for (int i = 0; i < $keys.length; i++) {
        String $key = $keys[i];
        if ($key != 'flutter' && $key != 'cupertino_icons') {
          $ye.remove(['dependencies', $key]);
        }
      }
    }
  }
  if ($ye.hasPath(['dev_dependencies'])) {
    if (!isFlutter) {
      $ye.remove(['dev_dependencies']);
    } else {
      dynamic $dep = $ye.parseAt(['dev_dependencies']).value;
      List<dynamic> $keys = $dep.keys.toList();
      for (int i = 0; i < $keys.length; i++) {
        String $key = $keys[i];
        if ($key != 'flutter_test' && $key != 'flutter_lints') {
          $ye.remove(['dev_dependencies', $key]);
        }
      }
    }
  }
  String pubspacYamlTemplate = $ye.toString();
  var file = io__.File('pubspec.yaml');
  //var file = io.File('pubspec.txt');
  var sink = file.openWrite();
  sink.write(pubspacYamlTemplate);
  await sink.flush();
  await sink.close();
  List<String> cmdArgs = <String>[];
  for (int i = 0; i < packageList.length; i++) {
    cmdArgs.add(packageList[i]);
  }
  final $run = run__.Run();
  //await sys__.runAsync$([dart, 'pub', 'add'], rest: cmdArgs);
  await $run.$$(dart, arguments: ['pub', 'add', ...cmdArgs]);
  if (packageList.contains('embed_annotation')) {
    List<String> $generatedFiles = sys__.pathFiles('.', true);
    $generatedFiles =
        $generatedFiles.where(($x) => $x.endsWith('.g.dart')).toList();
    for (int $i = 0; $i < $generatedFiles.length; $i++) {
      io__.File($generatedFiles[$i]).deleteSync();
    }
    //await sys__.runAsync$([dart, 'run', 'build_runner', 'build']);
    await $run.$$(dart, arguments: ['pub', 'add', ...cmdArgs]);
  }
}
