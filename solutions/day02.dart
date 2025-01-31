import 'dart:math' as math;

import '../utils/index.dart';
import '../utils/my_utils/string_parse_util.dart';

class Day02 extends GenericDay {
  Day02() : super(2);

  final _stringParseUtil = StringParseUtil();

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    final games = parseInput();
    var validGameSum = 0;

    gameLoop:
    for (final game in games) {
      final splitGame = game.split(':');

      final gameId = _stringParseUtil.intInString(splitGame[0]);
      final subGames = splitGame[1].split(';');

      // check each sub set of dies
      for (final subGame in subGames) {
        final colors = subGame.split(',');

        for (final color in colors) {
          // if for any color we violate the rules, we continue
          // with the next game
          if (_colorImpossiblePart1(color)) {
            continue gameLoop;
          }
        }
      }

      // if every color passed the rules we add the id
      validGameSum += gameId;
    }

    return validGameSum;
  }

  bool _colorImpossiblePart1(String color) {
    final numberOfColor = _stringParseUtil.intInString(color);

    // check each color in the most hacky string matching way
    if (color.contains('d') && numberOfColor > 12) {
      return true;
    } else if (color.contains('n') && numberOfColor > 13) {
      return true;
    } else if (color.contains('b') && numberOfColor > 14) {
      return true;
    }

    return false;
  }

  @override
  int solvePart2() {
    final games = parseInput();
    var powerSum = 0;

    for (final game in games) {
      final splitGame = game.split(':');

      final subGames = splitGame[1].split(';');

      final red = <int>[];
      final green = <int>[];
      final blue = <int>[];

      for (final subGame in subGames) {
        final colors = subGame.split(',');

        for (final color in colors) {
          final numberOfColor = _stringParseUtil.intInString(color);

          // add all colors that were recorded
          if (color.contains('d')) {
            red.add(numberOfColor);
          } else if (color.contains('n')) {
            green.add(numberOfColor);
          } else if (color.contains('b')) {
            blue.add(numberOfColor);
          }
        }
      }

      // add the maximum per color of the game
      powerSum += red.fold<int>(0, math.max) *
          green.fold<int>(0, math.max) *
          blue.fold<int>(0, math.max);
    }

    return powerSum;
  }
}
