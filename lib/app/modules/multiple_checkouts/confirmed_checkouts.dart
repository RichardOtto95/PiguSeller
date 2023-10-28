import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/app/modules/multiple_checkouts/multiple_checkouts_controller.dart';
import 'package:pigu_seller/app/modules/multiple_checkouts/widgets/paid_command.dart';
import 'package:pigu_seller/app/modules/staff_list/staff_list_page.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import './widgets/command.dart';
import 'multiple_checkouts_page.dart';
import './widgets/float_menu.dart';

class ConfirmedCheckoutsPage extends StatefulWidget {
  @override
  _ConfirmedCheckoutsPageState createState() => _ConfirmedCheckoutsPageState();
}

class _ConfirmedCheckoutsPageState extends State<ConfirmedCheckoutsPage> {
  String clickLabel;
  bool showMenu = false;
  int vagabundo = 0;
  DocumentSnapshot mainDs;
  final checkController = Modular.get<MultipleCheckoutsController>();
  final homeController = Modular.get<HomeController>();
  var _totalDs;

  @override
  void initState() {
    getAmount();
    super.initState();
  }

  @override
  void dispose() {
    checkController.setClickLabel('onGoing');
    homeController.setAmount(0);
    super.dispose();
  }

  getAmount() async {
    num _totalAmount = 0;

    QuerySnapshot orderSheets = await Firestore.instance
        .collection('order_sheets')
        .where('status', isEqualTo: 'paid')
        .where('seller_id', isEqualTo: homeController.sellerId)
        .getDocuments();

    if (orderSheets.documents.isNotEmpty) {
      orderSheets.documents.forEach((orderSheet) async {
        QuerySnapshot orders =
            await orderSheet.reference.collection('orders').getDocuments();
        orders.documents.forEach((order) {
          String status = order.data['item_status'];
          if (status == 'created' || status == 'created_shared') {
            _totalAmount += order.data['ordered_value'];
            checkController.setAmountc(_totalAmount);
          }
        });
      });
    }

    // Firestore.instance
    //     .collection('order_sheets')
    //     .where('status', isEqualTo: 'paid')
    //     .where('seller_id', isEqualTo: homeController.sellerId)
    //     .getDocuments()
    //     .then((value) {
    //   if (value.documents.isEmpty) {
    //     // setState(() {
    //     //   checkController.setAmountc(0);
    //     //   checkController.setDSc(0);
    //     // });
    //   } else {
    //     for (var i = 0; i < value.documents.length; i++) {
    //       value.documents[i].reference
    //           .collection('orders')
    //           // .where('status', isEqualTo: 'created' ?? 'paid')
    //           .getDocuments()
    //           .then((value) {
    //         value.documents.forEach((element) {
    //           _totalAmount += element.data['ordered_value'];
    //           setState(() {
    //             checkController.setAmountc(_totalAmount);
    //             print("$_totalDs");
    //           });
    //         });
    //       });
    //     }
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Modular.to.pushNamed('/');
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  AppBar(
                      leadingWidth: 47,
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
                      actions: [
                        Container(
                            alignment: Alignment.topCenter,
                            child: IconButton(
                                icon: Icon(Icons.more_vert),
                                onPressed: () {
                                  checkController.setShowMenu(true);
                                }))
                      ],
                      toolbarHeight: wXD(110, context),
                      backgroundColor: ColorTheme.primaryColor,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Checkouts",
                            style: TextStyle(
                              fontSize: 36,
                              color: ColorTheme.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "concluídos",
                            style: TextStyle(
                                fontSize: 28,
                                color: ColorTheme.white,
                                fontWeight: FontWeight.w300),
                          )
                        ],
                      )),
                  Expanded(
                    child: StreamBuilder(
                        stream: Firestore.instance
                            .collection('order_sheets')
                            .where('status', isEqualTo: 'paid')
                            .where('seller_id',
                                isEqualTo: homeController.sellerId)
                            .snapshots(),
                        builder: (context, snapshots) {
                          if (!snapshots.hasData) {
                            return Container();
                          } else {
                            return ListView.builder(
                              itemCount: snapshots.data.documents.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                _totalDs = snapshots.data.documents.length;
                                checkController.setDSc(_totalDs);
                                mainDs = snapshots.data.documents[index];

                                return PaidCommand(
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
                        }),
                  ),
                  Container(
                    height: wXD(82, context),
                    color: Color(0xff2C3E50),
                    child: Column(
                      children: [
                        SizedBox(height: wXD(10, context)),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 3),
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorTheme.textGray,
                          ),
                        ),
                        SizedBox(height: wXD(10, context)),
                        Row(
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
                              child: StreamBuilder(
                                  stream: Firestore.instance
                                      .collection('order_sheets')
                                      .where('status', isEqualTo: 'paid')
                                      .where('seller_id',
                                          isEqualTo: homeController.sellerId)
                                      .snapshots(),
                                  builder: (context, snapshotAmount) {
                                    return Text(
                                      '${snapshotAmount.data == null ? 0 : snapshotAmount.data.documents.length}',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: wXD(16, context),
                                        color: ColorTheme.brown,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    );
                                  }),
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
                            Observer(
                              builder: (context) {
                                return Container(
                                  height: wXD(45, context),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color(0xff2C3E50),
                                      border:
                                          Border.all(color: Color(0xff95989A))),
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'R\$',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: wXD(16, context),
                                            color: Color(0xffFAFAFA),
                                            fontWeight: FontWeight.w300,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(width: wXD(4, context)),
                                        Text(
                                          '${formatedCurrency(checkController.amountc)}',
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
                                );
                              },
                            ),
                            SizedBox(width: wXD(14, context)),
                          ],
                        ),
                        SizedBox(height: wXD(7, context)),
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
                              checkController.setShowMenu(false);
                              setState(() {
                                clickLabel = 'onGoing';
                              });
                              checkController.setClickLabel('onGoing');
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return MultipleCheckoutsPage();
                              }));
                            },
                            tapPaid: () {
                              checkController.setClickLabel('paid');
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ConfirmedCheckoutsPage();
                              }));
                            },
                          )),
                    ),
                  );
                },
              )
            ],
          ),
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
            fontSize: 16,
            color: ColorTheme.textGray,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}
