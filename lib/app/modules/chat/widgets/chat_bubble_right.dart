import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatBubbleRight extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Timestamp date;
  const ChatBubbleRight({
    Key key,
    this.date,
    this.imageUrl,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62.0,
      height: 195,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      margin: EdgeInsets.fromLTRB(75, 8, 15, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
          bottomRight: Radius.circular(8.0),
          bottomLeft: Radius.circular(24.0),
        ),
        color: ColorTheme.textGray,
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
              SizedBox(
                width: 14,
              ),
              Text(
                "Acabei de pedir",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: ColorTheme.white,
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
                  padding: EdgeInsets.only(right: 50),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
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
                            imageUrl: imageUrl,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 2,
                        right: 2,
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
                  color: ColorTheme.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              )
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
                  color: ColorTheme.white,
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
