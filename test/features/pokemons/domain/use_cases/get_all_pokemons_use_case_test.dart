import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:poke_app/src/common/patterns/result_pattern.dart';
import 'package:poke_app/src/features/pokemons/data/data.dart';
import 'package:poke_app/src/features/pokemons/domain/domain.dart';

import '../../pokemons_mocks.mocks.dart';

void main() {
  group('GetAllPokemonsUseCaseImpl', () {
    late MockPokemonsRepository mockRepository;
    late GetAllPokemonsUseCaseImpl useCase;

    setUpAll(() {
      provideDummy<PokemonResult>(
        SuccessResult<List<PokemonEntity>, PokemonException>(value: []),
      );
    });

    setUp(() {
      mockRepository = MockPokemonsRepository();
      useCase = GetAllPokemonsUseCaseImpl(pokemonsRepository: mockRepository);
    });

    test('delegates call to repository', () async {
      final expected = SuccessResult<List<PokemonModel>, PokemonException>(
        value: [PokemonModel(id: 1, name: 'Bulbasaur')],
      );
      when(mockRepository.getAllPokemon()).thenAnswer((_) async => expected);

      final result = await useCase.call();

      expect(result, expected);
      verify(mockRepository.getAllPokemon()).called(1);
    });
  });
}
