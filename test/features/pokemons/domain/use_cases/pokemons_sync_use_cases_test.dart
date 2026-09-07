import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:poke_app/src/common/enums/pokemons_enums.dart';
import 'package:poke_app/src/features/pokemons/data/data.dart';
import 'package:poke_app/src/features/pokemons/domain/domain.dart';

import '../../pokemons_mocks.mocks.dart';

void main() {
  final tPokemonList = [
    PokemonModel(id: 1, number: '001', name: 'Bulbasaur', type: [Type.grass]),
    PokemonModel(id: 2, number: '002', name: 'Ivysaur', type: [Type.grass]),
  ];

  group('SearchPokemonsUseCaseImpl', () {
    late MockPokemonsRepository mockRepository;
    late SearchPokemonsUseCaseImpl useCase;

    setUp(() {
      mockRepository = MockPokemonsRepository();
      useCase = SearchPokemonsUseCaseImpl(pokemonsRepository: mockRepository);
    });

    test('delegates to repository', () {
      when(mockRepository.searchPokemon(any, any)).thenReturn([tPokemonList.first]);

      final result = useCase.call(tPokemonList, 'bulba');

      expect(result.length, 1);
      verify(mockRepository.searchPokemon(tPokemonList, 'bulba')).called(1);
    });
  });

  group('SortPokemonsUseCaseImpl', () {
    late MockPokemonsRepository mockRepository;
    late SortPokemonsUseCaseImpl useCase;

    setUp(() {
      mockRepository = MockPokemonsRepository();
      useCase = SortPokemonsUseCaseImpl(pokemonsRepository: mockRepository);
    });

    test('delegates to repository', () {
      when(mockRepository.sortPokemon(any, any)).thenReturn(tPokemonList);

      final result = useCase.call(tPokemonList, SortType.byNumber);

      expect(result, tPokemonList);
      verify(mockRepository.sortPokemon(tPokemonList, SortType.byNumber)).called(1);
    });
  });

  group('FilterByTypeUseCaseImpl', () {
    late MockPokemonsRepository mockRepository;
    late FilterByTypeUseCaseImpl useCase;

    setUp(() {
      mockRepository = MockPokemonsRepository();
      useCase = FilterByTypeUseCaseImpl(pokemonsRepository: mockRepository);
    });

    test('delegates to repository', () {
      when(mockRepository.filterByType(any, any)).thenReturn([tPokemonList.first]);

      final result = useCase.call(tPokemonList, 'grass');

      expect(result.length, 1);
      verify(mockRepository.filterByType(tPokemonList, 'grass')).called(1);
    });
  });

  group('GetRelatedPokemonsUseCaseImpl', () {
    late MockPokemonsRepository mockRepository;
    late GetRelatedPokemonsUseCaseImpl useCase;

    setUp(() {
      mockRepository = MockPokemonsRepository();
      useCase = GetRelatedPokemonsUseCaseImpl(pokemonsRepository: mockRepository);
    });

    test('delegates to repository', () {
      when(mockRepository.getRelatedPokemon(any, any)).thenReturn([tPokemonList.first]);

      final result = useCase.call(tPokemonList[1], tPokemonList);

      expect(result.length, 1);
      verify(mockRepository.getRelatedPokemon(tPokemonList[1], tPokemonList))
          .called(1);
    });
  });
}
