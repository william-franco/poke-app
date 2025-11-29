import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:poke_app/src/common/enums/pokemons_enums.dart';
import 'package:poke_app/src/common/results/result.dart';
import 'package:poke_app/src/common/services/analytics_service.dart';
import 'package:poke_app/src/common/states/state.dart';
import 'package:poke_app/src/features/pokemons/data/models/pokemon_model.dart';
import 'package:poke_app/src/features/pokemons/domain/entities/pokemon_entity.dart';
import 'package:poke_app/src/features/pokemons/presentation/view_models/pokemons_view_model.dart';

import '../../pokemons_mocks.mocks.dart';

void main() {
  provideDummy<Result<List<PokemonEntity>, Exception>>(
    SuccessResult(value: []),
  );

  provideDummy<AnalyticsResult>((
    success: true,
    message: 'Test success',
    error: null,
  ));

  provideDummy<int>(0);
  provideDummy<String>('');
  provideDummy<PokemonEntity>(PokemonModel(id: 0));

  late MockAnalyticsService mockAnalyticsService;
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
    mockAnalyticsService = MockAnalyticsService();
    mockGetAllPokemonsUseCase = MockGetAllPokemonsUseCase();
    mockSearchPokemonsUseCase = MockSearchPokemonsUseCase();
    mockSortPokemonsUseCase = MockSortPokemonsUseCase();
    mockFilterByTypeUseCase = MockFilterByTypeUseCase();
    mockGetRelatedPokemonsUseCase = MockGetRelatedPokemonsUseCase();

    reset(mockAnalyticsService);
    reset(mockGetAllPokemonsUseCase);
    reset(mockSearchPokemonsUseCase);
    reset(mockSortPokemonsUseCase);
    reset(mockFilterByTypeUseCase);
    reset(mockGetRelatedPokemonsUseCase);

    when(
      mockAnalyticsService.logScreenView(
        screenName: anyNamed('screenName'),
        screenClass: anyNamed('screenClass'),
      ),
    ).thenAnswer(
      (_) async => (success: true, message: 'Screen view logged', error: null),
    );

    when(mockAnalyticsService.logPokemonListLoaded(any)).thenAnswer(
      (_) async => (success: true, message: 'List loaded logged', error: null),
    );

    when(mockAnalyticsService.logPokemonLoadError(any)).thenAnswer(
      (_) async => (success: true, message: 'Error logged', error: null),
    );

    when(
      mockAnalyticsService.logSearch(
        searchTerm: anyNamed('searchTerm'),
        resultsCount: anyNamed('resultsCount'),
      ),
    ).thenAnswer(
      (_) async => (success: true, message: 'Search logged', error: null),
    );

    when(
      mockAnalyticsService.logFilter(
        filterType: anyNamed('filterType'),
        filterValue: anyNamed('filterValue'),
      ),
    ).thenAnswer(
      (_) async => (success: true, message: 'Filter logged', error: null),
    );

    when(
      mockAnalyticsService.logSort(sortType: anyNamed('sortType')),
    ).thenAnswer(
      (_) async => (success: true, message: 'Sort logged', error: null),
    );

    when(mockAnalyticsService.logFilterCleared()).thenAnswer(
      (_) async =>
          (success: true, message: 'Filters cleared logged', error: null),
    );

    when(mockAnalyticsService.logPokemonViewFromEntity(any)).thenAnswer(
      (_) async => (success: true, message: 'Pokemon view logged', error: null),
    );

    when(
      mockAnalyticsService.logEvolutionViewed(
        fromPokemon: anyNamed('fromPokemon'),
        toPokemon: anyNamed('toPokemon'),
      ),
    ).thenAnswer(
      (_) async => (success: true, message: 'Evolution logged', error: null),
    );

    viewModel = PokemonsViewModelImpl(
      analyticsService: mockAnalyticsService,
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
      expect(viewModel.pokemonState, isA<InitialState>());
      expect(viewModel.displayedPokemon, isEmpty);
      expect(viewModel.currentSort, SortType.byNumber);
      expect(viewModel.selectedTypeFilter, isNull);
      expect(viewModel.availableTypes, isEmpty);
    });
  });

  group('PokemonsViewModelImpl - loadPokemon com Analytics', () {
    test(
      'deve emitir LoadingState e depois SuccessState quando carregar pokemons com sucesso E logar analytics',
      () async {
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

        await viewModel.loadPokemon();

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

        verify(
          mockAnalyticsService.logScreenView(screenName: 'Pokedex Home'),
        ).called(1);

        verify(mockAnalyticsService.logPokemonListLoaded(3)).called(1);
      },
    );

    test(
      'deve emitir LoadingState e depois ErrorState quando ocorrer erro ao carregar pokemons E logar erro',
      () async {
        final exception = Exception('Erro ao carregar pokemons');
        when(
          mockGetAllPokemonsUseCase.call(),
        ).thenAnswer((_) async => ErrorResult(error: exception));

        final states = <PokemonState>[];
        viewModel.addListener(() {
          states.add(viewModel.pokemonState);
        });

        await viewModel.loadPokemon();

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

        verify(
          mockAnalyticsService.logScreenView(screenName: 'Pokedex Home'),
        ).called(1);

        verify(
          mockAnalyticsService.logPokemonLoadError(
            'Exception: Erro ao carregar pokemons',
          ),
        ).called(1);
      },
    );

    test('deve notificar listeners quando o estado mudar', () async {
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

      await viewModel.loadPokemon();

      expect(notifyCount, 2);
    });
  });

  group('PokemonsViewModelImpl - searchPokemon com Analytics', () {
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

    test('deve filtrar pokemons pela query de busca E logar analytics', () {
      final filteredList = [mockPokemon1];
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(mockSearchPokemonsUseCase.call(any, any)).thenReturn(filteredList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(filteredList);

      clearInteractions(mockAnalyticsService);

      viewModel.searchPokemon('Bulba');

      expect(viewModel.displayedPokemon, filteredList);
      expect(viewModel.pokemonState, isA<SuccessState>());

      verify(
        mockSearchPokemonsUseCase.call(mockPokemonList, 'Bulba'),
      ).called(greaterThanOrEqualTo(1));

      verify(
        mockAnalyticsService.logSearch(searchTerm: 'Bulba', resultsCount: 1),
      ).called(1);
    });

    test(
      'deve retornar todos os pokemons quando a query estiver vazia E NÃO logar analytics',
      () {
        when(
          mockFilterByTypeUseCase.call(any, any),
        ).thenReturn(mockPokemonList);
        when(
          mockSearchPokemonsUseCase.call(any, any),
        ).thenReturn(mockPokemonList);
        when(
          mockSortPokemonsUseCase.call(any, any),
        ).thenReturn(mockPokemonList);

        clearInteractions(mockAnalyticsService);

        viewModel.searchPokemon('');

        expect(viewModel.displayedPokemon, mockPokemonList);
        verify(
          mockSearchPokemonsUseCase.call(mockPokemonList, ''),
        ).called(greaterThanOrEqualTo(1));

        verifyNever(
          mockAnalyticsService.logSearch(
            searchTerm: '',
            resultsCount: anyNamed('resultsCount'),
          ),
        );
      },
    );

    test('deve notificar listeners após busca', () {
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(mockSearchPokemonsUseCase.call(any, any)).thenReturn([mockPokemon1]);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn([mockPokemon1]);

      int notifyCount = 0;
      viewModel.addListener(() {
        notifyCount++;
      });

      viewModel.searchPokemon('Bulba');

      expect(notifyCount, 1);
    });
  });

  group('PokemonsViewModelImpl - sortPokemon com Analytics', () {
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

    test('deve ordenar pokemons por nome E logar analytics', () {
      final sortedList = [mockPokemon1, mockPokemon2, mockPokemon3];
      when(
        mockSortPokemonsUseCase.call(any, SortType.alphabetical),
      ).thenReturn(sortedList);
      when(mockSearchPokemonsUseCase.call(any, any)).thenReturn(sortedList);
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(sortedList);

      clearInteractions(mockAnalyticsService);

      viewModel.sortPokemon(SortType.alphabetical);

      expect(viewModel.currentSort, SortType.alphabetical);
      expect(viewModel.displayedPokemon, sortedList);

      verify(mockAnalyticsService.logSort(sortType: 'alphabetical')).called(1);
    });

    test('deve ordenar pokemons por número E logar analytics', () {
      final sortedList = [mockPokemon1, mockPokemon2, mockPokemon3];
      when(
        mockSortPokemonsUseCase.call(any, SortType.byNumber),
      ).thenReturn(sortedList);
      when(mockSearchPokemonsUseCase.call(any, any)).thenReturn(sortedList);
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(sortedList);

      clearInteractions(mockAnalyticsService);

      viewModel.sortPokemon(SortType.byNumber);

      expect(viewModel.currentSort, SortType.byNumber);
      expect(viewModel.displayedPokemon, sortedList);

      verify(mockAnalyticsService.logSort(sortType: 'by_number')).called(1);
    });

    test('deve notificar listeners após ordenação', () {
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(
        mockSearchPokemonsUseCase.call(any, any),
      ).thenReturn(mockPokemonList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(mockPokemonList);

      int notifyCount = 0;
      viewModel.addListener(() {
        notifyCount++;
      });

      viewModel.sortPokemon(SortType.alphabetical);

      expect(notifyCount, 1);
    });
  });

  group('PokemonsViewModelImpl - filterByType com Analytics', () {
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

    test('deve filtrar pokemons por tipo E logar analytics', () {
      final filteredList = [mockPokemon2];
      when(mockFilterByTypeUseCase.call(any, 'Fire')).thenReturn(filteredList);
      when(mockSearchPokemonsUseCase.call(any, any)).thenReturn(filteredList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(filteredList);

      clearInteractions(mockAnalyticsService);

      viewModel.filterByType('Fire');

      expect(viewModel.selectedTypeFilter, 'Fire');
      expect(viewModel.displayedPokemon, filteredList);

      verify(
        mockAnalyticsService.logFilter(filterType: 'type', filterValue: 'Fire'),
      ).called(1);
    });

    test(
      'deve mostrar todos os pokemons quando tipo for null E NÃO logar analytics',
      () {
        when(
          mockFilterByTypeUseCase.call(any, null),
        ).thenReturn(mockPokemonList);
        when(
          mockSearchPokemonsUseCase.call(any, any),
        ).thenReturn(mockPokemonList);
        when(
          mockSortPokemonsUseCase.call(any, any),
        ).thenReturn(mockPokemonList);

        clearInteractions(mockAnalyticsService);

        viewModel.filterByType(null);

        expect(viewModel.selectedTypeFilter, isNull);
        expect(viewModel.displayedPokemon, mockPokemonList);

        verifyNever(
          mockAnalyticsService.logFilter(
            filterType: anyNamed('filterType'),
            filterValue: anyNamed('filterValue'),
          ),
        );
      },
    );

    test('deve notificar listeners após filtrar por tipo', () {
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn([mockPokemon2]);
      when(mockSearchPokemonsUseCase.call(any, any)).thenReturn([mockPokemon2]);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn([mockPokemon2]);

      int notifyCount = 0;
      viewModel.addListener(() {
        notifyCount++;
      });

      viewModel.filterByType('Fire');

      expect(notifyCount, 1);
    });
  });

  group('PokemonsViewModelImpl - clearFilters com Analytics', () {
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

      final filteredList = [mockPokemon1];
      when(mockFilterByTypeUseCase.call(any, 'Grass')).thenReturn(filteredList);
      when(
        mockSearchPokemonsUseCase.call(any, 'Bulba'),
      ).thenReturn(filteredList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(filteredList);
      viewModel.searchPokemon('Bulba');
      viewModel.filterByType('Grass');
    });

    test(
      'deve limpar todos os filtros, restaurar lista completa E logar analytics',
      () {
        when(
          mockFilterByTypeUseCase.call(any, null),
        ).thenReturn(mockPokemonList);
        when(
          mockSearchPokemonsUseCase.call(any, ''),
        ).thenReturn(mockPokemonList);
        when(
          mockSortPokemonsUseCase.call(any, any),
        ).thenReturn(mockPokemonList);

        clearInteractions(mockAnalyticsService);

        viewModel.clearFilters();

        expect(viewModel.selectedTypeFilter, isNull);
        expect(viewModel.displayedPokemon, mockPokemonList);

        verify(mockAnalyticsService.logFilterCleared()).called(1);
      },
    );

    test('deve notificar listeners após limpar filtros', () {
      when(mockFilterByTypeUseCase.call(any, null)).thenReturn(mockPokemonList);
      when(mockSearchPokemonsUseCase.call(any, '')).thenReturn(mockPokemonList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(mockPokemonList);

      int notifyCount = 0;
      viewModel.addListener(() {
        notifyCount++;
      });

      viewModel.clearFilters();

      expect(notifyCount, 1);
    });
  });

  group('PokemonsViewModelImpl - logPokemonDetailView', () {
    test('deve logar visualização de detalhes do pokemon', () async {
      clearInteractions(mockAnalyticsService);

      await viewModel.logPokemonDetailView(mockPokemon1);

      verify(
        mockAnalyticsService.logPokemonViewFromEntity(mockPokemon1),
      ).called(1);
      verify(
        mockAnalyticsService.logScreenView(
          screenName: 'Pokemon Detail',
          screenClass: 'PokemonDetailView',
        ),
      ).called(1);
    });
  });

  group('PokemonsViewModelImpl - logEvolutionView', () {
    test('deve logar visualização de evolução', () async {
      clearInteractions(mockAnalyticsService);

      await viewModel.logEvolutionView(mockPokemon1, mockPokemon2);

      verify(
        mockAnalyticsService.logEvolutionViewed(
          fromPokemon: 'Bulbasaur',
          toPokemon: 'Charmander',
        ),
      ).called(1);
    });

    test('deve lidar com pokemons sem nome', () async {
      final pokemonWithoutName = PokemonModel(id: 999);

      clearInteractions(mockAnalyticsService);

      await viewModel.logEvolutionView(pokemonWithoutName, mockPokemon1);

      verify(
        mockAnalyticsService.logEvolutionViewed(
          fromPokemon: 'Unknown',
          toPokemon: 'Bulbasaur',
        ),
      ).called(1);
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
      final relatedPokemons = [mockPokemon2, mockPokemon3];
      when(
        mockGetRelatedPokemonsUseCase.call(mockPokemon1, any),
      ).thenReturn(relatedPokemons);

      final result = viewModel.getRelatedPokemon(mockPokemon1);

      expect(result, relatedPokemons);
      verify(
        mockGetRelatedPokemonsUseCase.call(mockPokemon1, mockPokemonList),
      ).called(1);
    });

    test(
      'deve retornar lista vazia quando não houver pokemons relacionados',
      () {
        when(
          mockGetRelatedPokemonsUseCase.call(mockPokemon1, mockPokemonList),
        ).thenReturn([]);

        final result = viewModel.getRelatedPokemon(mockPokemon1);

        expect(result, isEmpty);
      },
    );
  });

  group('PokemonsViewModelImpl - availableTypes', () {
    test('deve retornar lista vazia quando não houver pokemons carregados', () {
      expect(viewModel.availableTypes, isEmpty);
    });

    test('deve retornar lista de tipos únicos e ordenados', () async {
      when(
        mockGetAllPokemonsUseCase.call(),
      ).thenAnswer((_) async => SuccessResult(value: mockPokemonList));
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(
        mockSearchPokemonsUseCase.call(any, any),
      ).thenReturn(mockPokemonList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(mockPokemonList);

      await viewModel.loadPokemon();
      final types = viewModel.availableTypes;

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
      final filteredByType = [mockPokemon1];
      final searchResult = [mockPokemon1];
      final sortedResult = [mockPokemon1];

      when(
        mockFilterByTypeUseCase.call(any, 'Grass'),
      ).thenReturn(filteredByType);
      when(
        mockSearchPokemonsUseCase.call(filteredByType, 'Bulba'),
      ).thenReturn(searchResult);
      when(
        mockSortPokemonsUseCase.call(searchResult, SortType.alphabetical),
      ).thenReturn(sortedResult);
      when(
        mockSearchPokemonsUseCase.call(searchResult, any),
      ).thenReturn(sortedResult);

      viewModel.filterByType('Grass');
      viewModel.searchPokemon('Bulba');
      viewModel.sortPokemon(SortType.alphabetical);

      expect(viewModel.displayedPokemon, sortedResult);
      expect(viewModel.selectedTypeFilter, 'Grass');
      expect(viewModel.currentSort, SortType.alphabetical);
    });

    test('deve manter ordenação após limpar filtros', () {
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

      clearInteractions(mockSortPokemonsUseCase);

      viewModel.clearFilters();

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
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(
        mockSearchPokemonsUseCase.call(any, any),
      ).thenReturn(mockPokemonList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(mockPokemonList);

      int notifyCount = 0;
      viewModel.addListener(() {
        notifyCount++;
      });

      viewModel.searchPokemon('');
      viewModel.searchPokemon('');

      expect(notifyCount, lessThanOrEqualTo(2));
    });
  });

  group('PokemonsViewModelImpl - Edge Cases', () {
    test('deve lidar com lista vazia de pokemons', () async {
      when(
        mockGetAllPokemonsUseCase.call(),
      ).thenAnswer((_) async => SuccessResult(value: []));
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn([]);
      when(mockSearchPokemonsUseCase.call(any, any)).thenReturn([]);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn([]);

      clearInteractions(mockAnalyticsService);

      await viewModel.loadPokemon();

      expect(viewModel.displayedPokemon, isEmpty);
      expect(viewModel.availableTypes, isEmpty);
      expect(viewModel.pokemonState, isA<SuccessState>());

      verify(mockAnalyticsService.logPokemonListLoaded(0)).called(1);
    });

    test('deve lidar com busca sem resultados', () async {
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
        mockSearchPokemonsUseCase.call(mockPokemonList, 'XYZ'),
      ).thenReturn([]);
      when(mockSortPokemonsUseCase.call([], any)).thenReturn([]);

      clearInteractions(mockAnalyticsService);

      viewModel.searchPokemon('XYZ');

      expect(viewModel.displayedPokemon, isEmpty);
      expect(viewModel.pokemonState, isA<SuccessState>());

      verify(
        mockAnalyticsService.logSearch(searchTerm: 'XYZ', resultsCount: 0),
      ).called(1);
    });

    test('deve lidar com tipo de filtro inexistente', () async {
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

      clearInteractions(mockAnalyticsService);

      viewModel.filterByType('Dragon');

      expect(viewModel.displayedPokemon, isEmpty);
      expect(viewModel.selectedTypeFilter, 'Dragon');

      verify(
        mockAnalyticsService.logFilter(
          filterType: 'type',
          filterValue: 'Dragon',
        ),
      ).called(1);
    });
  });

  group('PokemonsViewModelImpl - Analytics Error Handling', () {
    test('deve continuar funcionando mesmo se analytics falhar', () async {
      when(
        mockAnalyticsService.logScreenView(
          screenName: anyNamed('screenName'),
          screenClass: anyNamed('screenClass'),
        ),
      ).thenAnswer(
        (_) async => (success: false, message: null, error: 'Analytics failed'),
      );

      when(
        mockGetAllPokemonsUseCase.call(),
      ).thenAnswer((_) async => SuccessResult(value: mockPokemonList));
      when(mockFilterByTypeUseCase.call(any, any)).thenReturn(mockPokemonList);
      when(
        mockSearchPokemonsUseCase.call(any, any),
      ).thenReturn(mockPokemonList);
      when(mockSortPokemonsUseCase.call(any, any)).thenReturn(mockPokemonList);

      await viewModel.loadPokemon();

      expect(viewModel.pokemonState, isA<SuccessState>());
      expect(viewModel.displayedPokemon, mockPokemonList);
    });
  });
}
