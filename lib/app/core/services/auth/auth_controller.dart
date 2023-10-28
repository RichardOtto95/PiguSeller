import 'package:pigu_seller/app/core/models/user_model.dart';
import 'package:pigu_seller/app/core/modules/root/root_controller.dart';
import 'package:pigu_seller/app/core/services/auth/auth_service_interface.dart';
import 'package:pigu_seller/app/core/utils/auth_status_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
part 'auth_controller.g.dart';

class AuthController = _AuthControllerBase with _$AuthController;

abstract class _AuthControllerBase with Store {
  _AuthControllerBase() {
    _authService.handleGetUser().then(setUser);
  }
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  final AuthServiceInterface _authService = Modular.get();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RootController rootController = Modular.get();
  @observable
  AuthStatus status = AuthStatus.loading;
  @observable
  String userVerifyId;
  @observable
  String phoneMobile;
  @observable
  bool linked = false;
  @observable
  FirebaseUser user;
  @observable
  bool codeSent = false;
  @observable
  UserModel userBD;
  @action
  setCodeSent(bool _valc) => codeSent = _valc;
  @action
  setLinked(bool _vald) => linked = _vald;
  @action
  setUser(FirebaseUser value) {
    user = value;
    status = user == null ? AuthStatus.signed_out : AuthStatus.signed_in;
  }

  @action
  Future signinWithGoogle() async {
    await _authService.handleGoogleSignin();
  }

  @action
  Future linkAccountGoogle() async {
    await _authService.handleLinkAccountGoogle(user);
  }

  @action
  Future getUser() async {
    user = await _authService.handleGetUser();
    await Firestore.instance
        .collection('users')
        .document(user.uid)
        .get()
        .then((value) {
      userBD = UserModel.fromDocument(value);
      // user = ;

      return user;
    });
  }

  @action
  Future signup(UserModel user) async {
    user = await _authService.handleSignup(user);
  }

  @action
  Future siginEmail(String email, String password) async {
    user = await _authService.handleEmailSignin(email, password);
  }

  @action
  Future signout() async {
    return _authService.handleSetSignout();
  }

  @action
  Future sentSMS(String userPhone) async {
    return _authService.verifyNumber(userPhone);
  }

  @action
  Future signinSMS(String smsCode, String verify) async {
    return _authService.handleSmsSignin(smsCode, verify);
  }

  @action
  Future verifyNumber(String userPhone) async {
    String verifID;
    var phoneMobile = '+55' + userPhone;

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneMobile,

      // timeout: Duration(seconds: 60),
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential authCredential) {
        //code for signing in}).catchError((e){
        Firestore.instance
            .collection('users')
            .where('phone_number', isEqualTo: userPhone)
            .snapshots()
            .map((queryResults) {
          return queryResults.documents.map((doc) {
            // Modular.to.pushNamed('/');
            // rootController.setSelectedTrunk(2);
            // rootController.setSelectIndexPage(1);
            // var _user = UserModel.fromDocument(doc);
            // doc.data.

            // print(
            //     ' \$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\ ORDER \$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\ : $order');
            // return _user;
          }).toList();
        });

        _auth
            .signInWithCredential(authCredential)
            .then((AuthResult result) {})
            .catchError((e) {});
        // print(e);
      },
      verificationFailed: (AuthException authException) {},
      codeSent: (String verificationId, [int forceResendingToken]) {
        userVerifyId = verificationId;
        codeSent = true;
        setCodeSent(true);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // ForceResendingToken from callbacks

        verificationId = verificationId;
      },
      // timeout: Duration(seconds: 60),
    );
    return verifID;
  }

  // @action
  // Future<FirebaseUser> handleLinkSmsSignin(
  //     String smsCode, String userVerifyId) async {
  //   final AuthCredential credential = PhoneAuthProvider.getCredential(
  //       verificationId: userVerifyId, smsCode: smsCode);

  //   FirebaseUser _user = (await user.linkWithCredential(credential)).user;
  //   return _user;
  // }

  @action
  Future<FirebaseUser> handleSmsSignin(
      String smsCode, String userVerifyId) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: userVerifyId, smsCode: smsCode);
    FirebaseUser _user;

    _user = (await _auth.signInWithCredential(credential)).user;

    return _user;
  }
}
