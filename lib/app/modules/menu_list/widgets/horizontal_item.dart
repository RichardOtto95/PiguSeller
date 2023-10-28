import 'package:pigu_seller/shared/color_theme.dart';
import 'package:flutter/material.dart';

class HorizontalItem extends StatelessWidget {
  final String title;
  final Function onTap;
  final String note;
  final String price;
  const HorizontalItem({
    Key key,
    this.title,
    this.note,
    this.price,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        // height: 60,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: Color(0xffBDAEA7)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: ColorTheme.textColor,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Expanded(child: SizedBox()),
                Text(
                  "R\$",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    color: ColorTheme.textColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
                ),
                Container(
                  child: Text(
                    "$price",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: ColorTheme.textColor,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            Text(
              "$note",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: MediaQuery.of(context).size.width * 0.03,
                color: ColorTheme.textGray,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
