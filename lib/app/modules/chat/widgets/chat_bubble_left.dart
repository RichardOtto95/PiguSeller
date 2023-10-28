import 'package:pigu_seller/shared/color_theme.dart';
import 'package:flutter/material.dart';

class ChatBubbleLeft extends StatelessWidget {
  final String title;
  const ChatBubbleLeft({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82.0,
      height: 80.0,
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
        color: ColorTheme.white,
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
                width: 24,
              ),
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: ColorTheme.textColor,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Spacer(),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Container(
          //       height: 37,
          //       width: 170,
          //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(21), color: ColorTheme.orange),
          //       child: Center(
          //         child: Text(
          //           "Enviar para a cozinha",
          //           style: TextStyle(
          //             fontFamily: 'Roboto',
          //             fontSize: 12,
          //             color: ColorTheme.textColor,
          //             fontWeight: FontWeight.w700,
          //           ),
          //           textAlign: TextAlign.center,
          //         ),
          //       ),
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}
