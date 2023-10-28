import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/app/modules/open_table/open_table_controller.dart';
import './profile_view.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FloatMenu extends StatelessWidget {
  final String group;
  final String click;
  final Function tapProfileView;
  final Function tapPromoteHoster;
  final Function tapPartialCheck;
  final String userView;
  FloatMenu(
      {Key key,
      this.click,
      this.tapProfileView,
      this.tapPromoteHoster,
      this.tapPartialCheck,
      this.userView,
      this.group})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final openTableController = Modular.get<OpenTableController>();
    final homeController = Modular.get<HomeController>();

    return StreamBuilder(
        stream:
            Firestore.instance.collection("group").document(group).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            var userDocument = snapshot.data;
            return Container(
                width: 200,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x29000000),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      openTableController.clickLabel == 'ProfileView'
                          ? Container()
                          : InkWell(
                              onTap: () {
                                openTableController
                                    .setClickLabelTableInfo('ProfileView');
                                if (openTableController.userView ==
                                    homeController.user.uid) {
                                  Modular.to.pushNamed('/user-profile');
                                } else {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ProfileView(
                                      userView: openTableController.userView,
                                    );
                                  }));
                                }
                              },
                              child: FloatMenuButton(
                                  title: "Visualizar Perfil",
                                  onTap: tapProfileView)),
                      openTableController.clickLabel == 'PromoteHoster'
                          ? Container()
                          : userDocument['user_host'] == homeController.user.uid
                              ? InkWell(
                                  onTap: () async {
                                    openTableController.setPromotehost(true);
                                    openTableController.setClickLabelTableInfo(
                                        'PromoteHoster');

                                    // openTableController.userView;
                                    // await Firestore.instance
                                    //     .collection('group').document()
                                    // .document(openTableController.userView)
                                    DocumentSnapshot _user = await Firestore
                                        .instance
                                        .collection('users')
                                        .document(openTableController.userView)
                                        .get();

                                    Firestore.instance
                                        .collection('group')
                                        .document(group)
                                        .updateData({
                                      'user_host_invited': _user.documentID
                                    });
                                    QuerySnapshot ref4 = await Firestore
                                        .instance
                                        .collection("chat")
                                        .where('group_id', isEqualTo: group)
                                        .getDocuments();

                                    ref4.documents[0].reference
                                        .collection("messages")
                                        .add({
                                      'author_id': _user.documentID,
                                      'group_id': group,
                                      'created_at': Timestamp.now(),
                                      'listing_images': '',
                                      'listing_note': '',
                                      'listing_title': '',
                                      'order_status': '',
                                      'text':
                                          'Usuario anfitriao criada com sucesso!',
                                      'type': 'user_host_invited',
                                    });

                                    Fluttertoast.showToast(
                                        msg:
                                            "Convite de anfitrião enviado para ${_user.data['fullname'] != null ? _user.data['fullname'] : _user.data['mobile_phone_number']}",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.SNACKBAR,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: ColorTheme.orange,
                                        textColor: ColorTheme.white,
                                        fontSize: 16.0);
                                    // Navigator.push(context,
                                    //     MaterialPageRoute(builder: (context) {
                                    //   return Text("PROMOTEHOSTERBUTTONPATH???");
                                    // }));
                                  },
                                  child: FloatMenuButton(
                                      title: "Promover a Anfitrião",
                                      onTap: tapPromoteHoster))
                              : Container(),
                      openTableController.clickLabel == 'PartialCheck'
                          ? Container()
                          : InkWell(
                              onTap: () {
                                openTableController
                                    .setClickLabelTableInfo('PartialCheck');
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Text("PARTIALCHECKPATH???");
                                }));
                              },
                              child: FloatMenuButton(
                                  title: "Ver Comanda Parcial",
                                  onTap: tapProfileView)),
                    ]));
          }
        });
  }
}

class FloatMenuButton extends StatelessWidget {
  final String title;
  final Function onTap;
  const FloatMenuButton({
    Key key,
    this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 39,
        padding: EdgeInsets.only(left: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: ColorTheme.textGray,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
