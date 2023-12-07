import 'dart:math';

import '../utils/index.dart';

class Day07 extends GenericDay {
  Day07() : super(7);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    final allHands = parseInput().map(_handAndBid);
    final sortedHands = allHands
        .sorted((a, b) => _strengthOfHand(b).compareTo(_strengthOfHand(a)));

    return sortedHands
        .asMap()
        .entries
        .toList()
        .map((hand) => (sortedHands.length - hand.key) * hand.value.$2)
        .sum;
  }

  @override
  int solvePart2() {
    final allHands = parseInput().map(_handAndBid);
    final sortedHands = allHands.sorted(
      (a, b) => _strengthOfHandJoker(b).compareTo(_strengthOfHandJoker(a)),
    );

    return sortedHands
        .asMap()
        .entries
        .toList()
        .map((hand) => (sortedHands.length - hand.key) * hand.value.$2)
        .sum;
  }

  num _strengthOfHand((String, int) handAndBid) {
    final type = _typeOfHand(handAndBid.$1);
    final combinedRank = _strengthOfCards(handAndBid.$1);

    return type * pow(14, 6) + combinedRank;
  }

  num _strengthOfHandJoker((String, int) handAndBid) {
    final type = _typeOfHandJoker(handAndBid.$1);
    final combinedRank = _strengthOfCardsJoker(handAndBid.$1);

    return type * pow(14, 5) + combinedRank;
  }

  int _typeOfHand(String hand) {
    final numberOfEachCard = _countCardsOfHand(hand);

    if (numberOfEachCard.length == 1) {
      // five of a kind
      return 7;
    } else if (numberOfEachCard.first == 4) {
      // four of a kind
      return 6;
    } else if (numberOfEachCard.length == 2 && numberOfEachCard.first == 3) {
      // full house
      return 5;
    } else if (numberOfEachCard.first == 3) {
      // three of a kind
      return 4;
    } else if (numberOfEachCard.elementAt(1) == 2) {
      // two pair
      return 3;
    } else if (numberOfEachCard.first == 2) {
      // one pair
      return 2;
    } else {
      // high card
      return 1;
    }
  }

  int _typeOfHandJoker(String hand) {
    final numberOfEachCard = _countCardsOfHandJoker(hand);

    if (numberOfEachCard.length == 1) {
      // five of a kind
      return 7;
    } else if (numberOfEachCard.first == 4) {
      // four of a kind
      return 6;
    } else if (numberOfEachCard.length == 2 && numberOfEachCard.first == 3) {
      // full house
      return 5;
    } else if (numberOfEachCard.first == 3) {
      // three of a kind
      return 4;
    } else if (numberOfEachCard.elementAt(1) == 2) {
      // two pair
      return 3;
    } else if (numberOfEachCard.first == 2) {
      // one pair
      return 2;
    } else {
      // high card
      return 1;
    }
  }

  Iterable<int> _countCardsOfHand(String hand) {
    final cards = hand.split('');
    final cardMap = <String, int>{};

    for (final card in cards) {
      cardMap.update(card, (value) => value + 1, ifAbsent: () => 1);
    }

    return cardMap.values.sorted((a, b) => b.compareTo(a));
  }

  Iterable<int> _countCardsOfHandJoker(String hand) {
    final cards = hand.split('');
    final cardMap = <String, int>{};

    for (final card in cards.where((c) => c != 'J')) {
      cardMap.update(card, (value) => value + 1, ifAbsent: () => 1);
    }

    final sortedCounts = cardMap.values.sorted((a, b) => b.compareTo(a));

    final numberOfJokers = cards.where((c) => c == 'J').length;

    if (sortedCounts.isEmpty) {
      sortedCounts.add(5);
    } else {
      sortedCounts.first += numberOfJokers;
    }

    return sortedCounts;
  }

  num _strengthOfCards(String hand) {
    final cards = hand.split('').map(_rankOfCard);

    return List.generate(5, (i) => cards.elementAt(i) * pow(14, 4 - i))
        .fold(0.0, (p, n) => p + n);
  }

  num _strengthOfCardsJoker(String hand) {
    final cards = hand.split('').map(_rankOfCardJoker);

    return List.generate(5, (i) => cards.elementAt(i) * pow(14, 4 - i))
        .fold(0.0, (p, n) => p + n);
  }

  int _rankOfCard(String card) {
    switch (card) {
      case 'A':
        return 14;
      case 'K':
        return 13;
      case 'Q':
        return 12;
      case 'J':
        return 11;
      case 'T':
        return 10;

      default:
        return int.parse(card);
    }
  }

  int _rankOfCardJoker(String card) {
    switch (card) {
      case 'A':
        return 14;
      case 'K':
        return 13;
      case 'Q':
        return 12;
      // joker is now worth 1 individually
      // making it the weakest card
      case 'J':
        return 1;
      case 'T':
        return 10;

      default:
        return int.parse(card);
    }
  }

  (String, int) _handAndBid(String line) {
    final splitLine = line.split(' ');
    return (splitLine.first, int.parse(splitLine.last));
  }
}
