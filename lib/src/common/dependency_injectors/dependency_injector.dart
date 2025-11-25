import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void dependencyInjector() {}

void resetDependencies() {
  locator.reset();
}
