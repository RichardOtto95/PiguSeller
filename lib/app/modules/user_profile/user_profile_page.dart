import 'dart:io';
import 'package:pigu_seller/app/core/modules/root/root_controller.dart';
import 'package:pigu_seller/app/core/services/auth/auth_controller.dart';
import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/app/modules/user_profile/widgets/card_profile.dart';
import 'package:pigu_seller/app/modules/user_profile/widgets/switch_notificacoes.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'user_profile_controller.dart';

class UserProfilePage extends StatefulWidget {
  final String title;
  const UserProfilePage({Key key, this.title = "UserProfile"})
      : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

double wXD(double size, BuildContext context) {
  double finalValue = MediaQuery.of(context).size.width * size / 375;
  return finalValue;
}

class _UserProfilePageState
    extends ModularState<UserProfilePage, UserProfileController> {
  var primaryColor = Color.fromRGBO(255, 132, 0, 1);
  var darkPrimaryColor = Color.fromRGBO(249, 153, 94, 1);
  var lightPrimaryColor = Color.fromRGBO(246, 183, 42, 1);
  var primaryText = Color.fromRGBO(22, 16, 18, 1);
  var secondaryText = Color.fromRGBO(84, 74, 65, 1);
  var accentColor = Color.fromRGBO(114, 74, 134, 1);
  var divisorColor = Color.fromRGBO(189, 174, 167, 1);
  final Firestore _db = Firestore.instance;
  final rootController = Modular.get<RootController>();
  var authController = Modular.get<AuthController>();
  final homeController = Modular.get<HomeController>();

  File _imageFile;

  final picker = ImagePicker();
  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile.path);
    });

    if (_imageFile != null) {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();

      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('users/${user.uid}/avatar/${_imageFile.path[0]}');
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      taskSnapshot.ref.getDownloadURL().then(
        (value) async {
          await Firestore.instance
              .collection("users")
              .document(user.uid)
              .updateData({'avatar': value});
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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

            return SafeArea(
              child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    leading: InkWell(
                      onTap: () {
                        Modular.to.pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: ColorTheme.primaryColor,
                        size: wXD(35, context),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                  body: SingleChildScrollView(
                      child: Container(
                    padding: EdgeInsets.only(
                        top: wXD(10, context),
                        left: wXD(40, context),
                        right: 0,
                        bottom: wXD(20, context)),
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
                                  pickImage();
                                },
                                child: CardProfile(
                                    username: userDocument['username'],
                                    photo: userDocument['avatar']),
                              ),
                              padding: EdgeInsets.only(right: wXD(40, context)),
                            )
                          ],
                        ),
                        SizedBox(
                          height: wXD(15, context),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Olá!",
                              style: TextStyle(
                                  color: ColorTheme.darkCyanBlue,
                                  fontSize: wXD(36, context),
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              userDocument['username'] != null
                                  ? userDocument['username']
                                  : userDocument['mobile_phone_number'],
                              style: TextStyle(
                                  color: ColorTheme.textColor,
                                  fontSize: wXD(36, context),
                                  fontWeight: FontWeight.w300),
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.only(right: wXD(45, context)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Visibility(
                                      visible: userDocument['email'] != null,
                                      child: Container(
                                        width: wXD(220, context),
                                        child: Text(
                                          '${userDocument['email']}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: wXD(16, context),
                                              fontWeight: FontWeight.w300,
                                              color: ColorTheme.textGray),
                                        ),
                                      ),
                                    ),
                                    Container(
                                        width: wXD(64, context),
                                        height: wXD(42, context),
                                        child: FlatButton(
                                            color: ColorTheme.blueCyan,
                                            padding: EdgeInsets.all(
                                                wXD(10, context)),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(30),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10)),
                                            ),
                                            onPressed: () {
                                              Modular.to.pushNamed(
                                                  '/user-profile-edit');
                                            },
                                            child: Icon(Icons.edit,
                                                color: Color(0xfffafafa)))),
                                  ],
                                )),
                            SizedBox(
                              height: wXD(25, context),
                            ),
                            Container(
                              height: wXD(2, context),
                              margin: EdgeInsets.only(left: wXD(150, context)),
                              color: ColorTheme.primaryColor,
                            ),
                            SizedBox(
                              height: wXD(15, context),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: wXD(10, context)),
                                          child: Text("Notificações",
                                              style: TextStyle(
                                                  fontSize: wXD(18, context),
                                                  color: ColorTheme.textGray))),
                                      SizedBox(
                                        height: wXD(15, context),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          authController.signout();
                                          Modular.to.pushNamed('/');
                                          authController.setCodeSent(false);
                                          rootController.setSelectedTrunk(1);
                                        },
                                        child: Text("Sair",
                                            style: TextStyle(
                                                fontSize: wXD(18, context),
                                                color: ColorTheme.textGray,
                                                fontWeight: FontWeight.w400)),
                                      ),
                                      // ButtonAlterarSenha()
                                    ]),
                                SwitchNotificacoes()
                              ],
                            ),
                            SizedBox(
                              height: wXD(10, context),
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
