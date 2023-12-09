import 'package:test/test.dart';

import '../solutions/index.dart';

const mockSequence = [
  [10, 13, 16, 21, 30, 45],
  [3, 3, 5, 9, 15],
  [0, 2, 4, 6],
  [2, 2, 2],
  [0, 0],
];

void main() {
  final solutionClass = Day09();

  group('Test day 09', () {
    test('Check getNextLayer', () {
      final prediction = solutionClass.getNextLayer([...mockSequence[0]]);
      expect(prediction, mockSequence[1]);
    });

    test('Check getAllLayers', () {
      final prediction = solutionClass.getAllLayers([
        [...mockSequence[0]],
      ]);

      expect(prediction, mockSequence);
    });

    test('Check extrapolateBeggining', () {
      final prediction = solutionClass.extrapolateBeggining([...mockSequence]);

      expect(prediction, 5);
    });

    test('Check getNextPrediction', () {
      final prediction =
          solutionClass.getNextPrediction([...mockSequence.first]);

      expect(prediction, 68);
    });

    test('Check getNextPredictionBeginning', () {
      final input = [...mockSequence.first];

      final prediction = solutionClass.getNextPredictionBeggining(input);

      expect(prediction, 5);
    });

    test('Check extrapolateBeggining', () {
      final prediction = solutionClass.extrapolateBeggining([...mockSequence]);

      expect(prediction, 5);
    });
  });
}
