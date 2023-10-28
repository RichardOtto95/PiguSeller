import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TableInvite extends StatelessWidget {
  const TableInvite({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double wXD(double size, BuildContext context) {
      double finalSize = MediaQuery.of(context).size.width * size / 375;
      return finalSize;
    }

    final homeController = Modular.get<HomeController>();

    return Container(
      width: wXD(50, context),
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('groups')
            .where('seller_id', isEqualTo: homeController.sellerId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            int i = 0;
            QuerySnapshot qs = snapshot.data;

            qs.documents.forEach((element) {
              if (element.data['status'] == 'requested' ||
                  element.data['status'] == 'queue') {
                i++;
              }
            });

            return Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                            top: wXD(20, context),
                            left: wXD(10, context),
                          ),
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Alerta de',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: wXD(17, context),
                                color: ColorTheme.textColor,
                                fontWeight: FontWeight.w400,
                                height: 0.9),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: wXD(10, context),
                          ),
                          width: wXD(80, context),
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Mesas',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: wXD(17, context),
                                color: ColorTheme.textColor,
                                fontWeight: FontWeight.w700,
                                height: 0.9),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: wXD(10, context)),
                      child: Visibility(
                        visible: i > 0,
                        child: Container(
                          alignment: Alignment.center,
                          height: wXD(23, context),
                          width: wXD(23, context),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: ColorTheme.blue),
                          child: Text(
                            '$i',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: wXD(14, context),
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
