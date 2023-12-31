import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app/app_module.dart';

void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) => Container();

  runApp(ModularApp(module: AppModule()));
}
