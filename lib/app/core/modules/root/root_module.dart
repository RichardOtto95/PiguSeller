import 'package:pigu_seller/app/core/modules/root/root_controller.dart';
import 'package:pigu_seller/app/core/modules/root/root_page.dart';
import 'package:pigu_seller/app/modules/establishment/establishment_module.dart';
import 'package:pigu_seller/app/modules/menu_list/menu_list_module.dart';
import 'package:pigu_seller/app/modules/multiple_checkouts/multiple_checkouts_module.dart';
import 'package:pigu_seller/app/modules/multiple_orders_list/multiple_orders_list_module.dart';
import 'package:pigu_seller/app/modules/staff_list/staff_list_module.dart';
import 'package:pigu_seller/app/modules/home/home_module.dart';
import 'package:pigu_seller/app/modules/open_table/open_table_module.dart';
import 'package:pigu_seller/app/modules/table_selection/table_selection_module.dart';
import 'package:pigu_seller/app/modules/user_profile/user_profile_module.dart';
import 'package:pigu_seller/app/modules/user_profile_edit/user_profile_edit_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RootModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => RootController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => RootPage()),
        ModularRouter('/home', module: HomeModule()),
        ModularRouter('/open-table', module: OpenTableModule()),
        ModularRouter('/user-profile', module: UserProfileModule()),
        ModularRouter('/user-profile-edit', module: UserProfileEditModule()),
        ModularRouter('/staff-list', module: StaffListModule()),
        ModularRouter('/multiple-orders-list',
            module: MultipleOrdersListModule()),
        ModularRouter('/menu-list', module: MenuListModule()),
        ModularRouter('/multiple-checkouts', module: MultipleCheckoutsModule()),
        ModularRouter('/table-selection', module: TableSelectionModule()),
        ModularRouter('/establishment', module: EstablishmentModule()),
        ModularRouter('/user-profile-edit', module: UserProfileEditModule()),
      ];

  static Inject get to => Inject<RootModule>.of();
}
