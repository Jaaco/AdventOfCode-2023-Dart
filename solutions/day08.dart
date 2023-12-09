import '../utils/index.dart';

class Day08 extends GenericDay {
  Day08() : super(8);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    final input = parseInput();
    final directions = input.first.split('');
    final nodes = input.getRange(2, input.length).map(lineToNode);

    return stepsToEndFor(nodes, directions);
  }

  @override
  int solvePart2() {
    final input = parseInput();
    final directions = input.first.split('');
    // final Map<String, Map<String, String>> nodes =
    //     input.getRange(2, input.length).map(lineToNode).map(
    //           (e) => {
    //             e.name: {
    //               'r': e.right,
    //               'l': e.left,
    //             },
    //           },
    //         );

    final nodes = <String, Map<String, dynamic>>{};

    for (final line in input.getRange(2, input.length)) {
      final node = lineToNode(line);
      nodes[node.name] = {
        'r': node.right,
        'l': node.left,
        'final': node.name.substring(2, 3) == 'Z',
      };
    }

    print("First node is contained: ${nodes['LRV']}");
    print("Last node is contained: ${nodes['MQV']}");

    // var step = 0;
    final currentNodes =
        nodes.keys.where((element) => element.substring(2, 3) == 'A');
    print('Start Nodes: $currentNodes');

    final repetitionPatterns = <int>[];

    for (final node in currentNodes) {
      final pattern = findRepetitionsInPattern(nodes, directions, node);
      if (pattern.last - pattern[1] == pattern[1] - pattern.first) {
        print('Pattern detected. Number: ${pattern.last - pattern[1]}');
        repetitionPatterns.add(pattern.last - pattern[1]);
      } else {
        print('PATTERN NOT DETECTED');
      }
    }

    print(lcmInList(repetitionPatterns));
    //
    // try {
    //   while (!currentNodes
    //       .map((e) => nodes[e]!['final'])
    //       .every((element) => element as bool)) {
    //     if (step % 10000 == 0) print('On step: $step');
    //     final right = isRight(step, directions);
    //
    //     currentNodes = currentNodes
    //         .map((e) => (right ? nodes[e]!['r'] : nodes[e]!['l']) as String);
    //
    //     step += 1;
    //   }
    // } catch (e) {
    //   print('Failed. Current nodes: $currentNodes');
    //   print(step);
    // }
    //
    // return step;
    return 0;
  }

  int lcmInList(List<int> numbers, {int currentLcm = 1}) {
    if (numbers.length == 1) return lcm(currentLcm, numbers.first);
    final next = numbers.removeLast();

    final newLcm = lcm(currentLcm, next);

    print(newLcm);

    return lcmInList(numbers, currentLcm: newLcm);
  }

  int lcm(int a, int b) => (a * b) ~/ a.gcd(b);

  List<int> findRepetitionsInPattern(
    Map<String, Map<String, dynamic>> nodes,
    Iterable<String> directions,
    String startNode,
  ) {
    final goals = <int>[];
    var step = 1;
    var currentNode = startNode;
    while (goals.length < 3) {
      final right = isRight(step, directions);
      final currentValues = nodes[currentNode];
      if (currentValues!['final'] as bool) goals.add(step);
      currentNode =
          right ? currentValues['r'] as String : currentValues['l'] as String;
      step += 1;
    }

    return goals;
  }

  int stepsToEndFor(
    Iterable<Node> nodes,
    Iterable<String> directions,
  ) {
    var step = 0;
    var currentNodeName = 'AAA';

    while (currentNodeName != 'ZZZ') {
      final right = isRight(step, directions);

      final node = nodeFromName(currentNodeName, nodes);

      currentNodeName = right ? node.right : node.left;
      step += 1;
    }

    return step;
  }

  int stepsToEndMultiple(
    Iterable<Node> nodes,
    Iterable<String> directions,
  ) {
    var step = 0;
    var currentNodes = nodes.where((n) => n.isStart);

    while (!currentNodes.every((element) => element.isEnd)) {
      if (step % 100 == 0) print(currentNodes);
      if (step % 100 == 0) print('On step: $step');
      final right = isRight(step, directions);
      currentNodes = nextNodes(nodes, currentNodes, isRight: right);
      step += 1;
    }

    return step;
  }

  Iterable<Node> nextNodes(
    Iterable<Node> allNodes,
    Iterable<Node> currentNodes, {
    required bool isRight,
  }) {
    return currentNodes.map(
      (e) {
        return isRight
            ? nodeFromName(e.right, allNodes)
            : nodeFromName(e.left, allNodes);
      },
    );
  }

  Node nodeFromName(String name, Iterable<Node> nodes) {
    return nodes.firstWhere((node) => node.name == name);
  }

  bool isRight(int step, Iterable<String> directions) {
    return directions.elementAt(step % directions.length) == 'R';
  }

  Node lineToNode(String line) {
    final split = line.split('=');
    final children = split.last.split(', ');
    return Node(
      split.first.substring(0, 3),
      children.first.substring(2, 5),
      children.last.substring(0, 3),
    );
  }
}

bool endsWithStr(String long, String ends) {
  return long.substring(2, 3) == ends;
}

class Node {
  Node(this.name, this.left, this.right)
      : isStart = endsWithStr(name, 'A'),
        isEnd = endsWithStr(name, 'Z');

  final String name;
  final String left;
  final String right;
  final bool isStart;
  final bool isEnd;

  @override
  String toString() => name;
}
