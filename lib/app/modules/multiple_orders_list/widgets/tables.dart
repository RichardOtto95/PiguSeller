import 'package:pigu_seller/shared/color_theme.dart';
import 'package:flutter/material.dart';

class Tables extends StatelessWidget {
  final String label;

  const Tables({Key key, this.label}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return Container(
      height: maxWidth * .16,
      padding: EdgeInsets.only(left: 15),
      margin: EdgeInsets.symmetric(
          horizontal: maxWidth * .03, vertical: maxWidth * .01),
      decoration: BoxDecoration(
        color: ColorTheme.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x29000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        '$label',
        style: TextStyle(
          fontSize: 16,
          color: ColorTheme.textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
