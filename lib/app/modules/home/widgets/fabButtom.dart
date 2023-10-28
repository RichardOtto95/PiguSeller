import 'package:flutter/material.dart';

class FabButton extends StatelessWidget {
  FabButton({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62.0,
      height: 80.0,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(58.0),
          topRight: Radius.circular(21.0),
          bottomRight: Radius.circular(21.0),
          bottomLeft: Radius.circular(21.0),
        ),
        color: Color(0xff14CC99),
        boxShadow: [
          BoxShadow(
            color: const Color(0x29000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Container(
          margin: EdgeInsets.only(top: 10, left: 11, bottom: 12),
          child: Center(
            child: Image.asset(
              'assets/icon/addPeople.png',
              height: 38,
              width: 38,
              fit: BoxFit.contain,
            ),
          )),
    );
  }
}
