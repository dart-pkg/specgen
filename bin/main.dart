import 'dart:core';
import 'dart:io' as io;
import 'package:dart_scan/dart_scan.dart' as dart_scan;
import 'package:sys/sys.dart' as sys;
import 'package:yaml_edit/yaml_edit.dart' as ye;

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

extension on ye.YamlEditor {
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
  String cwd = sys.getCwd();
  bool isFlutter = false;
  String dart = 'dart';
  ye.YamlEditor $ye = ye.YamlEditor(yamlTemplate);
  String defaultProjectName = sys.pathFileName(cwd);
  defaultProjectName = defaultProjectName
      .replaceAll('.', '_')
      .replaceAll('-', '_');
  $ye.update(['name'], defaultProjectName);
  $ye.update(['description'], '$defaultProjectName project');
  if (sys.fileExists('pubspec.yaml')) {
    String content = sys.readFileString('pubspec.yaml');
    $ye = ye.YamlEditor(content);
    if ($ye.hasPath(['flutter'])) {
      isFlutter = true;
      dart = 'flutter';
    }
  }
  if (version != null) {
    $ye.update(['version'], version);
  }
  String projectName = $ye.parseAt(['name']).value;
  List<String> packageList = dart_scan.packagesInSourceDirectory([
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
  var file = io.File('pubspec.yaml');
  //var file = io.File('pubspec.txt');
  var sink = file.openWrite();
  sink.write(pubspacYamlTemplate);
  await sink.flush();
  await sink.close();
  List<String> cmdArgs = <String>[];
  for (int i = 0; i < packageList.length; i++) {
    cmdArgs.add(packageList[i]);
  }
  await sys.runAsync$([dart, 'pub', 'add'], rest: cmdArgs);
  if (packageList.contains('embed_annotation')) {
    List<String> $generatedFiles = sys.pathFiles('.', true);
    $generatedFiles =
        $generatedFiles.where(($x) => $x.endsWith('.g.dart')).toList();
    for (int $i = 0; $i < $generatedFiles.length; $i++) {
      io.File($generatedFiles[$i]).deleteSync();
    }
    await sys.runAsync$([dart, 'run', 'build_runner', 'build']);
  }
}
