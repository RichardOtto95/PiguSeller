import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/app/modules/open_table/widgets/empty_state.dart';
import 'package:pigu_seller/app/modules/staff_list/widgets/staff.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'staff_list_controller.dart';

class StaffListPage extends StatefulWidget {
  final String title;
  const StaffListPage({Key key, this.title = "StaffList"}) : super(key: key);

  @override
  _StaffListPageState createState() => _StaffListPageState();
}

double wXD(double size, BuildContext context) {
  double finalSize = MediaQuery.of(context).size.width * size / 375;
  return finalSize;
}

class _StaffListPageState
    extends ModularState<StaffListPage, StaffListController> {
  final homeController = Modular.get<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.white,
      appBar: AppBar(
        backgroundColor: ColorTheme.primaryColor,
        title: Text(
          "Colaboradores",
          style: TextStyle(
              fontFamily: "Roboto", fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: AnimatedContainer(
                  height: wXD(670, context),
                  color: ColorTheme.white,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('teams')
                        .where('seller_id', isEqualTo: homeController.sellerId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                ColorTheme.primaryColor),
                          ),
                        );
                      } else if (snapshot.connectionState ==
                              ConnectionState.done ||
                          snapshot.connectionState == ConnectionState.active) {
                        return snapshot.data.documents.length == null ||
                                snapshot.data.documents.length == 0
                            ? EmptyStateList(
                                image: 'assets/img/empty_list.png',
                                title: 'Sem colaboradores no momento',
                                description:
                                    'Não existem colaboradores para serem listados',
                              )
                            : ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot ds =
                                      snapshot.data.documents[index];
                                  if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  }

                                  String role = 'Empregado';

                                  if (ds.data['role'] == 'admin') {
                                    role = 'Gerente';
                                  }

                                  return Contributor(
                                    ds: ds,
                                    role: role,
                                  );
                                },
                              );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
