import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ItemMenu extends StatelessWidget {
  final String name;
  final String note;
  final String price;
  final String image;
  const ItemMenu({
    Key key,
    this.name,
    this.note,
    this.price,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.85,
          margin: EdgeInsets.only(right: 14),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x29000000),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: image,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Text(
                      "$name",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: MediaQuery.of(context).size.width * .04,
                        color: Color(0xff3C3C3B),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "R\$",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: MediaQuery.of(context).size.width * .04,
                      color: Color(0xff3C3C3B),
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "$price",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: MediaQuery.of(context).size.width * .04,
                      color: Color(0xff3C3C3B),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.003,
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    // height: MediaQuery.of(context).size.height * 0.30,
                    child: Text(
                      "$note",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: MediaQuery.of(context).size.width * .04,
                        color: ColorTheme.textGray,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
