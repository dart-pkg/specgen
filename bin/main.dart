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
  String cwd = sys.getCwd();
  echo(cwd, 'cwd');
  String projectName = sys.pathFileName(cwd);
  echo(projectName);
  projectName = projectName.replaceAll('.', '_').replaceAll('-', '_');
  echo(projectName);
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
  String? repository;
  if ((await sys.httpGetBodyAsync(
        'https://github.com/dart-pkg/$projectName/raw/main/README.md',
      )) !=
      null) {
    repository = 'https://github.com/dart-pkg/$projectName';
  }
  dynamic template = ts.fromJson(templateJson);
  template['name'] = projectName;
  template['description'] = '$projectName project';
  template['version'] = version;
  template['repository'] = repository;
  if (sys.fileExists('./bin/main.dart')) {
    template['executables'] = <String, String>{projectName: 'main'};
  }
  //echo(ts.toYaml(template));
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
  // var result = await io.Process.run('bash', [
  //   'dart',
  //   'pub',
  //   'deps',
  //   '--no-dev',
  //   '--style',
  //   'list',
  // ]);
  // String stdout = result.stdout;
  // List<String> lines = sys.textToLines(stdout);
  // for (int i = 0; i < lines.length; i++) {
  //   if (!lines[i].startsWith(' ')) {
  //     print(lines[i]);
  //   }
  // }
  await sys.runAsync(['dart', 'format', '.']);
  if (packageList.contains('embed_annotation')) {
    List<String> $generatedFiles = sys.pathFiles('./lib', true);
    $generatedFiles =
        $generatedFiles.where(($x) => $x.endsWith('.g.dart')).toList();
    for (int $i = 0; $i < $generatedFiles.length; $i++) {
      io.File($generatedFiles[$i]).deleteSync();
    }
    await sys.runAsync(['dart', 'run', 'build_runner', 'build']);
  }
}
