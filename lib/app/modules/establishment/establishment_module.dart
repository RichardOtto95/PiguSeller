import 'package:pigu_seller/app/core/services/auth/auth_controller.dart';
import 'package:flutter/cupertino.dart';

import 'establishment_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'establishment_page.dart';

class EstablishmentModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        Bind((i) => EstablishmentController()),
        Bind((i) => AuthController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => EstablishmentPage()),
      ];

  static Inject get to => Inject<EstablishmentModule>.of();

  @override
  Widget get view => EstablishmentPage();
}
