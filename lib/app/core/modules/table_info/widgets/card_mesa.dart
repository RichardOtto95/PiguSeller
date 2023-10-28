import 'package:flutter/material.dart';

class CardMesa extends StatelessWidget {
  var primaryColor = Color.fromRGBO(254, 132, 0, 1);
  final String background_image;
  final String avatar;

  CardMesa({Key key, this.background_image, this.avatar}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 130,
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            image: new DecorationImage(
              image: new NetworkImage(background_image),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Positioned(
          child: CircleAvatar(
              radius: 26,
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: Image.network(
                  avatar,
                ),
              ),
              backgroundColor: primaryColor),
          top: 10,
          left: 10,
        ),
        Positioned(
          child: Container(
              width: 45,
              child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.all(0),
                  color: Colors.white,
                  child: Icon(
                    Icons.art_track,
                    color: Colors.grey[400],
                  ),
                  onPressed: () {})),
          bottom: 10,
          right: 10,
        )
      ],
    );
  }
}
