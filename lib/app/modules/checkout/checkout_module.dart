import 'package:pigu_seller/app/modules/checkout/checkout_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'checkout_page.dart';

class CheckoutModule extends ChildModule {
  @override
  List<Bind> get binds => [Bind((i) => CheckoutController())];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => CheckoutPage()),
      ];

  static Inject get to => Inject<CheckoutModule>.of();
}
