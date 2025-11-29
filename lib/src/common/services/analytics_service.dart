import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:poke_app/src/features/pokemons/domain/entities/pokemon_entity.dart';

typedef AnalyticsResult = ({bool success, String? message, String? error});

abstract interface class AnalyticsService {
  Future<AnalyticsResult> logEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
  });

  Future<AnalyticsResult> logScreenView({
    required String screenName,
    String? screenClass,
  });

  Future<AnalyticsResult> setUserId(String userId);

  Future<AnalyticsResult> setUserProperty({
    required String name,
    required String value,
  });

  Future<AnalyticsResult> logPokemonView({
    required int pokemonId,
    required String pokemonName,
    String? pokemonType,
  });

  Future<AnalyticsResult> logSearch({
    required String searchTerm,
    required int resultsCount,
  });

  Future<AnalyticsResult> logFilter({
    required String filterType,
    required String filterValue,
  });

  Future<AnalyticsResult> logSort({required String sortType});

  Future<AnalyticsResult> setAnalyticsEnabled(bool enabled);

  Future<AnalyticsResult> logError({
    required String errorMessage,
    String? errorCode,
    Map<String, dynamic>? additionalData,
  });

  Future<AnalyticsResult> logPokemonViewFromEntity(PokemonEntity pokemon);

  Future<AnalyticsResult> logPokemonListLoaded(int count);

  Future<AnalyticsResult> logPokemonLoadError(String error);

  Future<AnalyticsResult> logFilterCleared();

  Future<AnalyticsResult> logEvolutionViewed({
    required String fromPokemon,
    required String toPokemon,
  });
}

class AnalyticsServiceImpl implements AnalyticsService {
  static const MethodChannel _channel = MethodChannel(
    'com.pokedex.analytics/native',
  );

  AnalyticsResult _handleSuccess(String message) =>
      (success: true, message: message, error: null);

  AnalyticsResult _handlePlatformError(PlatformException error) {
    debugPrint('❌ Analytics Platform Error: ${error.message}');
    return (
      success: false,
      message: null,
      error: error.message ?? 'Platform error occurred',
    );
  }

  AnalyticsResult _handleGenericError(Object error) {
    debugPrint('❌ Analytics Generic Error: $error');
    return (success: false, message: null, error: error.toString());
  }

  Future<AnalyticsResult> _invokeMethod(
    String method,
    Map<String, dynamic>? arguments,
  ) async {
    try {
      debugPrint(
        '➡️ Analytics: $method ${arguments != null ? "with params" : ""}',
      );

      final result = await _channel.invokeMethod<String>(method, arguments);

      debugPrint('✅ Analytics: $method completed');
      return _handleSuccess(result ?? 'Operation completed successfully');
    } on PlatformException catch (e) {
      return _handlePlatformError(e);
    } catch (e) {
      return _handleGenericError(e);
    }
  }

  @override
  Future<AnalyticsResult> logEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
  }) async {
    return _invokeMethod('logEvent', {
      'eventName': eventName,
      'parameters': parameters ?? {},
    });
  }

  @override
  Future<AnalyticsResult> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    return _invokeMethod('logScreenView', {
      'screenName': screenName,
      'screenClass': screenClass,
    });
  }

  @override
  Future<AnalyticsResult> setUserId(String userId) async {
    return _invokeMethod('setUserId', {'userId': userId});
  }

  @override
  Future<AnalyticsResult> setUserProperty({
    required String name,
    required String value,
  }) async {
    return _invokeMethod('setUserProperty', {'name': name, 'value': value});
  }

  @override
  Future<AnalyticsResult> logPokemonView({
    required int pokemonId,
    required String pokemonName,
    String? pokemonType,
  }) async {
    return _invokeMethod('logPokemonView', {
      'pokemonId': pokemonId,
      'pokemonName': pokemonName,
      'pokemonType': pokemonType,
    });
  }

  @override
  Future<AnalyticsResult> logSearch({
    required String searchTerm,
    required int resultsCount,
  }) async {
    return _invokeMethod('logSearch', {
      'searchTerm': searchTerm,
      'resultsCount': resultsCount,
    });
  }

  @override
  Future<AnalyticsResult> logFilter({
    required String filterType,
    required String filterValue,
  }) async {
    return _invokeMethod('logFilter', {
      'filterType': filterType,
      'filterValue': filterValue,
    });
  }

  @override
  Future<AnalyticsResult> logSort({required String sortType}) async {
    return _invokeMethod('logEvent', {
      'eventName': 'pokemon_sorted',
      'parameters': {'sort_type': sortType},
    });
  }

  @override
  Future<AnalyticsResult> setAnalyticsEnabled(bool enabled) async {
    return _invokeMethod('setAnalyticsEnabled', {'enabled': enabled});
  }

  @override
  Future<AnalyticsResult> logError({
    required String errorMessage,
    String? errorCode,
    Map<String, dynamic>? additionalData,
  }) async {
    return _invokeMethod('logEvent', {
      'eventName': 'app_error',
      'parameters': {
        'error_message': errorMessage,
        if (errorCode != null) 'error_code': errorCode,
        if (additionalData != null) ...additionalData,
      },
    });
  }

  @override
  Future<AnalyticsResult> logPokemonViewFromEntity(PokemonEntity pokemon) {
    return logPokemonView(
      pokemonId: pokemon.id ?? 0,
      pokemonName: pokemon.name ?? 'Unknown',
      pokemonType: pokemon.type?.first.name,
    );
  }

  @override
  Future<AnalyticsResult> logPokemonListLoaded(int count) {
    return logEvent(
      eventName: 'pokemon_list_loaded',
      parameters: {'count': count},
    );
  }

  @override
  Future<AnalyticsResult> logPokemonLoadError(String error) {
    return logError(
      errorMessage: 'Failed to load pokemon',
      errorCode: 'POKEMON_LOAD_ERROR',
      additionalData: {'details': error},
    );
  }

  @override
  Future<AnalyticsResult> logFilterCleared() {
    return logEvent(eventName: 'filters_cleared', parameters: {});
  }

  @override
  Future<AnalyticsResult> logEvolutionViewed({
    required String fromPokemon,
    required String toPokemon,
  }) {
    return logEvent(
      eventName: 'evolution_viewed',
      parameters: {'from_pokemon': fromPokemon, 'to_pokemon': toPokemon},
    );
  }
}
