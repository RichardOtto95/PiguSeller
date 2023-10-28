import 'package:pigu_seller/app/modules/bill_detail/bill_detail_page.dart';
import 'package:pigu_seller/app/modules/bill_detail/widgets/group_table.dart';
import 'package:pigu_seller/app/modules/bill_request/bill_request_page.dart';
import 'package:pigu_seller/app/modules/chat/chat_page.dart';
import 'package:pigu_seller/app/modules/open_table/open_table_detail.dart';
import 'package:pigu_seller/app/core/modules/table_info/table_info_page.dart';
import 'package:pigu_seller/app/modules/order_pad/order_pad_page.dart';
import 'package:pigu_seller/app/modules/table_selection/table_selection_page.dart';
import 'open_table_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'open_table_page.dart';

class OpenTableModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => OpenTableController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => OpenTablePage()),
        ModularRouter(
          '/open-table-detail',
          child: (_, args) => OpenTableDetailPage(
            invite: args.data,
          ),
        ),
        ModularRouter('/table-info',
            child: (_, args) => TableInfoPage(
                  group: args.data,
                )),
        ModularRouter('/chat',
            child: (_, args) => ChatPage(
                  group: args.data,
                  msgType: 'view-chat',
                )),
        ModularRouter('/bill-request',
            child: (_, args) => BillRequestPage(groupId: args.data)),
        ModularRouter('/table-selection',
            child: (_, args) => TableSelectionPage()),
        ModularRouter('/group-table',
            child: (_, args) => GroupTable(groupID: args.data)),
        ModularRouter('/bill-detail',
            child: (_, args) => BillDetailPage(
                  groupId: args.data,
                )),
        ModularRouter(
          '/order-pad',
          child: (
            _,
            args,
          ) =>
              OrderPadPage(
            member: args.data,
          ),
        )
      ];

  static Inject get to => Inject<OpenTableModule>.of();
}
