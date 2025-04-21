#! /usr/bin/env -S dt run

import 'dart:core';
import 'dart:io' as io;
import 'package:embed_annotation/embed_annotation.dart';
import 'package:dart_scan/dart_scan.dart' as dart_scan;
import 'package:output/output.dart';
import 'package:sys/sys.dart' as sys;
import 'package:text_serializer/text_serializer.dart' as ts;

part 'main.g.dart';

@EmbedStr('template.json')
const templateJson = _$templateJson;

Future<void> main(List<String> args) async {
  String version = '';
  if (args.isNotEmpty) {
    version = args[0];
  } else {
    version = '0.0.1';
  }
  echo(version, 'version');
  String? projectName /* = null*/;
  String? description /* = null*/;
  String? homepage /* = null*/;
  String? repository /* = null*/;
  String? sdk /* = null*/;
  if (sys.fileExists('pubspec.yaml')) {
    String content = sys.readFileString('pubspec.yaml');
    dynamic obj = ts.fromYaml(content);
    projectName = obj['name'] as String?;
    description = obj['description'] as String?;
    homepage = obj['homepage'] as String?;
    repository = obj['repository'] as String?;
    sdk = obj['environment']['sdk'] as String?;
  }
  String cwd = sys.getCwd();
  echo(cwd, 'cwd');
  echo(projectName);
  if (projectName == null) {
    projectName = sys.pathFileName(cwd);
    projectName = projectName.replaceAll('.', '_').replaceAll('-', '_');
  }
  description ??= '$projectName project';
  sdk ??= '^3.7.2';
  List<String> packageList = dart_scan.packagesInSourceDirectory([
    './bin',
    './lib',
  ], './test');
  echo(packageList);
  packageList.remove(projectName);
  packageList.remove('dev:$projectName');
  packageList.add('dev:lints');
  if (packageList.contains('embed_annotation')) {
    packageList.add('dev:embed');
    packageList.add('dev:build_runner');
  }
  echo(packageList);
  dynamic template = ts.fromJson(templateJson);
  template['name'] = projectName;
  template['description'] = description;
  template['version'] = version;
  template['homepage'] = homepage;
  template['repository'] = repository;
  template['environment']['sdk'] = sdk;
  if (sys.fileExists('./bin/main.dart')) {
    template['executables'] = <String, String>{projectName: 'main'};
  }
  String pubspacYamlTemplate = ts.toYaml(template);
  var file = io.File('pubspec.yaml');
  var sink = file.openWrite();
  sink.write(pubspacYamlTemplate);
  await sink.flush();
  await sink.close();
  List<String> cmdArgs = <String>[]; //<String>['dart', 'pub', 'add'];
  for (int i = 0; i < packageList.length; i++) {
    cmdArgs.add(packageList[i]);
  }
  echo(cmdArgs);
  await sys.runAsync(['dart', 'pub', 'add'], cmdArgs);
  await sys.runAsync(['dart', 'format', '.']);
  if (packageList.contains('embed_annotation')) {
    List<String> $generatedFiles = sys.pathFiles('.', true);
    $generatedFiles =
        $generatedFiles.where(($x) => $x.endsWith('.g.dart')).toList();
    for (int $i = 0; $i < $generatedFiles.length; $i++) {
      io.File($generatedFiles[$i]).deleteSync();
    }
    await sys.runAsync(['dart', 'run', 'build_runner', 'build']);
  }
}
