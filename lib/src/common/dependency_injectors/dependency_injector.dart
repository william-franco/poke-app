import 'package:get_it/get_it.dart';
import 'package:poke_app/src/common/services/connection_service.dart';
import 'package:poke_app/src/common/services/http_service.dart';
import 'package:poke_app/src/features/pokemons/data/data_sources/pokemons_data_source.dart';
import 'package:poke_app/src/features/pokemons/data/data_sources/pokemons_data_source_impl.dart';
import 'package:poke_app/src/features/pokemons/data/repositories/pokemons_repository_impl.dart';
import 'package:poke_app/src/features/pokemons/domain/repositories/pokemons_repository.dart';
import 'package:poke_app/src/features/pokemons/domain/use_cases/filter_by_type_use_case.dart';
import 'package:poke_app/src/features/pokemons/domain/use_cases/get_all_pokemons_use_case.dart';
import 'package:poke_app/src/features/pokemons/domain/use_cases/get_related_pokemons_use_case.dart';
import 'package:poke_app/src/features/pokemons/domain/use_cases/search_pokemons_use_case.dart';
import 'package:poke_app/src/features/pokemons/domain/use_cases/sort_pokemons_use_case.dart';
import 'package:poke_app/src/features/pokemons/presentation/view_models/pokemons_view_model.dart';

final locator = GetIt.instance;

void dependencyInjector() {
  _startConnectionService();
  _startHttpService();
  _startFeaturePokemons();
}

void _startConnectionService() {
  locator.registerLazySingleton<ConnectionService>(
    () => ConnectionServiceImpl(),
  );
}

void _startHttpService() {
  locator.registerLazySingleton<HttpService>(() => HttpServiceImpl());
}

void _startFeaturePokemons() {
  locator.registerCachedFactory<PokemonsDataSource>(
    () => PokemonRemoteDataSourceImpl(
      connectionService: locator<ConnectionService>(),
      httpService: locator<HttpService>(),
    ),
  );
  locator.registerCachedFactory<PokemonsRepository>(
    () => PokemonsRepositoryImpl(dataSource: locator<PokemonsDataSource>()),
  );
  locator.registerCachedFactory<FilterByTypeUseCase>(
    () => FilterByTypeUseCaseImpl(
      pokemonsRepository: locator<PokemonsRepository>(),
    ),
  );
  locator.registerCachedFactory<GetAllPokemonsUseCase>(
    () => GetAllPokemonsUseCaseImpl(
      pokemonsRepository: locator<PokemonsRepository>(),
    ),
  );
  locator.registerCachedFactory<GetRelatedPokemonsUseCase>(
    () => GetRelatedPokemonsUseCaseImpl(
      pokemonsRepository: locator<PokemonsRepository>(),
    ),
  );
  locator.registerCachedFactory<SearchPokemonsUseCase>(
    () => SearchPokemonsUseCaseImpl(
      pokemonsRepository: locator<PokemonsRepository>(),
    ),
  );
  locator.registerCachedFactory<SortPokemonsUseCase>(
    () => SortPokemonsUseCaseImpl(
      pokemonsRepository: locator<PokemonsRepository>(),
    ),
  );
  locator.registerLazySingleton<PokemonsViewModel>(
    () => PokemonsViewModelImpl(
      filterByTypeUseCase: locator<FilterByTypeUseCase>(),
      getAllPokemonsUseCase: locator<GetAllPokemonsUseCase>(),
      getRelatedPokemonsUseCase: locator<GetRelatedPokemonsUseCase>(),
      searchPokemonsUseCase: locator<SearchPokemonsUseCase>(),
      sortPokemonsUseCase: locator<SortPokemonsUseCase>(),
    ),
  );
}

void resetDependencies() {
  locator.reset();
}
