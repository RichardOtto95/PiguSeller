import 'package:pigu_seller/app/modules/multiple_orders_list/multiple_orders_list_controller.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class OrderRequestPage extends StatefulWidget {
  final order;

  const OrderRequestPage({Key key, this.order}) : super(key: key);
  @override
  _OrderRequestPageState createState() => _OrderRequestPageState();
}

class _OrderRequestPageState extends State<OrderRequestPage> {
  final controller = Modular.get<MultipleOrdersListController>();

  String code = '';
  String group;
  Timestamp date;
  String status;
  bool loading = false;
  QuerySnapshot membs;

  @override
  void initState() {
    loading = false;

    code = widget.order.substring(0, 6).toUpperCase();
    getStatus();

    super.initState();
  }

  void dispose() {
    membs = null;
    loading = false;
    code = '';
    super.dispose();
  }

  getStatus() {
    Firestore.instance
        .collection('orders')
        .document(widget.order)
        .get()
        .then((value) {
      setState(() {
        status = value['status'];
        group = value['group_id'];
        date = value['created_at'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    double wXD(double size, BuildContext context) {
      double finalSize = MediaQuery.of(context).size.width * size / 375;
      return finalSize;
    }

    return StreamBuilder(
      stream: Firestore.instance
          .collection('orders')
          .document(widget.order)
          .collection('cart_item')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          var ds = snapshot.data.documents[0].data;
          return Scaffold(
            appBar: AppBar(
                leadingWidth: wXD(47, context),
                leading: IconButton(
                  icon: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: ColorTheme.white,
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    dispose();
                  },
                ),
                toolbarHeight: wXD(110, context),
                backgroundColor: ColorTheme.primaryColor,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Atualizar",
                      style: TextStyle(
                        fontSize: wXD(16, context),
                        color: ColorTheme.white,
                      ),
                    ),
                    SizedBox(
                      height: wXD(3, context),
                    ),
                    Text(
                      "Pedido",
                      style: TextStyle(
                        fontSize: wXD(30, context),
                        color: ColorTheme.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                )),
            body: SafeArea(
              child: Stack(
                children: [
                  ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: wXD(20, context),
                            vertical: wXD(15, context)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(bottom: wXD(8, context)),
                              alignment: Alignment.topLeft,
                              child: Text(
                                '${DateFormat(DateFormat.ABBR_WEEKDAY, 'pt_Br').format(ds['created_at'].toDate())}, ${ds['created_at'].toDate().hour.toString().padLeft(2, '0')}:${ds['created_at'].toDate().minute.toString().padLeft(2, '0')}',
                                // '',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: ColorTheme.textGray,
                                  fontSize: wXD(14, context),
                                ),
                              ),
                            ),
                            StreamBuilder(
                                stream: Firestore.instance
                                    .collection('groups')
                                    .document(group)
                                    .snapshots(),
                                builder: (context, snapshotGroup) {
                                  if (!snapshotGroup.hasData)
                                    return Container();
                                  return Container(
                                    child: Text(
                                      'Mesa ${snapshotGroup.data['label']}  / Comanda $code',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: ColorTheme.textColor,
                                          fontSize: wXD(16, context),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                }),
                            StreamBuilder(
                                stream: Firestore.instance
                                    .collection('listings')
                                    .document(ds['listing_id'])
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container();
                                  } else {
                                    return Container(
                                      padding: EdgeInsets.only(
                                          top: wXD(10, context),
                                          right: wXD(8, context)),
                                      width: wXD(330, context),
                                      child: Text(
                                        '${snapshot.data['label']} X ${ds['ordered_amount'].toInt()}',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: ColorTheme.textColor,
                                          fontSize: wXD(16, context),
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    );
                                  }
                                }),
                            Container(
                              padding: EdgeInsets.only(
                                  top: wXD(10, context),
                                  bottom: wXD(8, context)),
                              child: Text(
                                  ds['description'] == null
                                      ? 'Item sem descriçao'
                                      : ds['description'],
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: ColorTheme.textColor,
                                    fontSize: wXD(16, context),
                                    fontWeight: FontWeight.w300,
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: wXD(13, context)),
                              child: Text('Observação do cliente:',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: ColorTheme.textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: wXD(16, context),
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  top: wXD(13, context),
                                  bottom: wXD(3, context)),
                              child: Text(
                                  ds['note'] == null || ds['note'] == ''
                                      ? "Sem Observaçao"
                                      : ds['note'],
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: ColorTheme.textGray,
                                    fontSize: wXD(16, context),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width,
                          height: wXD(50, context),
                          padding: EdgeInsets.symmetric(
                              horizontal: wXD(20, context)),
                          color: Color(0xffDADCDC),
                          child: Text(
                            'Observação opcional para o cliente:',
                            style: TextStyle(
                              color: ColorTheme.textColor,
                              fontSize: wXD(16, context),
                              fontWeight: FontWeight.w300,
                            ),
                          )),
                      Container(
                        padding: EdgeInsets.fromLTRB(wXD(20, context), 0,
                            wXD(20, context), wXD(30, context)),
                        child: TextFormField(
                            onChanged: controller.setText,
                            decoration: InputDecoration(
                                labelText:
                                    "Digite aqui sua mensagem para o cliente...",
                                labelStyle: TextStyle(
                                  fontSize: wXD(16, context),
                                  fontWeight: FontWeight.w200,
                                ))),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              controller.setRefuseDialog(true);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: wXD(61, context),
                              width: wXD(142, context),
                              decoration: BoxDecoration(
                                color: ColorTheme.white,
                                border:
                                    Border.all(color: ColorTheme.primaryColor),
                                borderRadius: BorderRadius.circular(21),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0x29000000),
                                    offset: Offset(0, 3),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Text(
                                status == "order_accepted"
                                    ? "Cancelar"
                                    : "Recusar",
                                style: TextStyle(
                                    fontSize: wXD(16, context),
                                    fontWeight: FontWeight.w400,
                                    color: ColorTheme.textColor),
                              ),
                            ),
                          ),
                          StreamBuilder(
                              stream: Firestore.instance
                                  .collection('groups')
                                  .document(group)
                                  .collection('members')
                                  .snapshots(),
                              builder: (context, snapshotMemb) {
                                if (!snapshotMemb.hasData) return Container();
                                membs = snapshot.data;
                                return InkWell(
                                  borderRadius: BorderRadius.circular(21),
                                  onTap: () {
                                    controller.setAcceptDialog(true);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: wXD(61, context),
                                    width: wXD(142, context),
                                    decoration: BoxDecoration(
                                      color: ColorTheme.primaryColor,
                                      borderRadius: BorderRadius.circular(21),
                                      border: Border.all(
                                          color: ColorTheme.primaryColor),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0x29000000),
                                          offset: Offset(0, 3),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      status == "order_accepted"
                                          ? "Entregar"
                                          : "Aceitar",
                                      style: TextStyle(
                                          fontSize: wXD(16, context),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                );
                              })
                        ],
                      ),
                      SizedBox(
                        height: wXD(50, context),
                      )
                    ],
                  ),
                  Observer(
                    builder: (context) {
                      return Visibility(
                        visible: controller.acceptDialog,
                        child: AnimatedContainer(
                          height: maxHeight,
                          width: maxWidth,
                          color: !controller.acceptDialog
                              ? Colors.transparent
                              : Color(0x50000000),
                          duration: Duration(milliseconds: 300),
                          curve: Curves.decelerate,
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.only(top: wXD(5, context)),
                              height: wXD(153, context),
                              width: wXD(324, context),
                              decoration: BoxDecoration(
                                  color: Color(0xfffafafa),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(33))),
                              child: Column(
                                children: [
                                  Container(
                                    width: wXD(240, context),
                                    margin:
                                        EdgeInsets.only(top: wXD(15, context)),
                                    child: Text(
                                      status == "order_accepted"
                                          ? '''Tem certeza que deseja entregar este pedido?'''
                                          : '''Tem certeza que deseja aceitar este pedido?''',
                                      style: TextStyle(
                                        fontSize: wXD(15, context),
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xfa707070),
                                      ),
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  loading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  ColorTheme.yellow),
                                        ))
                                      : Row(
                                          children: [
                                            Spacer(),
                                            InkWell(
                                              onTap: () async {
                                                // setState(() {
                                                //   loading = true;
                                                // });
                                                controller
                                                    .setAcceptDialog(false);
                                              },
                                              child: Container(
                                                height: wXD(47, context),
                                                width: wXD(98, context),
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          offset: Offset(0, 3),
                                                          blurRadius: 3,
                                                          color:
                                                              Color(0x28000000))
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                17)),
                                                    border: Border.all(
                                                        color:
                                                            Color(0x80707070)),
                                                    color: Color(0xfffafafa)),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Não',
                                                  style: TextStyle(
                                                      color: ColorTheme
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          wXD(16, context)),
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            InkWell(
                                              onTap: () async {
                                                setState(() {
                                                  loading = true;
                                                });

                                                await controller.setStatus(
                                                    status, widget.order);

                                                membs.documents
                                                    .forEach((element) async {
                                                  QuerySnapshot myGroup =
                                                      await Firestore
                                                          .instance
                                                          .collection('users')
                                                          .document(element
                                                              .data['user_id'])
                                                          .collection(
                                                              'my_group')
                                                          .where('id',
                                                              isEqualTo: element
                                                                      .data[
                                                                  'group_id'])
                                                          .getDocuments();

                                                  myGroup.documents
                                                      .forEach((element) async {
                                                    num eventCounter =
                                                        await element.data[
                                                            'event_counter'];
                                                    eventCounter++;

                                                    element.reference
                                                        .updateData({
                                                      'event_counter':
                                                          eventCounter
                                                    });
                                                  });
                                                });
                                                controller
                                                    .setAcceptDialog(false);
                                                // loading = false;
                                                // setState(() {});
                                              },
                                              child: Container(
                                                height: wXD(47, context),
                                                width: wXD(98, context),
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          offset: Offset(0, 3),
                                                          blurRadius: 3,
                                                          color:
                                                              Color(0x28000000))
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                17)),
                                                    border: Border.all(
                                                        color:
                                                            Color(0x80707070)),
                                                    color: Color(0xfffafafa)),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Sim',
                                                  style: TextStyle(
                                                      color: ColorTheme
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          wXD(16, context)),
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                  Spacer(
                                    flex: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Observer(
                    builder: (context) {
                      return Visibility(
                        visible: controller.refuseDialog,
                        child: AnimatedContainer(
                          height: maxHeight,
                          width: maxWidth,
                          color: !controller.refuseDialog
                              ? Colors.transparent
                              : Color(0x50000000),
                          duration: Duration(milliseconds: 300),
                          curve: Curves.decelerate,
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.only(top: wXD(5, context)),
                              height: wXD(153, context),
                              width: wXD(324, context),
                              decoration: BoxDecoration(
                                  color: Color(0xfffafafa),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(33))),
                              child: Column(
                                children: [
                                  Container(
                                    width: wXD(240, context),
                                    margin:
                                        EdgeInsets.only(top: wXD(15, context)),
                                    child: Text(
                                      status == "order_accepted"
                                          ? '''Tem certeza que deseja cancelar este pedido?'''
                                          : '''Tem certeza que deseja recusar este pedido?''',
                                      style: TextStyle(
                                        fontSize: wXD(15, context),
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xfa707070),
                                      ),
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  loading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  ColorTheme.yellow),
                                        ))
                                      : Row(
                                          children: [
                                            Spacer(),
                                            InkWell(
                                              onTap: () {
                                                controller
                                                    .setRefuseDialog(false);
                                              },
                                              child: Container(
                                                height: wXD(47, context),
                                                width: wXD(98, context),
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          offset: Offset(0, 3),
                                                          blurRadius: 3,
                                                          color:
                                                              Color(0x28000000))
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                17)),
                                                    border: Border.all(
                                                        color:
                                                            Color(0x80707070)),
                                                    color: Color(0xfffafafa)),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Não',
                                                  style: TextStyle(
                                                      color: ColorTheme
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          wXD(16, context)),
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            InkWell(
                                              onTap: () async {
                                                setState(() {
                                                  loading = true;
                                                });

                                                await controller.unsetStatus(
                                                    status, widget.order);
                                                controller
                                                    .setRefuseDialog(false);
                                              },
                                              child: Container(
                                                height: wXD(47, context),
                                                width: wXD(98, context),
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          offset: Offset(0, 3),
                                                          blurRadius: 3,
                                                          color:
                                                              Color(0x28000000))
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                17)),
                                                    border: Border.all(
                                                        color:
                                                            Color(0x80707070)),
                                                    color: Color(0xfffafafa)),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Sim',
                                                  style: TextStyle(
                                                      color: ColorTheme
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          wXD(16, context)),
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                  Spacer(
                                    flex: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
