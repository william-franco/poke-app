enum Egg { NOT_IN_EGGS, OMANYTE_CANDY, THE_10_KM, THE_2_KM, THE_5_KM }

final eggValues = EnumValues({
  'Not in Eggs': Egg.NOT_IN_EGGS,
  'Omanyte Candy': Egg.OMANYTE_CANDY,
  '10 km': Egg.THE_10_KM,
  '2 km': Egg.THE_2_KM,
  '5 km': Egg.THE_5_KM,
});

enum Type {
  BUG,
  DARK,
  DRAGON,
  ELECTRIC,
  FAIRY,
  FIGHTING,
  FIRE,
  FLYING,
  GHOST,
  GRASS,
  GROUND,
  ICE,
  NORMAL,
  POISON,
  PSYCHIC,
  ROCK,
  STEEL,
  WATER,
}

final typeValues = EnumValues({
  'Bug': Type.BUG,
  'Dark': Type.DARK,
  'Dragon': Type.DRAGON,
  'Electric': Type.ELECTRIC,
  'Fairy': Type.FAIRY,
  'Fighting': Type.FIGHTING,
  'Fire': Type.FIRE,
  'Flying': Type.FLYING,
  'Ghost': Type.GHOST,
  'Grass': Type.GRASS,
  'Ground': Type.GROUND,
  'Ice': Type.ICE,
  'Normal': Type.NORMAL,
  'Poison': Type.POISON,
  'Psychic': Type.PSYCHIC,
  'Rock': Type.ROCK,
  'Steel': Type.STEEL,
  'Water': Type.WATER,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

enum SortType { alphabetical, byNumber }
