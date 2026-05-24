class PokemonException implements Exception {
  final String message;

  const PokemonException(this.message);

  @override
  String toString() => 'PokemonException: $message';
}
