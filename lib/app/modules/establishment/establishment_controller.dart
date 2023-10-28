import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'establishment_controller.g.dart';

@Injectable()
class EstablishmentController = _EstablishmentControllerBase
    with _$EstablishmentController;

abstract class _EstablishmentControllerBase with Store {
  final homeController = Modular.get<HomeController>();

  @observable
  int value = 0;

  _EstablishmentControllerBase() {
    // getSeller();
  }

  @action
  void increment() {
    value++;
  }
}
