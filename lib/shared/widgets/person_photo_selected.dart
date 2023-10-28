import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PersonPhotoSelected extends StatelessWidget {
  final Function onTap;
  const PersonPhotoSelected({
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        Stack(
          children: [
            Container(
              height: 80,
              width: 57,
              margin: EdgeInsets.only(right: 4),
            ),
            Positioned(
              top: 5,
              right: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(width: 54),
                  Container(
                    width: 54.0,
                    height: 54.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      border:
                          Border.all(width: 3.0, color: ColorTheme.textGray),
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
                        imageUrl: "https://i.pravatar.cc/150?img=30",
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: onTap,
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      color: Color(0xff1233B3), shape: BoxShape.circle),
                  child: Icon(
                    Icons.close,
                    size: 14,
                    color: ColorTheme.textGray,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
