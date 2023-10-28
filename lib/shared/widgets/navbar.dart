import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class NavBar extends StatelessWidget {
  final String title;
  final Function iconOnTap;
  final Function infoOnTap;
  final Function backPage;
  final Icon iconButton;
  const NavBar({
    Key key,
    this.infoOnTap,
    this.backPage,
    this.title = "StarBucks",
    this.iconOnTap,
    this.iconButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 57,
      color: ColorTheme.primaryColor,
      child: Row(
        children: [
          SizedBox(
            width: 16,
          ),
          IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: ColorTheme.white,
              ),
              onPressed: backPage),
          SizedBox(
            width: 28,
          ),
          InkWell(
            onTap: infoOnTap,
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: Color(0xfffafafa),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Spacer(),
          (iconOnTap != null)
              ? (iconButton != null)
                  ? InkWell(onTap: iconOnTap, child: iconButton)
                  : Icon(
                      Icons.favorite_border,
                      color: Color(0xfffafafa),
                    )
              : Container(),
          SizedBox(
            width: 30,
          ),
        ],
      ),
    );
  }
}

class NavTableBar extends StatelessWidget {
  final bool haveImage;
  final String title;
  final Function iconOnTap;
  final Icon iconButton;
  final Function goToTableInfo;
  final String imageURL;
  const NavTableBar({
    Key key,
    this.title,
    this.iconOnTap,
    this.iconButton,
    this.goToTableInfo,
    this.imageURL,
    this.haveImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 57,
      color: ColorTheme.primaryColor,
      child: Row(
        children: [
          SizedBox(
            width: 16,
          ),
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: ColorTheme.white,
              )),
          SizedBox(
            width: 10,
          ),
          Visibility(
            visible: haveImage,
            child: InkWell(
              onTap: goToTableInfo,
              child: Container(
                width: 50.0,
                height: 50.0,
                margin: EdgeInsets.only(left: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  border: Border.all(width: 3.0, color: Color(0xff95A5A6)),
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
                    imageUrl: imageURL,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: Color(0xfffafafa),
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
          ),
          // Spacer(),
          (iconOnTap != null)
              ? (iconButton != null)
                  ? InkWell(onTap: iconOnTap, child: iconButton)
                  : Icon(
                      Icons.favorite_border,
                      color: Color(0xfffafafa),
                    )
              : Container(),
          SizedBox(
            width: 30,
          ),
        ],
      ),
    );
  }
}
