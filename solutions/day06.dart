import '../utils/index.dart';

class Day06 extends GenericDay {
  Day06() : super(6);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    final input = parseInput();
    final times = _numbersFromLine(input.first);
    final distances = _numbersFromLine(input.last);
    final races = _racedataFromInput(times, distances);
    return races.map(_winningStrategiesForRace).fold(
        0,
        (previousValue, element) => previousValue == 0
            ? element
            : previousValue * (element == 0 ? 1 : element));
  }

  @override
  int solvePart2() {
    final input = parseInput();
    final race = _singleGameFromInput(input);

    return _winningStrategiesForRace(race);
  }

  int _winningStrategiesForRace(RaceData race) {
    return List.generate(race.time, (i) => i)
        .map((strat) => _distanceOfStrategy(race.time, strat))
        .where((dist) => dist > race.distance)
        .length;
  }

  int _distanceOfStrategy(int totalTime, int holdTime) {
    return (totalTime - holdTime) * holdTime;
  }

  Iterable<RaceData> _racedataFromInput(
    Iterable<int> times,
    Iterable<int> distances,
  ) {
    return times.mapIndexed(
      (i, time) => RaceData(time, distances.elementAt(i)),
    );
  }

  Iterable<int> _numbersFromLine(String line) {
    return RegExp('[0-9]+')
        .allMatches(line.split(':').last)
        .map((e) => int.parse(e[0]!.trim()));
  }

  RaceData _singleGameFromInput(List<String> lines) {
    final time = _numberFromLine(lines.first);
    final distance = _numberFromLine(lines.last);

    return RaceData(time, distance);
  }

  int _numberFromLine(String line) {
    return int.parse(line.split(':').last.replaceAll(' ', ''));
  }
}

class RaceData {
  RaceData(this.time, this.distance);
  final int time;
  final int distance;
}
