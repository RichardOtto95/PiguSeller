import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu_seller/app/modules/open_table/open_table_controller.dart';
import 'package:pigu_seller/app/modules/user_profile/widgets/card_profile.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfileView extends StatelessWidget {
  var lightPrimaryColor = Color.fromRGBO(246, 183, 42, 1);
  var primaryColor = Color.fromRGBO(250, 250, 250, 1);
  var anfitriaoText = Color(0xff95A5A6);
  var personText = Color(0xffD0D2D2);
  var todosPagaram = false;
  var pagou = true;
  final checkHost;
  final group;
  final String userView;
  final Function showMenu;
  // bool checkHost = false;
  ProfileView({
    this.checkHost,
    this.group,
    this.showMenu,
    this.userView,
  });

  Widget build(BuildContext context) {
    final openTableController = Modular.get<OpenTableController>();
    // final homeController = Modular.get<HomeController>();

    return StreamBuilder(
        stream: Firestore.instance
            .collection("user")
            .document(openTableController.userView)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            var userDocument = snapshot.data;
            return SafeArea(
              child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    leading: InkWell(
                      onTap: () {
                        Modular.to.pop();
                      },
                      child: Icon(
                        Icons.close,
                        color: ColorTheme.primaryColor,
                        size: 40,
                      ),
                    ),
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                  body: SingleChildScrollView(
                      child: Container(
                    padding: EdgeInsets.only(
                        top: 10, left: 40, right: 0, bottom: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: InkWell(
                                onTap: () {
                                  // pickImage();
                                },
                                child: CardProfile(
                                    username:
                                        userDocument['mobile_phone_number'],
                                    photo: userDocument['avatar']
                                    // != null && userDocument['avatar'] != ''
                                    // ? userDocument['avatar']
                                    // :'https://www.level10martialarts.com/wp-content/uploads/2017/04/default-image.jpg',

                                    ),
                              ),
                              padding: EdgeInsets.only(right: 40),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Olá!",
                              style: TextStyle(
                                  color: ColorTheme.darkCyanBlue,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              userDocument['full_name'] != null
                                  ? userDocument['full_name']
                                  : "Nome do Usuário!",
                              style: TextStyle(
                                  color: ColorTheme.textColor,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w300),
                            ),
                            Padding(
                                padding: EdgeInsets.only(right: 45),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      userDocument['email'] != null
                                          ? userDocument['email']
                                          : "emaildousurio@email.com",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          color: ColorTheme.textGray),
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 2,
                              margin: EdgeInsets.only(left: 150),
                              color: ColorTheme.primaryColor,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ))),
            );
          }
        });
  }
}
