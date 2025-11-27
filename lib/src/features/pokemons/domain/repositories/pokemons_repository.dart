import 'package:poke_app/src/common/enums/pokemons_enums.dart';
import 'package:poke_app/src/common/results/result.dart';
import 'package:poke_app/src/features/pokemons/domain/entities/pokemon_entity.dart';

typedef PokemonResult = Result<List<PokemonEntity>, Exception>;

abstract interface class PokemonsRepository {
  Future<PokemonResult> getAllPokemon();
  List<PokemonEntity> searchPokemon(
    List<PokemonEntity> pokemonList,
    String query,
  );
  List<PokemonEntity> sortPokemon(
    List<PokemonEntity> pokemonList,
    SortType sortType,
  );
  List<PokemonEntity> filterByType(
    List<PokemonEntity> pokemonList,
    String? type,
  );
  List<PokemonEntity> getRelatedPokemon(
    PokemonEntity pokemon,
    List<PokemonEntity> allPokemon,
  );
}
