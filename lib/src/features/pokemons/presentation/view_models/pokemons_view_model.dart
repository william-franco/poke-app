import 'package:flutter/foundation.dart';
import 'package:poke_app/src/common/enums/pokemons_enums.dart';
import 'package:poke_app/src/common/patterns/app_state_pattern.dart';
import 'package:poke_app/src/common/services/analytics_service.dart';
import 'package:poke_app/src/common/state_management/state_management.dart';
import 'package:poke_app/src/features/pokemons/domain/domain.dart';

typedef PokemonState = AppState<List<PokemonEntity>>;

typedef _ViewModel = StateManagement<PokemonState>;

abstract interface class PokemonsViewModel extends _ViewModel {
  SortType get currentSort;
  String? get selectedTypeFilter;
  List<String> get availableTypes;

  Future<void> loadPokemon();
  void searchPokemon(String query);
  void sortPokemon(SortType sortType);
  void filterByType(String? type);
  void clearFilters();
  List<PokemonEntity> getRelatedPokemon(PokemonEntity pokemon);

  Future<void> logPokemonDetailView(PokemonEntity pokemon);
  Future<void> logEvolutionView(PokemonEntity from, PokemonEntity to);
}

class PokemonsViewModelImpl extends _ViewModel implements PokemonsViewModel {
  final AnalyticsService analyticsService;
  final GetAllPokemonsUseCase getAllPokemonsUseCase;
  final SearchPokemonsUseCase searchPokemonsUseCase;
  final SortPokemonsUseCase sortPokemonsUseCase;
  final FilterByTypeUseCase filterByTypeUseCase;
  final GetRelatedPokemonsUseCase getRelatedPokemonsUseCase;

  PokemonsViewModelImpl({
    required this.analyticsService,
    required this.getAllPokemonsUseCase,
    required this.searchPokemonsUseCase,
    required this.sortPokemonsUseCase,
    required this.filterByTypeUseCase,
    required this.getRelatedPokemonsUseCase,
  });

  List<PokemonEntity> _allPokemon = [];
  SortType _currentSort = SortType.byNumber;
  String? _selectedTypeFilter;
  String _searchQuery = '';

  @override
  SortType get currentSort => _currentSort;

  @override
  String? get selectedTypeFilter => _selectedTypeFilter;

  @override
  List<String> get availableTypes {
    final types = <String>{};
    for (final pokemon in _allPokemon) {
      final typeNames = (pokemon.type ?? []).map(
        (t) => typeValues.reverse[t] ?? t.name,
      );
      types.addAll(typeNames);
    }
    return types.toList()..sort();
  }

  @override
  PokemonState build() => const InitialState();

  @override
  Future<void> loadPokemon() async {
    _emit(const LoadingState());

    await analyticsService.logScreenView(screenName: 'Pokedex Home');

    final result = await getAllPokemonsUseCase.call();

    final pokemonState = result.fold<PokemonState>(
      onSuccess: (pokemonList) {
        _allPokemon = pokemonList;
        analyticsService.logPokemonListLoaded(_allPokemon.length);
        return SuccessState(data: _computeDisplayedPokemon());
      },
      onError: (error) {
        analyticsService.logPokemonLoadError(error.toString());
        return ErrorState(message: '$error');
      },
    );

    _emit(pokemonState);
  }

  @override
  void searchPokemon(String query) {
    _searchQuery = query;

    final filtered = _computeDisplayedPokemon();

    if (query.isNotEmpty) {
      analyticsService.logSearch(
        searchTerm: query,
        resultsCount: filtered.length,
      );
    }

    _emit(SuccessState(data: filtered));
  }

  @override
  void sortPokemon(SortType sortType) {
    _currentSort = sortType;

    analyticsService.logSort(
      sortType: sortType == SortType.alphabetical
          ? 'alphabetical'
          : 'by_number',
    );

    _emit(SuccessState(data: _computeDisplayedPokemon()));
  }

  @override
  void filterByType(String? type) {
    _selectedTypeFilter = type;

    if (type != null) {
      analyticsService.logFilter(filterType: 'type', filterValue: type);
    }

    _emit(SuccessState(data: _computeDisplayedPokemon()));
  }

  @override
  void clearFilters() {
    _selectedTypeFilter = null;
    _searchQuery = '';

    analyticsService.logFilterCleared();

    _emit(SuccessState(data: _computeDisplayedPokemon()));
  }

  @override
  List<PokemonEntity> getRelatedPokemon(PokemonEntity pokemon) {
    return getRelatedPokemonsUseCase.call(pokemon, _allPokemon);
  }

  @override
  Future<void> logPokemonDetailView(PokemonEntity pokemon) async {
    await analyticsService.logPokemonViewFromEntity(pokemon);
    await analyticsService.logScreenView(
      screenName: 'Pokemon Detail',
      screenClass: 'PokemonDetailView',
    );
  }

  @override
  Future<void> logEvolutionView(PokemonEntity from, PokemonEntity to) async {
    await analyticsService.logEvolutionViewed(
      fromPokemon: from.name ?? 'Unknown',
      toPokemon: to.name ?? 'Unknown',
    );
  }

  List<PokemonEntity> _computeDisplayedPokemon() {
    var filtered = _allPokemon;
    filtered = filterByTypeUseCase.call(filtered, _selectedTypeFilter);
    filtered = searchPokemonsUseCase.call(filtered, _searchQuery);
    filtered = sortPokemonsUseCase.call(filtered, _currentSort);
    return filtered;
  }

  void _emit(PokemonState newState) {
    emitState(newState);
    debugPrint('Pokemon state: $state');
  }
}
