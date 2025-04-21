import 'package:test/test.dart';
import 'package:output/output.dart';
import 'package:specgen/specgen.dart';

void main() {
  group('Run', () {
    test('run1', () {
      var calc = Calculator();
      var result = calc.addOne(123);
      dump(result, 'result');
    });
  });
}
