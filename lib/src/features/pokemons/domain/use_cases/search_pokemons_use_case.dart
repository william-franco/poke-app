import 'package:poke_app/src/features/pokemons/domain/entities/pokemon_entity.dart';
import 'package:poke_app/src/features/pokemons/domain/repositories/pokemons_repository.dart';

abstract interface class SearchPokemonsUseCase {
  List<PokemonEntity> call(List<PokemonEntity> pokemonList, String query);
}

class SearchPokemonsUseCaseImpl implements SearchPokemonsUseCase {
  final PokemonsRepository pokemonsRepository;

  SearchPokemonsUseCaseImpl({required this.pokemonsRepository});

  @override
  List<PokemonEntity> call(List<PokemonEntity> pokemonList, String query) {
    try {
      return pokemonsRepository.searchPokemon(pokemonList, query);
    } catch (_) {
      rethrow;
    }
  }
}
