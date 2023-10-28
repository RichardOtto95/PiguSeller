import 'package:flutter/widgets.dart';

import 'table_selection_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'table_selection_page.dart';

class TableSelectionModule extends WidgetModule {
  @override
  List<Bind> get binds => [Bind((i) => TableSelectionController)];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => TableSelectionPage()),
      ];

  // static Inject get to => Inject<TableSelectionModule>.of();
  Widget get view => TableSelectionPage();
}
