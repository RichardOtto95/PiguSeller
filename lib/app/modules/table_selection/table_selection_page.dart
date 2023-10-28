import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/app/modules/user_profile/user_profile_page.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:pigu_seller/shared/navbar.dart';
import 'package:pigu_seller/shared/widgets/empty_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class TableSelectionPage extends StatefulWidget {
  @override
  _TableSelectionPageState createState() => _TableSelectionPageState();
}

class _TableSelectionPageState extends State<TableSelectionPage> {
  double wXD(double size, BuildContext context) {
    double finalValue = MediaQuery.of(context).size.width * size / 375;
    return finalValue;
  }

  final homeController = Modular.get<HomeController>();

  // Map<String, bool> tableSelected = Map();
  List tableSelect = [];
  // DateTime now = DateTime.now();
  int part;
  bool click = false;
  QuerySnapshot tables;
  String sellerId;
  @override
  void initState() {
    // getGroupSeller();

    super.initState();
  }

  @override
  void dispose() {
    homeController.setRouterBillRequested(false);
    cleanInvited();
    super.dispose();
  }

  cleanInvited() {
    Firestore.instance
        .collection('tables')
        .where('seller_id', isEqualTo: sellerId)
        .getDocuments()
        .then((value) {
      for (var i = 0; i <= value.documents.length; i++) {
        if (value.documents[i].data['invited'] != null) {
          value.documents[i].reference.updateData({'invited': false});
        }
      }
    });
  }

  // getGroupSeller() async {
  //   FirebaseUser user = await FirebaseAuth.instance.currentUser();
  //   var userRef = await Firestore.instance
  //       .collection('users')
  //       .where('id', isEqualTo: user.uid)
  //       .getDocuments();
  //   print('userRefuserRefuserRefuserRef  :${userRef.documents.first.data}');
  //   print('user.uiduser.uiduser.uid  :${user.uid}');
  //   homeController.setSellerId(userRef.documents.first.data['seller_id']);
  //   setState(() {
  //     sellerId = userRef.documents.first.data['seller_id'];
  //   });
  //   print(
  //       'homeController.sellerIdhomeController.sellerId  :${homeController.sellerId}');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NavBar(
                    title: "Listagem de Mesas",
                    backPage: () {
                      Modular.to.pop();
                    },
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.04,
                            ),
                            InkWell(
                              highlightColor: Colors.transparent,
                              splashColor:
                                  ColorTheme.primaryColor.withOpacity(.4),
                              borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(90)),
                              onTap: () {
                                // Firestore.instance.collection('tables').add({
                                //   'id': '',
                                //   'label': 'Mesa',
                                //   'seller_id': homeController.sellerId,
                                //   'seller_name': '',
                                //   'status': 'open',
                                //   'created_at': Timestamp.now(),
                                // });
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                  right: wXD(10, context),
                                ),
                                alignment: Alignment.centerRight,
                                height: wXD(120, context),
                                width: wXD(60, context),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: ColorTheme.primaryColor),
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(90),
                                        topRight: Radius.circular(90))),
                                child: Image.asset(
                                  "assets/icon/notify.png",
                                  height: wXD(40, context),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Text(
                              'Mesas',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: wXD(36, context),
                                color: ColorTheme.darkCyanBlue,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.end,
                            ),
                            Text(
                              'desta conta',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: wXD(36, context),
                                color: ColorTheme.darkCyanBlue,
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            homeController.routerBillRequested
                                ? Row(
                                    children: [
                                      Text(
                                        "${tableSelect.length}",
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: wXD(16, context),
                                          color: ColorTheme.textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: wXD(8, context)),
                                      Text(
                                        'Mesas selecionadas',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: wXD(16, context),
                                          color: ColorTheme.textColor,
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: ColorTheme.textGray,
                    margin: EdgeInsets.only(
                      bottom: wXD(16, context),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: wXD(20, context)),
                    child: Text("Todas as mesas:",
                        style: TextStyle(fontSize: wXD(16, context))),
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: Firestore.instance
                          .collection("tables")
                          .where("seller_id",
                              isEqualTo: homeController.sellerId)
                          .orderBy('created_at', descending: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.data.documents.isEmpty ||
                            snapshot.data.documents == null ||
                            snapshot.data.documents.length == 0) {
                          return EmptyStateList(
                            image: 'assets/img/empty_list.png',
                            title: 'Sem mesas cadastradas no banco',
                            description:
                                'Não existem mesas cadastradas no banco para serem listadas',
                          );
                        }
                        // print(
                        //     'dsdsDAAAAAAAAATAAAAAAAAAAAAAAdsdsdsds   :${snapshot.data.documents.first.data}');

                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            DocumentSnapshot dss =
                                snapshot.data.documents[index];

                            // print(
                            //     'dssdssdssdssdssdssdssdssdssdss   :${dss.data}');

                            // if (snapshot.data.documents.length == 0 ||
                            //     snapshot.data.documents.length == null) {
                            //   return EmptyStateList(
                            //     image: 'assets/img/empty_list.png',
                            //     title: 'Sem contas Em Andamento',
                            //     description:
                            //         'Não existem contas em andamento para serem listadas',
                            //   );
                            // } else {
                            String status = 'Disponível';
                            Color color = Color.fromRGBO(250, 250, 250, 1);
                            if (dss.data['status'] != 'open') {
                              color = Color(0xffDADCDC);
                              status = 'Ocupada';
                            }
                            return Table(
                              status: status,
                              color: color,
                              closed: status == 'Ocupada',
                              onTap: () {
                                setState(() {
                                  onTapp(dss);
                                });
                              },
                              check: tableSelect.contains(dss['id']),
                              title: dss.data['label'],
                              // date: now,9
                              date: dss.data['created_at'].toDate(),
                            );
                            // }
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            click && homeController.routerBillRequested
                ? InkWell(
                    onTap: () {
                      // List tables = [];
                      // tableSelect.forEach((element) {
                      //   tables.add(element);
                      // });
                      homeController.setArrayTables(tableSelect);
                      Modular.to.pop();
                    },
                    child: Container(
                      height: wXD(60, context),
                      width: double.infinity,
                      color: ColorTheme.primaryColor,
                      alignment: Alignment.center,
                      child: Text(
                        "Concluir seleção de mesas",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: wXD(16, context),
                            fontWeight: FontWeight.bold,
                            color: ColorTheme.white),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  onTapp(DocumentSnapshot doc) async {
    print('tableSelect>>>>>>>>>>>>>>>>>>>> $tableSelect');
    tableSelect.contains(doc['id'])
        ? tableSelect.remove(doc['id'])
        : tableSelect.add(doc['id']);

    // tableSelect.contains(doc['id']) ? click = true : click = false;
    tableSelect.isNotEmpty ? click = true : click = false;

    // if (doc['invited'] == null) {
    //   await doc.reference.updateData({'invited': true});
    // } else {
    //   doc.reference.updateData({'invited': !doc['invited']});
    // }
  }
}

class Table extends StatelessWidget {
  final DateTime date;
  final String title;
  final String status;
  final Function onTap;
  final bool check;
  final Color color;
  final bool closed;
  const Table(
      {Key key,
      this.onTap,
      this.title = 'Nome da mesa',
      this.date,
      this.check = false,
      this.color,
      this.closed,
      this.status = 'Livre'})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final homeController = Modular.get<HomeController>();

    return Padding(
      padding: EdgeInsets.fromLTRB(
          wXD(20, context), wXD(15, context), wXD(20, context), 0),
      child: Container(
        height: wXD(45, context),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffdadcdc)),
          color: color,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(25),
              topRight: Radius.circular(25)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: wXD(20, context),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    "$title",
                    style: TextStyle(
                        fontSize: wXD(16, context),
                        color: ColorTheme.textColor,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Row(
                //   children: [
                //     SizedBox(width: wXD(20, context)),
                //     Text(
                //       ' ${DateFormat(DateFormat.NUM_MONTH_DAY, 'pt_Br').format(date)} ${DateFormat(DateFormat.HOUR_MINUTE, 'pt_Br').format(date)}',
                //       style: TextStyle(
                //         fontSize: wXD(16, context),
                //         color: ColorTheme.textGray,
                //       ),
                //     ),
                //   ],
                // )
              ],
            ),
            Spacer(),
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Text(
                "$status",
                style: TextStyle(
                    fontSize: wXD(13, context),
                    color: ColorTheme.textColor.withOpacity(.5),
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Spacer(),
            Visibility(
              visible: !closed && homeController.routerBillRequested,
              // visible: homeController.routerBill,
              child: InkWell(
                  onTap: onTap,
                  child: check
                      ? Image.asset('assets/icon/addSelected.png')
                      : Image.asset('assets/icon/addPeople.png')),
            ),
            SizedBox(width: wXD(10, context))
          ],
        ),
      ),
    );
  }
}
