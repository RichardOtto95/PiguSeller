import 'package:pigu_seller/app/modules/multiple_orders_list/multiple_orders_list_controller.dart';
import 'package:pigu_seller/app/modules/multiple_orders_list/widgets/group_tables.dart';
import 'package:pigu_seller/app/modules/order_request/order_request_page.dart';
import 'package:pigu_seller/app/modules/staff_list/staff_list_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'multiple_orders_list_page.dart';

class MultipleOrdersListModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        Bind((i) => MultipleOrdersListController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => MultipleOrdersListPage()),
        ModularRouter('/order-request',
            child: (_, args) => OrderRequestPage(order: args.data)),
        ModularRouter('/group-tables',
            child: (_, args) => GroupTables(groupID: args.data))
      ];

  @override
  Widget get view => StaffListPage();
}
