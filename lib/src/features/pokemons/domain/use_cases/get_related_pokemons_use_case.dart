import 'package:poke_app/src/features/pokemons/domain/entities/pokemon_entity.dart';
import 'package:poke_app/src/features/pokemons/domain/repositories/pokemons_repository.dart';

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
