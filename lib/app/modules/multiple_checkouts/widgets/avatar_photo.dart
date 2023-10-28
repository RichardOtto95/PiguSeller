import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AvatarPhoto extends StatelessWidget {
  final double width;
  final double height;
  const AvatarPhoto({
    Key key,
    this.width = 36,
    this.height = 36,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.only(left: 15, top: 3, bottom: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
        border: Border.all(width: 3.0, color: ColorTheme.textGray),
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
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
