import 'package:get_it/get_it.dart';
import 'package:github_users/locator.config.dart';
import 'package:injectable/injectable.dart';

final locator = GetIt.instance;

@InjectableInit(initializerName: 'init')
Future<void> setupLocator() async {
  locator.init();
}
