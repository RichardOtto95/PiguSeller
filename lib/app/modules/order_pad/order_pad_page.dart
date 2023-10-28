import 'package:pigu_seller/app/modules/open_table/widgets/empty_state.dart';
import 'package:pigu_seller/app/modules/order_pad/item_order.dart';
import 'package:pigu_seller/app/modules/staff_list/staff_list_page.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:pigu_seller/shared/navbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

import 'item_order_with_persons.dart';

class OrderPadPage extends StatefulWidget {
  final DocumentSnapshot member;
  OrderPadPage({
    Key key,
    this.member,
  }) : super(key: key);

  @override
  _OrderPadPageState createState() => _OrderPadPageState();
}

class _OrderPadPageState extends State<OrderPadPage> {
  bool close = false;

  double getTotal(List<DocumentSnapshot> orders) {
    double total = 0.00;
    orders.forEach((order) {
      if (order['item_status'] == 'created' ||
          order['item_status'] == 'created_shared') {
        total = total + order['ordered_value'].toDouble();
      }
    });
    return total;
  }

  int getAmount(List<DocumentSnapshot> orders) {
    int total = 0;
    orders.forEach((order) {
      if (order['item_status'] == 'created' ||
          order['item_status'] == 'created_shared') {
        total = total + 1;
      }
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    // print('HAHA: ${widget.member.data}');
    // QuerySnapshot members;
    return StreamBuilder(
      stream: Firestore.instance
          .collection('order_sheets')
          .where('group_id', isEqualTo: widget.member.data['group_id'])
          .where('user_id', isEqualTo: widget.member.data['user_id'])
          .snapshots(),
      builder: (context, orderSheetSnapshot) {
        if (orderSheetSnapshot.connectionState == ConnectionState.waiting ||
            orderSheetSnapshot == null) {
          return CircularProgressIndicator();
        } else if (orderSheetSnapshot.hasData == false) {
          return Container();
        } else {
          DocumentSnapshot ds = orderSheetSnapshot.data.documents.first;
          // QuerySnapshot _ordersSnapshot =
          //     ds.reference.collection('orders').getDocuments();
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  NavBar(
                    title: "",
                    backPage: () {
                      Modular.to.pop();
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        right: wXD(15, context), top: wXD(7, context)),
                    alignment: Alignment.topRight,
                    width: double.infinity,
                    child: Text(
                      'Conta ${widget.member.data['group_id'].toString().substring(0, 5).toUpperCase()}',
                      style: TextStyle(
                          color: ColorTheme.textGray,
                          fontSize: wXD(16, context)),
                    ),
                  ),
                  SizedBox(
                    height: wXD(9, context),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: wXD(20, context),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: wXD(20, context),
                        ),
                        width: wXD(36, context),
                        height: wXD(36, context),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          border: Border.all(
                              width: wXD(3, context),
                              color: const Color(0xff95A5A6)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x29000000),
                              offset: Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: widget.member.data != null
                            ? StreamBuilder(
                                stream: Firestore.instance
                                    .collection('users')
                                    .document(widget.member.data['user_id'])
                                    .snapshots(),
                                builder: (context, snapshotUser) {
                                  if (!snapshotUser.hasData) {
                                    return CircularProgressIndicator();
                                  } else {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(90),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: snapshotUser.data['avatar'],
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                'assets/img/defaultUser.png'),
                                      ),
                                    );
                                  }
                                })
                            : Container(),
                      ),
                      SizedBox(
                        width: wXD(17, context),
                      ),
                      Container(
                        width: wXD(270, context),
                        child: Text(
                          '${widget.member.data['username']}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: ColorTheme.textColor,
                              fontSize: wXD(16, context),
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: wXD(18, context),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: wXD(23, context)),
                    height: wXD(50, context),
                    color: ColorTheme.gray,
                    child: Text(
                      'Detalhes da Comanda ${ds.documentID.toString().substring(0, 5).toUpperCase()}',
                      style: TextStyle(
                          color: ColorTheme.textColor,
                          fontSize: wXD(16, context),
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder(
                        stream: Firestore.instance
                            .collection('order_sheets')
                            .document(ds.documentID)
                            .collection('orders')
                            .snapshots(),
                        builder: (context, snapshotOrders) {
                          if (snapshotOrders.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            if (snapshotOrders.data.documents.length == 0 ||
                                snapshotOrders.data.documents.length == null) {
                              return EmptyStateList(
                                image: 'assets/img/empty_list.png',
                                title: 'Sem pedidos.',
                                description:
                                    'O usuário ainda não realizou nenhum pedido.',
                              );
                            } else {
                              return Column(
                                children: [
                                  ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount:
                                        snapshotOrders.data.documents.length,
                                    itemBuilder: (context, index) {
                                      // return Container();
                                      DocumentSnapshot dds =
                                          snapshotOrders.data.documents[index];
                                      return dds.data['item_status'] ==
                                                  'created' ||
                                              dds.data['item_status'] ==
                                                  'created_shared'
                                          ? ItemOrder(
                                              title: dds.data['title'],
                                              orderedAmount:
                                                  dds.data['ordered_amount'],
                                              orderedValue:
                                                  dds.data['ordered_value'],
                                              // orderId: orders.documentID,
                                            )
                                          : Container();
                                    },
                                  ),
                                ],
                              );
                            }
                          }
                        }),
                  ),
                  StreamBuilder(
                      stream: Firestore.instance
                          .collection('order_sheets')
                          .document(ds.documentID)
                          .collection('orders')
                          .snapshots(),
                      builder: (context, snapshotOrders) {
                        if (!snapshotOrders.hasData) {
                          return Container();
                        } else {
                          return Container(
                            height: wXD(82, context),
                            color: Color(0xff2C3E50),
                            child: Column(
                              children: [
                                SizedBox(height: wXD(16, context)),
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
                                      child: Text(
                                        // '${snapshotOrders.data.documents.length}',
                                        '${getAmount(snapshotOrders.data.documents)}',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: wXD(16, context),
                                          color: ColorTheme.brown,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(width: wXD(6, context)),
                                    Text(
                                      'item(s)',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: wXD(16, context),
                                        color: Color(0xfffafafa),
                                        fontWeight: FontWeight.w300,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Spacer(),
                                    // Container(
                                    //   width: wXD(40, context),
                                    // ),
                                    Spacer(),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      height: wXD(45, context),
                                      // width: 101,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          color: Color(0xff2C3E50),
                                          border: Border.all(
                                              color: Color(0xff95989A))),
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
                                            '${formatedCurrency(getTotal(snapshotOrders.data.documents))}',
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
                                    SizedBox(width: wXD(14, context)),
                                  ],
                                ),
                                SizedBox(height: wXD(16, context)),
                              ],
                            ),
                          );
                          // ),
                        }
                      }),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  String formatedCurrency(var value) {
    var newValue = new NumberFormat("#,##0.00", "pt_BR");
    return newValue.format(value);
  }
}
