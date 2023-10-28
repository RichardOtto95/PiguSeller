import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
      height: MediaQuery.of(context).size.height * 0.07,
      color: ColorTheme.primaryColor,
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.03,
          ),
          InkWell(
            onTap: backPage,
            child: Icon(
              Icons.arrow_back,
              color: ColorTheme.white,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.03,
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
          Expanded(child: SizedBox()),
          (iconOnTap != null)
              ? (iconButton != null)
                  ? InkWell(onTap: iconOnTap, child: iconButton)
                  : Icon(
                      Icons.favorite_border,
                      color: Color(0xfffafafa),
                    )
              : Container(),
          Container(
            width: MediaQuery.of(context).size.width * 0.03,
          ),
        ],
      ),
    );
  }
}

class NavTableBar extends StatelessWidget {
  final String title;
  final Function iconOnTap;
  final Icon iconButton;
  final Function goToTableInfo;
  final Function goBack;
  final String imageURL;
  const NavTableBar({
    Key key,
    this.title,
    this.iconOnTap,
    this.iconButton,
    this.goToTableInfo,
    this.imageURL,
    this.goBack,
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
              onTap: goBack,
              child: Icon(
                Icons.arrow_back,
                color: ColorTheme.white,
              )),
          SizedBox(
            width: 10,
          ),
          InkWell(
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
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: InkWell(
              onTap: goToTableInfo,
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
          ),
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
