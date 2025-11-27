import 'package:poke_app/src/features/pokemons/domain/entities/pokemon_entity.dart';
import 'package:poke_app/src/features/pokemons/domain/repositories/pokemons_repository.dart';

abstract interface class FilterByTypeUseCase {
  List<PokemonEntity> call(List<PokemonEntity> pokemonList, String? type);
}

class FilterByTypeUseCaseImpl implements FilterByTypeUseCase {
  final PokemonsRepository pokemonsRepository;

  FilterByTypeUseCaseImpl({required this.pokemonsRepository});

  @override
  List<PokemonEntity> call(List<PokemonEntity> pokemonList, String? type) {
    try {
      return pokemonsRepository.filterByType(pokemonList, type);
    } catch (_) {
      rethrow;
    }
  }
}
