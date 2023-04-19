enum CardinalDirection {
  north,
  south,
  west,
  east,
  northwest,
  northeast,
  southwest,
  southeast
}

extension CardinalDirectionExtension on CardinalDirection {
  String get value {
    switch (this) {
      case CardinalDirection.north:
        return 'N';
      case CardinalDirection.south:
        return 'S';
      case CardinalDirection.west:
        return 'W';
      case CardinalDirection.east:
        return 'E';
      case CardinalDirection.northwest:
        return 'NW';
      case CardinalDirection.northeast:
        return 'NE';
      case CardinalDirection.southwest:
        return 'SW';
      case CardinalDirection.southeast:
        return 'SE';
      default:
        return '';
    }
  }
}
