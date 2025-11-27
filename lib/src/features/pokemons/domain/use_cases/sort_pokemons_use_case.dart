import 'package:poke_app/src/common/enums/pokemons_enums.dart';
import 'package:poke_app/src/features/pokemons/domain/entities/pokemon_entity.dart';
import 'package:poke_app/src/features/pokemons/domain/repositories/pokemons_repository.dart';

abstract interface class SortPokemonsUseCase {
  List<PokemonEntity> call(List<PokemonEntity> pokemonList, SortType sortType);
}

class SortPokemonsUseCaseImpl implements SortPokemonsUseCase {
  final PokemonsRepository pokemonsRepository;

  SortPokemonsUseCaseImpl({required this.pokemonsRepository});

  @override
  List<PokemonEntity> call(List<PokemonEntity> pokemonList, SortType sortType) {
    try {
      return pokemonsRepository.sortPokemon(pokemonList, sortType);
    } catch (_) {
      rethrow;
    }
  }
}
