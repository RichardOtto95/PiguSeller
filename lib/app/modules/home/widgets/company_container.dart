import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CompanyContainer extends StatelessWidget {
  final String mainImg;
  final String name;
  final String iconImg;
  final bool restaurantFav;
  const CompanyContainer({
    Key key,
    this.mainImg,
    this.name,
    this.iconImg,
    this.restaurantFav,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 16),
          height: 165.0,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: const Color(0xfffafafa),
            boxShadow: [
              BoxShadow(
                color: const Color(0x29000000),
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 108,
                    width: double.infinity,
                    margin: EdgeInsets.all(7),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: mainImg,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 7,
                    right: 7,
                    child: Container(
                      width: 110,
                      height: 108,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(14.0),
                        ),
                        // gradis: Alignment(0.18, 0.0),
                        // colors: [
                        //   const Color(0xfff9995e),
                        //   const Color(0x00f6b72a)
                        // ],
                        // stops: [0.0, 1.0],
                        // ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 70,
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: ColorTheme.textColor,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                  Image.asset(
                    'assets/icon/sender.png',
                    height: 16,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    width: 22,
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 52,
                  ),
                  Image.asset(
                    'assets/icon/marker.png',
                    height: 16,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    '406 Sul',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: ColorTheme.textGray,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                  Text(
                    '3,2 Km',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: ColorTheme.blue,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: 7,
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
            top: 16,
            right: 36,
            child: Icon(
              restaurantFav == false ? Icons.favorite_border : Icons.favorite,
              color: Colors.white,
            )),
        Positioned(
          bottom: 52,
          left: 40,
          child: Container(
            padding: EdgeInsets.all(4),
            height: 48,
            width: 48,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Color(0xffF9995E)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                color: Colors.white,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: iconImg,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 72,
          right: 32,
          child: Container(
            padding: EdgeInsets.all(6),
            height: 32,
            width: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
            ),
            child: Image.asset(
              'assets/icon/pizza.png',
              height: 16,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
