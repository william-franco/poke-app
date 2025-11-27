import 'package:poke_app/src/features/pokemons/data/models/pokemon_model.dart';
import 'package:poke_app/src/features/pokemons/domain/entities/pokemons_entity.dart';

class PokemonsModel extends PokemonsEntity {
  @override
  final List<PokemonModel>? pokemon;

  PokemonsModel({this.pokemon});

  factory PokemonsModel.fromJson(Map<String, dynamic> json) => PokemonsModel(
    pokemon: json['pokemon'] == null
        ? []
        : List<PokemonModel>.from(
            json['pokemon']!.map((x) => PokemonModel.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    'pokemon': pokemon == null
        ? []
        : List<dynamic>.from(pokemon!.map((x) => x.toJson())),
  };
}
