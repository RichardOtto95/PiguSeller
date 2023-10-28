import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'user_profile_edit_controller.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class UserProfileEditPage extends StatefulWidget {
  final String title;
  const UserProfileEditPage({Key key, this.title = "UserProfileEdit"})
      : super(key: key);

  @override
  _UserProfileEditPageState createState() => _UserProfileEditPageState();
}

class _UserProfileEditPageState
    extends ModularState<UserProfileEditPage, UserProfileEditController> {
  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  final homeController = Modular.get<HomeController>();

  //use 'controller' variable to access controller
  @override
  Widget build(BuildContext context) {
    var maskFormatter = new MaskTextInputFormatter(
        mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
    return StreamBuilder(
        stream: Firestore.instance
            .collection("users")
            .document(homeController.user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            var userDocument = snapshot.data;
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(
                            top: wXD(26, context), left: wXD(10, context)),
                        child: InkWell(
                          onTap: () {
                            Modular.to.pop();
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: ColorTheme.primaryColor,
                            size: wXD(35, context),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(right: 60.0, top: 40.0),
                      //   child: Text(
                      //     'Bem vindo!',
                      //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: wXD(170, context),
                            top: wXD(
                              40,
                              context,
                            ),
                            bottom: wXD(12, context)),
                        child: Text('Editar perfil',
                            style: TextStyle(fontSize: wXD(29, context))),
                      ),
                      Container(
                          width: wXD(300, context),
                          child: TextFormField(
                            initialValue: userDocument['fullname'],
                            onChanged: (val) {
                              controller.setName(val);
                            },
                            decoration: InputDecoration(
                                labelText: 'Nome Completo',
                                labelStyle: TextStyle(
                                  color: ColorTheme.textGray,
                                  fontSize: wXD(19, context),
                                )),
                          )),
                      Container(
                          width: wXD(300, context),
                          child: TextFormField(
                            initialValue: userDocument['username'],
                            onChanged: (val) {
                              controller.setUserName(val);
                            },
                            decoration: InputDecoration(
                                labelText: 'Nome de usuário',
                                labelStyle: TextStyle(
                                  color: ColorTheme.textGray,
                                  fontSize: wXD(19, context),
                                )),
                          )),
                      Container(
                          width: wXD(300, context),
                          child: TextFormField(
                            initialValue: userDocument['email'],
                            onChanged: (val) {
                              controller.setEmail(val);
                            },
                            decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: ColorTheme.textGray,
                                  fontSize: wXD(19, context),
                                )),
                          )),
                      Container(
                          width: wXD(300, context),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [maskFormatter],
                            onChanged: (val) {
                              val = maskFormatter.getUnmaskedText();
                              controller.setCPF(val);
                            },
                            initialValue: userDocument['cpf'],
                            // maxLength: 14,
                            decoration: InputDecoration(
                                labelText: 'CPF',
                                labelStyle: TextStyle(
                                  color: ColorTheme.textGray,
                                  fontSize: wXD(19, context),
                                )),
                          )),
                      // Contai
                      // Container(
                      //     width: 200.0,
                      //     child: TextFormField(
                      //       decoration: InputDecoration(
                      //           labelText: 'Senha',
                      //           labelStyle: TextStyle(
                      //             color: ColorTheme.primaryColor,
                      //             fontSize: 20,
                      //           )),
                      //     )),
                      SizedBox(height: 30),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // new RaisedButton(
                            //   color: Colors.white,
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(18.0),
                            //       side: BorderSide(color: Colors.transparent)),
                            //   child: new FaIcon(
                            //     FontAwesomeIcons.facebookF,
                            //     color: Colors.blue,
                            //     size: 25,
                            //   ),
                            //   onPressed: () {},
                            // ),
                            // SizedBox(width: 16),
                            // new RaisedButton(
                            //   color: Colors.white,
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(18.0),
                            //       side: BorderSide(color: Colors.transparent)),
                            //   child: Image(
                            //     image: AssetImage('assets/google.png'),
                            //     width: 30,
                            //   ),
                            //   onPressed: () {},
                            // ),
                          ],
                        ),
                      ),
                      Container(
                          width: 280,
                          height: 60,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.transparent)),
                            child: Text(
                              'Salvar',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: ColorTheme.white),
                            ),
                            color: ColorTheme.primaryColor,
                            textColor: Colors.black,
                            onPressed: () {
                              controller.updateProfile();
                              // Navigator.push(context,
                              //     MaterialPageRoute(builder: (context) {
                              //   return SingUpValidation_();
                              // }));
                            },
                          )),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
