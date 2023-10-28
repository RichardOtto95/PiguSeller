import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class GroupTable extends StatefulWidget {
  final groupID;

  GroupTable({
    Key key,
    this.groupID,
  }) : super(key: key);
  @override
  _GroupTableState createState() => _GroupTableState();
}

class _GroupTableState extends State<GroupTable> {
// class GroupTable extends StatelessWidget {
  List tablesID = [];
  List tableUsed = [];

  @override
  void initState() {
    getTables();
    super.initState();
  }

  final homeController = Modular.get<HomeController>();
  // Map<String, bool> tableSelected = Map();
  // bool click = false;

  double wXD(double size, BuildContext context) {
    double finalValue = MediaQuery.of(context).size.width * size / 375;
    return finalValue;
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    Size size = MediaQuery.of(context).size;
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
        toolbarHeight: size.height * .157,
        backgroundColor: ColorTheme.primaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * .01,
            ),
            Text(
              "Mesas",
              style: TextStyle(
                fontSize: size.width * .04,
                color: ColorTheme.white,
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              "Desta conta",
              style: TextStyle(
                fontSize: size.width * .075,
                color: ColorTheme.white,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FutureBuilder(
                future: Firestore.instance
                    .collection('groups')
                    .document(widget.groupID)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Center(
                      child: Text('Nenhuma mesa ainda'),
                    );
                  }
                  DocumentSnapshot ds = snapshot.data;

                  return FutureBuilder(
                    future: Firestore.instance
                        .collection('tables')
                        .where('seller_id', isEqualTo: ds.data['seller_id'])
                        .getDocuments(),
                    builder: (context, snapshotTables) {
                      if (snapshotTables.hasError) {
                        return Center(
                          child: Text('Error: ${snapshotTables.error}'),
                        );
                      }

                      if (snapshotTables.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (!snapshotTables.hasData) {
                        return Center(
                          child: Text('Nenhuma mesa ainda'),
                        );
                      }

                      return ListView.builder(
                        itemCount: snapshotTables.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot dss =
                              snapshotTables.data.documents[index];

                          String status = 'Disponível';
                          Color color = Color.fromRGBO(250, 250, 250, 1);
                          bool verification =
                              tableUsed.contains(dss.data['id']);
                          // if (!tablesID.contains(dss.data['id'])) {
                          if (dss.data['status'] != 'open' &&
                              verification == false) {
                            color = Color(0xffDADCDC);
                            status = 'Ocupada';
                          }
                          // } else {
                          //   tableSelected.putIfAbsent(
                          //       dss.data['id'], () => true);
                          //   click = true;
                          // }

                          return Table(
                            onTap: () {
                              setState(() {
                                onTapp(dss);
                              });
                            },
                            status: status,
                            title: dss.data['label'],
                            color: color,
                            date: now,
                            check: tablesID.contains(dss.data['id']),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            // click
            //     ?
            InkWell(
              onTap: () {
                homeController.changeTables(
                    tables: tablesID, groupID: widget.groupID);
                Modular.to.pop();
              },
              child: Container(
                height: wXD(60, context),
                width: double.infinity,
                color: ColorTheme.primaryColor,
                alignment: Alignment.center,
                child: Text(
                  "Concluir alteração de mesas",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: wXD(16, context),
                      fontWeight: FontWeight.bold,
                      color: ColorTheme.white),
                ),
              ),
            )
            // : Container(),
          ],
        ),
      ),
    );
  }

  getTables() {
    Firestore.instance
        .collection('groups')
        .document(widget.groupID)
        .collection('tables')
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        tablesID.add(element.data['table_id']);
        tableUsed.add(element.data['table_id']);
        // tableSelected.putIfAbsent(element.data['table_id'], () => true);
      });
    });
  }

  onTapp(DocumentSnapshot doc) async {
    if (tablesID.contains(doc['id'])) {
      tablesID.remove(doc['id']);
    } else {
      tablesID.add(doc['id']);
    }
    // tableSelected.containsKey(doc['id'])
    //     ? tableSelected.remove(doc['id'])
    //     : tableSelected.putIfAbsent(doc['id'], () => true);

    // tableSelected.containsValue(true) ? click = true : click = false;
  }
}

class Table extends StatelessWidget {
  final String status;
  final DateTime date;
  final String title;
  final Function onTap;
  final bool check;
  final Color color;
  // final bool closed;
  const Table({
    Key key,
    this.onTap,
    this.title = 'Nome da mesa',
    this.date,
    this.check = false,
    this.color,
    this.status,

    // this.closed
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
      child: Container(
        height: MediaQuery.of(context).size.height * .07,
        width: MediaQuery.of(context).size.width,
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
              width: MediaQuery.of(context).size.height * .025,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    "$title",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.025,
                        color: ColorTheme.textColor,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Row(
                //   children: [
                //     SizedBox(
                //       width: MediaQuery.of(context).size.height * 0.025,
                //     ),
                //     Text(
                //       '${DateFormat(DateFormat.MONTH_WEEKDAY_DAY, 'pt_Br').format(date)} ${DateFormat(DateFormat.HOUR_MINUTE, 'pt_Br').format(date)}',
                //       style: TextStyle(
                //         fontSize: MediaQuery.of(context).size.height * 0.025,
                //         color: ColorTheme.textGray,
                //       ),
                //     ),
                //   ],
                // )
              ],
            ),
            // Container(
            //   width: MediaQuery.of(context).size.width * 0.2,
            //   child: Text(
            //     "$status",
            //     style: TextStyle(
            //         fontSize: MediaQuery.of(context).size.height * 0.025,
            //         color: ColorTheme.textColor.withOpacity(.5),
            //         fontWeight: FontWeight.bold),
            //     overflow: TextOverflow.ellipsis,
            //   ),
            // ),
            Spacer(),
            Visibility(
              visible: status == 'Disponível',
              child: InkWell(
                  onTap: onTap,
                  child: check
                      ? Image.asset('assets/icon/addSelected.png')
                      : Image.asset('assets/icon/addPeople.png')),
            ),
            SizedBox(width: 10)
          ],
        ),
      ),
    );
  }
}
