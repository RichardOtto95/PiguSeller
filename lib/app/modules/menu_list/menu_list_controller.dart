import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'menu_list_controller.g.dart';

@Injectable()
class MenuListController = _MenuListControllerBase with _$MenuListController;

abstract class _MenuListControllerBase with Store {
  @observable
  bool clickItem = false;
  @observable
  int value = 0;
  int value2 = 0;
  @observable
  String sellerId;

 @action
  setSellerId(String ee) => sellerId = ee;
  @action
  setclickItem(bool _clickItem) => clickItem = _clickItem;
  @action
  void increment() {
    value++;
  }
}
