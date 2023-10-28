import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/app/modules/open_table/open_table_controller.dart';
import 'package:pigu_seller/app/modules/open_table/widgets/person_container.dart';
import 'package:pigu_seller/app/modules/open_table/widgets/account_request_alert.dart';
import 'package:pigu_seller/app/modules/open_table/widgets/request_table_alerts.dart';
import 'package:pigu_seller/app/modules/open_table/widgets/refused_table_page.dart';
import 'package:pigu_seller/app/modules/open_table/widgets/table_invite_widget.dart';
import 'package:pigu_seller/app/modules/open_table/widgets/float_menu.dart';
import 'package:pigu_seller/app/core/services/auth/auth_controller.dart';
import 'package:pigu_seller/app/modules/user_profile/user_profile_page.dart';
import 'package:pigu_seller/shared/widgets/empty_state.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:pigu_seller/shared/widgets/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../open_table_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PaidTablePage extends StatefulWidget {
  PaidTablePage({Key key}) : super(key: key);

  @override
  _PaidTablePageState createState() => _PaidTablePageState();
}

class _PaidTablePageState extends State<PaidTablePage> {
  bool click = false;
  bool showMenu = false;
  final authController = Modular.get<AuthController>();
  final homeController = Modular.get<HomeController>();
  final controller = Modular.get<OpenTableController>();
  String clickLabel;
  // Future<dynamic> _paidTablesFuture;
  bool _eventVerifier;
  bool eventVerifier;
  // List<dynamic> paidTables = new List();

  @override
  void initState() {
    controller.setClickLabel('onPaid');

    setState(() {
      controller.groupEventCounter(homeController.categoryID);

      // _paidTablesFuture = getOpenGroup();
      eventVerifier = controller.eventVerifier;
    });
    super.initState();
  }

  setEventVerifier(bool _eventVerifier) => eventVerifier = _eventVerifier;

  // Future<dynamic> getOpenGroup() async {
  //   QuerySnapshot _groups = await Firestore.instance
  //       .collection('groups')
  //       .where('seller_id', isEqualTo: homeController.sellerId)
  //       .where('status', isEqualTo: 'paid')
  //       .orderBy('created_at', descending: false)
  //       .getDocuments();
  //   _groups.documents.forEach((element) {
  //     paidTables.add(element.data);
  //   });
  //   await Future.delayed(Duration(seconds: 1));

  //   return paidTables;
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _paidTablesFuture.then((value) {
    //   print('_paidTablesFuture_paidTablesFuture   :::$value');
    // });
    return WillPopScope(
      onWillPop: () {
        Modular.to.pushNamed('/');
      },
      child: Observer(builder: (_) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showMenu = false;
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NavBar(
                          backPage: () {
                            // dispose();
                            Modular.to.pushNamed('/');
                          },
                          title: "",
                          iconButton:
                              Icon(Icons.more_vert, color: Color(0xfffafafa)),
                          iconOnTap: () {
                            setState(() {
                              showMenu = !showMenu;
                            });
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        AccountRequestAlert(),
                        AdicionarPessoasTitle(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Expanded(
                          child: StreamBuilder(
                            stream: Firestore.instance
                                .collection('groups')
                                .where('seller_id',
                                    isEqualTo: homeController.sellerId)
                                .where('status', isEqualTo: 'paid')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.connectionState ==
                                      ConnectionState.done ||
                                  snapshot.connectionState ==
                                      ConnectionState.active) {
                                if (snapshot.data.documents.length == 0) {
                                  return EmptyStateList(
                                    image: 'assets/img/empty_list.png',
                                    title: 'Sem contas quitadas',
                                    description:
                                        'Não existem contas quitadas para serem listadas',
                                  );
                                } else {
                                  return ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot ds =
                                          snapshot.data.documents[index];
                                      List<String> list = [];

                                      Firestore.instance
                                          .collection('groups')
                                          .document(ds['id'])
                                          .collection('members')
                                          .getDocuments()
                                          .then(
                                        (value) {
                                          value.documents.forEach(
                                            (element) {
                                              if (element.data['user_id'] !=
                                                  null) {
                                                list.add(
                                                    element.data['user_id']);
                                              } else {
                                                list.add(
                                                    'https://firebasestorage.googleapis.com/v0/b/ayou-4d78d.appspot.com/o/defaut%2FdefaultUser.png?alt=media&token=33daa153-d1f8-4d92-9afe-30e3f646a8fd');
                                              }
                                            },
                                          );
                                        },
                                      );
                                      return PersonContainer(
                                        listMembers: list,
                                        group: ds['id'],
                                        onTap: () {
                                          controller.setSellerGroupSelected(
                                              ds['seller_id']);
                                          Modular.to.pushNamed(
                                              '/open_table/bill-detail',
                                              arguments: ds['id']);
                                        },
                                        name: ds['label'],
                                        createAt: ds['created_at'],
                                        avatar: ds['avatar'],
                                        sellerId: ds['seller_id'],
                                      );
                                    },
                                  );
                                }
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: showMenu,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        showMenu = !showMenu;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        right: wXD(6, context),
                        top: wXD(6, context),
                      ),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Color(0x30000000),
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            showMenu = !showMenu;
                          });
                        },
                        child: FloatMenu(
                          click: controller.clickLabel,
                          onTapOngoing: () {
                            setState(() {
                              clickLabel = 'onGoing';
                            });
                            controller.setClickLabel('onGoing');
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return OpenTablePage();
                            }));
                          },
                          onTapPaid: () {
                            controller.setClickLabel('onPaid');
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return PaidTablePage();
                            }));
                          },
                          onTapRefused: () {
                            controller.setClickLabel('onRefused');
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return RefusedTablePage();
                            }));
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class AdicionarPessoasTitle extends StatelessWidget {
  const AdicionarPessoasTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: wXD(100, context),
      padding: EdgeInsets.only(left: wXD(30, context)),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 9,
          ),
          Stack(
            children: [
              Text(
                'Contas',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: wXD(36, context),
                    color: Color(0xff2C3E50),
                    fontWeight: FontWeight.w700,
                    height: 0.9),
              ),
            ],
          ),
          Text(
            'quitadas',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: wXD(28, context),
                color: Color(0xff2C3E50),
                fontWeight: FontWeight.w300,
                height: 1),
          ),
          SizedBox(
            height: wXD(13, context),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: wXD(5, context),
              width: wXD(170, context),
              color: Color(0xff1233B3),
            ),
          )
        ],
      ),
    );
  }
}

class LetterDivision extends StatelessWidget {
  final String letter;
  const LetterDivision({
    Key key,
    this.letter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: wXD(34, context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            letter,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: wXD(36, context),
              color: ColorTheme.textColor,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.start,
          )
        ],
      ),
    );
  }
}
