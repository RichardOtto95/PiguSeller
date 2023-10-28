import 'package:pigu_seller/app/core/services/auth/auth_controller.dart';
import 'package:pigu_seller/app/modules/chat/widgets/person_photo.dart';
import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/app/modules/home/searchservice.dart';
import 'package:pigu_seller/app/modules/home/widgets/check_button.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeWidget extends StatefulWidget {
  final String title;
  const HomeWidget({Key key, this.title = "Menu"}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends ModularState<HomeWidget, HomeController> {
  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  final authController = Modular.get<AuthController>();
  final Firestore _db = Firestore.instance;
  // final FirebaseMessaging _fcm = FirebaseMessaging();
  String uid;
  String fav;
  var queryResultSet = [];
  var tempSearchStore = [];
  String categoryID;
  // var favAux;

  @override
  void initState() {
    // authController.signout();
    controller.getUserAuth();
    super.initState();
    FirebaseAuth.instance.currentUser().then((value) {
      setState(() {
        uid = value.uid;
      });
    });
    askPermissions();
    // getUserFavs();
  }

  // getUserFavs() async {
  //   favAux = await Firestore.instance
  //       .collection('users')
  //       .document(controller.user.uid)
  //       .collection('favorite_sellers')
  //       .getDocuments();
  // }

  Future<void> askPermissions() async {
    var user = await FirebaseAuth.instance.currentUser;
    PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {}
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['name'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller.user != null) {
      return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(controller.user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            var userDocument = snapshot.data;

            return Scaffold(
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              top: wXD(39, context), left: wXD(24, context)),
                          child: Text(
                            "Bem Vindo!",
                            style: TextStyle(
                              color: ColorTheme.primaryColor,
                              fontSize: wXD(36, context),
                              fontWeight: FontWeight.bold,
                              fontFamily: "roboto",
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: wXD(25, context)),
                          child: InkWell(
                            onTap: () {
                              Modular.to.pushNamed('user-profile');
                            },
                            child: PersonPhoto(image: userDocument['avatar']),
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: wXD(24, context), bottom: wXD(29, context)),
                      width: wXD(350, context),
                      child: Text(
                        userDocument['username'] != null
                            ? userDocument['username']
                            : userDocument['mobile_phone_number'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xff3c3c3b),
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w300,
                          fontSize: wXD(28, context),
                        ),
                      ),
                    ),
                    Expanded(
                        child: ListView(
                      children: [
                        CheckButton(
                          title: "Contas",
                          onTap: () {
                            Modular.to.pushNamed("open-table");
                          },
                        ),
                        CheckButton(
                          title: "Pedidos",
                          onTap: () {
                            Modular.to.pushNamed('multiple-orders-list');
                          },
                        ),
                        CheckButton(
                          onTap: () async {
                            // await controller.getAmount();
                            //// DONT REMOVE SETSTATE  ///////
                            setState(() {});
                            //// DONT REMOVE SETSTATE  ///////
                            Modular.to.pushNamed('multiple-checkouts');
                          },
                          title: "Checkouts",
                        ),
                        CheckButton(
                          title: "Mesas",
                          onTap: () {
                            Modular.to.pushNamed('table-selection');
                          },
                        ),
                        CheckButton(
                          onTap: () {
                            Modular.to.pushNamed('menu-list');
                          },
                          title: "Menu",
                        ),
                        CheckButton(
                          onTap: () {
                            Modular.to.pushNamed('/staff-list');
                            // /staff_list
                          },
                          title: "Equipe",
                        ),
                        CheckButton(
                          title: "Perfil",
                          onTap: () {
                            Modular.to.pushNamed("establishment");
                          },
                        ),
                      ],
                    ))
                  ],
                ),
              ),
            );
          }
        },
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}

class PersonPhoto extends StatelessWidget {
  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  final Function onTap;
  final String image;
  const PersonPhoto({
    Key key,
    this.onTap,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: wXD(10, context),
        ),
        Stack(
          children: [
            Container(
              height: wXD(68, context),
              width: wXD(57, context),
              margin: EdgeInsets.only(right: wXD(6, context)),
            ),
            Positioned(
              top: wXD(5, context),
              right: wXD(3, context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(width: wXD(54, context)),
                  Container(
                    width: wXD(50, context),
                    height: wXD(50, context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      border: Border.all(
                          width: wXD(3, context),
                          color: ColorTheme.primaryColor),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x29000000),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: image,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Positioned(
            //   top: 0,
            //   right: 0,
            //   child: InkWell(
            //     onTap: onTap,
            //     child: Container(
            //         height: 21,
            //         width: 21,
            //         decoration: BoxDecoration(
            //             color: Color(0xff1233B3), shape: BoxShape.circle),
            //         child: Padding(
            //             padding: EdgeInsets.only(top: 1),
            //             child: Text("5",
            //                 style: TextStyle(
            //                     fontSize: 14, color: Color(0xfffafafa)),
            //                 textAlign: TextAlign.center))),
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
