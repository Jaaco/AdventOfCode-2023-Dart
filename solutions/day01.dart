import '../utils/index.dart';

class Day01 extends GenericDay {
  Day01() : super(1);

  @override
  List<String> parseInput() {
    final lines = input.getPerLine();

    return lines;
  }

  @override
  int solvePart1() {
    final pattern = RegExp('[0-9]');

    return _sumOfString(pattern: pattern);
  }

  @override
  int solvePart2() {
    final patternSpelled = numbers.map((n) => n.pattern).join('|');
    final pattern = RegExp('[0-9]|$patternSpelled');

    return _sumOfString(pattern: pattern);
  }

  int _sumOfString({required RegExp pattern}) {
    final inputLines = parseInput();

    final valuePerLine = <int>[];

    for (final line in inputLines) {
      final numbersInLine = pattern.allMatches(line).map(_intFromPattern);

      final valueOfLine = numbersInLine.first * 10 + numbersInLine.last;

      valuePerLine.add(valueOfLine);
    }

    return valuePerLine.sum;
  }

  int _intFromPattern(RegExpMatch match) {
    final numberAsString = match[0]!;

    return numberAsString.length > 1
        ? _intFromSpelled(numberAsString)
        : int.parse(numberAsString);
  }

  int _intFromSpelled(String spelled) {
    return numbers.firstWhere((element) => element.pattern == spelled).number;
  }
}

const numbers = [
  Number('one', 1),
  Number('two', 2),
  Number('three', 3),
  Number('four', 4),
  Number('five', 5),
  Number('six', 6),
  Number('seven', 7),
  Number('eight', 8),
  Number('nine', 9),
];

class Number {
  const Number(this.pattern, this.number);

  final String pattern;
  final int number;
}
