import 'package:poke_app/src/common/results/result.dart';
import 'package:poke_app/src/features/pokemons/data/models/pokemon_model.dart';

typedef PokemonsResult = Result<List<PokemonModel>, Exception>;

abstract interface class PokemonsDataSource {
  Future<PokemonsResult> getAllPokemon();
}
