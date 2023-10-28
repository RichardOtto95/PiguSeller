import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/app/modules/multiple_orders_list/multiple_orders_list_controller.dart';
import 'package:pigu_seller/app/modules/multiple_orders_list/refused_list_page.dart';
import 'package:pigu_seller/app/modules/multiple_orders_list/widgets/order_detail.dart';
import 'package:pigu_seller/app/modules/multiple_orders_list/widgets/order_request_alert.dart';
import 'package:pigu_seller/app/modules/multiple_orders_list/widgets/orders_alert.dart';
import 'package:pigu_seller/app/modules/multiple_orders_list/widgets/request_alerts.dart';
import 'package:pigu_seller/app/modules/open_table/widgets/empty_state.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:pigu_seller/shared/widgets/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import './widgets/float_menu.dart';
import 'canceled_list_page.dart';
import 'delivered_list_page.dart';

class MultipleOrdersListPage extends StatefulWidget {
  final String title;
  final group;
  const MultipleOrdersListPage(
      {Key key, this.title = "MultipleOrdersList", this.group})
      : super(key: key);

  @override
  _MultipleOrdersListPageState createState() => _MultipleOrdersListPageState();
}

class _MultipleOrdersListPageState
    extends ModularState<MultipleOrdersListPage, MultipleOrdersListController> {
  bool click = false;
  bool showMenu = false;
  final homeController = Modular.get<HomeController>();
  final controller = Modular.get<MultipleOrdersListController>();
  String clickLabel;
  // Future<dynamic> _onGoingAskings;
  bool eventVerifier;
  List<dynamic> onGoingAskings = new List();

  @override
  void initState() {
    controller.setClickLabel('onGoing');

    // setState(() {
    //   _onGoingAskings = getOnGoing();
    // });
    super.initState();
  }

  setEventVerifier(bool _eventVerifier) => eventVerifier = _eventVerifier;

  Future<dynamic> getOnGoing() async {
    QuerySnapshot _orders = await Firestore.instance
        .collection('orders')
        .where('seller_id', isEqualTo: homeController.sellerId)
        .where('status', isEqualTo: 'order_accepted')
        .orderBy('created_at', descending: false)
        .getDocuments();
    _orders.documents.forEach((element) {
      onGoingAskings.add(element.data);
    });
    await Future.delayed(Duration(seconds: 1));

    return onGoingAskings;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    // print('%%%%%% multiple orders list pageeeeee %%%%%%%%');
    double wXD(double size) {
      double finalSize = MediaQuery.of(context).size.width * size / 375;
      return finalSize;
    }

    // _onGoingAskings.then((value) {
    // print(
    //     '_onGoingAskings_onGoingAskings_onGoingAskings_onGoingAskings_onGoingAskings   :::$value');
    // });
    return WillPopScope(onWillPop: () {
      Modular.to.pushNamed('/');
    }, child: Observer(builder: (_) {
      return Scaffold(
        body: SafeArea(
          child: InkWell(
            onTap: () {
              if (showMenu == true) {
                setState(() {
                  showMenu = false;
                });
              }
            },
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NavBar(
                      backPage: () {
                        Modular.to.pushNamed('/');
                        dispose();
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
                      height: wXD(5),
                    ),
                    OrderRequestAlert(),
                    AskingsTitle(),
                    Expanded(
                      child: StreamBuilder(
                        stream: Firestore.instance
                            .collection('orders')
                            .where('status', isEqualTo: 'order_accepted')
                            .where('seller_id',
                                isEqualTo: homeController.sellerId)
                            .orderBy('created_at', descending: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting)
                            return Center(child: CircularProgressIndicator());
                          else if (!snapshot.hasData ||
                              snapshot.data.documents.length == 0 ||
                              snapshot.data.documents.length == null) {
                            return EmptyStateList(
                              image: 'assets/img/empty_list.png',
                              title: 'Sem pedidos em andamento',
                              description:
                                  'Não existem pedidos em andamento para serem listados',
                            );
                          } else {
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data.documents.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                DocumentSnapshot ds =
                                    snapshot.data.documents[index];
                                return StreamBuilder(
                                  stream: Firestore.instance
                                      .collection('orders')
                                      .document(ds.documentID)
                                      .collection('cart_item')
                                      .snapshots(),
                                  builder: (context, snapshot2) {
                                    if (snapshot2.hasData != true) {
                                      return Container();
                                    } else {
                                      String code = ds.documentID
                                          .toString()
                                          .substring(0, 5)
                                          .toUpperCase();
                                      var dds =
                                          snapshot2.data.documents.first.data;
                                      return OrderDetail(
                                        userID: ds['user_id'],
                                        hash: dds['listing_id'],
                                        note: dds['description'],
                                        createdAt: dds['created_at'],
                                        code: code,
                                        onTap: () {
                                          Modular.to.pushNamed(
                                              'multiple-orders-list/order-request',
                                              arguments: ds['id']);
                                        },
                                        onTables: () {
                                          Modular.to.pushNamed(
                                              'multiple-orders-list/group-tables',
                                              arguments: ds['group_id']);
                                          // arguments: ds.documentID);
                                        },
                                      );
                                    }
                                  },
                                );
                              },
                            );
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
                        right: wXD(6),
                        top: wXD(6),
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
                          tapOnGoing: () {
                            setState(() {
                              clickLabel = 'onGoing';
                            });
                            controller.setClickLabel('onGoing');
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return MultipleOrdersListPage();
                            }));
                          },
                          tapRefused: () {
                            controller.setClickLabel('refused');
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return RefusedListPage();
                            }));
                          },
                          tapCanceled: () {
                            controller.setClickLabel('canceled');
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CanceledListPage();
                            }));
                          },
                          tapDelivered: () {
                            controller.setClickLabel('delivered');
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return DeliveredListPage();
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
    }));
  }
}

class AskingsTitle extends StatelessWidget {
  const AskingsTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double wXD(double size) {
      double finalSize = MediaQuery.of(context).size.width * size / 375;
      return finalSize;
    }

    return Container(
      height: wXD(100),
      padding: EdgeInsets.only(left: wXD(30)),
      width: double.infinity,
      // color: ColorTheme.primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: wXD(9),
          ),
          Text(
            'Pedidos',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: wXD(36),
                color: Color(0xff2C3E50),
                fontWeight: FontWeight.w700,
                height: 0.9),
          ),
          Text(
            'em Andamento',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: wXD(28),
                color: Color(0xff2C3E50),
                fontWeight: FontWeight.w300,
                height: 1),
          ),
          SizedBox(
            height: wXD(13),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: wXD(5),
              width: wXD(170),
              color: Color(0xff49CCA5),
            ),
          )
        ],
      ),
    );
  }
}
