import 'package:pigu_seller/app/modules/chat/widgets/person_photo.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class ChatBubblePerson extends StatelessWidget {
  final String userName;
  final String title;
  final String qtd;
  final String image;
  final Timestamp date;

  const ChatBubblePerson({
    Key key,
    this.userName,
    this.date,
    this.qtd,
    this.image,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62.0,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      margin: EdgeInsets.fromLTRB(15, 8, 42, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
          bottomLeft: Radius.circular(8.0),
        ),
        color: Colors.white,
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
          Row(
            children: [
              Text(
                "Nome do usuário",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: ColorTheme.textColor,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 14,
              ),
              Text(
                "Acabei de pedir",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: ColorTheme.textGray,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  child: Stack(
                    children: [
                      Container(
                        width: 204,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x29000000),
                              offset: Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: image,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 2,
                        right: 70,
                        child: Container(
                          width: 54,
                          height: 42,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(21.0),
                              topRight: Radius.circular(21.0),
                              bottomRight: Radius.circular(21.0),
                              bottomLeft: Radius.circular(58.0),
                            ),
                            color: ColorTheme.blueCyan,
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
                              'Obs.',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                color: ColorTheme.white,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  color: ColorTheme.textColor,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Stack(
                children: [
                  Container(
                    width: 180,
                    height: 36,
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            'com',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              color: ColorTheme.textGray,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '/$qtd',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            color: ColorTheme.textGray,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        PersonPhoto(),
                      ],
                    ),
                  ),
                  // PersonPhoto(),
                  // for (var i in [2, 1, 0])
                  //   Positioned(
                  //     left: 28.0 * i,
                  //     child: PersonPhoto(),
                  //   ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "${date.toDate().hour.toString().padLeft(2, '0')}:${date.toDate().minute.toString().padLeft(2, '0')}",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 10,
                  color: ColorTheme.orange,
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
