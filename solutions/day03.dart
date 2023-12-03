import '../utils/index.dart';
/*
Approach:
Map Input to NumberCoordinates and Special Character Coordinates

These classes simplify finding adjecent values
*/

class Day03 extends GenericDay {
  Day03() : super(3);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    final lines = parseInput();

    final (numberCoords, specialCharCoords) = _inputToNumberCoords(lines);

    var sum = 0;

    for (final number in numberCoords) {
      final adjacentRowSpecialChars =
          _getSpecialCharsAdjecentNumber(number, specialCharCoords);

      if (adjacentRowSpecialChars.isNotEmpty) sum += number.number;
    }

    return sum;
  }

  @override
  int solvePart2() {
    final lines = parseInput();

    final (numberCoords, specialCharCoords) = _inputToNumberCoords(lines);

    // potential gears are special chars with * as symbol
    final potentialGears =
        specialCharCoords.where((specialChar) => specialChar.symbol == '*');

    var gearRatio = 0;

    for (final potentialGear in potentialGears) {
      final adjacentNumbers =
          _getNumbersAdjecentGear(potentialGear, numberCoords);

      // if gear has exactly two neighbours we add
      if (adjacentNumbers.length == 2) {
        gearRatio += adjacentNumbers.first.number * adjacentNumbers.last.number;
      }
    }

    return gearRatio;
  }

  // maps input to number & special char coordinate classes
  (List<NumberCoordinate>, List<SpecialCharCoordinate>) _inputToNumberCoords(
    List<String> lines,
  ) {
    final numberCoords = <NumberCoordinate>[];
    final specialCharCoords = <SpecialCharCoordinate>[];

    // match numbers
    final numberPattern = RegExp('[0-9]+');

    // match special chars (not number && not .)
    final notNumberPattern = RegExp('[^0-9.]');

    // use .asMap().entries to get access to index of line
    for (final line in lines.asMap().entries) {
      // find numbers

      final numberMatches = numberPattern
          .allMatches(line.value)
          .map((e) => numberCoordFromMatch(line.key, e));

      // find special chars
      final specialCharMatches = notNumberPattern
          .allMatches(line.value)
          .map((e) => speciaCharFromMatch(line.key, e));

      numberCoords.addAll(numberMatches);
      specialCharCoords.addAll(specialCharMatches);
    }

    return (numberCoords, specialCharCoords);
  }

  NumberCoordinate numberCoordFromMatch(int row, RegExpMatch match) {
    return NumberCoordinate(
      row: row,
      columnStart: match.start,
      columnEnd: match.end - 1,
      number: int.parse(
        match[0]!,
      ),
    );
  }

  SpecialCharCoordinate speciaCharFromMatch(int row, RegExpMatch match) {
    return SpecialCharCoordinate(
      row: row,
      column: match.start,
      symbol: match[0]!,
    );
  }

  Iterable<SpecialCharCoordinate> _getSpecialCharsAdjecentNumber(
    NumberCoordinate numberCoord,
    List<SpecialCharCoordinate> specialCharCoords,
  ) {
    return specialCharCoords.where(
      (specialChar) =>
          _isAdjacentSingle(specialChar.row, numberCoord.row) &&
          _isAdjacentRange(
            specialChar.column,
            numberCoord.columnStart,
            numberCoord.columnEnd,
          ),
    );
  }

  Iterable<NumberCoordinate> _getNumbersAdjecentGear(
    SpecialCharCoordinate gear,
    List<NumberCoordinate> numberCoords,
  ) {
    return numberCoords.where(
      (number) =>
          _isAdjacentSingle(
            number.row,
            gear.row,
          ) &&
          _isAdjacentRange(
            gear.column,
            number.columnStart,
            number.columnEnd,
          ),
    );
  }

  // for checking if rows are adjacent
  bool _isAdjacentSingle(int first, int second) {
    return (first - second).abs() <= 1;
  }

  // for checking if columns are adjacent
  bool _isAdjacentRange(int inQuestion, int start, int end) {
    return inQuestion >= start - 1 && inQuestion <= end + 1;
  }
}

class SpecialCharCoordinate {
  SpecialCharCoordinate({
    required this.row,
    required this.column,
    required this.symbol,
  });

  final int row;
  final int column;
  final String symbol;

  @override
  String toString() {
    return 'Symbol: $symbol Row: $row Column: $column';
  }
}

class NumberCoordinate {
  NumberCoordinate({
    required this.row,
    required this.columnStart,
    required this.columnEnd,
    required this.number,
  });

  final int row;
  final int columnStart;
  final int columnEnd;
  final int number;

  @override
  String toString() {
    return 'Number: $number Row: $row Column: $columnStart - $columnEnd';
  }
}
