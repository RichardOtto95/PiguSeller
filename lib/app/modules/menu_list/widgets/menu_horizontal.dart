import 'package:pigu_seller/shared/color_theme.dart';
import 'package:flutter/material.dart';

class MenuHorizontal extends StatelessWidget {
  const MenuHorizontal({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(
            width: 14,
          ),
          Text(
            "Mais populares",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: Color(0xff3C3C3B),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            width: 14,
          ),
          Text(
            "Cafés quentes",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: ColorTheme.textGray,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            width: 14,
          ),
          Text(
            "Cafés gelado",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: ColorTheme.textGray,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            width: 14,
          ),
          Text(
            "Outros",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: ColorTheme.textGray,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            width: 14,
          ),
        ],
      ),
    );
  }
}
