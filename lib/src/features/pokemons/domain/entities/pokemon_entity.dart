import 'package:poke_app/src/common/enums/pokemons_enums.dart';
import 'package:poke_app/src/features/pokemons/domain/entities/evolution_entity.dart';

class PokemonEntity {
  final int? id;
  final String? num;
  final String? name;
  final String? img;
  final List<Type>? type;
  final String? height;
  final String? weight;
  final String? candy;
  final int? candyCount;
  final Egg? egg;
  final double? spawnChance;
  final double? avgSpawns;
  final String? spawnTime;
  final List<double>? multipliers;
  final List<Type>? weaknesses;
  final List<EvolutionEntity>? nextEvolution;
  final List<EvolutionEntity>? prevEvolution;

  PokemonEntity({
    this.id,
    this.num,
    this.name,
    this.img,
    this.type,
    this.height,
    this.weight,
    this.candy,
    this.candyCount,
    this.egg,
    this.spawnChance,
    this.avgSpawns,
    this.spawnTime,
    this.multipliers,
    this.weaknesses,
    this.nextEvolution,
    this.prevEvolution,
  });
}
