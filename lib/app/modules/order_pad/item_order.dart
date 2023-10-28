import 'package:pigu_seller/app/modules/staff_list/staff_list_page.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemOrder extends StatelessWidget {
  final String title;
  final orderedAmount;
  final orderedValue;
  final String orderId;
  final bool length;
  const ItemOrder({
    Key key,
    this.title,
    this.length = false,
    this.orderId,
    this.orderedAmount,
    this.orderedValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: wXD(15, context)),
      height: wXD(40, context),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              width: 1,
              color: length ? Colors.transparent : ColorTheme.textColor),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: wXD(9, context),
          ),
          Text(
            '${orderedAmount.toInt()}',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: wXD(16, context),
              color: ColorTheme.textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            width: wXD(13, context),
          ),
          Container(
            width: wXD(210, context),
            child: Text(
              '$title',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: wXD(16, context),
                color: ColorTheme.textColor,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Text(
            'R\$',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: wXD(16, context),
              color: ColorTheme.textColor,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(
            width: wXD(2, context),
          ),
          Container(
            width: wXD(63, context),
            child: Text(
              '${formatedCurrency(orderedValue)}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: wXD(16, context),
                color: ColorTheme.textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String formatedCurrency(var value) {
  var newValue = new NumberFormat("#,##0.00", "pt_BR");
  return newValue.format(value);
}
