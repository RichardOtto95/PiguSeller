import 'package:flutter/cupertino.dart';

import 'bill_detail_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'bill_detail_page.dart';

class BillDetailModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        Bind((i) => BillDetailController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => BillDetailPage()),
      ];

  Widget get view => BillDetailPage();
}
