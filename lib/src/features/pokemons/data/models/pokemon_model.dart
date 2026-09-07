import 'package:poke_app/src/common/enums/pokemons_enums.dart';
import 'package:poke_app/src/features/pokemons/data/data.dart';
import 'package:poke_app/src/features/pokemons/domain/domain.dart';

class PokemonModel extends PokemonEntity {
  PokemonModel({
    super.id,
    super.number,
    super.name,
    super.img,
    super.type,
    super.height,
    super.weight,
    super.candy,
    super.candyCount,
    super.egg,
    super.spawnChance,
    super.avgSpawns,
    super.spawnTime,
    super.multipliers,
    super.weaknesses,
    super.nextEvolution,
    super.prevEvolution,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) => PokemonModel(
    id: json['id'],
    number: json['num'],
    name: json['name'],
    img: json['img'],
    type: json['type'] == null
        ? []
        : List<Type>.from(json['type']!.map((x) => typeValues.map[x]!)),
    height: json['height'],
    weight: json['weight'],
    candy: json['candy'],
    candyCount: json['candy_count'],
    egg: eggValues.map[json['egg']]!,
    spawnChance: json['spawn_chance']?.toDouble(),
    avgSpawns: json['avg_spawns']?.toDouble(),
    spawnTime: json['spawn_time'],
    multipliers: json['multipliers'] == null
        ? []
        : List<double>.from(json['multipliers']!.map((x) => x?.toDouble())),
    weaknesses: json['weaknesses'] == null
        ? []
        : List<Type>.from(json['weaknesses']!.map((x) => typeValues.map[x]!)),
    nextEvolution: json['next_evolution'] == null
        ? []
        : List<EvolutionModel>.from(
            json['next_evolution']!.map((x) => EvolutionModel.fromJson(x)),
          ),
    prevEvolution: json['prev_evolution'] == null
        ? []
        : List<EvolutionModel>.from(
            json['prev_evolution']!.map((x) => EvolutionModel.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'num': number,
    'name': name,
    'img': img,
    'type': type == null
        ? []
        : List<dynamic>.from(type!.map((x) => typeValues.reverse[x])),
    'height': height,
    'weight': weight,
    'candy': candy,
    'candy_count': candyCount,
    'egg': eggValues.reverse[egg],
    'spawn_chance': spawnChance,
    'avg_spawns': avgSpawns,
    'spawn_time': spawnTime,
    'multipliers': multipliers == null
        ? []
        : List<dynamic>.from(multipliers!.map((x) => x)),
    'weaknesses': weaknesses == null
        ? []
        : List<dynamic>.from(weaknesses!.map((x) => typeValues.reverse[x])),
    'next_evolution': nextEvolution == null
        ? []
        : List<dynamic>.from(
            nextEvolution!.map((x) => (x as EvolutionModel).toJson()),
          ),
    'prev_evolution': prevEvolution == null
        ? []
        : List<dynamic>.from(
            prevEvolution!.map((x) => (x as EvolutionModel).toJson()),
          ),
  };
}
