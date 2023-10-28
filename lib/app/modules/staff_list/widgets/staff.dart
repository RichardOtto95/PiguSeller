import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Contributor extends StatelessWidget {
  final DocumentSnapshot ds;
  final String role;
  const Contributor({
    Key key,
    this.ds,
    this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double wXD(double size, BuildContext context) {
      double finalSize = MediaQuery.of(context).size.width * size / 375;
      return finalSize;
    }

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: wXD(0, context), vertical: wXD(0, context)),
      height: wXD(91, context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
          bottomLeft: Radius.circular(8.0),
        ),
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AvatarContainer(employee: ds.documentID),
          SizedBox(
            width: wXD(14, context),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: wXD(240, context),
                child: Text(
                  "${ds.data['fullname']}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: wXD(16, context),
                      fontWeight: FontWeight.bold,
                      color: ColorTheme.textColor),
                ),
              ),
              SizedBox(
                height: wXD(3, context),
              ),
              Text(
                "$role",
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: wXD(16, context),
                    color: ColorTheme.primaryColor),
              ),
              Text(
                formatedNumber(ds.data['mobile_phone_number'],
                    ds.data['region_phone_code']),
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: wXD(16, context),
                    color: ColorTheme.textGray),
              ),
            ],
          )
        ],
      ),
    );
  }

  String formatedNumber(String value, [String rpc]) {
    int i = 0;
    List<String> newValue = value.split('');
    List<String> newlist = List();
    newlist.add('+55 ');
    if (rpc != null) newlist.add('($rpc)');

    if (newValue.length == 8) {
      newlist.add('9');
      newValue.forEach((element) {
        i++;
        newlist.add(element);
        if (i == 4) {
          newlist.add('-');
        }
      });
    } else {
      if (newValue.length == 9) {
        newValue.forEach((element) {
          i++;
          newlist.add(element);
          if (i == 5) {
            newlist.add('-');
          }
        });
      }
    }

    return newlist.join();
  }
}

class AvatarContainer extends StatelessWidget {
  final String employee;

  const AvatarContainer({Key key, this.employee}) : super(key: key);

  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('teams')
            .document(employee)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            return Container(
              width: wXD(64, context),
              height: wXD(64, context),
              margin: EdgeInsets.only(
                  left: wXD(15, context), top: wXD(3, context), bottom: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                border: Border.all(width: 3.0, color: ColorTheme.textGray),
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
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: snapshot.data['avatar'],
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            );
          }
        });
  }
}
