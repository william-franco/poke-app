import 'package:poke_app/src/common/enums/pokemons_enums.dart';
import 'package:poke_app/src/common/results/result.dart';
import 'package:poke_app/src/features/pokemons/data/data_sources/pokemons_data_source.dart';
import 'package:poke_app/src/features/pokemons/domain/entities/pokemon_entity.dart';
import 'package:poke_app/src/features/pokemons/domain/repositories/pokemons_repository.dart';

class PokemonsRepositoryImpl implements PokemonsRepository {
  final PokemonsDataSource dataSource;

  PokemonsRepositoryImpl({required this.dataSource});

  @override
  Future<PokemonResult> getAllPokemon() async {
    try {
      final result = await dataSource.getAllPokemon();

      return result.fold<PokemonResult>(
        onSuccess: (pokemonList) => SuccessResult(value: pokemonList),
        onError: (error) => ErrorResult(error: error),
      );
    } catch (error) {
      return ErrorResult(error: Exception(error));
    }
  }

  @override
  List<PokemonEntity> searchPokemon(
    List<PokemonEntity> pokemonList,
    String query,
  ) {
    if (query.isEmpty) return pokemonList;

    final lowercaseQuery = query.toLowerCase().trim();

    return pokemonList.where((pokemon) {
      final name = pokemon.name?.toLowerCase() ?? '';
      final num = pokemon.num ?? '';
      final types = pokemon.type ?? [];

      return name.contains(lowercaseQuery) ||
          num.contains(lowercaseQuery) ||
          types.any(
            (typeEnum) => typeEnum.name.toLowerCase().contains(lowercaseQuery),
          );
    }).toList();
  }

  @override
  List<PokemonEntity> sortPokemon(
    List<PokemonEntity> pokemonList,
    SortType sortType,
  ) {
    final sorted = List<PokemonEntity>.from(pokemonList);

    switch (sortType) {
      case SortType.alphabetical:
        sorted.sort((a, b) {
          final nameA = a.name ?? '';
          final nameB = b.name ?? '';
          return nameA.compareTo(nameB);
        });
        break;

      case SortType.byNumber:
        sorted.sort((a, b) {
          final idA = a.id ?? 0;
          final idB = b.id ?? 0;
          return idA.compareTo(idB);
        });
        break;
    }

    return sorted;
  }

  @override
  List<PokemonEntity> filterByType(
    List<PokemonEntity> pokemonList,
    String? type,
  ) {
    if (type == null || type.isEmpty) return pokemonList;

    final query = type.toLowerCase();

    return pokemonList.where((pokemon) {
      final types = pokemon.type ?? [];
      return types.any((typeEnum) => typeEnum.name.toLowerCase() == query);
    }).toList();
  }

  @override
  List<PokemonEntity> getRelatedPokemon(
    PokemonEntity pokemon,
    List<PokemonEntity> allPokemon,
  ) {
    final related = <PokemonEntity>[];

    if (pokemon.prevEvolution != null) {
      for (var evo in pokemon.prevEvolution!) {
        final evoNum = evo.num;
        if (evoNum == null) continue;

        PokemonEntity? found;
        for (final p in allPokemon) {
          if (p.num == evoNum) {
            found = p;
            break;
          }
        }

        if (found != null) {
          related.add(found);
        }
      }
    }

    if (pokemon.nextEvolution != null) {
      for (var evo in pokemon.nextEvolution!) {
        final evoNum = evo.num;
        if (evoNum == null) continue;

        PokemonEntity? found;
        for (final p in allPokemon) {
          if (p.num == evoNum) {
            found = p;
            break;
          }
        }

        if (found != null) {
          related.add(found);
        }
      }
    }

    return related;
  }
}
