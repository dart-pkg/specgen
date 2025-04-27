# CHANGELOG.md

## 2025.421.2307

- Initial release

## 2025.421.2322

- Fixed bug of using bash on Windows

## 2025.422.37

- Modified bin/main.dart in order to inherit existing some informations form pubspec.yaml

## 2025.422.59

- Modified bin/main.dart. specgen now does not execute dart format

## 2025.423.624

- Modified main.dart to follow the changes of sys package

## 2025.423.643

- specgen now keeps all of the settings in pubspec.yaml

## 2025.423.809

- specgen now supports flutter

## 2025.423.1516

- String value within generated pubspec.yaml are not quoted now

## 2025.423.1756

- Rewrote main.dart using yaml_edit package

## 2025.423.2311

- Started to use run package

## 2025.424.44

- Updated package dpencencies: run 2025.424.35 (was 2025.423.2250)

## 2025.424.206

- Updated package dependencies: run 2025.424.154 (was 2025.424.35)

## 2025.424.304

- Updated package dependencies: dart_scan 2025.424.257 (was 2025.421.2226)

## 2025.424.1215

- specgen now seraches current directory (non-recursively)

## 2025.424.1907

- Removed dependency to run package

## 2025.425.216

- specgen calls protoc when .proto files found

## 2025.425.2034

- Fixed bug of creating lib/src/generated dir even if .proto does not exist

## 2025.426.2002

- Update dependencies

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.425.2034
+version: 2025.426.2002
-  dart_scan: ^2025.424.1203
+  dart_scan: ^2025.426.1731
-  std: ^2025.425.2018
-  sys: ^2025.425.243
+  std: ^2025.426.1637
+  sys: ^2025.426.1725
```

## 2025.426.2358

- Update dependencies

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.426.2002
+version: 2025.426.2358
-  output: ^1.0.7
-  std: ^2025.426.1637
-  sys: ^2025.426.1725
+  output: ^2025.426.2027
+  std: ^2025.426.2248
+  sys: ^2025.426.2256
```

## 2025.427.1717

- Update dependencies

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.426.2358
+version: 2025.427.1717
-  dart_scan: ^2025.426.1731
+  dart_scan: ^2025.427.1709
-  std: ^2025.426.2248
+  std: ^2025.427.52
```

## 2025.427.1747

- Update dependencies

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.427.1717
+version: 2025.427.1747
-  dart_scan: ^2025.427.1709
+  dart_scan: ^2025.427.1743
-  sys: ^2025.426.2256
+  sys: ^2025.427.1718
```
