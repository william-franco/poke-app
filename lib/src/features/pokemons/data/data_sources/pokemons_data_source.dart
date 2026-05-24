import 'package:poke_app/src/common/patterns/result_pattern.dart';
import 'package:poke_app/src/features/pokemons/data/data.dart';

typedef PokemonsResult = Result<List<PokemonModel>, PokemonException>;

abstract interface class PokemonsDataSource {
  Future<PokemonsResult> getAllPokemon();
}
