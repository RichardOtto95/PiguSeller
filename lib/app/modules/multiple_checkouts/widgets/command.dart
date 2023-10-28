import 'package:pigu_seller/app/modules/multiple_checkouts/widgets/avatar_photo.dart';
import 'package:pigu_seller/app/modules/open_table/widgets/person_photo.dart';
import 'package:pigu_seller/app/modules/staff_list/staff_list_page.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class CommandState extends StatelessWidget {
  final bottomMargin;
  final userName;
  final tableID;
  final orderID;
  final groupID;
  final createdAt;
  final docId;

  const CommandState({
    Key key,
    this.bottomMargin = true,
    this.userName,
    this.tableID,
    this.orderID,
    this.groupID,
    this.createdAt,
    this.docId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('order_sheets')
          .document(docId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              // child: CircularProgressIndicator(),
              );
        } else if (snapshot.connectionState == ConnectionState.done ||
            snapshot.connectionState == ConnectionState.active) {
          DocumentSnapshot ds = snapshot.data;
          return Container(
            margin: EdgeInsets.fromLTRB(
                wXD(15, context), wXD(20, context), wXD(15, context), 0),
            // padding: EdgeInsets.only(bottom: wXD(5, context)),
            height: wXD(55, context),
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 1,
                      color: bottomMargin
                          ? ColorTheme.textGray
                          : Colors.transparent)),
              color: (ds['status'] == 'awaiting_checkout')
                  ? Colors.transparent
                  : ColorTheme.gray,
            ),
            child: InkWell(
              onTap: (ds['status'] == 'awaiting_checkout')
                  ? () {
                      Modular.to.pushNamed('/multiple-checkouts/checkout',
                          arguments: docId);
                    }
                  : () {},
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('users')
                    .document(userName)
                    .snapshots(),
                builder: (context, snapUser) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    return Row(
                      children: [
                        PersonPhoto(
                          size: wXD(37, context),
                          avatar: snapUser.data['avatar'],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: wXD(3, context)),
                              child: Text(
                                'Comanda ${docId.substring(0, 5).toUpperCase()}',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: wXD(10, context),
                                  color: ColorTheme.textColor,
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Container(
                              width: wXD(220, context),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${snapUser.data['username']}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: wXD(18, context),
                                  color: ColorTheme.textColor,
                                  fontWeight: FontWeight.w700,
                                ),
                                // overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: wXD(3, context),
                                ),
                                StreamBuilder(
                                  stream: Firestore.instance
                                      .collection('groups')
                                      .document(groupID)
                                      .snapshots(),
                                  builder: (context, snapshot2) {
                                    if (!snapshot2.hasData) {
                                      return Container();
                                    } else {
                                      return Container(
                                        width: wXD(220, context),
                                        child: Text(
                                          '${snapshot2.data['label']}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: wXD(12, context),
                                            color: ColorTheme.textColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '$createdAt',
                                style: TextStyle(
                                    color: ColorTheme.textGray,
                                    fontSize: wXD(10, context)),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              StreamBuilder(
                                stream: Firestore.instance
                                    .collection('order_sheets')
                                    .document(docId)
                                    .collection('orders')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container();
                                  } else {
                                    // List orders = [];
                                    double total = 0;

                                    snapshot.data.documents.forEach((element) {
                                      if (element.data['item_status'] ==
                                              'created' ||
                                          element.data['item_status'] ==
                                              'created_shared') {
                                        total = total +
                                            element.data['ordered_value']
                                                .toDouble();
                                      }
                                    });

                                    return Row(
                                      children: [
                                        Text(
                                          'R\$ ',
                                          style: TextStyle(
                                            fontSize: wXD(10, context),
                                            color: ColorTheme.textColor,
                                          ),
                                        ),
                                        Text(
                                          formatedCurrency(total),
                                          style: TextStyle(
                                              fontSize: wXD(10, context),
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  }
                },
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

String formatedCurrency(var value) {
  var newValue = new NumberFormat("#,##0.00", "pt_BR");
  return newValue.format(value);
}
