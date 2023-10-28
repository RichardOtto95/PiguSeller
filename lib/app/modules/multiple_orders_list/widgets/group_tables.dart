import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/app/modules/multiple_orders_list/widgets/tables.dart';
import 'package:pigu_seller/app/modules/open_table/widgets/empty_state.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class GroupTables extends StatelessWidget {
  final groupID;

  GroupTables({Key key, this.groupID}) : super(key: key);
  final homeController = Modular.get<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 47,
        leading: IconButton(
          icon: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.arrow_back,
                color: ColorTheme.white,
              )
            ],
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        toolbarHeight: 110,
        backgroundColor: ColorTheme.primaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 8,
            ),
            Text(
              "Mesas",
              style: TextStyle(
                fontSize: 16,
                color: ColorTheme.white,
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              "Desta conta",
              style: TextStyle(
                fontSize: 30,
                color: ColorTheme.white,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: Firestore.instance
              .collection('groups')
              .document(groupID)
              .collection('tables')
              .getDocuments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return new Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else {
                if (snapshot.hasData) {
                  if (snapshot.data.documents.isEmpty) {
                    return Center(
                        child: EmptyStateList(
                      image: 'assets/img/empty_list.png',
                      title: 'Sem messas',
                      description: 'Não existem mesas para essa conta',
                    ));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.documents[index];

                        return Tables(
                          label: ds.data['label'],
                        );
                      },
                    );
                  }
                } else
                  return Container();
              }
            }
          },
        ),
      ),
    );
  }
}
