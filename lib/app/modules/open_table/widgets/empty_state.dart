import 'package:pigu_seller/shared/color_theme.dart';
import 'package:flutter/material.dart';

class EmptyStateList extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const EmptyStateList(
      {Key key, this.image, this.title, this.description, int height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: maxHeight * .12,
              width: maxHeight * .50,
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
              style: TextStyle(color: ColorTheme.textGray, fontSize: 14),
            )),
          ],
        ),
      ),
    );
  }
}
