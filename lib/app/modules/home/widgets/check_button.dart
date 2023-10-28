import 'package:flutter/material.dart';

class CheckButton extends StatelessWidget {
  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  final String title;
  final Function onTap;
  const CheckButton({
    Key key,
    this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.fromLTRB(wXD(24, context), wXD(3, context),
              wXD(24, context), wXD(26, context)),
          padding: EdgeInsets.symmetric(horizontal: 24),
          height: 100,
          decoration: BoxDecoration(
              color: Color(0xffFAF8F7),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x29000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
              borderRadius: BorderRadius.circular(14)),
          child: Center(
            child: CheckboxListTile(
              // onChanged: (covariant) {},
              title: Text(
                title,
                style: TextStyle(
                    fontSize: wXD(28, context),
                    fontWeight: FontWeight.normal,
                    color: Color(0xff3C3C3B)),
              ),
              value: false,
            ),
          )),
    );
  }
}
