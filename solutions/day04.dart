import 'dart:math';

import '../utils/index.dart';

class Day04 extends GenericDay {
  Day04() : super(4);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    return parseInput().map(_correctOfCard).map(_pointsFromCorrect).sum.toInt();
  }

  @override
  int solvePart2() {
    final lines = parseInput();

    final cardMap = <int, int>{};

    for (final line in lines.asMap().entries) {
      final correct = _correctOfCard(line.value);

      cardMap.update(line.key, (v) => v + 1, ifAbsent: () => 1);

      final copiesOfCard = cardMap[line.key]!;

      for (var i = 1; i <= correct; i++) {
        cardMap.update(
          line.key + i,
          (v) => v + copiesOfCard,
          ifAbsent: () => copiesOfCard,
        );
      }
    }

    return cardMap.values.sum;
  }

  int _correctOfCard(String card) {
    final splitSections = card.split(RegExp('[|:]'));

    final winning = _intsFromString(splitSections[1]);
    final played = _intsFromString(splitSections[2]);

    return winning.where(played.contains).length;
  }

  num _pointsFromCorrect(int correctCards) {
    if (correctCards == 0) return 0;

    return pow(2, correctCards - 1);
  }

  Iterable<int> _intsFromString(String str) {
    return str.split(' ').where((e) => e.isNotEmpty).map(int.parse);
  }
}
