import 'package:mockito/annotations.dart';
import 'package:poke_app/src/common/services/analytics_service.dart';
import 'package:poke_app/src/common/services/connection_service.dart';
import 'package:poke_app/src/common/services/http_service.dart';
import 'package:poke_app/src/features/pokemons/data/data_sources/pokemons_data_source.dart';
import 'package:poke_app/src/features/pokemons/domain/use_cases/filter_by_type_use_case.dart';
import 'package:poke_app/src/features/pokemons/domain/use_cases/get_all_pokemons_use_case.dart';
import 'package:poke_app/src/features/pokemons/domain/use_cases/get_related_pokemons_use_case.dart';
import 'package:poke_app/src/features/pokemons/domain/use_cases/search_pokemons_use_case.dart';
import 'package:poke_app/src/features/pokemons/domain/use_cases/sort_pokemons_use_case.dart';
import 'package:poke_app/src/features/pokemons/presentation/view_models/pokemons_view_model.dart';

@GenerateMocks([
  AnalyticsService,
  ConnectionService,
  HttpService,
  PokemonsDataSource,
  FilterByTypeUseCase,
  GetAllPokemonsUseCase,
  GetRelatedPokemonsUseCase,
  SearchPokemonsUseCase,
  SortPokemonsUseCase,
  PokemonsViewModel,
])
void main() {}
