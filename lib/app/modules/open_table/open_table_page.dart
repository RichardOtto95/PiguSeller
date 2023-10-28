import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/app/modules/open_table/open_table_controller.dart';
import 'package:pigu_seller/app/modules/open_table/widgets/person_container.dart';
import 'package:pigu_seller/app/modules/open_table/widgets/request_alert.dart';
import 'package:pigu_seller/app/modules/open_table/widgets/request_table_alerts.dart';
import 'package:pigu_seller/app/modules/user_profile/user_profile_page.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:pigu_seller/shared/widgets/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pigu_seller/shared/widgets/empty_state.dart';
import 'package:pigu_seller/app/core/services/auth/auth_controller.dart';
import 'package:pigu_seller/app/modules/open_table/widgets/float_menu.dart';
import 'package:pigu_seller/app/modules/open_table/widgets/paid_tables_page.dart';
import 'package:pigu_seller/app/modules/open_table/widgets/refused_table_page.dart';
import 'package:pigu_seller/app/modules/open_table/widgets/table_invite_widget.dart';

class OpenTablePage extends StatefulWidget {
  OpenTablePage({Key key}) : super(key: key);

  @override
  _OpenTablePageState createState() => _OpenTablePageState();
}

class _OpenTablePageState
    extends ModularState<OpenTablePage, OpenTableController> {
  double wXD(double size, BuildContext context) {
    double finalValue = MediaQuery.of(context).size.width * size / 375;
    return finalValue;
  }

  bool click = false;
  bool showMenu = false;
  final authController = Modular.get<AuthController>();
  final homeController = Modular.get<HomeController>();
  String clickLabel;
  Future<dynamic> _openTablesfuture;
  bool _eventVerifier;
  List<dynamic> openTables = new List();
  bool eventVerifier;

  @override
  void initState() {
    controller.setClickLabel('onGoing');

    setState(() {
      _openTablesfuture = getOpenGroup();
      _eventVerifier = controller.eventVerifier;
    });
    super.initState();
  }

  setEventVerifier(bool _eventVerifier) => eventVerifier = _eventVerifier;

  Future<dynamic> getOpenGroup() async {
    // print('##### aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa #####');

    QuerySnapshot _groups = await Firestore.instance
        .collection('groups')
        .where('seller_id', isEqualTo: homeController.sellerId)
        .where('status', isEqualTo: 'open')
        .orderBy('created_at', descending: false)
        .getDocuments();

    _groups.documents.forEach((element) {
      openTables.add(element.data);
    });
    await Future.delayed(Duration(seconds: 2));
    return openTables;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('#################### ${homeController.sellerId}');
    return WillPopScope(
      onWillPop: () {
        Modular.to.pushNamed('/');
      },
      child: Observer(builder: (_) {
        return Scaffold(
          body: GestureDetector(
            onTap: () {
              if (showMenu == true) {
                setState(() {
                  showMenu = !showMenu;
                });
              }
            },
            child: SafeArea(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NavBar(
                        backPage: () {
                          dispose();
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
                      Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.30,
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: TableInvite(),
                            ),
                            Expanded(
                              child: StreamBuilder(
                                stream: Firestore.instance
                                    .collection('groups')
                                    .where('seller_id',
                                        isEqualTo: homeController.sellerId)
                                    .orderBy('created_at', descending: false)
                                    .snapshots(),
                                builder: (context, groupsSnap) {
                                  if (!groupsSnap.hasData) {
                                    return CircularProgressIndicator();
                                  } else {
                                    List<dynamic> groupsList = new List();
                                    groupsSnap.data.documents.forEach((group) {
                                      if (group.data['status'] == 'queue' ||
                                          group.data['status'] == 'requested') {
                                        groupsList.add(group.data);
                                      }
                                    });
                                    if (groupsList.length == 0) {
                                      return Center(
                                        child: Text('Nenhuma mesa ainda'),
                                      );
                                    } else {
                                      return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: groupsList.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          var ds = groupsList[index];
                                          return RequestTableAlerts(
                                            avatar: ds['avatar'],
                                            onTap: () {
                                              Modular.to.pushNamed(
                                                '/open-table/bill-request',
                                                arguments: ds['id'],
                                              );
                                            },
                                          );
                                        },
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
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
                              .where('status', isEqualTo: 'open')
                              .orderBy('created_at', descending: true)
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
                                  title: 'Sem contas Abertas',
                                  description:
                                      'Não existem contas abertas para serem listadas',
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
                                              list.add(element.data['user_id']);
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
                                            '/open-table/bill-detail',
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
                            // onTapArquived: () {
                            //   controller.setClickLabel('onFiled');
                            //   Navigator.push(context,
                            //       MaterialPageRoute(builder: (context) {
                            //     return ArquivedTablePage();
                            //   }));
                            // },
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
            height: wXD(9, context),
          ),
          Text(
            'Contas',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: wXD(36, context),
                color: Color(0xff2C3E50),
                fontWeight: FontWeight.w700,
                height: 0.9),
          ),
          Text(
            'em andamento',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: wXD(28, context),
                color: Color(0xff2C3E50),
                fontWeight: FontWeight.w300,
                height: 1),
          ),
          SizedBox(
            height: wXD(10, context),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: wXD(5, context),
              width: wXD(170, context),
              color: Color(0xff49CCA5),
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
      height: 34,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            letter,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 36,
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
