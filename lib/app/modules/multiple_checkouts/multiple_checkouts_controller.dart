import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'multiple_checkouts_controller.g.dart';

@Injectable()
class MultipleCheckoutsController = _MultipleCheckoutsControllerBase
    with _$MultipleCheckoutsController;

abstract class _MultipleCheckoutsControllerBase with Store {
  final homeController = Modular.get<HomeController>();

  @observable
  int value = 0;
  @observable
  bool showMenu = false;
  @observable
  String name;

  @observable
  num amountc = 0;
  @observable
  num totalDSc = 0;
  @observable
  String clickLabel = 'onGoing';

  @action
  void increment() {
    value++;
  }

  @action
  setClickLabel(String _click) => clickLabel = _click;
  @action
  setDSc(num x) => totalDSc = x;
  @action
  setAmountc(num y) => amountc = y;
  @action
  setShowMenu(bool _showMenu) => showMenu = _showMenu;
}
