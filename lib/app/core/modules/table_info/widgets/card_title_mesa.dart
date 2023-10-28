import './card_mesa.dart';
import 'package:flutter/material.dart';

class CardTitleMesa extends StatelessWidget {
  var primaryColor = Color.fromRGBO(237, 237, 237, 1);
  var primaryText = Color.fromRGBO(22, 16, 18, 1);
  final String title;
  final String background_image;
  final String avatar;
  var usuarios = [
    {"nome": "Murilo", "tipo": "anfitrião", "numero": "(51) 99865-5102"},
    {"nome": "Murilo", "tipo": "anfitrião", "numero": "(51) 99865-5102"},
    {"nome": "Murilo", "tipo": "anfitrião", "numero": "(51) 99865-5102"},
    {"nome": "Murilo", "tipo": "anfitrião", "numero": "(51) 99865-5102"},
    {"nome": "Murilo", "tipo": "anfitrião", "numero": "(51) 99865-5102"},
  ];

  CardTitleMesa({Key key, this.title, this.background_image, this.avatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 250,
        color: primaryColor,
        child: Column(
          children: <Widget>[
            Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(30, 20, 0, 8),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Em",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text("$title",
                          style: TextStyle(
                              fontSize: 34,
                              color: primaryText,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                )),
            Container(
                padding: EdgeInsets.only(left: 27, right: 27),
                child: CardMesa(
                  avatar: avatar,
                  background_image: background_image,
                )),
          ],
        ));
  }
}
