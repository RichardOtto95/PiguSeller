import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'user_profile_edit_controller.g.dart';

@Injectable()
class UserProfileEditController = _UserProfileEditControllerBase
    with _$UserProfileEditController;

abstract class _UserProfileEditControllerBase with Store {
  final homeController = Modular.get<HomeController>();
  @observable
  int value = 0;
  int valueh = 0;
  @observable
  String name;
  @observable
  String username;
  @observable
  String email;
  @observable
  String cpf;
  @action
  setName(String _name) => name = _name;
  @action
  setUserName(String _name) => username = _name;
  @action
  setEmail(String _email) => email = _email;
  @action
  setCPF(String _cpf) => cpf = _cpf;
  @action
  void increment() {
    value++;
  }

  @action
  updateProfile() async {
    if (name != null) {
      await Firestore.instance
          .collection("users")
          .document(homeController.user.uid)
          .updateData({
        'fullname': name,
      });
    }
    if (email != null) {
      await Firestore.instance
          .collection("users")
          .document(homeController.user.uid)
          .updateData({
        'email': email,
      });
      //  await Modular.to.pop();
    }
    if (cpf != null) {
      await Firestore.instance
          .collection("users")
          .document(homeController.user.uid)
          .updateData({
        'cpf': cpf,
      });
    }
    if (username != null) {
      await Firestore.instance
          .collection("users")
          .document(homeController.user.uid)
          .updateData({
        'username': username,
      });
    }
    await Modular.to.pop();
  }
}
