import 'package:pigu_seller/app/modules/staff_list/staff_list_page.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pigu_seller/app/modules/menu_list/menu_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MenuSlide extends StatelessWidget {
  final Function onTap;
  final String name;
  final String note;
  final bool clickItem;
  final String price;
  final menuController = Modular.get<MenuListController>();
  final String image;
  MenuSlide({
    this.name,
    this.note,
    this.image,
    this.price,
    Key key,
    this.clickItem,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Stack(
        children: [
          Column(
            children: [
              AnimatedContainer(
                duration: Duration(seconds: 2),
                curve: Curves.ease,
                color: Colors.black.withOpacity(.3),
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: InkWell(onTap: () {
                  menuController.setclickItem(false);
                }),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.45,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              color: Colors.black.withOpacity(.2),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(26),
                      topRight: Radius.circular(26)),
                ),
                child: ListView(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.002,
                          width: MediaQuery.of(context).size.width * 0.50,
                          margin: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.02,
                          ),
                          decoration: BoxDecoration(
                              color: ColorTheme.textGray,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.22,
                          width: MediaQuery.of(context).size.width * 0.87,
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
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04,
                            ),
                            Container(
                              width: wXD(340, context),
                              child: Text(
                                "$name",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  color: ColorTheme.textColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Text(
                            "$note",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              color: ColorTheme.textGray,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
