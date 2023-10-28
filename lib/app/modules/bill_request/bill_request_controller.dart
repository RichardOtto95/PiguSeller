import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'bill_request_controller.g.dart';

@Injectable()
class BillRequestController = _BillRequestControllerBase
    with _$BillRequestController;

abstract class _BillRequestControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
