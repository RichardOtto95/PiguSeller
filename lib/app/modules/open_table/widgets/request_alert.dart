import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/app/modules/open_table/widgets/request_table_alerts.dart';
import 'package:pigu_seller/app/modules/open_table/widgets/table_invite_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RequestAlert extends StatefulWidget {
  @override
  _RequestAlertState createState() => _RequestAlertState();
}

class _RequestAlertState extends State<RequestAlert> {
  final homeController = Modular.get<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.12,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.30,
            height: MediaQuery.of(context).size.height * 0.1,
            child: TableInvite(),
          ),
          Expanded(
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('groups')
                  .where('seller_id', isEqualTo: homeController.sellerId)
                  .orderBy('created_at', descending: false)
                  .snapshots(),
              builder: (context, groupsSnap) {
                List<dynamic> groupsList = new List();
                groupsSnap.data.documents.forEach((group) {
                  if (group.data['status'] == 'queue' ||
                      group.data['status'] == 'requested') {
                    groupsList.add(group.data);
                  }
                });
                if (groupsList.length == 0) {
                  return Center(
                    child: Text('Nenhuma mesa ainda'),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: groupsList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var ds = groupsList[index];
                      return RequestTableAlerts(
                        avatar: ds['avatar'],
                        onTap: () {
                          Modular.to.pushNamed(
                            '/open-table/bill-request',
                            arguments: ds['id'],
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
