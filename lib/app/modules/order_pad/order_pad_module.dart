import 'package:flutter/widgets.dart';

import 'order_pad_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'order_pad_page.dart';

class OrderPadModule extends WidgetModule {
  @override
  List<Bind> get binds => [Bind((i) => OrderPadController())];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => OrderPadPage()),
      ];

  // static Inject get to => Inject<OrderPadModule>.of();
  Widget get view => OrderPadPage();
}
