import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Members extends StatelessWidget {
  final bool host;
  final String name;
  final String hash;
  final String number;
  const Members({
    this.hash,
    this.name,
    this.number,
    Key key,
    this.host = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double wXD(double size, BuildContext context) {
      double finalSize = MediaQuery.of(context).size.width * size / 375;
      return finalSize;
    }

    double maxWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: wXD(0, context), vertical: wXD(5, context)),
      height: wXD(70, context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
          bottomLeft: Radius.circular(8.0),
        ),
        color: host ? Color(0xffdadcdc) : Colors.transparent,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StreamBuilder(
                  stream: Firestore.instance
                      .collection('users')
                      .document(hash)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    } else {
                      return Container(
                        width: wXD(62.0, context),
                        height: wXD(62.0, context),
                        margin: EdgeInsets.only(
                            left: wXD(15, context),
                            top: wXD(3, context),
                            bottom: wXD(0, context)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          border: Border.all(
                              width: wXD(3.0, context),
                              color: ColorTheme.textGray),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x29000000),
                              offset: Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(90),
                            child: snapshot.data['avatar'] == null
                                ? Image.asset('assets/img/defaultUser.png')
                                : Image.network(snapshot.data['avatar'],
                                    fit: BoxFit.cover)),
                      );
                    }
                  }),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: maxWidth * .045),
                        alignment: Alignment.centerLeft,
                        width: maxWidth * .48,
                        child: Text(
                          '$name',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: maxWidth * .04,
                            color: ColorTheme.textColor,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // SizedBox(
                      //   width: maxWidth * .3,
                      // ),
                      host
                          ? Text(
                              'anfitrião',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: maxWidth * .04,
                                color: ColorTheme.primaryColor,
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.right,
                            )
                          : Container(),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: wXD(34, context),
                      ),
                      Text(
                        '$number',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: maxWidth * .04,
                          color: ColorTheme.textGray,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: maxWidth * .025,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
