import 'package:pigu_seller/app/core/models/seller_model.dart';
import 'package:pigu_seller/app/modules/staff_list/staff_list_page.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CardSeller extends StatelessWidget {
  final String backgroundImage;
  final String avatar;
  final String address;
  final String name;
  var lightPrimaryColor = Color.fromRGBO(246, 183, 42, 1);
  var accentColor = Color.fromRGBO(114, 74, 134, 1);
  var primaryColor = Color.fromRGBO(254, 214, 165, 1);
  var orientation;

  CardSeller({
    this.orientation,
    this.backgroundImage,
    this.avatar,
    this.address,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
            alignment: Alignment.topCenter,
            child: Container(
                margin: EdgeInsets.only(bottom: 0, left: 0, right: 0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: wXD(200, context),
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        image: new DecorationImage(
                          image: new NetworkImage(backgroundImage),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    // Positioned(
                    //     bottom: wXD(7, context),
                    //     right: wXD(15, context),
                    //     child: Container(
                    //       width: wXD(50, context),
                    //       height: wXD(35, context),
                    //       child: Icon(Icons.wrap_text),
                    //       decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.all(
                    //             Radius.circular(9),
                    //           ),
                    //           color: Color(0xfffafafa)),
                    //     ))
                  ],
                ))),
        Align(
            alignment: Alignment.center,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    top: wXD(140, context),
                    right: wXD(25, context),
                    left: wXD(25, context),
                  ),
                  height: wXD(140, context),
                  width: MediaQuery.of(context).size.width - 70,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    image: new DecorationImage(
                      image: new AssetImage("assets/map.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    right: wXD(0, context),
                    child: Container(
                        height: wXD(45, context),
                        width: wXD(65, context),
                        child: FlatButton(
                          onPressed: () {},
                          color: ColorTheme.blueCyan,
                          child: Center(
                            child: Icon(
                              Icons.send,
                              size: wXD(28, context),
                              color: ColorTheme.white,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(60),
                                bottomRight: Radius.circular(15)),
                          ),
                        )))
              ],
            )),
        Align(
            alignment: Alignment.center,
            child: Container(
                margin: EdgeInsets.only(top: wXD(150, context)),
                width: wXD(40, context),
                height: wXD(40, context),
                // margin: EdgeInsets.only(bottom: 40),
                child: Image.asset("assets/icon/mapMarker.png"))),
        Align(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.only(top: wXD(330, context)),
            width: wXD(375, context),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  color: ColorTheme.textGray,
                  size: wXD(28, context),
                ),
                SizedBox(
                  width: wXD(5, context),
                ),
                Container(
                  width: wXD(320, context),
                  child: Text("$address",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: ColorTheme.textGray,
                          fontSize: wXD(18, context))),
                )
              ],
            ),
          ),
        ),
        Align(
            alignment: Alignment.center,
            child: Container(
                margin: EdgeInsets.only(top: wXD(380, context)),
                child: Divider(
                  endIndent: wXD(30, context),
                  indent: wXD(30, context),
                  color: ColorTheme.textGray,
                ))),
        Positioned(
          bottom: wXD(190, context),
          child: Row(
            children: [
              InkWell(
                child: Container(
                  width: wXD(60, context),
                  height: wXD(60, context),
                  margin: EdgeInsets.only(left: wXD(15, context)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90),
                    border: Border.all(
                        width: wXD(3, context), color: ColorTheme.primaryColor),
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
                      imageUrl: avatar,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              // Container(
              //   // top: 0,
              //   // left: 5,
              //   child: CircleAvatar(
              //     backgroundColor: lightPrimaryColor,
              //     radius: 28,
              //     child: Image.network(seller.avatar),
              //   ),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(90),
              //     border: Border.all(width: 3.0, color: ColorTheme.textGray),
              //     boxShadow: [
              //       BoxShadow(
              //         color: const Color(0x29000000),
              //         offset: Offset(0, 3),
              //         blurRadius: 6,
              //       ),
              //     ],
              //   ),
              // )
              SizedBox(
                width: wXD(5, context),
              ),
              Container(
                width: wXD(240, context),
                child: Text(
                  '$name',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: ColorTheme.white,
                      fontSize: wXD(40, context),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Roboto'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
