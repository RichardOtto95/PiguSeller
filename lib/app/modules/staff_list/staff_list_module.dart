import 'package:flutter/widgets.dart';

import 'staff_list_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'staff_list_page.dart';

class StaffListModule extends WidgetModule {
  @override
  List<Bind> get binds => [Bind((i) => StaffListController())];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => StaffListPage()),
      ];

  static Inject get to => Inject<StaffListModule>.of();

  @override
  Widget get view => StaffListPage();
}
