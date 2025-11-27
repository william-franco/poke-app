import 'dart:convert';

import 'package:poke_app/src/common/constants/api_constant.dart';
import 'package:poke_app/src/common/results/result.dart';
import 'package:poke_app/src/common/services/connection_service.dart';
import 'package:poke_app/src/common/services/http_service.dart';
import 'package:poke_app/src/features/pokemons/data/data_sources/pokemons_data_source.dart';
import 'package:poke_app/src/features/pokemons/data/models/pokemons_model.dart';

class PokemonRemoteDataSourceImpl implements PokemonsDataSource {
  final ConnectionService connectionService;
  final HttpService httpService;

  PokemonRemoteDataSourceImpl({
    required this.connectionService,
    required this.httpService,
  });

  @override
  Future<PokemonsResult> getAllPokemon() async {
    try {
      await connectionService.checkConnection();

      if (!connectionService.isConnected) {
        return ErrorResult(error: Exception('Sem conexão com a internet.'));
      }

      final result = await httpService.getData(path: ApiConstant.pokemons);

      if (result.statusCode == 200 && result.data != null) {
        final Map<String, dynamic> data = result.data is String
            ? jsonDecode(result.data) as Map<String, dynamic>
            : result.data as Map<String, dynamic>;

        final pokemonsModel = PokemonsModel.fromJson(data);
        final pokemons = pokemonsModel.pokemon ?? [];

        return SuccessResult(value: pokemons);
      }

      return ErrorResult(
        error: Exception(
          'Erro ao buscar pokemons. Código da API: ${result.statusCode}',
        ),
      );
    } catch (error) {
      return ErrorResult(
        error: Exception('Erro inesperado ao buscar pokemons: $error'),
      );
    }
  }
}
