import 'package:flutter/material.dart';

import 'menu_list_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'menu_list_page.dart';

class MenuListModule extends WidgetModule {
  @override
  List<Bind> get binds => [Bind((i) => MenuListController())];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => MenuListPage()),
      ];

  static Inject get to => Inject<MenuListModule>.of();

  @override
  Widget get view => MenuListPage();
}
