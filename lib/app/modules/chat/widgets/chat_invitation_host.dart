import 'package:pigu_seller/app/modules/chat/widgets/person_photo.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChatInvitationHost extends StatelessWidget {
  final String title;
  const ChatInvitationHost({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 100.0,
      padding: EdgeInsets.fromLTRB(16, 9, 16, 9),
      margin: EdgeInsets.fromLTRB(15, 8, 50, 8),
      decoration: BoxDecoration(
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
            height: 15,
          ),
          Row(
            children: [
              PersonPhoto(),
              SizedBox(
                width: 5,
              ),
              Container(
                width: 150,
                child: Text(
                  "Nome do usuário ",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    color: ColorTheme.textColor,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
              ),
              Text(
                "quer promover",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: ColorTheme.textGray,
                  fontWeight: FontWeight.w300,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              PersonPhoto(),
              SizedBox(
                width: 5,
              ),
              Container(
                width: 150,
                child: Text(
                  "Nome do usuário ",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    color: ColorTheme.textColor,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
              ),
              Text(
                "como anfitrião",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: ColorTheme.textGray,
                  fontWeight: FontWeight.w300,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Você aceita?",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: ColorTheme.textGray,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  height: 37,
                  width: 96,
                  margin: EdgeInsets.only(left: 30),
                  decoration: BoxDecoration(
                    color: Color(0xfffafafa),
                    border: Border.all(color: ColorTheme.primaryColor),
                    borderRadius: BorderRadius.circular(21),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x29000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Não',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: ColorTheme.textColor,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )),
              Container(
                  height: 37,
                  width: 96,
                  margin: EdgeInsets.only(right: 30),
                  decoration: BoxDecoration(
                    color: ColorTheme.primaryColor,
                    borderRadius: BorderRadius.circular(21),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x29000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Sim!',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: Color(0xfffafafa),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "16:45",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  color: ColorTheme.primaryColor,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ],
      ),
    );
  }
}
