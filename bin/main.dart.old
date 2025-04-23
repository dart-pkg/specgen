#! /usr/bin/env -S dt run

import 'dart:core';
import 'dart:io' as io;
import 'package:embed_annotation/embed_annotation.dart';
import 'package:dart_scan/dart_scan.dart' as dart_scan;

//import 'package:output/output.dart';
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
  //echo(version, 'version');
  bool isFlutter = false;
  String dart = 'dart';
  String? projectName /* = null*/;
  String? description /* = null*/;
  String? homepage /* = null*/;
  String? repository /* = null*/;
  String? sdk /* = null*/;
  dynamic template = ts.fromJson(templateJson);
  if (sys.fileExists('pubspec.yaml')) {
    String content = sys.readFileString('pubspec.yaml');
    template = ts.fromYaml(content);
    if ((template as Map<String, dynamic>).containsKey('flutter')) {
      isFlutter = true;
      dart = 'flutter';
    }
    projectName = template['name'] as String?;
    description = template['description'] as String?;
    homepage = template['homepage'] as String?;
    repository = template['repository'] as String?;
    sdk = template['environment']['sdk'] as String?;
    template['dependencies'] = null;
    template['dev_dependencies'] = null;
    (template).remove('executables');
  }
  String cwd = sys.getCwd();
  //echo(cwd, 'cwd');
  //echo(projectName);
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
  //echo(packageList);
  packageList.remove(projectName);
  packageList.remove('dev:$projectName');
  packageList.remove('flutter');
  packageList.remove('dev:flutter_test');
  packageList.add(isFlutter ? 'dev:flutter_lints' : 'dev:lints');
  if (isFlutter) {
    packageList.add('cupertino_icons');
  }
  if (packageList.contains('embed_annotation')) {
    packageList.add('dev:embed');
    packageList.add('dev:build_runner');
  }
  //echo(packageList);
  template['name'] = projectName;
  template['description'] = description;
  template['version'] = version;
  if (homepage != null) template['homepage'] = homepage;
  if (repository != null) template['repository'] = repository;
  template['environment']['sdk'] = sdk;
  if (sys.fileExists('./bin/main.dart')) {
    template['executables'] = <String, String>{projectName: 'main'};
  }
  if (isFlutter) {
    template['dependencies'] = <String, dynamic>{
      'flutter': <String, dynamic>{'sdk': 'flutter'},
    };
    template['dev_dependencies'] = <String, dynamic>{
      'flutter_test': <String, dynamic>{'sdk': 'flutter'},
    };
  }
  String pubspacYamlTemplate = ts.toYaml(template);
  var file = io.File('pubspec.yaml');
  var sink = file.openWrite();
  sink.write(pubspacYamlTemplate);
  await sink.flush();
  await sink.close();
  List<String> cmdArgs = <String>[];
  for (int i = 0; i < packageList.length; i++) {
    cmdArgs.add(packageList[i]);
  }
  //echo(cmdArgs);
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
