import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/app/modules/multiple_checkouts/widgets/command.dart';
import 'package:pigu_seller/app/modules/multiple_checkouts/widgets/float_menu.dart';
import 'package:pigu_seller/app/modules/open_table/widgets/empty_state.dart';
import 'package:pigu_seller/app/modules/staff_list/staff_list_page.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'multiple_checkouts_controller.dart';
import 'package:intl/intl.dart';
import './confirmed_checkouts.dart';

class MultipleCheckoutsPage extends StatefulWidget {
  @override
  _MultipleCheckoutsPageState createState() => _MultipleCheckoutsPageState();
}

class _MultipleCheckoutsPageState
    extends ModularState<MultipleCheckoutsPage, MultipleCheckoutsController> {
  // bool showMenu = false;
  int vagabundo = 0;
  String clickLabel;
  DocumentSnapshot mainDs;
  final checkController = Modular.get<MultipleCheckoutsController>();
  final homeController = Modular.get<HomeController>();
  var _totalDs;

  @override
  void initState() {
    print('object');
    setState(() {});
    super.initState();
    //esperar funcao terminar Não apagar
    homeController.getAmount().then((value) {
      setState(() {
        print('...');
      });
      //esperar funcao terminar Não apagar
    });
  }

  @override
  void dispose() {
    checkController.setClickLabel('onGoing');
    homeController.setAmount(0);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Modular.to.pushNamed('/');
      },
      child: Scaffold(
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              checkController.setShowMenu(false);
            },
            child: Stack(
              children: [
                Column(
                  children: [
                    AppBar(
                      leadingWidth: wXD(47, context),
                      actions: [
                        Container(
                          alignment: Alignment.topCenter,
                          child: IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () {
                              checkController.setShowMenu(true);
                            },
                          ),
                        ),
                      ],
                      leading: Container(
                        padding: EdgeInsets.only(top: wXD(17, context)),
                        alignment: Alignment.topCenter,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_outlined),
                          onPressed: () {
                            Modular.to.pushNamed('/');
                          },
                        ),
                      ),
                      toolbarHeight: wXD(110, context),
                      backgroundColor: ColorTheme.primaryColor,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Checkouts",
                            style: TextStyle(
                              fontSize: wXD(36, context),
                              color: ColorTheme.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: wXD(3, context),
                          ),
                          Text(
                            "em andamento",
                            style: TextStyle(
                                fontSize: wXD(28, context),
                                color: ColorTheme.white,
                                fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: Firestore.instance
                            .collection('order_sheets')
                            .where('status', isEqualTo: 'awaiting_checkout')
                            .where('seller_id',
                                isEqualTo: homeController.sellerId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          QuerySnapshot qs = snapshot.data;
                          if (!snapshot.hasData) return Container();
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            if (snapshot.connectionState ==
                                    ConnectionState.done ||
                                snapshot.connectionState ==
                                    ConnectionState.active) {
                              if (qs.documents.isEmpty ||
                                  qs.documents.length == 0) {
                                return EmptyStateList(
                                  image: 'assets/img/empty_list.png',
                                  title: 'Sem checkouts no momento',
                                  description:
                                      'Não existem checkouts para serem listados',
                                );
                              } else {
                                return ListView.builder(
                                  itemCount: snapshot.data.documents.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    homeController.setDS(_totalDs);
                                    mainDs = snapshot.data.documents[index];

                                    return CommandState(
                                        groupID: mainDs['group_id'],
                                        orderID: mainDs.documentID
                                            .toUpperCase()
                                            .substring(13),
                                        userName: mainDs['user_id'],
                                        docId: mainDs.documentID,
                                        createdAt:
                                            '${DateFormat(DateFormat.ABBR_WEEKDAY, 'pt_Br').format(mainDs['created_at'].toDate())}, ${mainDs['created_at'].toDate().hour.toString().padLeft(2, '0')}:${mainDs['created_at'].toDate().minute.toString().padLeft(2, '0')}');
                                  },
                                );
                              }
                            } else {
                              return Container();
                            }
                          }
                        },
                      ),
                    ),
                    Container(
                      height: wXD(82, context),
                      // width: MediaQuery.of(context).size.width,
                      color: Color(0xff2C3E50),
                      child: Column(
                        children: [
                          SizedBox(height: wXD(10, context)),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 3),
                            height: wXD(4, context),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorTheme.textGray,
                            ),
                          ),
                          SizedBox(height: wXD(10, context)),
                          Observer(
                            builder: (context) {
                              print('amount: ${homeController.amount}');
                              print('totalDS: ${homeController.totalDS}');
                              return Row(
                                children: [
                                  SizedBox(width: wXD(16, context)),
                                  Container(
                                    height: wXD(36, context),
                                    width: wXD(36, context),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color(0xfffafafa),
                                    ),
                                    child: Text(
                                      '${homeController.totalDS}',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 16,
                                        color: ColorTheme.brown,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(width: wXD(6, context)),
                                  Text(
                                    'items(s)',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: wXD(16, context),
                                      color: Color(0xfffafafa),
                                      fontWeight: FontWeight.w300,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Spacer(),
                                  Container(
                                    height: wXD(45, context),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Color(0xff2C3E50),
                                        border: Border.all(
                                            color: Color(0xff95989A))),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: wXD(10, context)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'R\$',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 16,
                                              color: Color(0xffFAFAFA),
                                              fontWeight: FontWeight.w300,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(width: wXD(4, context)),
                                          Text(
                                            '${formatedCurrency(homeController.amount)}',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: wXD(16, context),
                                              color: Color(0xffFAFAFA),
                                              fontWeight: FontWeight.w700,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: wXD(21, context)),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Observer(
                  builder: (context) {
                    return Visibility(
                      visible: checkController.showMenu,
                      child: InkWell(
                        onTap: () {
                          checkController.setShowMenu(false);
                        },
                        child: Container(
                          color: Color(0x30000000),
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                            top: wXD(7, context),
                            right: wXD(7, context),
                          ),
                          alignment: Alignment.topRight,
                          child: FloatMenu(
                            click: checkController.clickLabel,
                            tapOnGoing: () {
                              setState(
                                () {
                                  clickLabel = 'onGoing';
                                },
                              );
                              checkController.setClickLabel('onGoing');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return MultipleCheckoutsPage();
                                  },
                                ),
                              );
                            },
                            tapPaid: () {
                              checkController.setShowMenu(false);
                              checkController.setClickLabel('paid');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ConfirmedCheckoutsPage();
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuFloat extends StatelessWidget {
  final String title;
  final Function onTap1;

  final Function onTap2;

  final Function onTap3;
  final Function ofTap;

  const MenuFloat({
    Key key,
    this.ofTap,
    this.title,
    this.onTap1,
    this.onTap2,
    this.onTap3,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ofTap,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              right: wXD(3, context),
              top: wXD(3, context),
              child: Container(
                  width: wXD(150, context),
                  // height: 202,
                  padding: EdgeInsets.only(
                      left: wXD(14, context), top: wXD(15, context)),
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
                        MenuButton(
                          title: "Em andamento",
                          onTap: onTap1,
                        ),
                        MenuButton(
                          title: "Concluídos",
                          onTap: onTap2,
                        ),
                        MenuButton(
                          title: "Em aberto",
                          onTap: onTap3,
                        ),
                      ])),
            ),
          ],
        ),
      ),
    );
  }
}

String formatedCurrency(var value) {
  var newValue = new NumberFormat("#,##0.00", "pt_BR");
  return newValue.format(value);
}

class MenuButton extends StatelessWidget {
  final String title;
  final Function onTap;
  const MenuButton({
    Key key,
    this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 13),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: wXD(16, context),
            color: ColorTheme.textGray,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}
