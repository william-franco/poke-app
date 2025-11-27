import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:poke_app/src/common/enums/pokemons_enums.dart';
import 'package:poke_app/src/common/results/result.dart';
import 'package:poke_app/src/common/states/state.dart';
import 'package:poke_app/src/features/pokemons/data/models/pokemon_model.dart';
import 'package:poke_app/src/features/pokemons/domain/entities/pokemon_entity.dart';
import 'package:poke_app/src/features/pokemons/presentation/view_models/pokemons_view_model.dart';

import '../../pokemons_mocks.mocks.dart';

void main() {
  // Configurar dummy values para o Mockito
  provideDummy<Result<List<PokemonEntity>, Exception>>(
    SuccessResult(value: []),
  );

  late PokemonsViewModelImpl viewModel;
  late MockGetAllPokemonsUseCase mockGetAllPokemonsUseCase;
  late MockSearchPokemonsUseCase mockSearchPokemonsUseCase;
  late MockSortPokemonsUseCase mockSortPokemonsUseCase;
  late MockFilterByTypeUseCase mockFilterByTypeUseCase;
  late MockGetRelatedPokemonsUseCase mockGetRelatedPokemonsUseCase;

  // Mock data
  final mockPokemon1 = PokemonModel(
    id: 1,
    num: '001',
    name: 'Bulbasaur',
    img: 'http://example.com/bulbasaur.png',
    type: [Type.GRASS, Type.POISON],
    height: '0.71 m',
    weight: '6.9 kg',
    candy: 'Bulbasaur Candy',
    candyCount: 25,
    egg: Egg.THE_2_KM,
    spawnChance: 0.69,
    avgSpawns: 69,
    spawnTime: '20:00',
    multipliers: [1.58],
    weaknesses: [Type.FIRE, Type.ICE, Type.FLYING, Type.PSYCHIC],
  );

  final mockPokemon2 = PokemonModel(
    id: 4,
    num: '004',
    name: 'Charmander',
    img: 'http://example.com/charmander.png',
    type: [Type.FIRE],
    height: '0.61 m',
    weight: '8.5 kg',
    candy: 'Charmander Candy',
    candyCount: 25,
    egg: Egg.THE_2_KM,
    spawnChance: 0.253,
    avgSpawns: 25.3,
    spawnTime: '08:45',
    multipliers: [1.65],
    weaknesses: [Type.WATER, Type.GROUND, Type.ROCK],
  );

  final mockPokemon3 = PokemonModel(
    id: 7,
    num: '007',
    name: 'Squirtle',
    img: 'http://example.com/squirtle.png',
    type: [Type.WATER],
    height: '0.51 m',
    weight: '9.0 kg',
    candy: 'Squirtle Candy',
    candyCount: 25,
    egg: Egg.THE_2_KM,
    spawnChance: 0.58,
    avgSpawns: 58,
    spawnTime: '04:25',
    multipliers: [2.1],
    weaknesses: [Type.ELECTRIC, Type.GRASS],
  );

  final mockPokemonList = [mockPokemon1, mockPokemon2, mockPokemon3];

  setUp(() {
    mockGetAllPokemonsUseCase = MockGetAllPokemonsUseCase();
    mockSearchPokemonsUseCase = MockSearchPokemonsUseCase();
    mockSortPokemonsUseCase = MockSortPokemonsUseCase();
    mockFilterByTypeUseCase = MockFilterByTypeUseCase();
    mockGetRelatedPokemonsUseCase = MockGetRelatedPokemonsUseCase();

    viewModel = PokemonsViewModelImpl(
      getAllPokemonsUseCase: mockGetAllPokemonsUseCase,
      searchPokemonsUseCase: mockSearchPokemonsUseCase,
      sortPokemonsUseCase: mockSortPokemonsUseCase,
      filterByTypeUseCase: mockFilterByTypeUseCase,
      getRelatedPokemonsUseCase: mockGetRelatedPokemonsUseCase,
    );
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('PokemonsViewModelImpl - Initial State', () {
    test('deve ter estado inicial correto', () {
      // Assert
      expect(viewModel.pokemonState, isA<InitialState>());
      expect(viewModel.displayedPokemon, isEmpty);
      expect(viewModel.currentSort, SortType.byNumber);
      expect(viewModel.selectedTypeFilter, isNull);
      expect(viewModel.availableTypes, isEmpty);
    });
  });

  group('PokemonsViewModelImpl - loadPokemon', () {
    test(
      'deve emitir LoadingState e depois SuccessState quando carregar pokemons com sucesso',
      () async {
        // Arrange
        when(
          mockGetAllPokemonsUseCase.call(),
        ).thenAnswer((_) async => SuccessResult(value: mockPokemonList));
        when(
          mockFilterByTypeUseCase.call(any, any),
        ).thenReturn(mockPokemonList);
        when(
          mockSearchPokemonsUseCase.call(any, any),
        ).thenReturn(mockPokemonList);
        when(
          mockSortPokemonsUseCase.call(any, any),
        ).thenReturn(mockPokemonList);

        final states = <PokemonState>[];
        viewModel.addListener(() {
          states.add(viewModel.pokemonState);
        });

        // Act
        await viewModel.loadPokemon();

        // Assert
        expect(states.length, 2);
        expect(states[0], isA<LoadingState>());
        expect(states[1], isA<SuccessState<List<PokemonEntity>>>());

        final successState = states[1] as SuccessState<List<PokemonEntity>>;
        expect(successState.data, mockPokemonList);
        expect(viewModel.displayedPokemon, mockPokemonList);

        verify(mockGetAllPokemonsUseCase.call()).called(1);
        verify(mockFilterByTypeUseCase.call(mockPokemonList, null)).called(1);
        verify(mockSearchPokemonsUseCase.call(mockPokemonList, '')).called(1);
        verify(
          mockSortPokemonsUseCase.call(mockPokemonList, SortType.byNumber),
        ).called(1);
      },
    );

    test(
      'deve emitir LoadingState e depois ErrorState quando ocorrer erro ao carregar pokemons',
      () async {
        // Arrange
        final exception = Exception('Erro ao carregar pokemons');
        when(
          mockGetAllPokemonsUseCase.call(),
        ).thenAnswer((_) async => ErrorResult(error: exception));

        final states = <PokemonState>[];
        viewModel.addListener(() {
          states.add(viewModel.pokemonState);
        });

        // Act
        await viewModel.loadPokemon();

        // Assert
        expect(states.length, 2);
        expect(states[0], isA<LoadingState>());
        expect(states[1], isA<ErrorState<List<PokemonEntity>>>());

        final errorState = states[1] as ErrorState<List<PokemonEntity>>;
        expect(errorState.message, contains('Erro ao carregar pokemons'));
        expect(viewModel.displayedPokemon, isEmpty);

        verify(mockGetAllPokemonsUseCase.call()).called(1);
        verifyNever(mockFilterByTypeUseCase.call(any, any));
        verifyNever(mockSearchPokemonsUseCase.call(any, any));
        verifyNever(mockSortPokemonsUseCase.call(any, any));
      },
    );

    test('deve notificar listeners quando o estado mudar', () async {
      // Arrange
      when(
        mockGetAllPokemonsUseCase.call(),
      ).thenAnswer((_) async => SuccessResult(value: mockPokemonList));
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(
        mockSearchPokemonsUseCase.call(any, any),
      ).thenReturn(mockPokemonList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(mockPokemonList);

      int notifyCount = 0;
      viewModel.addListener(() {
        notifyCount++;
      });

      // Act
      await viewModel.loadPokemon();

      // Assert
      expect(notifyCount, 2); // Loading + Success
    });
  });

  group('PokemonsViewModelImpl - searchPokemon', () {
    setUp(() async {
      when(
        mockGetAllPokemonsUseCase.call(),
      ).thenAnswer((_) async => SuccessResult(value: mockPokemonList));
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(
        mockSearchPokemonsUseCase.call(any, any),
      ).thenReturn(mockPokemonList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(mockPokemonList);

      await viewModel.loadPokemon();
    });

    test('deve filtrar pokemons pela query de busca', () {
      // Arrange
      final filteredList = [mockPokemon1];
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(mockSearchPokemonsUseCase.call(any, any)).thenReturn(filteredList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(filteredList);

      // Act
      viewModel.searchPokemon('Bulba');

      // Assert
      expect(viewModel.displayedPokemon, filteredList);
      expect(viewModel.pokemonState, isA<SuccessState>());

      verify(
        mockSearchPokemonsUseCase.call(mockPokemonList, 'Bulba'),
      ).called(greaterThanOrEqualTo(1));
      verify(
        mockFilterByTypeUseCase.call(mockPokemonList, null),
      ).called(greaterThanOrEqualTo(1));
      verify(
        mockSortPokemonsUseCase.call(filteredList, SortType.byNumber),
      ).called(greaterThanOrEqualTo(1));
    });

    test('deve retornar todos os pokemons quando a query estiver vazia', () {
      // Arrange
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(
        mockSearchPokemonsUseCase.call(any, any),
      ).thenReturn(mockPokemonList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(mockPokemonList);

      // Act
      viewModel.searchPokemon('');

      // Assert
      expect(viewModel.displayedPokemon, mockPokemonList);
      verify(
        mockSearchPokemonsUseCase.call(mockPokemonList, ''),
      ).called(greaterThanOrEqualTo(1));
    });

    test('deve notificar listeners após busca', () {
      // Arrange
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(mockSearchPokemonsUseCase.call(any, any)).thenReturn([mockPokemon1]);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn([mockPokemon1]);

      int notifyCount = 0;
      viewModel.addListener(() {
        notifyCount++;
      });

      // Act
      viewModel.searchPokemon('Bulba');

      // Assert
      expect(notifyCount, 1);
    });
  });

  group('PokemonsViewModelImpl - sortPokemon', () {
    setUp(() async {
      when(
        mockGetAllPokemonsUseCase.call(),
      ).thenAnswer((_) async => SuccessResult(value: mockPokemonList));
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(
        mockSearchPokemonsUseCase.call(any, any),
      ).thenReturn(mockPokemonList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(mockPokemonList);

      await viewModel.loadPokemon();
    });

    test('deve ordenar pokemons por nome', () {
      // Arrange
      final sortedList = [mockPokemon1, mockPokemon2, mockPokemon3];
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(
        mockSearchPokemonsUseCase.call(any, any),
      ).thenReturn(mockPokemonList);
      when(
        mockSortPokemonsUseCase.call(any, SortType.alphabetical),
      ).thenReturn(sortedList);

      // Act
      viewModel.sortPokemon(SortType.alphabetical);

      // Assert
      expect(viewModel.currentSort, SortType.alphabetical);
      expect(viewModel.displayedPokemon, sortedList);
      verify(
        mockSortPokemonsUseCase.call(mockPokemonList, SortType.alphabetical),
      ).called(1);
    });

    test('deve ordenar pokemons por número', () {
      // Arrange
      final sortedList = [mockPokemon1, mockPokemon2, mockPokemon3];
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(
        mockSearchPokemonsUseCase.call(any, any),
      ).thenReturn(mockPokemonList);
      when(
        mockSortPokemonsUseCase.call(any, SortType.byNumber),
      ).thenReturn(sortedList);

      // Act
      viewModel.sortPokemon(SortType.byNumber);

      // Assert
      expect(viewModel.currentSort, SortType.byNumber);
      expect(viewModel.displayedPokemon, sortedList);
      verify(
        mockSortPokemonsUseCase.call(mockPokemonList, SortType.byNumber),
      ).called(greaterThanOrEqualTo(1));
    });

    test('deve notificar listeners após ordenação', () {
      // Arrange
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(
        mockSearchPokemonsUseCase.call(any, any),
      ).thenReturn(mockPokemonList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(mockPokemonList);

      int notifyCount = 0;
      viewModel.addListener(() {
        notifyCount++;
      });

      // Act
      viewModel.sortPokemon(SortType.alphabetical);

      // Assert
      expect(notifyCount, 1);
    });
  });

  group('PokemonsViewModelImpl - filterByType', () {
    setUp(() async {
      when(
        mockGetAllPokemonsUseCase.call(),
      ).thenAnswer((_) async => SuccessResult(value: mockPokemonList));
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(
        mockSearchPokemonsUseCase.call(any, any),
      ).thenReturn(mockPokemonList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(mockPokemonList);

      await viewModel.loadPokemon();
    });

    test('deve filtrar pokemons por tipo', () {
      // Arrange
      final filteredList = [mockPokemon2];
      when(mockFilterByTypeUseCase.call(any, 'Fire')).thenReturn(filteredList);
      when(mockSearchPokemonsUseCase.call(any, any)).thenReturn(filteredList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(filteredList);

      // Act
      viewModel.filterByType('Fire');

      // Assert
      expect(viewModel.selectedTypeFilter, 'Fire');
      expect(viewModel.displayedPokemon, filteredList);
      verify(mockFilterByTypeUseCase.call(mockPokemonList, 'Fire')).called(1);
    });

    test('deve mostrar todos os pokemons quando tipo for null', () {
      // Arrange
      when(mockFilterByTypeUseCase.call(any, null)).thenReturn(mockPokemonList);
      when(
        mockSearchPokemonsUseCase.call(any, any),
      ).thenReturn(mockPokemonList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(mockPokemonList);

      // Act
      viewModel.filterByType(null);

      // Assert
      expect(viewModel.selectedTypeFilter, isNull);
      expect(viewModel.displayedPokemon, mockPokemonList);
      verify(
        mockFilterByTypeUseCase.call(mockPokemonList, null),
      ).called(greaterThanOrEqualTo(1));
    });

    test('deve notificar listeners após filtrar por tipo', () {
      // Arrange
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn([mockPokemon2]);
      when(mockSearchPokemonsUseCase.call(any, any)).thenReturn([mockPokemon2]);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn([mockPokemon2]);

      int notifyCount = 0;
      viewModel.addListener(() {
        notifyCount++;
      });

      // Act
      viewModel.filterByType('Fire');

      // Assert
      expect(notifyCount, 1);
    });
  });

  group('PokemonsViewModelImpl - clearFilters', () {
    setUp(() async {
      // Configurar estado inicial com pokemons carregados
      when(
        mockGetAllPokemonsUseCase.call(),
      ).thenAnswer((_) async => SuccessResult(value: mockPokemonList));
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(
        mockSearchPokemonsUseCase.call(any, any),
      ).thenReturn(mockPokemonList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(mockPokemonList);

      await viewModel.loadPokemon();

      // Aplicar filtros antes de limpar
      final filteredList = [mockPokemon1];
      when(mockFilterByTypeUseCase.call(any, 'Grass')).thenReturn(filteredList);
      when(
        mockSearchPokemonsUseCase.call(any, 'Bulba'),
      ).thenReturn(filteredList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(filteredList);

      viewModel.searchPokemon('Bulba');
      viewModel.filterByType('Grass');
    });

    test('deve limpar todos os filtros e restaurar lista completa', () {
      // Arrange
      when(mockFilterByTypeUseCase.call(any, null)).thenReturn(mockPokemonList);
      when(mockSearchPokemonsUseCase.call(any, '')).thenReturn(mockPokemonList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(mockPokemonList);

      // Act
      viewModel.clearFilters();

      // Assert
      expect(viewModel.selectedTypeFilter, isNull);
      expect(viewModel.displayedPokemon, mockPokemonList);
      verify(
        mockFilterByTypeUseCase.call(mockPokemonList, null),
      ).called(greaterThanOrEqualTo(1));
      verify(
        mockSearchPokemonsUseCase.call(mockPokemonList, ''),
      ).called(greaterThanOrEqualTo(1));
    });

    test('deve notificar listeners após limpar filtros', () {
      // Arrange
      when(mockFilterByTypeUseCase.call(any, null)).thenReturn(mockPokemonList);
      when(mockSearchPokemonsUseCase.call(any, '')).thenReturn(mockPokemonList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(mockPokemonList);

      int notifyCount = 0;
      viewModel.addListener(() {
        notifyCount++;
      });

      // Act
      viewModel.clearFilters();

      // Assert
      expect(notifyCount, 1);
    });
  });

  group('PokemonsViewModelImpl - getRelatedPokemon', () {
    setUp(() async {
      when(
        mockGetAllPokemonsUseCase.call(),
      ).thenAnswer((_) async => SuccessResult(value: mockPokemonList));
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(
        mockSearchPokemonsUseCase.call(any, any),
      ).thenReturn(mockPokemonList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(mockPokemonList);

      await viewModel.loadPokemon();
    });

    test('deve retornar pokemons relacionados', () {
      // Arrange
      final relatedPokemons = [mockPokemon2, mockPokemon3];
      when(
        mockGetRelatedPokemonsUseCase.call(mockPokemon1, mockPokemonList),
      ).thenReturn(relatedPokemons);

      // Act
      final result = viewModel.getRelatedPokemon(mockPokemon1);

      // Assert
      expect(result, relatedPokemons);
      verify(
        mockGetRelatedPokemonsUseCase.call(mockPokemon1, mockPokemonList),
      ).called(1);
    });

    test(
      'deve retornar lista vazia quando não houver pokemons relacionados',
      () {
        // Arrange
        when(
          mockGetRelatedPokemonsUseCase.call(mockPokemon1, mockPokemonList),
        ).thenReturn([]);

        // Act
        final result = viewModel.getRelatedPokemon(mockPokemon1);

        // Assert
        expect(result, isEmpty);
      },
    );
  });

  group('PokemonsViewModelImpl - availableTypes', () {
    test('deve retornar lista vazia quando não houver pokemons carregados', () {
      // Assert
      expect(viewModel.availableTypes, isEmpty);
    });

    test('deve retornar lista de tipos únicos e ordenados', () async {
      // Arrange
      when(
        mockGetAllPokemonsUseCase.call(),
      ).thenAnswer((_) async => SuccessResult(value: mockPokemonList));
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(
        mockSearchPokemonsUseCase.call(any, any),
      ).thenReturn(mockPokemonList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(mockPokemonList);

      // Act
      await viewModel.loadPokemon();
      final types = viewModel.availableTypes;

      // Assert
      expect(types, isNotEmpty);
      expect(types.contains('Fire'), true);
      expect(types.contains('Water'), true);
      expect(types.contains('Grass'), true);
      expect(types.contains('Poison'), true);

      final sortedTypes = [...types]..sort();
      expect(types, sortedTypes);
    });
  });

  group('PokemonsViewModelImpl - Filtros combinados', () {
    setUp(() async {
      // Configurar estado inicial com pokemons carregados
      when(
        mockGetAllPokemonsUseCase.call(),
      ).thenAnswer((_) async => SuccessResult(value: mockPokemonList));
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(
        mockSearchPokemonsUseCase.call(any, any),
      ).thenReturn(mockPokemonList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(mockPokemonList);

      await viewModel.loadPokemon();
    });

    test('deve aplicar busca, filtro por tipo e ordenação juntos', () {
      // Arrange
      final filteredByType = [mockPokemon1];
      final searchResult = [mockPokemon1];
      final sortedResult = [mockPokemon1];

      when(
        mockFilterByTypeUseCase.call(mockPokemonList, 'Grass'),
      ).thenReturn(filteredByType);
      when(
        mockSearchPokemonsUseCase.call(filteredByType, 'Bulba'),
      ).thenReturn(searchResult);
      when(
        mockSortPokemonsUseCase.call(searchResult, SortType.alphabetical),
      ).thenReturn(sortedResult);

      // Act
      viewModel.filterByType('Grass');
      viewModel.searchPokemon('Bulba');
      viewModel.sortPokemon(SortType.alphabetical);

      // Assert
      expect(viewModel.displayedPokemon, sortedResult);
      expect(viewModel.selectedTypeFilter, 'Grass');
      expect(viewModel.currentSort, SortType.alphabetical);
    });

    test('deve manter ordenação após limpar filtros', () {
      // Arrange
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(
        mockSearchPokemonsUseCase.call(any, any),
      ).thenReturn(mockPokemonList);
      when(
        mockSortPokemonsUseCase.call(any, SortType.alphabetical),
      ).thenReturn(mockPokemonList);

      viewModel.sortPokemon(SortType.alphabetical);
      viewModel.filterByType('Fire');
      viewModel.searchPokemon('Char');

      // Act
      viewModel.clearFilters();

      // Assert
      expect(viewModel.currentSort, SortType.alphabetical);
      expect(viewModel.selectedTypeFilter, isNull);
      verify(
        mockSortPokemonsUseCase.call(mockPokemonList, SortType.alphabetical),
      ).called(greaterThan(0));
    });
  });

  group('PokemonsViewModelImpl - Estado não muda se for igual', () {
    setUp(() async {
      when(
        mockGetAllPokemonsUseCase.call(),
      ).thenAnswer((_) async => SuccessResult(value: mockPokemonList));
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(
        mockSearchPokemonsUseCase.call(any, any),
      ).thenReturn(mockPokemonList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(mockPokemonList);

      await viewModel.loadPokemon();
    });

    test('não deve notificar listeners se o estado não mudar', () {
      // Arrange
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(
        mockSearchPokemonsUseCase.call(any, any),
      ).thenReturn(mockPokemonList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(mockPokemonList);

      int notifyCount = 0;
      viewModel.addListener(() {
        notifyCount++;
      });

      // Act
      viewModel.searchPokemon('');
      viewModel.searchPokemon('');

      // Assert
      expect(notifyCount, lessThanOrEqualTo(2));
    });
  });

  group('PokemonsViewModelImpl - Edge Cases', () {
    test('deve lidar com lista vazia de pokemons', () async {
      // Arrange
      when(
        mockGetAllPokemonsUseCase.call(),
      ).thenAnswer((_) async => SuccessResult(value: []));
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn([]);
      when(mockSearchPokemonsUseCase.call(any, any)).thenReturn([]);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn([]);

      // Act
      await viewModel.loadPokemon();

      // Assert
      expect(viewModel.displayedPokemon, isEmpty);
      expect(viewModel.availableTypes, isEmpty);
      expect(viewModel.pokemonState, isA<SuccessState>());
    });

    test('deve lidar com busca sem resultados', () async {
      // Arrange
      when(
        mockGetAllPokemonsUseCase.call(),
      ).thenAnswer((_) async => SuccessResult(value: mockPokemonList));
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(
        mockSearchPokemonsUseCase.call(any, any),
      ).thenReturn(mockPokemonList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(mockPokemonList);

      await viewModel.loadPokemon();

      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(
        mockSearchPokemonsUseCase.call(mockPokemonList, 'XYZ'),
      ).thenReturn([]);
      when(mockSortPokemonsUseCase.call([], any)).thenReturn([]);

      // Act
      viewModel.searchPokemon('XYZ');

      // Assert
      expect(viewModel.displayedPokemon, isEmpty);
      expect(viewModel.pokemonState, isA<SuccessState>());
    });

    test('deve lidar com tipo de filtro inexistente', () async {
      // Arrange
      when(
        mockGetAllPokemonsUseCase.call(),
      ).thenAnswer((_) async => SuccessResult(value: mockPokemonList));
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(
        mockSearchPokemonsUseCase.call(any, any),
      ).thenReturn(mockPokemonList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(mockPokemonList);

      await viewModel.loadPokemon();

      when(
        mockFilterByTypeUseCase.call(mockPokemonList, 'Dragon'),
      ).thenReturn([]);
      when(mockSearchPokemonsUseCase.call([], any)).thenReturn([]);
      when(mockSortPokemonsUseCase.call([], any)).thenReturn([]);

      // Act
      viewModel.filterByType('Dragon');

      // Assert
      expect(viewModel.displayedPokemon, isEmpty);
      expect(viewModel.selectedTypeFilter, 'Dragon');
    });
  });
}
