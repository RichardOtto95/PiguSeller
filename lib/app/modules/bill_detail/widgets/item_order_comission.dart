import 'package:pigu_seller/shared/color_theme.dart';
import 'package:flutter/material.dart';

class ItemOrderCommission extends StatelessWidget {
  final String price;
  const ItemOrderCommission({
    Key key,
    this.price = "14,99",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      height: 50,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 3, color: Color(0xff95A5A6)),
        ),
      ),
      child: Row(
        children: [
          Checkbox(
              value: true,
              checkColor: Colors.white, // color of tick Mark
              activeColor: ColorTheme.orange,
              onChanged: (bool value) {}),
          SizedBox(
            width: 0,
          ),
          Text(
            'Adicionar Comissão',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: ColorTheme.textGray,
              fontWeight: FontWeight.w300,
            ),
          ),
          Spacer(),
          Icon(
            Icons.add,
            color: ColorTheme.textGray,
            size: 24,
          ),
          SizedBox(
            width: 14,
          ),
          Text(
            '10',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: ColorTheme.textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '%',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: ColorTheme.textColor,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(
            width: 24,
          ),
        ],
      ),
    );
  }
}
