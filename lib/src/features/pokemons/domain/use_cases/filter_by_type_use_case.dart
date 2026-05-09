import 'package:poke_app/src/features/pokemons/domain/domain.dart';

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
