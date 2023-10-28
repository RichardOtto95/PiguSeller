import 'package:pigu_seller/app/modules/bill_request/widgets/members.dart';
import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/app/modules/open_table/open_table_controller.dart';
import 'package:pigu_seller/app/modules/staff_list/staff_list_page.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class BillRequestPage extends StatefulWidget {
  final avatar;
  final name;
  final String groupId;
  BillRequestPage({Key key, this.avatar, this.groupId, this.name})
      : super(key: key);
  @override
  _BillRequestPageState createState() => _BillRequestPageState();
}

List listaVazia = [];

class _BillRequestPageState extends State<BillRequestPage> {
  final controller = Modular.get<OpenTableController>();
  final homeController = Modular.get<HomeController>();
  bool loading = false;
  QuerySnapshot membs;
  String status;
  String sellerId;
  bool queuedTable = false;

  @override
  void dispose() {
    membs = null;
    homeController.setArrayTables(listaVazia);
    loading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    AppBar appBar = AppBar(
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
        toolbarHeight: MediaQuery.of(context).size.height * .15,
        backgroundColor: ColorTheme.primaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Solicitação",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * .025,
                  color: ColorTheme.white),
            ),
            Text(
              "Abertura de conta",
              style: TextStyle(
                  // fontSize: 30,
                  fontSize: MediaQuery.of(context).size.height * .045,
                  fontWeight: FontWeight.bold,
                  color: ColorTheme.white),
            )
          ],
        ));
    Size size = MediaQuery.of(context).size;
    var screenHeight = (size.height - appBar.preferredSize.height) -
        MediaQuery.of(context).padding.top;

    return Scaffold(
        backgroundColor: ColorTheme.white,
        appBar: appBar,
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      width: size.width * .85,
                      // color: Colors.red,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(29, 19, 0, 0),
                            child: StreamBuilder(
                              stream: Firestore.instance
                                  .collection('groups')
                                  .document(widget.groupId)
                                  .snapshots(),
                              builder: (context, group) {
                                controller.setId(group.data['id']);
                                controller.setSeller(group.data['seller_id']);
                                controller.setStatusLabel(group.data['status']);
                                if (!group.hasData) {
                                  return Container();
                                } else {
                                  DocumentSnapshot ds = group.data;

                                  // print('ds==============: ${ds.data}');
                                  return Row(
                                    children: [
                                      Container(
                                        width: 30.0,
                                        height: 30.0,
                                        margin: EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(90),
                                          border: Border.all(
                                              width: 3.0,
                                              color: ColorTheme.textGray),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0x29000000),
                                              offset: Offset(0, 3),
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                        child: CircleAvatar(
                                          radius: 85,
                                          backgroundColor: Color(0xfffafafa),
                                          child: CircleAvatar(
                                            backgroundImage: ds['avatar'] !=
                                                    null
                                                ? NetworkImage(ds['avatar'])
                                                : AssetImage(
                                                    'assets/img/defaultUser.png'),
                                            backgroundColor: Colors.white,
                                            // child: ,
                                            radius: 82,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: wXD(247, context),
                                        child: Text(
                                          "${ds['label']}",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: ColorTheme.textColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                0, screenHeight * .033, 0, screenHeight * .035),
                            child: Text("Seus participantes:"),
                          ),
                          Container(
                            height: screenHeight * .52,
                            child: StreamBuilder(
                              stream: Firestore.instance
                                  .collection('groups')
                                  .document(widget.groupId)
                                  .collection('members')
                                  .snapshots(),
                              builder: (context, members) {
                                membs = members.data;
                                if (members.hasError) {
                                  return Center(
                                    child: Text('Error: ${members.error}'),
                                  );
                                }

                                if (members.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (!members.hasData) {
                                  return Center(
                                    child: Text('Nenhuma mesa ainda'),
                                  );
                                }
                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: members.data.documents.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    var ds = members.data.documents[index].data;

                                    if (ds['role'] == 'created' ||
                                        ds['role'] == 'accepted_invite') {
                                      return Members(
                                        name: ds['username'],
                                        hash: ds['user_id'],
                                        number: ds['mobile_phone_number'],
                                        host: ds['inviter_id'] == ds['user_id'],
                                      );
                                    }
                                    return Container();
                                  },
                                );
                              },
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              homeController.setRouterBillRequested(true);
                              Modular.to
                                  .pushNamed('/open-table/table-selection');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icon/menuOpen.png',
                                  height: size.height * .06,
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
                          Container(
                            height: size.height * .04,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  controller.setRefuseDialog(true);
                                  setState(() {});
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: size.height * .09,
                                  width: size.width * .36,
                                  decoration: BoxDecoration(
                                    color: ColorTheme.white,
                                    border: Border.all(
                                        color: ColorTheme.primaryColor),
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
                                    "Recusar",
                                    style: TextStyle(
                                        fontSize: size.width * .04,
                                        fontWeight: FontWeight.w400,
                                        color: ColorTheme.textColor),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: size.width * .12,
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(21),
                                onTap: () async {
                                  controller.setAcceptDialog(true);
                                  setState(() {});
                                  queuedTable = false;
                                  // Modular.to.pop();
                                  // Navigator.of(context).pop();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: size.height * .09,
                                  width: size.width * .36,
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
                                    "Aceitar",
                                    style: TextStyle(
                                        fontSize: size.width * .04,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
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
                        borderRadius: BorderRadius.all(Radius.circular(33))),
                    child: Column(
                      children: [
                        Container(
                          width: wXD(240, context),
                          margin: EdgeInsets.only(top: wXD(15, context)),
                          child: Text(
                            '''Tem certeza que deseja aceitar esta mesa?''',
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
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    ColorTheme.yellow),
                              ))
                            : Row(
                                children: [
                                  Spacer(),
                                  InkWell(
                                    onTap: () async {
                                      controller.setAcceptDialog(false);
                                      setState(() {
                                        loading = true;
                                      });
                                      loading = false;
                                    },
                                    child: Container(
                                      height: wXD(47, context),
                                      width: wXD(98, context),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(0, 3),
                                                blurRadius: 3,
                                                color: Color(0x28000000))
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(17)),
                                          border: Border.all(
                                              color: Color(0x80707070)),
                                          color: Color(0xfffafafa)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Não',
                                        style: TextStyle(
                                            color: ColorTheme.primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: wXD(16, context)),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: () async {
                                      setState(() {
                                        loading = true;
                                      });

                                      await controller.setStatus(context);

                                      controller.setTables(
                                        groupId: widget.groupId,
                                        tablesId: homeController.arrayTables,
                                      );

                                      membs.documents.forEach((element) async {
                                        QuerySnapshot myGroup = await Firestore
                                            .instance
                                            .collection('users')
                                            .document(element.data['user_id'])
                                            .collection('my_group')
                                            .where('id',
                                                isEqualTo:
                                                    element.data['group_id'])
                                            .getDocuments();

                                        myGroup.documents
                                            .forEach((element) async {
                                          num eventCounter = await element
                                              .data['event_counter'];
                                          eventCounter++;

                                          element.reference.updateData(
                                              {'event_counter': eventCounter});
                                        });
                                      });
                                      controller.setAcceptDialog(false);
                                      loading = false;
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: wXD(47, context),
                                      width: wXD(98, context),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(0, 3),
                                                blurRadius: 3,
                                                color: Color(0x28000000))
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(17)),
                                          border: Border.all(
                                              color: Color(0x80707070)),
                                          color: Color(0xfffafafa)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Sim',
                                        style: TextStyle(
                                            color: ColorTheme.primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: wXD(16, context)),
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
            ),
            Visibility(
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
                        borderRadius: BorderRadius.all(Radius.circular(33))),
                    child: Column(
                      children: [
                        Container(
                          width: wXD(240, context),
                          margin: EdgeInsets.only(top: wXD(15, context)),
                          child: Text(
                            '''Tem certeza que deseja recusar esta mesa?''',
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
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    ColorTheme.yellow),
                              ))
                            : Row(
                                children: [
                                  Spacer(),
                                  InkWell(
                                    onTap: () async {
                                      controller.setRefuseDialog(false);
                                      setState(() {
                                        loading = true;
                                      });
                                      loading = false;
                                    },
                                    child: Container(
                                      height: wXD(47, context),
                                      width: wXD(98, context),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(0, 3),
                                                blurRadius: 3,
                                                color: Color(0x28000000))
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(17)),
                                          border: Border.all(
                                              color: Color(0x80707070)),
                                          color: Color(0xfffafafa)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Não',
                                        style: TextStyle(
                                            color: ColorTheme.primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: wXD(16, context)),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: () async {
                                      loading = true;
                                      setState(() {});

                                      await controller.unsetStatus(
                                          controller.stts,
                                          widget.groupId,
                                          context);
                                      loading = false;
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: wXD(47, context),
                                      width: wXD(98, context),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(0, 3),
                                                blurRadius: 3,
                                                color: Color(0x28000000))
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(17)),
                                          border: Border.all(
                                              color: Color(0x80707070)),
                                          color: Color(0xfffafafa)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Sim',
                                        style: TextStyle(
                                            color: ColorTheme.primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: wXD(16, context)),
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
            )
          ],
        ));
  }
}
