import 'package:flutter/material.dart';
import 'package:poke_app/src/common/enums/pokemons_enums.dart';
import 'package:poke_app/src/common/states/state.dart';
import 'package:poke_app/src/features/pokemons/domain/entities/pokemon_entity.dart';
import 'package:poke_app/src/features/pokemons/domain/use_cases/filter_by_type_use_case.dart';
import 'package:poke_app/src/features/pokemons/domain/use_cases/get_all_pokemons_use_case.dart';
import 'package:poke_app/src/features/pokemons/domain/use_cases/get_related_pokemons_use_case.dart';
import 'package:poke_app/src/features/pokemons/domain/use_cases/search_pokemons_use_case.dart';
import 'package:poke_app/src/features/pokemons/domain/use_cases/sort_pokemons_use_case.dart';

typedef _ViewModel = ChangeNotifier;

typedef PokemonState = AppState<List<PokemonEntity>>;

abstract interface class PokemonsViewModel extends _ViewModel {
  PokemonState get pokemonState;
  List<PokemonEntity> get displayedPokemon;
  SortType get currentSort;
  String? get selectedTypeFilter;
  List<String> get availableTypes;

  Future<void> loadPokemon();
  void searchPokemon(String query);
  void sortPokemon(SortType sortType);
  void filterByType(String? type);
  void clearFilters();
  List<PokemonEntity> getRelatedPokemon(PokemonEntity pokemon);
}

class PokemonsViewModelImpl extends _ViewModel implements PokemonsViewModel {
  final GetAllPokemonsUseCase getAllPokemonsUseCase;
  final SearchPokemonsUseCase searchPokemonsUseCase;
  final SortPokemonsUseCase sortPokemonsUseCase;
  final FilterByTypeUseCase filterByTypeUseCase;
  final GetRelatedPokemonsUseCase getRelatedPokemonsUseCase;

  PokemonsViewModelImpl({
    required this.getAllPokemonsUseCase,
    required this.searchPokemonsUseCase,
    required this.sortPokemonsUseCase,
    required this.filterByTypeUseCase,
    required this.getRelatedPokemonsUseCase,
  });

  PokemonState _pokemonState = const InitialState();
  List<PokemonEntity> _allPokemon = [];
  List<PokemonEntity> _displayedPokemon = [];
  SortType _currentSort = SortType.byNumber;
  String? _selectedTypeFilter;
  String _searchQuery = '';

  @override
  PokemonState get pokemonState => _pokemonState;

  @override
  List<PokemonEntity> get displayedPokemon => _displayedPokemon;

  @override
  SortType get currentSort => _currentSort;

  @override
  String? get selectedTypeFilter => _selectedTypeFilter;

  @override
  List<String> get availableTypes {
    final types = <String>{};

    for (var pokemon in _allPokemon) {
      final pokemonTypes = pokemon.type ?? [];

      final typeNames = pokemonTypes.map((t) {
        return typeValues.reverse[t] ?? t.name;
      });

      types.addAll(typeNames);
    }

    final list = types.toList()..sort();
    return list;
  }

  @override
  Future<void> loadPokemon() async {
    _emit(const LoadingState());

    final result = await getAllPokemonsUseCase.call();

    final state = result.fold<PokemonState>(
      onSuccess: (pokemonList) {
        _allPokemon = pokemonList;
        _applyFiltersAndSort();
        return SuccessState(data: _displayedPokemon);
      },
      onError: (error) => ErrorState(message: error.toString()),
    );

    _emit(state);
  }

  @override
  void searchPokemon(String query) {
    _searchQuery = query;
    _applyFiltersAndSort();
    _emit(SuccessState(data: _displayedPokemon));
  }

  @override
  void sortPokemon(SortType sortType) {
    _currentSort = sortType;
    _applyFiltersAndSort();
    _emit(SuccessState(data: _displayedPokemon));
  }

  @override
  void filterByType(String? type) {
    _selectedTypeFilter = type;
    _applyFiltersAndSort();
    _emit(SuccessState(data: _displayedPokemon));
  }

  @override
  void clearFilters() {
    _selectedTypeFilter = null;
    _searchQuery = '';
    _applyFiltersAndSort();
    _emit(SuccessState(data: _displayedPokemon));
  }

  @override
  List<PokemonEntity> getRelatedPokemon(PokemonEntity pokemon) {
    return getRelatedPokemonsUseCase.call(pokemon, _allPokemon);
  }

  void _applyFiltersAndSort() {
    var filtered = _allPokemon;

    // Apply type filter
    filtered = filterByTypeUseCase.call(filtered, _selectedTypeFilter);

    // Apply search
    filtered = searchPokemonsUseCase.call(filtered, _searchQuery);

    // Apply sort
    filtered = sortPokemonsUseCase.call(filtered, _currentSort);

    _displayedPokemon = filtered;
  }

  void _emit(PokemonState newState) {
    if (_pokemonState != newState) {
      _pokemonState = newState;
      notifyListeners();
      debugPrint('Pokemon State: $_pokemonState');
    }
  }
}
