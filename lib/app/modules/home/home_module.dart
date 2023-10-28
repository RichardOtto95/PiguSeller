import 'package:pigu_seller/app/modules/home/home_widget.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'home_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dio/dio.dart';

class HomeModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        Bind((i) => HomeController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => HomeWidget()),
        // ModularRouter('/restaurant-selected/:seller', child: (_, args) => RestaurantSelectedPage(seller:args.params['seller'])),
      ];

  static Inject get to => Inject<HomeModule>.of();

  @override
  Widget get view => HomeWidget();
}
