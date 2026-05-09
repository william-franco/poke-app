import 'package:poke_app/src/features/pokemons/domain/domain.dart';

abstract interface class GetRelatedPokemonsUseCase {
  List<PokemonEntity> call(
    PokemonEntity pokemon,
    List<PokemonEntity> allPokemon,
  );
}

class GetRelatedPokemonsUseCaseImpl implements GetRelatedPokemonsUseCase {
  final PokemonsRepository pokemonsRepository;

  GetRelatedPokemonsUseCaseImpl({required this.pokemonsRepository});

  @override
  List<PokemonEntity> call(
    PokemonEntity pokemon,
    List<PokemonEntity> allPokemon,
  ) {
    try {
      return pokemonsRepository.getRelatedPokemon(pokemon, allPokemon);
    } catch (_) {
      rethrow;
    }
  }
}
