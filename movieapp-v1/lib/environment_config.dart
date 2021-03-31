import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnvironmentConfig {
  //final movieApiKey = const String.fromEnvironment("movieApiKey");
  final movieApiKey = "5872f0bc94beae0bd581a51708e05738";
}

final environmentConfigProvider = Provider<EnvironmentConfig>((ref) {
  return EnvironmentConfig();
});
