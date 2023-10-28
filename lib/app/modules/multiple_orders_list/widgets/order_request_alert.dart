import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/app/modules/multiple_orders_list/widgets/orders_alert.dart';
import 'package:pigu_seller/app/modules/multiple_orders_list/widgets/request_alerts.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OrderRequestAlert extends StatefulWidget {
  @override
  _OrderRequestAlertState createState() => _OrderRequestAlertState();
}

Future<dynamic> ordersRequestFuture;
List<dynamic> requestTables = new List();

class _OrderRequestAlertState extends State<OrderRequestAlert> {
  final homeController = Modular.get<HomeController>();
  @override
  Widget build(BuildContext context) {
    double wXD(double size) {
      double finalSize = MediaQuery.of(context).size.width * size / 375;
      return finalSize;
    }

    return Container(
      height: wXD(103),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: wXD(10)),
          OrdersAlert(),
          Expanded(
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('orders')
                  .where('seller_id', isEqualTo: homeController.sellerId)
                  .where('status', isEqualTo: 'order_requested')
                  .orderBy('created_at', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          ColorTheme.primaryColor),
                    ),
                  );
                } else {
                  if (!snapshot.hasData ||
                      snapshot.data.documents.length == 0 ||
                      snapshot.data.documents.length == null) {
                    return Center(child: Text('Nenhum pedido ainda'));
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.documents.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return RequestAlerts(
                          orderId: snapshot.data.documents[index].documentID,
                          onTap: () {
                            Modular.to.pushNamed(
                                'multiple-orders-list/order-request',
                                arguments:
                                    snapshot.data.documents[index].documentID);
                          },
                        );
                      },
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
