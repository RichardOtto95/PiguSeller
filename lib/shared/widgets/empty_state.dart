import 'package:flutter/material.dart';
import 'package:pigu_seller/shared/color_theme.dart';

class EmptyStateList extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const EmptyStateList(
      {Key key, this.image, this.title, this.description, int height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: maxWidth * .05),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.width,
          ),
          Image.asset(
            image,
            fit: BoxFit.fill,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 7),
            child: Text(
              title,
              style: TextStyle(
                  color: ColorTheme.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          Container(
              child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(color: ColorTheme.textGray, fontSize: 14),
          )),
        ],
      ),
    );
  }
}
