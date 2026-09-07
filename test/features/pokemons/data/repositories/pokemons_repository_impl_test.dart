import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:poke_app/src/common/enums/pokemons_enums.dart';
import 'package:poke_app/src/common/patterns/result_pattern.dart';
import 'package:poke_app/src/features/pokemons/data/data.dart';
import 'package:poke_app/src/features/pokemons/domain/domain.dart';

import '../../pokemons_mocks.mocks.dart';

void main() {
  group('PokemonsRepositoryImpl', () {
    late MockPokemonsDataSource mockDataSource;
    late PokemonsRepositoryImpl repository;

    final tPokemonList = [
      PokemonModel(id: 1, num: '001', name: 'Bulbasaur', type: [Type.GRASS]),
      PokemonModel(id: 2, num: '002', name: 'Ivysaur', type: [Type.GRASS]),
      PokemonModel(id: 3, num: '003', name: 'Venusaur', type: [Type.GRASS]),
    ];

    setUpAll(() {
      provideDummy<PokemonsResult>(
        SuccessResult<List<PokemonModel>, PokemonException>(value: []),
      );
    });

    setUp(() {
      mockDataSource = MockPokemonsDataSource();
      repository = PokemonsRepositoryImpl(dataSource: mockDataSource);
    });

    group('getAllPokemon', () {
      test('returns SuccessResult when data source succeeds', () async {
        final expected = SuccessResult<List<PokemonModel>, PokemonException>(
          value: tPokemonList,
        );
        when(mockDataSource.getAllPokemon()).thenAnswer((_) async => expected);

        final result = await repository.getAllPokemon();

        expect(result, isA<SuccessResult<List<PokemonEntity>, PokemonException>>());
        verify(mockDataSource.getAllPokemon()).called(1);
      });

      test('returns ErrorResult when data source fails', () async {
        final expected = ErrorResult<List<PokemonModel>, PokemonException>(
          error: PokemonException('Device not connected.'),
        );
        when(mockDataSource.getAllPokemon()).thenAnswer((_) async => expected);

        final result = await repository.getAllPokemon();

        expect(result, isA<ErrorResult<List<PokemonEntity>, PokemonException>>());
      });
    });

    group('searchPokemon', () {
      test('returns full list when query is empty', () {
        final result = repository.searchPokemon(tPokemonList, '');

        expect(result, tPokemonList);
      });

      test('filters by name', () {
        final result = repository.searchPokemon(tPokemonList, 'bulba');

        expect(result.length, 1);
        expect(result.first.name, 'Bulbasaur');
      });
    });

    group('sortPokemon', () {
      test('sorts alphabetically', () {
        final shuffled = [tPokemonList[2], tPokemonList[0], tPokemonList[1]];

        final result = repository.sortPokemon(shuffled, SortType.alphabetical);

        expect(result.map((p) => p.name).toList(),
            ['Bulbasaur', 'Ivysaur', 'Venusaur']);
      });

      test('sorts by number', () {
        final shuffled = [tPokemonList[2], tPokemonList[0], tPokemonList[1]];

        final result = repository.sortPokemon(shuffled, SortType.byNumber);

        expect(result.map((p) => p.id).toList(), [1, 2, 3]);
      });
    });

    group('filterByType', () {
      test('returns all when type is null or empty', () {
        expect(repository.filterByType(tPokemonList, null), tPokemonList);
        expect(repository.filterByType(tPokemonList, ''), tPokemonList);
      });

      test('filters by type name', () {
        final mixed = [
          ...tPokemonList,
          PokemonModel(id: 4, num: '004', name: 'Charmander', type: [Type.FIRE]),
        ];

        final result = repository.filterByType(mixed, 'fire');

        expect(result.length, 1);
        expect(result.first.name, 'Charmander');
      });
    });

    group('getRelatedPokemon', () {
      test('returns prev and next evolution matches', () {
        final ivysaur = PokemonModel(
          id: 2,
          num: '002',
          name: 'Ivysaur',
          prevEvolution: [EvolutionModel(num: '001', name: 'Bulbasaur')],
          nextEvolution: [EvolutionModel(num: '003', name: 'Venusaur')],
        );

        final result = repository.getRelatedPokemon(ivysaur, tPokemonList);

        expect(result.length, 2);
        expect(result.map((p) => p.name).toList(),
            containsAll(['Bulbasaur', 'Venusaur']));
      });
    });
  });
}
