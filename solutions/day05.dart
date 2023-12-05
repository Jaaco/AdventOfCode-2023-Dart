import 'dart:math' as math;
import '../utils/index.dart';

class Day05 extends GenericDay {
  Day05() : super(5);

  @override
  String parseInput() => input.asString;

  @override
  int solvePart1() {
    final input = parseInput();

    final seeds = _getSeeds(input);

    final mappings = _getMappings(input).map(getMappingsFromString);

    return seeds
        .map((seed) => applyMappingsRecursively(seed, mappings))
        .reduce(math.min);
  }

  // bruteforce part 2 forward
  // @override
  // int solvePart2() {
  //   final input = parseInput();

  //   final seeds = _getSeedsWithRanges(input);

  //   final mappings = _getMappings(input).map(getMappingsFromString);

  //   return seeds.map((seed) => seedToLocation(seed, mappings)).reduce(math.min);
  // }

  // --
  // bruteforce part 2 backward
  @override
  int solvePart2() {
    final input = parseInput();
    final seeds = _getSeedRanges(input);
    final mappings =
        _getMappings(input).map(getReversedMappingsFromString).toList();

    final reversedMappings = mappings.reversed.toList();

    final locations =
        reversedMappings[0].sorted((a, b) => a.end.compareTo(b.end));

    for (final locationRange in locations) {
      for (var location = locationRange.start;
          location < locationRange.end;
          location += 1) {
        final theoreticalSeed =
            applyMappingsRecursively(location, reversedMappings);

        for (final seedRange in seeds) {
          if (seedRange.inSource(theoreticalSeed)) {
            return theoreticalSeed;
          }
        }
      }
    }

    throw Error();
  }

  // recursive function to walk through all mappings
  int applyMappingsRecursively(
    int from,
    Iterable<Iterable<Mapping>> mappings, {
    int position = 0,
  }) {
    if (position == mappings.length) return from;

    final to = applyMapping(from, mappings.elementAt(position));

    return applyMappingsRecursively(
      to,
      mappings,
      position: position + 1,
    );
  }

  int applyMapping(int input, Iterable<Mapping> mappings) {
    final mapping = mappings.firstWhereOrNull((e) => e.inSource(input));

    // either use offset of mapping
    // or if none were found, use same destination number
    return input + (mapping?.offset ?? 0);
  }

  Iterable<Mapping> getMappingsFromString(String mapping) {
    return (mapping.split(':\n')[1].split('\n')..removeLast())
        .map(rowToMapping);
  }

  Iterable<Mapping> getReversedMappingsFromString(String mapping) {
    final mappingStrings = (mapping.split(':\n')[1].split('\n')..removeLast());

    return mappingStrings.map(rowToReversedMapping);
  }

  Mapping rowToMapping(String row) {
    final rowSplit = row.split(' ');
    final destStart = int.parse(rowSplit[0]);
    final sourceStart = int.parse(rowSplit[1]);
    final range = int.parse(rowSplit[2]);

    return Mapping(sourceStart, sourceStart + range, destStart - sourceStart);
  }

  Mapping rowToReversedMapping(String row) {
    final rowSplit = row.split(' ');
    final destStart = int.parse(rowSplit[1]); // index changed
    final sourceStart = int.parse(rowSplit[0]); // index changed
    final range = int.parse(rowSplit[2]);

    return Mapping(sourceStart, sourceStart + range, destStart - sourceStart);
  }

  Iterable<int> _getSeeds(String input) {
    final seedLine = input.split('\n')[0].split(': ')[1].split(' ');
    return seedLine.map(int.parse);
  }

  Iterable<Mapping> _getSeedRanges(String input) {
    final seedLine = input.split('\n')[0].split(': ')[1].split(' ');
    final initialValues = seedLine.map(int.parse).toList();

    final seedRanges = <Mapping>[];

    print("initial values: $initialValues");

    for (var seedIndex = 0; seedIndex < initialValues.length; seedIndex += 2) {
      print('seedindex: $seedIndex');
      final start = initialValues[seedIndex];
      final range = initialValues[seedIndex + 1];
      seedRanges.add(Mapping(start, range, 0));
    }

    return seedRanges;
  }

  Iterable<int> _getSeedsWithRanges(String input) {
    final seedLine = input.split('\n')[0].split(': ')[1].split(' ');
    final initialValues = seedLine.map(int.parse).toList();

    final allSeeds = <int>[];

    for (var seedIndex = 0; seedIndex < initialValues.length; seedIndex += 2) {
      print('getting seeds ${seedIndex / 2 + 1} / ${initialValues.length / 2}');
      final start = initialValues[seedIndex];
      final range = initialValues[seedIndex + 1];

      for (var i = 0; i < range; i += 1) {
        allSeeds.add(start + i);
      }
    }

    return allSeeds;
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

  @override
  String toString() {
    return 'Start: $start End: $end Offset: $offset';
  }
}
