import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OrdersAlert extends StatelessWidget {
  final homeController = Modular.get<HomeController>();

  @override
  Widget build(BuildContext context) {
    double wXD(double size) {
      double finalValue = MediaQuery.of(context).size.width * size / 375;
      return finalValue;
    }

    return Container(
      margin: EdgeInsets.only(top: wXD(15)),
      height: wXD(60),
      width: wXD(80),
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('orders')
            .where('seller_id', isEqualTo: homeController.sellerId)
            .where('status', isEqualTo: 'order_requested')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return Container();
          } else {
            return Stack(
              children: [
                Container(
                  width: wXD(208),
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.only(
                    bottom: wXD(7),
                    top: wXD(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alertas',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: wXD(17),
                            color: ColorTheme.textColor,
                            fontWeight: FontWeight.w400,
                            height: 0.9),
                      ),
                      Container(
                        child: Text(
                          'Pedidos',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: wXD(17),
                              color: ColorTheme.textColor,
                              fontWeight: FontWeight.w700,
                              height: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                snapshot.data.documents.length == 0
                    ? Container()
                    : Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          // alignment: Alignment.center,
                          height: 23,
                          width: 23,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: ColorTheme.blue),
                          child: Center(
                            child: Text(
                              snapshot.data.documents.length >= 10
                                  ? '9+'
                                  : '${snapshot.data.documents.length}',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: wXD(14),
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
              ],
            );
          }
        },
      ),
    );
  }
}
