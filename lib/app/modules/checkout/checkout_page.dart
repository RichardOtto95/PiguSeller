import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/app/modules/multiple_checkouts/multiple_checkouts_controller.dart';
import 'package:pigu_seller/app/modules/open_table/widgets/person_photo.dart';
import 'package:pigu_seller/app/modules/staff_list/staff_list_page.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CheckoutPage extends StatefulWidget {
  final String orderSheetId;

  const CheckoutPage({Key key, this.orderSheetId}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final checkController = Modular.get<MultipleCheckoutsController>();
  final homeController = Modular.get<HomeController>();
  var txtcontrol =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  num check = 0;
  num confirmplus = 0;
  num confirmless = 0;
  // bool loading = false;
  var zero = 0;
  num price;
  FocusNode focusNode;

  @override
  void initState() {
    // txtcontrol = confirmOrder;
    focusNode = FocusNode();
    focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    homeController.setDS(0);
    homeController.setAmount(0);
    focusNode.dispose();
    // loading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Modular.get<HomeController>();

    DocumentSnapshot ds;

    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        // if (loading != true) {
        Modular.to.pushNamed('/multiple-checkouts');
        // }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            leadingWidth: wXD(47, context),
            leading: IconButton(
              icon: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.arrow_back,
                    color: ColorTheme.white,
                  )
                ],
              ),
              onPressed: () {
                // if (loading != true) {
                homeController.setShowDialog(false);
                Modular.to.pushNamed('/multiple-checkouts');
                // }
              },
            ),
            toolbarHeight: wXD(110, context),
            backgroundColor: ColorTheme.primaryColor,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Realizar",
                  style: TextStyle(
                      fontSize: wXD(16, context),
                      color: ColorTheme.white,
                      fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: wXD(3, context),
                ),
                Text(
                  "Checkout",
                  style: TextStyle(
                    fontSize: wXD(30, context),
                    color: ColorTheme.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )),
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              setState(() {
                focusNode.unfocus();
              });
            },
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        wXD(wXD(25, context), context),
                        wXD(20, context),
                        wXD(15, context),
                        0,
                      ),
                      padding: EdgeInsets.only(bottom: wXD(15, context)),
                      height: wXD(73, context),
                      child: StreamBuilder(
                          stream: Firestore.instance
                              .collection('order_sheets')
                              .document(widget.orderSheetId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            // print('### orderId ${widget.orderId}');
                            if (!snapshot.hasData) {
                              return Container();
                            } else {
                              ds = snapshot.data;

                              return Row(
                                children: [
                                  StreamBuilder(
                                      stream: Firestore.instance
                                          .collection('users')
                                          .document(ds['user_id'])
                                          .snapshots(),
                                      builder: (context, userSnap) {
                                        if (!userSnap.hasData) {
                                          return Container();
                                        } else {
                                          return Row(
                                            children: [
                                              PersonPhoto(
                                                  size: wXD(37, context),
                                                  avatar:
                                                      userSnap.data['avatar']),
                                              // SizedBox(
                                              //   width: wXD(10, context),
                                              // ),
                                              Container(
                                                width: wXD(200, context),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Comanda ${widget.orderSheetId.toUpperCase().substring(13)}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize:
                                                            wXD(10, context),
                                                        color: ColorTheme
                                                            .textColor,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Container(
                                                      width: wXD(250, context),
                                                      child: Text(
                                                        '${userSnap.data['username']}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontSize:
                                                              wXD(18, context),
                                                          color: ColorTheme
                                                              .textColor,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                    StreamBuilder(
                                                        stream: Firestore
                                                            .instance
                                                            .collection(
                                                                'groups')
                                                            .document(
                                                                ds['group_id'])
                                                            .snapshots(),
                                                        builder:
                                                            (context, table) {
                                                          if (!table.hasData) {
                                                            return Container();
                                                          } else {
                                                            return Container(
                                                              width: wXD(
                                                                  250, context),
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                'Mesa ${table.data['label']}',
                                                                // 'afhpFOPMJ8CTQW3VJ08NU2 afhpFOPMJ8CTQW3VJ08NU2 afhpFOPMJ8CTQW3VJ08NU2 afhpFOPMJ8CTQW3VJ08NU2 ',

                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: wXD(
                                                                      12,
                                                                      context),
                                                                  color: ColorTheme
                                                                      .textColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              ),
                                                            );
                                                          }
                                                        }),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                      }),
                                  Spacer(),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${DateFormat(DateFormat.ABBR_WEEKDAY, 'pt_Br').format(ds['created_at'].toDate())}, ${ds['created_at'].toDate().hour.toString().padLeft(2, '0')}:${ds['created_at'].toDate().minute.toString().padLeft(2, '0')}',
                                          style: TextStyle(
                                              color: ColorTheme.textGray,
                                              fontSize: wXD(10, context)),
                                        ),
                                        SizedBox(
                                          height: wXD(2, context),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            }
                          }),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: wXD(40, context)),
                      // alignment: Alignment.center,
                      child: StreamBuilder(
                          stream: Firestore.instance
                              .collection('order_sheets')
                              .document(widget.orderSheetId)
                              .collection('orders')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container();
                            } else {
                              List ordersValues = [];
                              num total = 0;
                              snapshot.data.documents
                                  .forEach((DocumentSnapshot element) {
                                if (element.data['item_status'] == 'created' ||
                                    element.data['item_status'] ==
                                        'created_shared') {
                                  ordersValues
                                      .add(element.data['ordered_value']);
                                }
                              });

                              for (num n in ordersValues) {
                                total += n;
                                confirmplus = total + 0.02;
                                confirmless = total - 0.02;
                              }
                              price = total;
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'R\$ ',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: wXD(28, context),
                                      color: ColorTheme.textColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    formatedCurrency(total),
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: wXD(28, context),
                                      color: ColorTheme.textColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                ],
                              );
                            }
                          }),
                    ),
                    InkWell(
                      onTap: () async {
                        homeController.setShowDialog(true);
                      },
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                          width: maxWidth * .4,
                          height: maxWidth * .17,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: ColorTheme.primaryColor,
                              borderRadius: BorderRadius.circular(25)),
                          child: Text(
                            'Confirmar',
                            style: TextStyle(
                                fontSize: wXD(18, context),
                                color: ColorTheme.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
                Visibility(
                  visible: focusNode.hasFocus,
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      focusNode.unfocus();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                ),
                Observer(
                  builder: (context) {
                    return Visibility(
                      visible: homeController.showDialog,
                      child: AnimatedContainer(
                        height: maxHeight,
                        width: maxWidth,
                        color: !homeController.showDialog
                            ? Colors.transparent
                            : Color(0x50000000),
                        duration: Duration(milliseconds: 300),
                        curve: Curves.decelerate,
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.only(top: wXD(5, context)),
                            height: wXD(153, context),
                            width: wXD(324, context),
                            decoration: BoxDecoration(
                                color: Color(0xfffafafa),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(33))),
                            child: Column(
                              children: [
                                Container(
                                  width: wXD(240, context),
                                  margin:
                                      EdgeInsets.only(top: wXD(15, context)),
                                  child: Text(
                                    'Tem certeza que deseja efetuar este checkout?',
                                    style: TextStyle(
                                      fontSize: wXD(15, context),
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xfa707070),
                                    ),
                                  ),
                                ),
                                Spacer(
                                  flex: 1,
                                ),
                                homeController.loading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                ColorTheme.yellow),
                                      ))
                                    : Row(
                                        children: [
                                          Spacer(),
                                          InkWell(
                                            onTap: () {
                                              homeController
                                                  .setShowDialog(false);
                                            },
                                            child: Container(
                                              height: wXD(47, context),
                                              width: wXD(98, context),
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        offset: Offset(0, 3),
                                                        blurRadius: 3,
                                                        color:
                                                            Color(0x28000000))
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(17)),
                                                  border: Border.all(
                                                      color: Color(0x80707070)),
                                                  color: Color(0xfffafafa)),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Não',
                                                style: TextStyle(
                                                    color:
                                                        ColorTheme.primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: wXD(16, context)),
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          InkWell(
                                            onTap: () async {
                                              homeController.setLoading(true);

                                              await homeController.ordersAction(
                                                  orderSheetId:
                                                      widget.orderSheetId);

                                              await homeController.groupPaid(
                                                  orderSheetId:
                                                      widget.orderSheetId);

                                              Fluttertoast.showToast(
                                                  msg: "Quitado com sucesso!",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor:
                                                      ColorTheme.primaryColor,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);

                                              await homeController.getAmount();
                                              homeController.setLoading(false);
                                              homeController
                                                  .setShowDialog(false);

                                              Modular.to.pushNamed(
                                                  '/multiple-checkouts');
                                            },
                                            child: Container(
                                              height: wXD(47, context),
                                              width: wXD(98, context),
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        offset: Offset(0, 3),
                                                        blurRadius: 3,
                                                        color:
                                                            Color(0x28000000))
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(17)),
                                                  border: Border.all(
                                                      color: Color(0x80707070)),
                                                  color: Color(0xfffafafa)),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Sim',
                                                style: TextStyle(
                                                    color:
                                                        ColorTheme.primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: wXD(16, context)),
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                Spacer(
                                  flex: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<bool> showToast() {
  //   return Fluttertoast.showToast();
  // }
}

String formatedCurrency(var value) {
  var newValue = new NumberFormat("#,##0.00", "pt_BR");
  return newValue.format(value);
}
