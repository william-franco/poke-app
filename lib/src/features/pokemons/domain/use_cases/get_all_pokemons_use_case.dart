import 'package:poke_app/src/common/results/result.dart';
import 'package:poke_app/src/features/pokemons/domain/entities/pokemon_entity.dart';
import 'package:poke_app/src/features/pokemons/domain/repositories/pokemons_repository.dart';

typedef PokemonResult = Result<List<PokemonEntity>, Exception>;

abstract interface class GetAllPokemonsUseCase {
  Future<PokemonResult> call();
}

class GetAllPokemonsUseCaseImpl implements GetAllPokemonsUseCase {
  final PokemonsRepository pokemonsRepository;

  GetAllPokemonsUseCaseImpl({required this.pokemonsRepository});

  @override
  Future<PokemonResult> call() async {
    try {
      return await pokemonsRepository.getAllPokemon();
    } catch (_) {
      rethrow;
    }
  }
}
