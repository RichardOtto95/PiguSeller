import 'package:pigu_seller/app/modules/chat/widgets/person_photo.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemOrderWithPersons extends StatelessWidget {
  final List members;
  final String orderId;

  const ItemOrderWithPersons({
    Key key,
    this.orderId,
    this.members,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('orders')
          .document(orderId)
          .collection('cart')
          .snapshots(),
      builder: (context, order) {
        if (!order.hasData) {
          return Container();
        } else {
          DocumentSnapshot ds = order.data.documents.first;
          return Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                height: 77,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: ColorTheme.textColor),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 11,
                        ),
                        Text(
                          '${ds['item_amount']}',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            color: ColorTheme.textColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          width: 29,
                        ),
                        Text(
                          '${ds['description_ptbr']}',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            color: ColorTheme.textColor,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'R\$',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            color: ColorTheme.textColor,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          '${ds['item_price']}',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            color: ColorTheme.textColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          width: 24,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 58,
                        ),
                        Stack(
                          children: [
                            Container(
                              width: 180,
                              height: 36,
                              child: Row(
                                children: [
                                  Text(
                                    'com',
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
                            for (var i = 0; i < members.length; i++)
                              Positioned(
                                left: 28.0 * i,
                                child: PersonPhoto(),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 30,
                right: 21,
                child: Transform.rotate(
                  angle: -10,
                  child: Container(
                    height: 3,
                    width: 35,
                    color: ColorTheme.textGray,
                  ),
                ),
              ),
              Positioned(
                top: 35,
                right: 27,
                child: Text(
                  '${members.length}',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: ColorTheme.orange,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
