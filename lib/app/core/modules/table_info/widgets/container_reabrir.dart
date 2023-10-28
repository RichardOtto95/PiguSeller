import 'package:flutter/material.dart';

class ContainerReabrir extends StatelessWidget {
  var secondaryText = Color.fromRGBO(84, 74, 65, 1);
  final Function reopen;

   ContainerReabrir({Key key, this.reopen}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        height: 80,
        width: double.infinity,
        color: secondaryText,
        child: Stack(children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  color: Colors.grey[300],
                  height: 3,
                  width: 120,
                ),
                SizedBox(
                  height: 16,
                ),
                new Text(
                  "Conta Fechada",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                shape: new RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.white,
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: new BorderRadius.circular(10.0)),
                onPressed:reopen,
                textColor: Colors.white,
                color: secondaryText,
                child: Text("Reabrir", style: TextStyle(color: Colors.white)),
              ))
        ]));
  }
}
