import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:poke_app/src/common/results/result.dart';
import 'package:poke_app/src/features/pokemons/data/data_sources/pokemons_data_source_impl.dart';
import 'package:poke_app/src/features/pokemons/data/models/pokemon_model.dart';

import '../../pokemons_mocks.mocks.dart';

void main() {
  late PokemonRemoteDataSourceImpl dataSource;
  late MockConnectionService mockConnectionService;
  late MockHttpService mockHttpService;

  setUp(() {
    mockConnectionService = MockConnectionService();
    mockHttpService = MockHttpService();
    dataSource = PokemonRemoteDataSourceImpl(
      connectionService: mockConnectionService,
      httpService: mockHttpService,
    );
  });

  group('PokemonRemoteDataSourceImpl - getAllPokemon', () {
    final mockPokemonJson = {
      'pokemon': [
        {
          'id': 1,
          'num': '001',
          'name': 'Bulbasaur',
          'img': 'http://example.com/bulbasaur.png',
          'type': ['Grass', 'Poison'],
          'height': '0.71 m',
          'weight': '6.9 kg',
          'candy': 'Bulbasaur Candy',
          'candy_count': 25,
          'egg': '2 km',
          'spawn_chance': 0.69,
          'avg_spawns': 69,
          'spawn_time': '20:00',
          'multipliers': [1.58],
          'weaknesses': ['Fire', 'Ice', 'Flying', 'Psychic'],
          'next_evolution': [
            {'num': '002', 'name': 'Ivysaur'},
          ],
        },
        {
          'id': 2,
          'num': '002',
          'name': 'Ivysaur',
          'img': 'http://example.com/ivysaur.png',
          'type': ['Grass', 'Poison'],
          'height': '1.00 m',
          'weight': '13.0 kg',
          'candy': 'Bulbasaur Candy',
          'candy_count': 100,
          'egg': 'Not in Eggs',
          'spawn_chance': 0.042,
          'avg_spawns': 4.2,
          'spawn_time': '07:00',
          'multipliers': [1.2, 1.6],
          'weaknesses': ['Fire', 'Ice', 'Flying', 'Psychic'],
          'prev_evolution': [
            {'num': '001', 'name': 'Bulbasaur'},
          ],
          'next_evolution': [
            {'num': '003', 'name': 'Venusaur'},
          ],
        },
      ],
    };

    test(
      'deve retornar SuccessResult com lista de pokemons quando a requisição for bem-sucedida com data como Map',
      () async {
        // Arrange
        when(
          mockConnectionService.checkConnection(),
        ).thenAnswer((_) async => Future.value());
        when(mockConnectionService.isConnected).thenReturn(true);
        when(mockHttpService.getData(path: anyNamed('path'))).thenAnswer(
          (_) async => (statusCode: 200, data: mockPokemonJson, error: null),
        );

        // Act
        final result = await dataSource.getAllPokemon();

        // Assert
        expect(result, isA<SuccessResult<List<PokemonModel>, Exception>>());

        result.fold(
          onSuccess: (pokemons) {
            expect(pokemons, isA<List<PokemonModel>>());
            expect(pokemons.length, 2);
            expect(pokemons[0].name, 'Bulbasaur');
            expect(pokemons[0].num, '001');
            expect(pokemons[1].name, 'Ivysaur');
            expect(pokemons[1].num, '002');
          },
          onError: (_) => fail('Should not return error'),
        );

        verify(mockConnectionService.checkConnection()).called(1);
        verify(mockConnectionService.isConnected).called(1);
        verify(mockHttpService.getData(path: anyNamed('path'))).called(1);
      },
    );

    test(
      'deve retornar SuccessResult com lista de pokemons quando data for String JSON',
      () async {
        // Arrange
        final jsonString = jsonEncode(mockPokemonJson);

        when(
          mockConnectionService.checkConnection(),
        ).thenAnswer((_) async => Future.value());
        when(mockConnectionService.isConnected).thenReturn(true);
        when(mockHttpService.getData(path: anyNamed('path'))).thenAnswer(
          (_) async => (statusCode: 200, data: jsonString, error: null),
        );

        // Act
        final result = await dataSource.getAllPokemon();

        // Assert
        expect(result, isA<SuccessResult<List<PokemonModel>, Exception>>());

        result.fold(
          onSuccess: (pokemons) {
            expect(pokemons, isA<List<PokemonModel>>());
            expect(pokemons.length, 2);
            expect(pokemons[0].name, 'Bulbasaur');
            expect(pokemons[1].name, 'Ivysaur');
          },
          onError: (_) => fail('Should not return error'),
        );

        verify(mockConnectionService.checkConnection()).called(1);
        verify(mockConnectionService.isConnected).called(1);
        verify(mockHttpService.getData(path: anyNamed('path'))).called(1);
      },
    );

    test(
      'deve retornar SuccessResult com lista vazia quando pokemon for null no JSON',
      () async {
        // Arrange
        final emptyPokemonJson = {'pokemon': null};

        when(
          mockConnectionService.checkConnection(),
        ).thenAnswer((_) async => Future.value());
        when(mockConnectionService.isConnected).thenReturn(true);
        when(mockHttpService.getData(path: anyNamed('path'))).thenAnswer(
          (_) async => (statusCode: 200, data: emptyPokemonJson, error: null),
        );

        // Act
        final result = await dataSource.getAllPokemon();

        // Assert
        expect(result, isA<SuccessResult<List<PokemonModel>, Exception>>());

        result.fold(
          onSuccess: (pokemons) {
            expect(pokemons, isA<List<PokemonModel>>());
            expect(pokemons.isEmpty, true);
          },
          onError: (_) => fail('Should not return error'),
        );
      },
    );

    test(
      'deve retornar ErrorResult quando não houver conexão com a internet',
      () async {
        // Arrange
        when(
          mockConnectionService.checkConnection(),
        ).thenAnswer((_) async => Future.value());
        when(mockConnectionService.isConnected).thenReturn(false);

        // Act
        final result = await dataSource.getAllPokemon();

        // Assert
        expect(result, isA<ErrorResult<List<PokemonModel>, Exception>>());

        result.fold(
          onSuccess: (_) => fail('Should not return success'),
          onError: (error) {
            expect(error.toString(), contains('Sem conexão com a internet'));
          },
        );

        verify(mockConnectionService.checkConnection()).called(1);
        verify(mockConnectionService.isConnected).called(1);
        verifyNever(mockHttpService.getData(path: anyNamed('path')));
      },
    );

    test('deve retornar ErrorResult quando statusCode não for 200', () async {
      // Arrange
      when(
        mockConnectionService.checkConnection(),
      ).thenAnswer((_) async => Future.value());
      when(mockConnectionService.isConnected).thenReturn(true);
      when(mockHttpService.getData(path: anyNamed('path'))).thenAnswer(
        (_) async => (statusCode: 404, data: null, error: 'Not Found'),
      );

      // Act
      final result = await dataSource.getAllPokemon();

      // Assert
      expect(result, isA<ErrorResult<List<PokemonModel>, Exception>>());

      result.fold(
        onSuccess: (_) => fail('Should not return success'),
        onError: (error) {
          expect(error.toString(), contains('Erro ao buscar pokemons'));
          expect(error.toString(), contains('404'));
        },
      );

      verify(mockConnectionService.checkConnection()).called(1);
      verify(mockConnectionService.isConnected).called(1);
      verify(mockHttpService.getData(path: anyNamed('path'))).called(1);
    });

    test('deve retornar ErrorResult quando data for null', () async {
      // Arrange
      when(
        mockConnectionService.checkConnection(),
      ).thenAnswer((_) async => Future.value());
      when(mockConnectionService.isConnected).thenReturn(true);
      when(
        mockHttpService.getData(path: anyNamed('path')),
      ).thenAnswer((_) async => (statusCode: 200, data: null, error: null));

      // Act
      final result = await dataSource.getAllPokemon();

      // Assert
      expect(result, isA<ErrorResult<List<PokemonModel>, Exception>>());

      result.fold(
        onSuccess: (_) => fail('Should not return success'),
        onError: (error) {
          expect(error.toString(), contains('Erro ao buscar pokemons'));
          expect(error.toString(), contains('200'));
        },
      );

      verify(mockConnectionService.checkConnection()).called(1);
      verify(mockConnectionService.isConnected).called(1);
      verify(mockHttpService.getData(path: anyNamed('path'))).called(1);
    });

    test(
      'deve retornar ErrorResult quando statusCode for 500 (erro do servidor)',
      () async {
        // Arrange
        when(
          mockConnectionService.checkConnection(),
        ).thenAnswer((_) async => Future.value());
        when(mockConnectionService.isConnected).thenReturn(true);
        when(mockHttpService.getData(path: anyNamed('path'))).thenAnswer(
          (_) async =>
              (statusCode: 500, data: null, error: 'Internal Server Error'),
        );

        // Act
        final result = await dataSource.getAllPokemon();

        // Assert
        expect(result, isA<ErrorResult<List<PokemonModel>, Exception>>());

        result.fold(
          onSuccess: (_) => fail('Should not return success'),
          onError: (error) {
            expect(error.toString(), contains('Erro ao buscar pokemons'));
            expect(error.toString(), contains('500'));
          },
        );

        verify(mockConnectionService.checkConnection()).called(1);
        verify(mockConnectionService.isConnected).called(1);
        verify(mockHttpService.getData(path: anyNamed('path'))).called(1);
      },
    );

    test(
      'deve retornar ErrorResult quando checkConnection lançar uma exceção',
      () async {
        // Arrange
        when(
          mockConnectionService.checkConnection(),
        ).thenThrow(Exception('Connection check failed'));

        // Act
        final result = await dataSource.getAllPokemon();

        // Assert
        expect(result, isA<ErrorResult<List<PokemonModel>, Exception>>());

        result.fold(
          onSuccess: (_) => fail('Should not return success'),
          onError: (error) {
            expect(
              error.toString(),
              contains('Erro inesperado ao buscar pokemons'),
            );
            expect(error.toString(), contains('Connection check failed'));
          },
        );

        verify(mockConnectionService.checkConnection()).called(1);
        verifyNever(mockHttpService.getData(path: anyNamed('path')));
      },
    );

    test(
      'deve retornar ErrorResult quando httpService lançar uma exceção',
      () async {
        // Arrange
        when(
          mockConnectionService.checkConnection(),
        ).thenAnswer((_) async => Future.value());
        when(mockConnectionService.isConnected).thenReturn(true);
        when(
          mockHttpService.getData(path: anyNamed('path')),
        ).thenThrow(Exception('Network error'));

        // Act
        final result = await dataSource.getAllPokemon();

        // Assert
        expect(result, isA<ErrorResult<List<PokemonModel>, Exception>>());

        result.fold(
          onSuccess: (_) => fail('Should not return success'),
          onError: (error) {
            expect(
              error.toString(),
              contains('Erro inesperado ao buscar pokemons'),
            );
            expect(error.toString(), contains('Network error'));
          },
        );

        verify(mockConnectionService.checkConnection()).called(1);
        verify(mockConnectionService.isConnected).called(1);
        verify(mockHttpService.getData(path: anyNamed('path'))).called(1);
      },
    );

    test('deve retornar ErrorResult quando JSON for inválido', () async {
      // Arrange
      when(
        mockConnectionService.checkConnection(),
      ).thenAnswer((_) async => Future.value());
      when(mockConnectionService.isConnected).thenReturn(true);
      when(mockHttpService.getData(path: anyNamed('path'))).thenAnswer(
        (_) async =>
            (statusCode: 200, data: 'invalid json string', error: null),
      );

      // Act
      final result = await dataSource.getAllPokemon();

      // Assert
      expect(result, isA<ErrorResult<List<PokemonModel>, Exception>>());

      result.fold(
        onSuccess: (_) => fail('Should not return success'),
        onError: (error) {
          expect(
            error.toString(),
            contains('Erro inesperado ao buscar pokemons'),
          );
        },
      );

      verify(mockConnectionService.checkConnection()).called(1);
      verify(mockConnectionService.isConnected).called(1);
      verify(mockHttpService.getData(path: anyNamed('path'))).called(1);
    });

    test(
      'deve retornar SuccessResult quando houver erro no parse de campos opcionais',
      () async {
        // Arrange
        final minimalPokemonJson = {
          'pokemon': [
            {'id': 1, 'num': '001', 'name': 'Test Pokemon'},
          ],
        };

        when(
          mockConnectionService.checkConnection(),
        ).thenAnswer((_) async => Future.value());
        when(mockConnectionService.isConnected).thenReturn(true);
        when(mockHttpService.getData(path: anyNamed('path'))).thenAnswer(
          (_) async => (statusCode: 200, data: minimalPokemonJson, error: null),
        );

        // Act
        final result = await dataSource.getAllPokemon();

        // Assert
        expect(result, isA<Result<List<PokemonModel>, Exception>>());

        result.fold(
          onSuccess: (pokemons) {
            expect(pokemons, isA<List<PokemonModel>>());
            expect(pokemons.length, 1);
            expect(pokemons[0].name, 'Test Pokemon');
          },
          onError: (error) {
            expect(
              error.toString(),
              contains('Erro inesperado ao buscar pokemons'),
            );
          },
        );
      },
    );

    test('deve retornar ErrorResult quando statusCode for null', () async {
      // Arrange
      when(
        mockConnectionService.checkConnection(),
      ).thenAnswer((_) async => Future.value());
      when(mockConnectionService.isConnected).thenReturn(true);
      when(mockHttpService.getData(path: anyNamed('path'))).thenAnswer(
        (_) async =>
            (statusCode: null, data: mockPokemonJson, error: 'Unknown error'),
      );

      // Act
      final result = await dataSource.getAllPokemon();

      // Assert
      expect(result, isA<ErrorResult<List<PokemonModel>, Exception>>());

      result.fold(
        onSuccess: (_) => fail('Should not return success'),
        onError: (error) {
          expect(error.toString(), contains('Erro ao buscar pokemons'));
        },
      );
    });

    test(
      'deve retornar ErrorResult quando a resposta for 401 (não autorizado)',
      () async {
        // Arrange
        when(
          mockConnectionService.checkConnection(),
        ).thenAnswer((_) async => Future.value());
        when(mockConnectionService.isConnected).thenReturn(true);
        when(mockHttpService.getData(path: anyNamed('path'))).thenAnswer(
          (_) async => (statusCode: 401, data: null, error: 'Unauthorized'),
        );

        // Act
        final result = await dataSource.getAllPokemon();

        // Assert
        expect(result, isA<ErrorResult<List<PokemonModel>, Exception>>());

        result.fold(
          onSuccess: (_) => fail('Should not return success'),
          onError: (error) {
            expect(error.toString(), contains('Erro ao buscar pokemons'));
            expect(error.toString(), contains('401'));
          },
        );
      },
    );

    test(
      'deve retornar ErrorResult quando a resposta for 403 (proibido)',
      () async {
        // Arrange
        when(
          mockConnectionService.checkConnection(),
        ).thenAnswer((_) async => Future.value());
        when(mockConnectionService.isConnected).thenReturn(true);
        when(mockHttpService.getData(path: anyNamed('path'))).thenAnswer(
          (_) async => (statusCode: 403, data: null, error: 'Forbidden'),
        );

        // Act
        final result = await dataSource.getAllPokemon();

        // Assert
        expect(result, isA<ErrorResult<List<PokemonModel>, Exception>>());

        result.fold(
          onSuccess: (_) => fail('Should not return success'),
          onError: (error) {
            expect(error.toString(), contains('Erro ao buscar pokemons'));
            expect(error.toString(), contains('403'));
          },
        );
      },
    );
  });
}
