import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'table_selection_controller.g.dart';

@Injectable()
class TableSelectionController = _TableSelectionControllerBase
    with _$TableSelectionController;

abstract class _TableSelectionControllerBase with Store {
  _TableSelectionControllerBase() {}

  @observable
  int value = 0;

  // @observable
  // var table;

  @action
  void increment() {
    value++;
  }

  // @action
  // void setTable(newTable) => table = newTable;
}
