import 'package:pigu_seller/app/modules/open_table/open_table_controller.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class UserAccount extends StatelessWidget {
  final bool host;
  final String name;
  final String groupId;
  final String userId;
  final double totalUser;
  final bool pagou;
  final bool length;
  final Function onTap;

  const UserAccount({
    Key key,
    this.length = false,
    this.pagou = false,
    this.host = false,
    this.onTap,
    this.name = '',
    this.totalUser,
    this.groupId,
    this.userId,
  }) : super(key: key);
  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  // double getTotal(List<DocumentSnapshot> orders) {
  //   double total = 0.00;
  //   print('oreders na function: $orders');
  //   orders.forEach((order) {
  //     if (order['item_status'] == 'created' ||
  //         order['item_status'] == 'created_shared') {
  //       total = total + order['ordered_value'].toDouble();
  //     }
  //   });
  //   return total;
  // }

  @override
  Widget build(BuildContext context) {
    final openTableController = Modular.get<OpenTableController>();
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: size.width * .038, vertical: wXD(5, context)),
            height: wXD(70, context),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                  bottomRight: Radius.circular(24.0),
                  bottomLeft: Radius.circular(8.0),
                ),
                color: host ? ColorTheme.gray : Colors.transparent),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          height: wXD(70, context),
                          width: size.width * .24,
                        ),
                        StreamBuilder(
                            stream: Firestore.instance
                                .collection('users')
                                .document(userId)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container();
                              } else {
                                return Container(
                                  width: wXD(64, context),
                                  height: wXD(64, context),
                                  margin: EdgeInsets.only(
                                      left: wXD(15, context),
                                      top: wXD(0, context),
                                      bottom: wXD(0, context)),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(90),
                                    border: Border.all(
                                        width: 3.0, color: ColorTheme.textGray),
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
                                      imageUrl: snapshot.data['avatar'],
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                              'assets/img/defaultUser.png'),
                                    ),
                                  ),
                                );
                              }
                            }),
                        pagou
                            ? Positioned(
                                right: 0,
                                bottom: 3.25,
                                child: Container(
                                  child: Image.asset(
                                    "assets/img/closed.png",
                                    height: size.width * .1,
                                    width: size.width * .094,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Container(
                                width: wXD(200, context),
                                child: Text(
                                  '$name',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: size.width * .04,
                                    color: ColorTheme.textColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              SizedBox(
                                width: size.width * .03,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: wXD(5, context),
                          ),
                          Row(
                            children: [
                              // SizedBox(
                              //   width: 16,
                              // ),
                              Text(
                                'anfitrião',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: size.width * .04,
                                  color: host
                                      ? ColorTheme.primaryColor
                                      : Colors.transparent,
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Spacer(),
                              Text(
                                "R\$ ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              StreamBuilder(
                                stream: Firestore.instance
                                    .collection('order_sheets')
                                    .where('group_id', isEqualTo: groupId)
                                    .where('user_id', isEqualTo: userId)
                                    .snapshots(),
                                builder: (context, orderSheetSnapshot) {
                                  if (orderSheetSnapshot.hasError) {
                                    return Center(
                                      child: Text(
                                          'Error: ${orderSheetSnapshot.error}'),
                                    );
                                  } else {
                                    DocumentSnapshot ds =
                                        orderSheetSnapshot.data.documents.first;

                                    return StreamBuilder(
                                      stream: Firestore.instance
                                          .collection('order_sheets')
                                          .document(ds.documentID)
                                          .collection('orders')
                                          .snapshots(),
                                      builder: (context, ordersSnapshot) {
                                        if (ordersSnapshot.hasData == false) {
                                          return Container();
                                        } else {
                                          double totalUserValue = 0;
                                          // QuerySnapshot _array = ordersSnapshot
                                          //     .data.documents.firts;
                                          // print('_array: ${_array}');
                                          ordersSnapshot.data.documents
                                              .forEach((order) {
                                            if (order['item_status'] ==
                                                    'created' ||
                                                order['item_status'] ==
                                                    'created_shared') {
                                              totalUserValue +=
                                                  order['ordered_value']
                                                      .toDouble();
                                            }
                                          });

                                          return Text(
                                            '${formatedCurrency(totalUserValue)}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: ColorTheme.textColor),
                                          );
                                        }
                                      },
                                    );
                                  }
                                },
                              ),
                              SizedBox(
                                width: wXD(10, context),
                              )
                            ],
                          ),
                          SizedBox(
                            height: wXD(10, context),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        length
            ? Container()
            : Container(
                height: 1,
                color: ColorTheme.textGray,
                margin: EdgeInsets.symmetric(horizontal: 15),
              )
      ],
    );
  }
}

String formatedCurrency(var value) {
  var newValue = new NumberFormat("#,##0.00", "pt_BR");
  return newValue.format(value);
}
