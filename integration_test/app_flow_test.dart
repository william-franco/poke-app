import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:poke_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('pokedex home reaches loaded, empty, or loading state', (
    tester,
  ) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 20));

    final hasContent =
        find.textContaining('Pokémon').evaluate().isNotEmpty ||
        find.text('Nenhum Pokémon encontrado').evaluate().isNotEmpty ||
        find.byType(CircularProgressIndicator).evaluate().isNotEmpty;

    expect(hasContent, isTrue);
  });
}