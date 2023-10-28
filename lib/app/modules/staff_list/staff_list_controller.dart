import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'staff_list_controller.g.dart';

@Injectable()
class StaffListController = _StaffListControllerBase with _$StaffListController;

abstract class _StaffListControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
