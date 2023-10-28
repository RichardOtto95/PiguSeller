import 'dart:async';

import 'package:pigu_seller/app/core/modules/root/root_controller.dart';
import 'package:pigu_seller/app/core/services/auth/auth_controller.dart';
import 'package:pigu_seller/app/core/services/auth/auth_service_interface.dart';
import 'package:pigu_seller/app/modules/sign/signup_validation.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'sign_controller.dart';

class SignPageEmail extends StatefulWidget {
  final String title;
  const SignPageEmail({Key key, this.title = "Sign"}) : super(key: key);

  @override
  SignPageEmailState createState() => SignPageEmailState();
}

class SignPageEmailState extends ModularState<SignPageEmail, SignController> {
  //use 'controller' variable to access controller
  final authController = Modular.get<AuthController>();
  final rootController = Modular.get<RootController>();
  AuthServiceInterface authService = Modular.get();
  bool secondResend = false;
  bool loadCircular = false;
  bool loginClicked = true;
  FocusNode phoneFocusNode;
  FocusNode firstNode;
  FocusNode secondFocusNode;
  FocusNode thirdFocusNode;
  FocusNode fouthFocusNode;
  FocusNode fiveFocusNode;
  FocusNode sixFocusNode;
  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";

  @override
  void initState() {
    super.initState();
    firstNode = FocusNode();
    secondFocusNode = FocusNode();
    thirdFocusNode = FocusNode();
    fouthFocusNode = FocusNode();
    fiveFocusNode = FocusNode();
    sixFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    FirebaseAuth.instance.onAuthStateChanged.listen((firebaseUser) async {
      // do whatever you want based on the firebaseUser state
      // Modular.to.pushNamed('/');
      if (firebaseUser != null) {
        // valueUser = value;
        var _user = (await Firestore.instance
                .collection('users')
                .document(firebaseUser.uid)
                .get())
            .data;

        if (_user != null) {
          Modular.to.pushNamed('/');
          rootController.setSelectedTrunk(2);
          rootController.setSelectIndexPage(1);

          // Modular.to.pushNamed('/');
        } else {
          controller.user.mobile_region_code =
              firebaseUser.phoneNumber.substring(3, 5);
          controller.user.mobile_phone_number =
              firebaseUser.phoneNumber.substring(5, 12);

          await authService.handleSignup(controller.user);
          await authService.handleGetUser();
          // await authController.getUser();
          Modular.to.pushNamed('/');

          rootController.setSelectedTrunk(2);
          rootController.setSelectIndexPage(1);
        }
      }
    });

    // .onAuthStateChanged( (user) => {
    //     if (user) {
    //         // Obviously, you can add more statements here,
    //         //       e.g. call an action creator if you use Redux.

    //         // navigate the user away from the login screens:
    //         props.navigation.navigate("PermissionsScreen");
    //     }
    //     else
    //     {
    //         // reset state if you need to
    //         dispatch({ type: "reset_user" });
    //     }
    // });
  }

  Timer _timer;
  int _start = 60;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            controller.authController.verifyNumber(controller.tel);
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _timer.cancel();

    phoneFocusNode.dispose();
    firstNode.dispose();
    secondFocusNode.dispose();
    thirdFocusNode.dispose();
    fouthFocusNode.dispose();
    fiveFocusNode.dispose();
    sixFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorTheme.primaryColor,
        width: 900,
        height: 900,
        child: Container(
            width: 80,
            height: 70,
            child: Image.asset(
                'assets/img/PIGU_Icone-App_iOS-Android-Opcao1.png')),
      ),
    );
    // List<Widget> _signPages = [
    //   // SigninEmailModule(),
    //   // SignupModule(),
    // ];
    // PageController _pageSignController = PageController(
    //   initialPage: controller.selectedPage,
    //   keepPage: true,
    // );
    // void bottomTapped(int index) {
    //   setState(() {
    //     _pageSignController.animateToPage(index,
    //         duration: Duration(milliseconds: 500), curve: Curves.ease);
    //   });
    // }
    // int selectPage = 0;
    return Observer(builder: (_) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(80.0),
            child: authController.codeSent == true
                ? Column(
                    //mainAxisAlignment: MainAxisAlignment.,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Text(
                          'Código enviado',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 50),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 10.0, bottom: 100.0),
                        child: Text('Insira o código \n enviado',
                            style: TextStyle(fontSize: 40)),
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                                width: MediaQuery.of(context).size.width * 100,
                                child: PinCodeTextField(
                                  length: 6,
                                  // obscureText: false,
                                  animationType: AnimationType.fade,
                                  pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.underline,
                                      // borderRadius: BorderRadius.circular(5),
                                      fieldHeight: 50,
                                      fieldWidth: 40,
                                      inactiveColor: Colors.grey[400], //
                                      activeColor: Color(0xFFF6B72A),
                                      selectedColor: Colors.yellow),

                                  animationDuration:
                                      Duration(milliseconds: 300),
                                  // backgroundColor: Colors.blue.shade50,
                                  // enableActiveFill: true,
                                  errorAnimationController: errorController,
                                  controller: textEditingController,
                                  onCompleted: (v) {},
                                  onChanged: (value) {
                                    setState(() {
                                      currentText = value;
                                    });
                                  },
                                  beforeTextPaste: (text) {
                                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                    return true;
                                  },
                                  appContext: context,
                                )
                                //  PinPut(
                                //   validator: (s) {
                                //     if (s.contains('1')) return null;
                                //     return 'NOT VALID';
                                //   },
                                //   autovalidateMode:
                                //       AutovalidateMode.onUserInteraction,
                                //   withCursor: true,
                                //   fieldsCount: 6,
                                //   fieldsAlignment: MainAxisAlignment.spaceAround,
                                //   textStyle: const TextStyle(
                                //       fontSize: 25.0, color: Colors.black),
                                //   eachFieldMargin: EdgeInsets.all(0),
                                //   eachFieldWidth: 25.0,
                                //   eachFieldHeight: 55.0,
                                //   // onSubmit: (String pin) => _showSnackBar(pin),
                                //   focusNode: _pinPutFocusNode,
                                //   controller: _pinPutController,
                                //   submittedFieldDecoration: pinPutDecoration,
                                //   selectedFieldDecoration:
                                //       pinPutDecoration.copyWith(
                                //     color: Colors.white,
                                //     border:
                                //      Border.symmetric(horizontal:BorderSide(width: 16.0, color: Colors.black) ,
                                //       // width: 2,
                                //       // color: Colors.black,
                                //     ),
                                //   ),
                                //   followingFieldDecoration: pinPutDecoration,
                                //   pinAnimationType: PinAnimationType.scale,
                                // ),
                                ),
                          ),
                        ],
                      ),
                      // EnterCodeWidget(
                      //   val1: (val1) {
                      //     setState(() {
                      //       controller.setFirstVal(val1);
                      //     });
                      //     if (val1 != null) {
                      //       print('val1: $val1');
                      //       secondFocusNode.requestFocus();
                      //     }
                      //   },
                      //   val2: (val2) {
                      //     setState(() {
                      //       controller.setSecondVal(val2);
                      //     });
                      //     if (val2 != null) {
                      //       print('val1: $val2');
                      //       thirdFocusNode.requestFocus();
                      //     }
                      //   },
                      //   val3: (val3) {
                      //     setState(() {
                      //       controller.setThirdVal(val3);
                      //     });
                      //     if (val3 != null) {
                      //       print('val1: $val3');
                      //       fouthFocusNode.requestFocus();
                      //     }
                      //   },
                      //   val4: (val4) {
                      //     setState(() {
                      //       controller.setfourthVal(val4);
                      //     });
                      //     if (val4 != null) {
                      //       print('val1: $val4');
                      //       fiveFocusNode.requestFocus();
                      //     }
                      //   },
                      //   val5: (val5) {
                      //     setState(() {
                      //       controller.setFiveCode(val5);
                      //     });
                      //     if (val5 != null) {
                      //       print('val1: $val5');
                      //       sixFocusNode.requestFocus();
                      //     }
                      //   },
                      //   val6: (val6) {
                      //     setState(() {
                      //       controller.setSixCode(val6);
                      //     });
                      //   },
                      //   maxLength1: 1,
                      //   setFocus1: () {
                      //     firstNode.requestFocus();
                      //   },
                      //   focus1: firstNode,
                      //   setFocus2: () {
                      //     secondFocusNode.requestFocus();
                      //   },
                      //   focus2: secondFocusNode,
                      //   setFocus3: () {
                      //     thirdFocusNode.requestFocus();
                      //   },
                      //   focus3: thirdFocusNode,
                      //   setFocus4: () {
                      //     fouthFocusNode.requestFocus();
                      //   },
                      //   focus4: fouthFocusNode,
                      //   setFocus5: () {
                      //     fiveFocusNode.requestFocus();
                      //   },
                      //   focus5: fiveFocusNode,
                      //   setFocus6: () {
                      //     sixFocusNode.requestFocus();
                      //   },
                      //   focus6: sixFocusNode,
                      // )

                      SizedBox(height: 20),
                      FlatButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          startTimer();
                          setState(() {
                            secondResend = true;
                          });
                          /*...*/
                        },
                        child: Text(
                          "Reenviar código",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal),
                        ),
                        shape: Border(
                            bottom: BorderSide(
                                width: 3.0, color: Color(0xFFF6B72A))),
                      ),
                      secondResend
                          ? Text(
                              "Reenviando código em ${_start} segundos",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.normal),
                            )
                          : Container(),
                      SizedBox(height: 80),
                      loadCircular
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container(
                              width: 320,
                              height: 60,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Color(0xFFF6B72A))),
                                child: Text(
                                  'Validar',
                                  style: TextStyle(fontSize: 20),
                                ),
                                color: ColorTheme.primaryColor,
                                textColor: Colors.white,
                                onPressed: () {
                                  if (currentText.length == 6 &&
                                      currentText.isNotEmpty) {
                                    setState(() {
                                      loadCircular = true;
                                    });
                                    controller.setUserCode(currentText);
                                    controller.signinPhone(
                                      controller.code,
                                      controller.authController.userVerifyId,
                                    );
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Digite o Codigo enviado!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: ColorTheme.yellow,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }

                                  // Modular.to.pushNamed('/home');
                                  // Navigator.push(context,
                                  //     MaterialPageRoute(builder: (context) {
                                  //   return SignModule();
                                  // }
                                  // )
                                  // );
                                },
                              )),
                    ],
                  )
                : Column(
                    children: <Widget>[
                      Text(
                        'Bem vindo!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 45),
                      ),
                      SizedBox(height: 16),
                      Text('Cadastre-se \n para entrar',
                          style: TextStyle(fontSize: 40)),
                      SizedBox(height: 16),
                      Container(
                          width: 200.0,
                          child: TextField(
                            onChanged: (text) {
                              controller.setUserTel(text);
                            },
                            decoration: InputDecoration(
                                labelText: 'Nome',
                                labelStyle: TextStyle(
                                  color: ColorTheme.textGray,
                                  fontSize: 20,
                                )),
                          )),
                      Container(
                          width: 200.0,
                          child: TextFormField(
                            onChanged: (text) {
                              // controller.setUserEmail(text);
                            },
                            decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: ColorTheme.textGray,
                                  fontSize: 20,
                                )),
                          )),
                      Container(
                          width: 200.0,
                          child: TextField(
                            onChanged: (text) {
                              controller.setUserTel(text);
                            },
                            keyboardType: TextInputType.number,
                            maxLength: 11,
                            decoration: InputDecoration(
                                hintText: '(61)999999999',
                                hintStyle: TextStyle(
                                  color: Color(0xFFF6B72A),
                                  fontSize: 20,
                                ),
                                counterText: "",
                                labelText: 'Telefone',
                                labelStyle: TextStyle(
                                  color: ColorTheme.textGray,
                                  fontSize: 20,
                                )),
                          )),
                      SizedBox(height: 16),
                      Container(
                          width: 200.0,
                          child: TextFormField(
                            onChanged: (text) {
                              controller.setUserTel(text);
                            },
                            decoration: InputDecoration(
                                labelText: 'Senha',
                                labelStyle: TextStyle(
                                  color: ColorTheme.textGray,
                                  fontSize: 20,
                                )),
                          )),
                      SizedBox(height: 16),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            new RaisedButton(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                      color: ColorTheme.primaryColor)),
                              child: new Icon(
                                FontAwesomeIcons.facebookF,
                                color: Colors.blue,
                                size: 25,
                              ),
                              onPressed: () {},
                            ),
                            SizedBox(width: 16),
                            new RaisedButton(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                      color: ColorTheme.primaryColor)),
                              child: Image.asset(
                                'assets/img/google.png',
                                width: 28,
                                height: 24,
                                //color: Colors.blueAccent,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      Container(
                          width: 280,
                          height: 60,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side:
                                    BorderSide(color: ColorTheme.primaryColor)),
                            child: Text(
                              'Entrar',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            color: ColorTheme.primaryColor,
                            textColor: Colors.white,
                            onPressed: () {
                              if (controller.authController.codeSent == true) {
                                if (controller.val1 != null &&
                                    controller.val1 != '' &&
                                    controller.val2 != null &&
                                    controller.val2 != '' &&
                                    controller.val3 != null &&
                                    controller.val3 != '' &&
                                    controller.val4 != null &&
                                    controller.val4 != '' &&
                                    controller.val5 != null &&
                                    controller.val5 != '' &&
                                    controller.val6 != null &&
                                    controller.val6 != '') {
                                  controller.setUserCode(controller.val1 +
                                      controller.val2 +
                                      controller.val3 +
                                      controller.val4 +
                                      controller.val5 +
                                      controller.val6);
                                  controller.signinPhone(
                                    controller.code,
                                    controller.authController.userVerifyId,
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Digite o Codigo enviado!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: ColorTheme.yellow,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              } else {
                                if (controller.tel != null &&
                                    controller.tel != '') {
                                  controller.authController
                                      .verifyNumber(controller.tel);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Digite o numero do telefone!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: ColorTheme.yellow,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              }
                              Modular.to.pushNamed(
                                  '/signin-phone/signin-phone-verify');
                            },
                          )),
                      SizedBox(height: 16),
                      Container(
                          width: 280,
                          height: 60,
                          child: RaisedButton(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side:
                                    BorderSide(color: ColorTheme.primaryColor)),
                            child: Text(
                              'Entrar',
                              style: TextStyle(fontSize: 20),
                            ),
                            color: ColorTheme.white..withOpacity(0.5),
                            textColor: Colors.black,
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return SingUpValidation_();
                              }));
                            },
                          )),
                    ],
                  ),
          ),
        ),
      );
    });
  }
}
