import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'order_pad_controller.g.dart';

@Injectable()
class OrderPadController = _OrderPadControllerBase with _$OrderPadController;

abstract class _OrderPadControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
