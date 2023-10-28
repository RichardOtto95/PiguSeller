import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/app/modules/open_table/widgets/request_table_alerts.dart';
import 'package:pigu_seller/app/modules/open_table/widgets/table_invite_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AccountRequestAlert extends StatefulWidget {
  @override
  _AccountRequestAlertState createState() => _AccountRequestAlertState();
}

class _AccountRequestAlertState extends State<AccountRequestAlert> {
  final homeController = Modular.get<HomeController>();

  Future<dynamic> tablesRequestFuture;
  List<dynamic> requestTables = new List();

  @override
  void initState() {
    tablesRequestFuture = getTablesRequest();
    super.initState();
  }

  Future<dynamic> getTablesRequest() async {
    QuerySnapshot _groups = await Firestore.instance
        .collection('groups')
        .where('seller_id', isEqualTo: homeController.sellerId)
        .orderBy('created_at', descending: false)
        .getDocuments();

    _groups.documents.forEach((element) {
      if (element.data['status'] == 'requested' ||
          element.data['status'] == 'queue') {
        requestTables.add(element.data);
      }
    });
    return requestTables;
  }

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
            child: FutureBuilder(
              future: tablesRequestFuture,
              builder: (context, groupsSnap) {
                switch (groupsSnap.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                    break;
                  case ConnectionState.done:
                    if (requestTables.isEmpty) {
                      return Center(
                        child: Text('Nenhuma mesa ainda'),
                      );
                    } else {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: requestTables.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var ds = groupsSnap.data[index];
                          return RequestTableAlerts(
                            avatar: ds['avatar'],
                            onTap: () {
                              Modular.to.pushNamed('/open-table/bill-request',
                                  arguments: ds['id']);
                            },
                          );
                        },
                      );
                    }
                    break;
                  default:
                    return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
