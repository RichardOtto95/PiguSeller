import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/app/modules/open_table/open_table_controller.dart';
import './widgets/button_arquivar_mesa.dart';
import './widgets/card_title_mesa.dart';
import './widgets/container_reabrir.dart';
import './widgets/mesainfo_appbar.dart';
import './widgets/participante_tile.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './widgets/float_menu_table.dart';

class TableInfoPage extends StatefulWidget {
  final String title;
  final group;

  const TableInfoPage({Key key, this.title = "TableInfo", this.group})
      : super(key: key);

  @override
  _TableInfoPageState createState() => _TableInfoPageState();
}

class _TableInfoPageState extends State<TableInfoPage> {
  //use 'controller' variable to access controller
  final openTableController = Modular.get<OpenTableController>();
  final homeController = Modular.get<HomeController>();

  var primaryColor = Color.fromRGBO(255, 132, 0, 1);
  var darkPrimaryColor = Color.fromRGBO(249, 153, 94, 1);
  var lightPrimaryColor = Color.fromRGBO(246, 183, 42, 1);
  var primaryText = Color.fromRGBO(22, 16, 18, 1);
  var blackText = Color(0xff3C3C3B);
  var secondaryText = Color.fromRGBO(84, 74, 65, 1);
  var accentColor = Color.fromRGBO(114, 74, 134, 1);
  var divisorColor = Color.fromRGBO(189, 174, 167, 1);
  bool _checkHost = false;
  bool checkMenu = false;
  double space = 0;
  double checkClickMenu = 0;
  Function kickmenu;
  var mesaName = "Magros de Ruim";
  var todosPagaram = false;

  String clickLabel;

  var listParticipantes = [
    {"nome": "Murilo Haas", "tipo": "anfitrião", "telefone": "(51) 98656-5623"},
    {"nome": "Murilo Haas", "tipo": "outro", "telefone": "(51) 98656-5623"},
    {"nome": "Murilo Haas", "tipo": "outro", "telefone": "(51) 98656-5623"},
    {"nome": "Murilo Haas", "tipo": "outro", "telefone": "(51) 98656-5623"},
    {"nome": "Murilo Haas", "tipo": "outro", "telefone": "(51) 98656-5623"},
    {"nome": "Murilo Haas", "tipo": "outro", "telefone": "(51) 98656-5623"},
    {"nome": "Murilo Haas", "tipo": "anfitrião", "telefone": "(51) 98656-5623"},
    {"nome": "Murilo Haas", "tipo": "anfitrião", "telefone": "(51) 98656-5623"},
    {"nome": "Murilo Haas", "tipo": "anfitrião", "telefone": "(51) 98656-5623"},
  ];

  @override
  Widget build(BuildContext context) {
    var orientationn = MediaQuery.of(context).orientation.index;
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection("groups")
                    .document(widget.group)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    var ds = snapshot.data;
                    return MesainfoAppbar(
                      iconButton:
                          Icon(Icons.group_add, color: Color(0xfffafafa)),
                      title: ds['name'],
                      imageURL: ds['avatar'],
                      iconOnTap: () {
                        openTableController.setGroupSelected(widget.group);
                        Modular.to.pushNamed('/add-participant');
                      },
                    );
                  }
                }),
            preferredSize: Size.fromHeight(kToolbarHeight),
          ),
          body: orientationn != Orientation.landscape.index
              ? getBody(widget.group, orientationn, context)
              : SingleChildScrollView(
                  child: getBody(widget.group, orientationn, context),
                )),
    );
  }

  Widget getBody(group, orientationn, context) {
    return StreamBuilder(
        stream:
            Firestore.instance.collection("groups").document(group).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            var ds = snapshot.data;
            return Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    CardTitleMesa(
                      title: ds['seller_name'],
                      background_image: ds['background_image'],
                      avatar: ds['avatar'],
                    ),
                    ds['status'] == 'filed'
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              width: double.infinity,
                              child: RaisedButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                                color: lightPrimaryColor,
                                child: Text("Mesa Arquivada",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                padding: EdgeInsets.all(20),
                                onPressed: () {},
                              ),
                            ))
                        : ButtonArquivarMesa(
                            archived: () {
                              if (ds['user_host'] == homeController.user.uid) {
                                Firestore.instance
                                    .collection("groups")
                                    .document(group)
                                    .updateData({'status': 'filed'});
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Usuario nao é anfitrião da mesa!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: ColorTheme.yellow,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            },
                          ),

                    StreamBuilder(
                        stream: Firestore.instance
                            .collection("groups")
                            .document(group)
                            .collection('members')
                            .snapshots(),
                        builder: (context, snapshot2) {
                          if (!snapshot.hasData) {
                            return Container();
                          } else {
                            return Container(
                              padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                      "${snapshot2.data.documents.length} participantes:",
                                      style: TextStyle(
                                        fontSize: 18,
                                      )),
                                  todosPagaram
                                      ? Text("todos pagaram",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: primaryColor,
                                              fontWeight: FontWeight.bold))
                                      : Text(
                                          "0/${snapshot2.data.documents.length} pagaram",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: primaryColor,
                                              fontWeight: FontWeight.bold))
                                ],
                              ),
                            );
                          }
                        }),
                    orientationn != Orientation.landscape.index
                        ? Expanded(
                            child: StreamBuilder(
                                stream: Firestore.instance
                                    .collection("groups")
                                    .document(group)
                                    .collection('members')
                                    .where('created')
                                    .where('accepted_invite')
                                    .orderBy("created_at", descending: true)
                                    .snapshots(),
                                builder: (context, snapshot3) {
                                  if (!snapshot.hasData) {
                                    return CircularProgressIndicator();
                                  } else {
                                    return Stack(
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.only(
                                                top: 10,
                                                left: 20,
                                                right: 20,
                                                bottom: 5),
                                            height: double.infinity,
                                            child: ListView.separated(
                                              itemCount: snapshot3
                                                  .data.documents.length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                DocumentSnapshot ds = snapshot3
                                                    .data.documents[index];
                                                print('ds:${ds}');
                                                return ParticipanteTile(
                                                    showMenu: () {
                                                      setState(() {
                                                        if (index >= 1) {
                                                          space = index * 10.0;
                                                        } else {
                                                          space = 0;
                                                        }
                                                        index++;
                                                        checkClickMenu =
                                                            index * 80.0 +
                                                                space;

                                                        checkMenu = !checkMenu;
                                                      });
                                                      openTableController
                                                          .setUserView(ds.data[
                                                              'user_invited']);
                                                    },
                                                    participante: ds.data);
                                              },
                                              separatorBuilder:
                                                  (context, index) {
                                                return SizedBox(
                                                  height: 15,
                                                );
                                              },
                                            )),
                                        Positioned(
                                          top: checkClickMenu,
                                          right: 20,
                                          child: Visibility(
                                              visible: checkMenu,
                                              child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      checkMenu = !checkMenu;
                                                    });

                                                    // openTableController
                                                    //     .setUserView(ds.data[
                                                    //         'user_invited']);
                                                    // setUserView
                                                  },
                                                  child: FloatMenu(
                                                    group: widget.group,
                                                  ))),
                                        ),
                                      ],
                                    );
                                  }
                                  return CircularProgressIndicator();
                                }),
                          )
                        : Container(
                            padding: EdgeInsets.only(
                                top: 10, left: 20, right: 20, bottom: 5),
                            height:
                                orientationn != Orientation.landscape ? 180 : 0,
                            child: ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return ParticipanteTile(
                                      participante:
                                          listParticipantes.elementAt(index));
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: 15,
                                  );
                                },
                                itemCount: listParticipantes.length)),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ds['status'] == 'filed'
                            ? ContainerReabrir(
                                reopen: () {
                                  Firestore.instance
                                      .collection("groups")
                                      .document(group)
                                      .updateData({'status': 'open'});
                                },
                              )
                            : Container()
                      ],
                    )
                    // Expanded(flex: 6, child: ContainerReabrir())
                  ],
                ),
              ],
            );
          }
        });
  }

  Widget getList(orientation) {
    return Container(
        padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 5),
        height: orientation != Orientation.landscape ? 180 : 0,
        child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ParticipanteTile(
                  showMenu: () {
                    setState(() {
                      checkMenu = !checkMenu;
                    });
                  },
                  participante: listParticipantes.elementAt(index));
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 15,
              );
            },
            itemCount: listParticipantes.length));
  }
}
