import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

import './float_menu_table.dart';
import 'package:flutter/material.dart';

class ParticipanteTile extends StatelessWidget {
  var participante;
  var lightPrimaryColor = Color.fromRGBO(246, 183, 42, 1);
  var primaryColor = Color.fromRGBO(250, 250, 250, 1);
  var anfitriaoText = Color(0xff95A5A6);
  var personText = Color(0xffD0D2D2);
  var todosPagaram = false;
  var pagou = true;
  final checkHost;
  final group;
  final Function showMenu;
  // bool checkHost = false;
  ParticipanteTile({
    @required this.participante,
    this.checkHost,
    this.group,
    this.showMenu,
  });

  @override
  Widget build(BuildContext context) {
    var styleMenu = TextStyle(fontSize: 16, color: Color(0xff95A5A6));
    List menuOption = [
      Text('Visualizar perfil', style: styleMenu),
      Text('Promover a anfitrião', style: styleMenu),
      Text('Ver comanda parcial', style: styleMenu),
    ];

    return StreamBuilder(
        stream: Firestore.instance
            .collection("group")
            .document(participante['group_id'])
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            return InkWell(
                onTap: showMenu,
                // onTap: () {
                //   // print("participante: ${participante.data}");
                //   if (participante["type"] == "host") {
                //   } else {
                //     print("Não é  host");
                //   }
                // },
                child: Stack(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: snapshot.data['user_host'] !=
                                    participante['user_invited']
                                ? primaryColor
                                : Color(0xffDADCDC),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(25),
                                topRight: Radius.circular(25))),
                        child: ListTile(
                          leading: Container(
                              child: CircleAvatar(
                                  radius: 29,
                                  backgroundColor: todosPagaram
                                      ? Color(0xffE7E9E9)
                                      : Color(0xff95A5A6),
                                  child: CircleAvatar(
                                    child:
                                        Image.asset("assets/img/hamburger.png"),
                                    radius: 26,
                                    backgroundColor: Colors.white,
                                  ))),
                          title: Row(
                            children: [
                              Text(
                                  participante['nickname'] != null
                                      ? participante['nickname']
                                      : participante['phone'],
                                  style: TextStyle(
                                      color: todosPagaram
                                          ? Color(0xff95A5A6)
                                          : Color(0xff3C3C3B),
                                      fontWeight: FontWeight.bold)),
                              Spacer(),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                participante['phone'],
                                style: TextStyle(
                                    color: todosPagaram
                                        ? Color(0xff95A5A6)
                                        : Color(0xff3C3C3B)),
                              ),
                            ],
                          ),
                        )),
                    // pagou
                    //     ? Positioned(
                    //         left: 52,
                    //         top: 30,
                    //         child: Container(
                    //             height: 40,
                    //             width: 40,
                    //             child: Image.asset('assets/icon/closed.png')),
                    //       )
                    //     : null,
                  ],
                ));
          }
          // DocumentSnapshot ds = snapshot.data.documents;
        });
  }
}
