import 'package:test/test.dart';

import '../solutions/index.dart';

const mockData = '''
LLLRRR

AAA = (BBB, CCC)
DDD = (EEE, FFF)
''';

void main() {
  final solutionClass = Day08();
  final input = mockData.split('\n');
  final directions = input.first.split('');
  final nodeLines = input.getRange(2, input.length - 1);

  group('Test day 08', () {
    test('Parse First Direction', () {
      final direction = solutionClass.isRight(0, directions);
      expect(direction, false);
    });

    test('Parse Last Direction', () {
      final direction = solutionClass.isRight(5, directions);
      expect(direction, true);
    });

    test('Parse 1 Past Last Direction', () {
      final direction = solutionClass.isRight(6, directions);
      expect(direction, false);
    });

    test('Parse Last Direction 2nd Time', () {
      final direction = solutionClass.isRight(11, directions);
      expect(direction, true);
    });

    test('Parse First Node', () {
      final node = solutionClass.lineToNode(nodeLines.first);
      expect(node.name, 'AAA');
      expect(node.left, 'BBB');
      expect(node.right, 'CCC');
    });

    test('Parse Nodes Length', () {
      final nodes = nodeLines.map(solutionClass.lineToNode);
      expect(nodes.length, 2);
    });
  });
}
