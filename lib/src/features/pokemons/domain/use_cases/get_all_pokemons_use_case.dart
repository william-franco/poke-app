import 'package:poke_app/src/features/pokemons/domain/domain.dart';

abstract interface class GetAllPokemonsUseCase {
  Future<PokemonResult> call();
}

class GetAllPokemonsUseCaseImpl implements GetAllPokemonsUseCase {
  final PokemonsRepository pokemonsRepository;

  GetAllPokemonsUseCaseImpl({required this.pokemonsRepository});

  @override
  Future<PokemonResult> call() async {
    return await pokemonsRepository.getAllPokemon();
  }
}
