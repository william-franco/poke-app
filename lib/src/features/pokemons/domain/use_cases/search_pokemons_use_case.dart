import 'package:poke_app/src/features/pokemons/domain/domain.dart';

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
