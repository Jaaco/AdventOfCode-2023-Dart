import '../utils/index.dart';

class Day09 extends GenericDay {
  Day09() : super(9);

  @override
  Iterable<List<int>> parseInput() {
    return input.getPerLine().map((e) => e.split(' ').map(int.parse).toList());
  }

  @override
  int solvePart1() => parseInput().map(getNextPrediction).sum;

  @override
  int solvePart2() => parseInput().map(getNextPredictionBeggining).sum;

  int getNextPrediction(
    List<int> initial,
  ) =>
      extrapolate(getAllLayers([initial]));

  int getNextPredictionBeggining(
    List<int> initial,
  ) =>
      extrapolateBeggining(getAllLayers([initial]));

  List<List<int>> getAllLayers(
    List<List<int>> layers,
  ) {
    if (allZeros(layers.last)) return layers;

    return getAllLayers([...layers, getNextLayer(layers.last)]);
  }

  List<int> getNextLayer(
    List<int> currentLayer, {
    int index = 0,
    List<int> nextLayer = const [],
  }) {
    if (index == currentLayer.length - 1) return nextLayer;

    return getNextLayer(
      currentLayer,
      nextLayer: [...nextLayer, currentLayer[index + 1] - currentLayer[index]],
      index: index + 1,
    );
  }

  int extrapolate(List<List<int>> layers) {
    // deep copy so tests work without mutating original data
    final reversed = List<List<int>>.from(layers.reversed.map(List<int>.from));

    for (var i = 0; i < reversed.length; i++) {
      final int add;
      if (i == 0) {
        add = 0;
      } else {
        add = reversed[i - 1].last;
      }
      reversed[i].add(reversed[i].last + add);
    }

    return reversed.last.last;
  }

  int extrapolateBeggining(List<List<int>> layers) {
    // deep copy so tests work without mutating original data
    final reversed = List<List<int>>.from(layers.reversed.map(List<int>.from));

    for (var i = 0; i < reversed.length; i++) {
      final int subtract;
      if (i == 0) {
        subtract = 0;
      } else {
        subtract = reversed[i - 1].first;
      }
      reversed[i].insert(0, reversed[i].first - subtract);
    }

    return reversed.last.first;
  }

  bool allZeros(Iterable<int> l) => l.every((e) => e == 0);
}
