import 'package:flutter/cupertino.dart';

import 'order_request_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'order_request_page.dart';

class OrderRequestModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        Bind((i) => OrderRequestController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => OrderRequestPage()),
      ];

  // static Inject get to => Inject<OrderRequestModule>.of();
  Widget get view => OrderRequestPage();
}
