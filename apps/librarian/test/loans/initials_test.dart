import 'package:flutter_test/flutter_test.dart';
import 'package:librarian_app/src/features/loans/widgets/loans_list/loans_list.dart';

void main() {
  group('Initials', () {
    for (TestCase t in [
      const TestCase('Alice Alisson', 'AA'),
      const TestCase('Ponce de Leon', 'PL'),
      const TestCase('Double  Spaces', 'DS'),
      const TestCase('NoSpaces', 'NO'),
      const TestCase('Weird ness ', 'WN'),
      const TestCase(' ', '?'),
      const TestCase('', '?'),
    ]) {
      test('#convert(${t.fullName}) returns ${t.expected}', () {
        final result = Initials.convert(t.fullName);
        expect(result, t.expected);
      });
    }
  });
}

class TestCase {
  const TestCase(this.fullName, this.expected);

  final String fullName;
  final String expected;
}
