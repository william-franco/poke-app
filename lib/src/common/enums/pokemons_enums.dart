enum Egg { notInEggs, omanyteCandy, the10Km, the2Km, the5Km }

final eggValues = EnumValues({
  'Not in Eggs': Egg.notInEggs,
  'Omanyte Candy': Egg.omanyteCandy,
  '10 km': Egg.the10Km,
  '2 km': Egg.the2Km,
  '5 km': Egg.the5Km,
});

enum Type {
  bug,
  dark,
  dragon,
  electric,
  fairy,
  fighting,
  fire,
  flying,
  ghost,
  grass,
  ground,
  ice,
  normal,
  poison,
  psychic,
  rock,
  steel,
  water,
}

final typeValues = EnumValues({
  'Bug': Type.bug,
  'Dark': Type.dark,
  'Dragon': Type.dragon,
  'Electric': Type.electric,
  'Fairy': Type.fairy,
  'Fighting': Type.fighting,
  'Fire': Type.fire,
  'Flying': Type.flying,
  'Ghost': Type.ghost,
  'Grass': Type.grass,
  'Ground': Type.ground,
  'Ice': Type.ice,
  'Normal': Type.normal,
  'Poison': Type.poison,
  'Psychic': Type.psychic,
  'Rock': Type.rock,
  'Steel': Type.steel,
  'Water': Type.water,
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
