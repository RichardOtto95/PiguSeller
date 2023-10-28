import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CardProfile extends StatelessWidget {
  var divisorColor = Color.fromRGBO(189, 174, 167, 1);
  var primaryColor = Color.fromRGBO(255, 132, 0, 1);
  final String username;
  final String photo;
  CardProfile({Key key, this.username, this.photo}) : super(key: key);

  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: wXD(210, context),
      width: MediaQuery.of(context).size.width * .45,
      // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: new BoxDecoration(
        color: ColorTheme.primaryColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(58),
            bottomLeft: Radius.circular(21),
            bottomRight: Radius.circular(21),
            topRight: Radius.circular(21)),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: wXD(7, context),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0x29000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                )
              ],
            ),
            child: CircleAvatar(
              radius: wXD(70, context),
              backgroundColor: Color(0xfffafafa),
              child: CircleAvatar(
                backgroundImage: photo != null
                    ? NetworkImage(photo)
                    : AssetImage('assets/img/defaultUser.png'),
                backgroundColor: Colors.white,
                // child: ,
                radius: wXD(67, context),
              ),
            ),
          ),
          SizedBox(
            height: wXD(9, context),
          ),
          Container(
            width: wXD(180, context),
            child: Text("$username",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xfffafafa), fontSize: wXD(18, context))),
          )
        ],
      ),
    );
  }
}
