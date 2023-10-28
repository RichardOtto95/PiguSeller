import 'package:flutter/widgets.dart';

import 'bill_request_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'bill_request_page.dart';

class BillRequestModule extends WidgetModule {
  @override
  List<Bind> get binds => [Bind((i) => BillRequestController())];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => BillRequestPage()),
      ];

  // static Inject get to => Inject<BillRequestModule>.of();
  Widget get view => BillRequestPage();
}
