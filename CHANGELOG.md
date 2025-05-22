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

## 2025.427.2204

- Introduced yaml_magic package

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.427.1747
-homepage:
+version: 2025.427.2204
+homepage: 
-  dart_scan: ^2025.427.1743
+  dart_scan: ^2025.427.2004
-  yaml_edit: ^2.2.2
+  yaml_magic: ^1.0.6
```

## 2025.427.2226

- Modified bin/main.dart

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.427.2204
+version: 2025.427.2226
```

## 2025.427.2259

- Fixed bug of redundant newlines

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.427.2226
+version: 2025.427.2259
```

## 2025.427.2303

- Removed debug messages

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.427.2259
+version: 2025.427.2303
-  output: ^2025.426.2027
+  output: ^2025.426.2027
```

## 2025.427.2326

- Fixed bug of pubspec.yaml note ending with newline

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.427.2303
+version: 2025.427.2326
```

## 2025.427.2341

- Fixed newline bug

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.427.2326
+version: 2025.427.2341
```

## 2025.428.28

- Introduced handling of path dependencies and git dependencies

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.427.2341
+version: 2025.428.28
-  dart_scan: ^2025.427.2004
+  dart_scan: ^2025.428.15
```

## 2025.428.1741

- Update package dependencies

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.428.28
+version: 2025.428.1741
-  dart_scan: ^2025.428.15
-  std: ^2025.427.52
-  sys: ^2025.427.1718
+  dart_scan: ^2025.428.1730
+  std: ^2025.428.1703
+  sys: ^2025.428.1721
```

## 2025.429.235

- Removed --offline flag from dart pub remove operation

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.428.1741
+version: 2025.429.235
```

## 2025.430.1933

- Update package dependencies

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.429.235
+version: 2025.430.1933
-  std: ^2025.428.1703
-  sys: ^2025.428.1721
+  std: ^2025.430.1833
+  sys: ^2025.430.1853
```

## 2025.502.936

- Update pacage dependencies

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.430.1933
+version: 2025.502.936
-  dart_scan: ^2025.428.1730
-  std: ^2025.430.1833
-  sys: ^2025.430.1853
+  dart_scan: ^2025.501.856
+  std: ^2025.501.843
+  sys: ^2025.501.850
```

## 2025.503.39

- Update package dependencies

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.502.936
+version: 2025.503.39
-  dart_scan: ^2025.501.856
-  std: ^2025.501.843
-  sys: ^2025.501.850
+  dart_scan: ^2025.503.13
+  std: ^2025.502.2358
+  sys: ^2025.503.6
-  output: ^2025.430.1731
+  output: ^2025.502.1958
```

## 2025.503.104

- Update package dependencies

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.503.39
+version: 2025.503.104
-  sys: ^2025.503.6
+  sys: ^2025.503.56
```

## 2025.504.1212

- Update package dependencies

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.503.104
+version: 2025.504.1212
-  dart_scan: ^2025.503.13
-  std: ^2025.502.2358
-  sys: ^2025.503.56
+  dart_scan: ^2025.504.1204
+  std: ^2025.504.1143
+  sys: ^2025.504.1149
```

## 2025.510.2109

- Update package dependencies

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.504.1212
+version: 2025.510.2109
-  std: ^2025.504.1143
-  sys: ^2025.504.1149
+  std: ^2025.504.1244
+  sys: ^2025.504.1255
```

## 2025.510.2148

- Auto change dir functionality removed

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.510.2109
+version: 2025.510.2148
```

## 2025.523.149

- Update dependencies

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.510.2148
+version: 2025.523.149
-  std: ^2025.504.1244
-  sys: ^2025.504.1255
+  std: ^2025.513.452
+  sys: ^2025.513.437
-  test: ^1.25.15
+  test: ^1.26.2
```

## 2025.523.152

- Update dependencies

```
--- a/pubspec.yaml
+++ b/pubspec.yaml
-version: 2025.523.149
+version: 2025.523.152
-  std: ^2025.513.452
```
