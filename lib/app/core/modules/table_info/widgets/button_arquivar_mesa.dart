import 'package:flutter/material.dart';

class ButtonArquivarMesa extends StatelessWidget {
  var lightPrimaryColor = Color.fromRGBO(246, 183, 42, 1);
  final Function archived;

  ButtonArquivarMesa({Key key, this.archived}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          child: RaisedButton(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)),
            color: lightPrimaryColor,
            onPressed: archived,
            child: Text("Arquivar Mesa",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            padding: EdgeInsets.all(20),
          ),
        ));
  }
}
