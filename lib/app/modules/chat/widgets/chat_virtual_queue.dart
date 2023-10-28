import 'package:pigu_seller/shared/color_theme.dart';
import 'package:flutter/material.dart';

class chatVirtualQueue extends StatelessWidget {
  const chatVirtualQueue({
    Key key,
    // this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82.0,
      height: 120.0,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.fromLTRB(15, 8, 42, 8),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff95A5A6)),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
          bottomLeft: Radius.circular(8.0),
        ),
        color: Color(0xfffafafa),
        boxShadow: [
          BoxShadow(
            color: const Color(0x29000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Flexible(
                child: Text(
                  'Aguardando na fila virtual!',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    color: ColorTheme.textColor,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Flexible(
            child: Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: Text(
                    'Posição na fila ',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      color: ColorTheme.textColor,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Text(
                  '8',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    color: ColorTheme.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Flexible(
            child: Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: Text(
                    'Previsão estimada ',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      color: ColorTheme.textColor,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Text(
                  '21:08',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    color: ColorTheme.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
