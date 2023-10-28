import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'bill_detail_controller.g.dart';

@Injectable()
class BillDetailController = _BillDetailControllerBase
    with _$BillDetailController;

abstract class _BillDetailControllerBase with Store {
  @observable
  int value = 0;
  int ordersheets = 0;

  @action
  void increment() {
    value++;
  }
}
