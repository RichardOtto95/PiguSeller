import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'order_request_controller.g.dart';

@Injectable()
class OrderRequestController = _OrderRequestControllerBase
    with _$OrderRequestController;

abstract class _OrderRequestControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
