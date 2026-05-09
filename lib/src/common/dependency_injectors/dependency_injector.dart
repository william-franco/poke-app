import 'package:get_it/get_it.dart';
import 'package:poke_app/src/common/services/analytics_service.dart';
import 'package:poke_app/src/common/services/connection_service.dart';
import 'package:poke_app/src/common/services/http_service.dart';
import 'package:poke_app/src/features/pokemons/pokemons.dart';

final locator = GetIt.instance;

void dependencyInjector() {
  _startAnalyticsService();
  _startConnectionService();
  _startHttpService();
  _startFeaturePokemons();
}

void _startAnalyticsService() {
  locator.registerLazySingleton<AnalyticsService>(() => AnalyticsServiceImpl());
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
      analyticsService: locator<AnalyticsService>(),
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
