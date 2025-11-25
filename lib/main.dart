import 'package:flutter/material.dart';
import 'package:poke_app/src/common/dependency_injectors/dependency_injector.dart';
import 'package:poke_app/src/common/design/theme_design.dart';
import 'package:poke_app/src/common/routes/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dependencyInjector();
  final Routes appRoutes = Routes();
  runApp(MyApp(appRoutes: appRoutes));
}

class MyApp extends StatelessWidget {
  final Routes appRoutes;

  const MyApp({super.key, required this.appRoutes});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pokédex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: ThemeDesign.primaryRed,
        scaffoldBackgroundColor: ThemeDesign.backgroundColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ThemeDesign.primaryRed,
          primary: ThemeDesign.primaryRed,
        ),
      ),
      routerConfig: appRoutes.routes,
    );
  }
}
