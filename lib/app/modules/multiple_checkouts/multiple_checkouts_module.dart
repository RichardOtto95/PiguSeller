import 'package:pigu_seller/app/modules/checkout/checkout_page.dart';
import 'package:flutter/material.dart';

import 'multiple_checkouts_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'multiple_checkouts_page.dart';

class MultipleCheckoutsModule extends WidgetModule {
  @override
  List<Bind> get binds => [Bind((i) => MultipleCheckoutsController())];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => MultipleCheckoutsPage()),
        ModularRouter('/checkout',
            child: (_, args) => CheckoutPage(
                  orderSheetId: args.data,
                )),
      ];

  Widget get view => MultipleCheckoutsPage();
}
