import 'package:pigu_seller/app/modules/bill_detail/widgets/user_account.dart';
import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/app/modules/open_table/open_table_controller.dart';
import 'package:pigu_seller/app/modules/staff_list/staff_list_page.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class BillDetailPage extends StatefulWidget {
  final groupId;

  const BillDetailPage({
    Key key,
    this.groupId,
  }) : super(key: key);
  @override
  _BillDetailPageState createState() => _BillDetailPageState();
}

class _BillDetailPageState extends State<BillDetailPage> {
  final openTableController = Modular.get<OpenTableController>();
  final homeController = Modular.get<HomeController>();
  double totalGroup = 0;
  int ordersheets = 0;

  @override
  void initState() {
    openTableController.setOrdersheetsNull();
    getTotalOpenOrders();
    super.initState();
  }

  @override
  void dispose() {
    openTableController.setOrdersheetsNull();
    openTableController.setTotalValueGroupNull();

    super.dispose();
  }

  getTotalOpenOrders() async {
    // num count = 0;
    QuerySnapshot orderSheets = await Firestore.instance
        .collection('order_sheets')
        .where('group_id', isEqualTo: widget.groupId)
        // .where('status', isEqualTo: 'opened')
        .getDocuments();

    // openTableController.setOrdersheets(orderSheets.documents.length);

    orderSheets.documents.forEach((sheet) async {
      if (sheet.data['status'] == 'opened' ||
          sheet.data['status'] == 'awaiting_checkout') {
        openTableController.setOrdersheets(1);
        QuerySnapshot orders =
            await sheet.reference.collection('orders').getDocuments();

        orders.documents.forEach((order) {
          if (order.data['item_status'] == 'created' ||
              order.data['item_status'] == 'created_shared') {
            openTableController.setTotalValueGroup(order.data['ordered_value']);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        openTableController.setTotalValueGroupNull();
        openTableController.setOrdersheetsNull();
      },
      child: StreamBuilder(
          stream: Firestore.instance
              .collection('groups')
              .document(widget.groupId)
              .snapshots(),
          builder: (context, group) {
            if (group.hasError) {
              return Center(
                child: Text('Error: ${group.error}'),
              );
            }

            if (group.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!group.hasData) {
              return Center(
                child: Text('Nenhuma mesa ainda'),
              );
            }
            DocumentSnapshot ds = group.data;
            AppBar appBar = AppBar(
                leadingWidth: wXD(47, context),
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
                  onPressed: () {
                    Navigator.of(context).pop();
                    openTableController.setTotalValueGroupNull();
                    openTableController.setOrdersheetsNull();

                    // openTableController.totalValue = 0;
                    // openTableController.qtdMembers = 0;
                  },
                ),
                toolbarHeight: MediaQuery.of(context).size.height * .15,
                backgroundColor: ColorTheme.primaryColor,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Detalhes da Conta",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * .025,
                          color: ColorTheme.white),
                    ),
                    SizedBox(
                      height: wXD(5, context),
                    ),
                    Text(
                      "${ds.documentID.substring(0, 5).toUpperCase()}",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * .045,
                          fontWeight: FontWeight.bold,
                          color: ColorTheme.white),
                    )
                  ],
                ));
            Size size = MediaQuery.of(context).size;
            var screenHeight = (size.height - appBar.preferredSize.height) -
                MediaQuery.of(context).padding.top;
            return Observer(builder: (_) {
              return Scaffold(
                appBar: appBar,
                body: StreamBuilder(
                    stream: Firestore.instance
                        .collection('groups')
                        .document(widget.groupId)
                        .collection('members')
                        .snapshots(),
                    builder: (context, members) {
                      if (members.hasError) {
                        return Center(
                          child: Text('Error: ${members.error}'),
                        );
                      }

                      if (members.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (!members.hasData) {
                        return Center(
                          child: Text('Nenhuma mesa ainda'),
                        );
                      }
                      openTableController.getOpenSheets(members.data);

                      return Observer(
                        builder: (_) {
                          return Column(
                            children: [
                              Center(
                                child: Container(
                                  height: screenHeight * .85,
                                  width: size.width * .9,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: screenHeight * .025,
                                      ),
                                      Text("Listagem de comandas:"),
                                      Container(
                                        width: size.width,
                                        height: screenHeight * .63,
                                        child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount:
                                              members.data.documents.length,
                                          itemBuilder: (context, index) {
                                            DocumentSnapshot ds =
                                                members.data.documents[index];
                                            if (ds['role'] == 'created' ||
                                                ds['role'] ==
                                                    'accepted_invite') {
                                              return UserAccount(
                                                  host: ds['role'] == 'created',
                                                  pagou: ds['role'] == 'paid',
                                                  onTap: () {
                                                    Modular.to.pushNamed(
                                                        '/open-table/order-pad',
                                                        arguments: ds);
                                                  },
                                                  name: ds.data['username'],
                                                  groupId: ds.data['group_id'],
                                                  userId: ds.data['user_id']);
                                            } else {
                                              return Container();
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: screenHeight * .05,
                                      ),
                                      //   // ItemOrderCommission(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Modular.to.pushNamed(
                                                  'open-table/group-table',
                                                  arguments: widget.groupId);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/icon/menuOpen.png',
                                                  height: screenHeight * .07,
                                                  fit: BoxFit.contain,
                                                ),
                                                SizedBox(
                                                  width: size.width * .01,
                                                ),
                                                Text(
                                                  'Listar',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: size.width * .04,
                                                    color: ColorTheme.textColor,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  width: size.width * .01,
                                                ),
                                                Text(
                                                  'mesas',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: size.width * .04,
                                                    color: ColorTheme.textColor,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: screenHeight * .04,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: screenHeight * .15,
                                color: Color(0xff2C3E50),
                                child: Column(
                                  children: [
                                    SizedBox(height: screenHeight * .035),
                                    Row(
                                      children: [
                                        SizedBox(width: size.width * .04),
                                        Container(
                                          height: size.width * .091,
                                          width: size.width * .091,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Color(0xfffafafa),
                                          ),
                                          child: Text(
                                            // '${openTableController.qtdMembers}',
                                            '${openTableController.orderShettsAmount}',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: size.width * .04,
                                              color: ColorTheme.brown,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(width: wXD(6, context)),
                                        Text(
                                          'comanda(s) em aberto',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: size.width * .04,
                                            color: Color(0xfffafafa),
                                            fontWeight: FontWeight.w300,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Spacer(),
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: wXD(5, context)),
                                            height: screenHeight * .079,
                                            // width: size.width * .25,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(13),
                                                color: Color(0xff2C3E50),
                                                border: Border.all(
                                                    color: Color(0xff95989A))),
                                            child: Observer(
                                              builder: (BuildContext context) {
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'R\$',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize:
                                                            size.width * .04,
                                                        color:
                                                            Color(0xffFAFAFA),
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    SizedBox(
                                                        width: wXD(4, context)),
                                                    Text(
                                                      '${formatedCurrency(openTableController.totalValueGroup)}',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize:
                                                            size.width * .04,
                                                        color:
                                                            Color(0xffFAFAFA),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.visible,
                                                    )
                                                  ],
                                                );
                                              },
                                            )
                                            //   },
                                            // )
                                            ),
                                        SizedBox(width: wXD(14, context)),
                                      ],
                                    ),
                                    SizedBox(height: wXD(7, context)),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }),
              );
            });
          }),
    );
  }
}

String formatedCurrency(var value) {
  var newValue = new NumberFormat("#,##0.00", "pt_BR");
  return newValue.format(value);
}
