import 'dart:math' as math;
import '../utils/index.dart';

// tried 100.000 but got wrong answer
// tried 10.000 but got wrong answer
// tried 1.000 but got wrong answer
// tried 100 but got wrong answer
// tried 10 but got wrong answer
final int stepSize = 1;

class Day05 extends GenericDay {
  Day05() : super(5);

  @override
  String parseInput() => input.asString;

  @override
  int solvePart1() {
    return 0;
    // final input = parseInput();

    // final seeds = _getSeeds(input);

    // final mappings = _getMappings(input).map(_getMappingsFromString);

    // return seeds
    //     .map((seed) => _applyMappingsRecursively(seed, mappings))
    //     .reduce(math.min);
  }

  @override
  int solvePart2() {
    final input = parseInput();

    final seedRanges = _getSeedRanges(input);

    final mappings = _getMappings(input).map(_getMappingsFromString);

    return seedRanges
        .map((seedRange) => _minOfSeedRange(seedRange, mappings))
        .reduce(math.min);
  }

  // bruteforce part 2 backward
  @override
  int solvePart2back() {
    final input = parseInput();
    final seeds = _getSeedRanges(input);
    final mappings =
        _getMappings(input).map(_getReversedMappingsFromString).toList();

    final reversedMappings = mappings.reversed.toList();

    var location = 0;
    while (true) {
      if (location % 10000000 == 0) print(location);
      final theoreticalSeed =
          _applyMappingsRecursively(location, reversedMappings);

      for (final seedRange in seeds) {
        if (seedRange.inSource(theoreticalSeed)) return theoreticalSeed;

        location += 1;
      }
    }
  }

  // recursive function to walk through all mappings
  int _applyMappingsRecursively(
    int from,
    Iterable<Iterable<Mapping>> mappings, {
    int position = 0,
  }) {
    if (position == mappings.length) return from;

    final to = _applyMapping(from, mappings.elementAt(position));

    return _applyMappingsRecursively(
      to,
      mappings,
      position: position + 1,
    );
  }

  int _applyMapping(int input, Iterable<Mapping> mappings) {
    final mapping = mappings.firstWhereOrNull((e) => e.inSource(input));

    // either use offset of mapping
    // or if none were found, use same destination number
    return input + (mapping?.offset ?? 0);
  }

  Iterable<Mapping> _getMappingsFromString(String mapping) {
    return (mapping.split(':\n')[1].split('\n')..removeLast())
        .map(_rowToMapping);
  }

  Iterable<Mapping> _getReversedMappingsFromString(String mapping) {
    final mappingStrings = (mapping.split(':\n')[1].split('\n')..removeLast());

    return mappingStrings.map(_rowToReversedMapping);
  }

  int _minOfSeedRange(Mapping seedRange, Iterable<Iterable<Mapping>> mappings) {
    print('Checking seedrange: ${seedRange.start}');

    var min = -1 >>> 1;
    var seedOfMin = 0;

    // tried this with different step sizes to see if I could speed it up
    // and then do a fine-grain search near the minimum
    for (var seed = seedRange.start; seed < seedRange.end; seed += stepSize) {
      final location = _applyMappingsRecursively(seed, mappings);

      if (location < min) {
        min = location;
        seedOfMin = seed;
      }
    }

    // var exactMin = -1 >>> 1;

    // for (var exactSeed = seedOfMin - 2 * stepSize;
    //     exactSeed < seedOfMin + stepSize;
    //     exactSeed += 1) {
    //   final exactLocation = _applyMappingsRecursively(exactSeed, mappings);

    //   if (exactLocation < exactMin) {
    //     exactMin = exactLocation;
    //   }
    // }
    // print('Min of seedrange: $exactMin');

    // return exactMin;
    return min;
  }

  Mapping _rowToMapping(String row) {
    final rowSplit = row.split(' ');
    final destStart = int.parse(rowSplit[0]);
    final sourceStart = int.parse(rowSplit[1]);
    final range = int.parse(rowSplit[2]);

    return Mapping(sourceStart, sourceStart + range, destStart - sourceStart);
  }

  Mapping _rowToReversedMapping(String row) {
    final rowSplit = row.split(' ');
    final destStart = int.parse(rowSplit[1]); // index changed
    final sourceStart = int.parse(rowSplit[0]); // index changed
    final range = int.parse(rowSplit[2]);

    return Mapping(sourceStart, sourceStart + range, sourceStart - destStart);
  }

  Iterable<int> _getSeeds(String input) {
    final seedLine = input.split('\n')[0].split(': ')[1].split(' ');
    return seedLine.map(int.parse);
  }

  Iterable<Mapping> _getSeedRanges(String input) {
    final seedLine = input.split('\n')[0].split(': ')[1].split(' ');
    final initialValues = seedLine.map(int.parse).toList();

    final seedRanges = <Mapping>[];

    for (var seedIndex = 0; seedIndex < initialValues.length; seedIndex += 2) {
      final start = initialValues[seedIndex];
      final range = initialValues[seedIndex + 1];
      seedRanges.add(Mapping(start, start + range, 0));
    }

    return seedRanges;
  }

  List<String> _getMappings(String input) {
    return input.split(RegExp('\n[a-z]'))..removeAt(0);
  }
}

class Mapping {
  Mapping(this.start, this.end, this.offset);
  final int start;
  final int end;
  final int offset;

  bool inSource(int x) => start <= x && x <= end;
}
