import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TableAlert extends StatelessWidget {
  const TableAlert({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Modular.get<HomeController>();
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      width: MediaQuery.of(context).size.width * 0.18,
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('groups')
            .where('seller_id', isEqualTo: homeController.sellerId)
            .where('status', isEqualTo: 'requested')
            .snapshots(),
        builder: (context, requested) {
          return StreamBuilder(
            stream: Firestore.instance
                .collection('groups')
                .where('seller_id', isEqualTo: homeController.sellerId)
                .where('status', isEqualTo: 'queue')
                .snapshots(),
            builder: (context, queue) {
              if (!queue.hasData) {
                return Container();
              } else {
                var totalLenght = requested.data.documents.length +
                    queue.data.documents.length;
                return Stack(
                  children: [
                    Container(
                      alignment: Alignment.bottomLeft,
                      padding: EdgeInsets.only(bottom: 7),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alertas',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 17,
                                color: ColorTheme.textColor,
                                fontWeight: FontWeight.w700,
                                height: 0.9),
                          ),
                          Text(
                            'Contas',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 17,
                                color: ColorTheme.textColor,
                                fontWeight: FontWeight.w700,
                                height: 0.9),
                          ),
                        ],
                      ),
                    ),
                    totalLenght == 0
                        ? Container()
                        : Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              // alignment: Alignment.center,
                              height: 23,
                              width: 23,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorTheme.blue),
                              child: Center(
                                child: Text(
                                  totalLenght >= 10 ? '9+' : '$totalLenght',
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
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
          );
        },
      ),
    );
  }
}
