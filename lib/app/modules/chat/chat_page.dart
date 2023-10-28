import 'dart:async';

import 'package:pigu_seller/app/core/models/seller_model.dart';
import 'package:pigu_seller/app/modules/chat/widgets/chat_bubble_left.dart';
import 'package:pigu_seller/app/modules/chat/widgets/chat_bubble_person.dart';
import 'package:pigu_seller/app/modules/chat/widgets/chat_bubble_right.dart';
import 'package:pigu_seller/app/modules/chat/widgets/float_menu.dart';
import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:pigu_seller/shared/widgets/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'chat_controller.dart';

class ChatPage extends StatefulWidget {
  final String title;
  final group;
  final order;
  final msgType;
  const ChatPage(
      {Key key, this.title = "Chat", this.group, this.msgType, this.order})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final homeController = Modular.get<HomeController>();
  ScrollController _scrollController = new ScrollController();

  //use 'controller' variable to access controller
  bool clickItem = false;
  String hash;
  bool showMenu = false;
  Future<List<dynamic>> getMessages(String documentID) async {
    // var firestore = Firestore.instance;

    // var docRef = firestore.collection('companies').document(documentID);
    var docRef = await Firestore.instance
        .collection('chat')
        .document(documentID)
        .collection('messages')
        .getDocuments();

    return docRef.documents.map((snap) => snap.data).toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(seconds: 1),
      () => _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      ),
    );

    if (widget.group != widget.group.toString()) {
      setState(() {
        hash = widget.group[1];
      });
    } else {
      setState(() {
        hash = widget.group;
      });
    }
    return StreamBuilder(
        stream:
            Firestore.instance.collection("groups").document(hash).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            // print('Dados ${snapshot.data}');
            DocumentSnapshot ds = snapshot.data;
            return Scaffold(
              backgroundColor: Color(0xffFAFAFA),
              body: SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        NavTableBar(
                          goToTableInfo: () {
                            Modular.to.pushNamed('open-table/table-info',
                                arguments: widget.group);
                          },
                          title: "${ds['name']}",
                          imageURL: ds['avatar'],
                          iconButton:
                              Icon(Icons.more_vert, color: Color(0xfffafafa)),
                          iconOnTap: () {
                            setState(() {
                              showMenu = !showMenu;
                            });
                          },
                        ),
                        StreamBuilder(
                            stream: Firestore.instance
                                .collection("chat")
                                .where('group_id', isEqualTo: hash)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container();
                              } else {
                                // print('Dados ${snapshot.data}');
                                QuerySnapshot ds = snapshot.data;
                                return FutureBuilder(
                                  future: Firestore.instance
                                      .collection('chat')
                                      .document(ds.documents[0].documentID)
                                      .collection('messages')
                                      .orderBy('created_at', descending: false)
                                      .getDocuments(),
                                  builder: (BuildContext context, snapshot2) {
                                    if (snapshot2.hasData) {
                                      if (snapshot2.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return Expanded(
                                            child: ListView.builder(
                                                controller: _scrollController,
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemCount: snapshot2
                                                    .data.documents.length,
                                                itemBuilder: (context, index) {
                                                  DocumentSnapshot dss =
                                                      snapshot2.data
                                                          .documents[index];

                                                  return dss['type'] ==
                                                          'create-table'
                                                      ? InkWell(
                                                          child: ChatBubbleLeft(
                                                            title:
                                                                "${dss['text']}",
                                                          ),
                                                        )
                                                      : dss['type'] ==
                                                              'order-with-members'
                                                          ? InkWell(
                                                              child:
                                                                  ChatBubblePerson(
                                                                date: dss[
                                                                    'created_at'],
                                                                image: dss['listing_image'] !=
                                                                        null
                                                                    ? dss[
                                                                        'listing_image']
                                                                    : 'https://www.level10martialarts.com/wp-content/uploads/2017/04/default-image.jpg',
                                                                qtd: dss[
                                                                        'amount_users']
                                                                    .toString(),
                                                                userName: '',
                                                                title: dss[
                                                                    'listing_title'],
                                                              ),
                                                            )
                                                          : dss['type'] ==
                                                                  'create-order'
                                                              ? InkWell(
                                                                  child:
                                                                      ChatBubbleRight(
                                                                    date: dss[
                                                                        'created_at'],
                                                                    imageUrl: dss['listing_image'] !=
                                                                            null
                                                                        ? dss[
                                                                            'listing_image']
                                                                        : 'https://www.level10martialarts.com/wp-content/uploads/2017/04/default-image.jpg',
                                                                    title: dss[
                                                                        'listing_title'],
                                                                  ),
                                                                )
                                                              : dss['type'] ==
                                                                      'user-invite-table'
                                                                  ? InkWell(
                                                                      child:
                                                                          ChatBubbleLeft(
                                                                        title:
                                                                            "${dss['text']}",
                                                                      ),
                                                                    )
                                                                  : BlankSpacer();
                                                })

                                            //  ListView(

                                            //   children: [

                                            //     InkWell(
                                            //       onTap: (){
                                            //         setState(() {
                                            //           clickItem = !clickItem;
                                            //         });
                                            //       },
                                            //       child: ChatBubblePerson(
                                            //         title: "1 Coffee Jelly Frappuccino ",
                                            //       ),
                                            //     ),
                                            //     InkWell(
                                            //       onTap: (){
                                            //         setState(() {
                                            //           clickItem = !clickItem;
                                            //         });
                                            //       },
                                            //       child: ChatBubblePersonSplit(
                                            //         title: "1 Coffee Jelly Frappuccino ",
                                            //       ),
                                            //     ),
                                            //     snapshot.data[0]['type'] == 'create-table' ?
                                            //     InkWell(
                                            //       onTap: (){
                                            //         setState(() {
                                            //           // clickItem = !clickItem;
                                            //         });
                                            //       },
                                            //       child: ChatBubbleLeft(
                                            //         title: "${snapshot.data[0]['text']}",

                                            //       ),
                                            //     ): snapshot.data[0]['type'] == 'create-order' ?
                                            //     InkWell(
                                            //       onTap: (){
                                            //         setState(() {
                                            //           clickItem = !clickItem;
                                            //         });
                                            //       },
                                            //       child:

                                            //       ChatBubbleRight(
                                            //         date:Timestamp.now(),
                                            //         imageUrl:snapshot.data[0]['listing_image'] != null ? snapshot.data[0]['listing_image'] : 'https://www.level10martialarts.com/wp-content/uploads/2017/04/default-image.jpg' ,
                                            //         title: "1 Coffee Jelly Frappuccino",
                                            //       ),
                                            //     ) :
                                            //     InkWell(
                                            //       onTap: (){
                                            //         setState(() {
                                            //           // clickItem = !clickItem;
                                            //         });
                                            //       },
                                            //     child:ChatBubbleLeft(
                                            //       title: "4/4 decidiram o que pedir",
                                            //     ),
                                            //     ),
                                            //     BlankSpacer()
                                            //   ],
                                            // ),
                                            );
                                      }
                                    } else if (snapshot.hasError) {
                                      Text('no data');
                                    }
                                    return CircularProgressIndicator();
                                  },
                                );
                              }
                            })
                      ],
                    ),
                    Positioned(
                        bottom: 0,
                        child: clickItem
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    clickItem = !clickItem;
                                  });
                                },
                                // child: SlideMenu(),
                              )
                            : Container()),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Visibility(
                          visible: showMenu,
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  showMenu = !showMenu;
                                });
                              },
                              child: FloatMenu(
                                group: widget.group,
                              ))),
                    )
                  ],
                ),
              ),
              bottomNavigationBar: BottomAppBar(
                  elevation: 0.3,
                  notchMargin: 22,
                  clipBehavior: Clip.antiAlias,
                  color: ColorTheme.white,
                  shape: AutomaticNotchedShape(
                      RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.only(topRight: Radius.circular(0))),
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)))),
                  child: Row(
                    children: [
                      SizedBox(width: 43),
                      InkWell(
                        onTap: () {
                          if (ds['status'] == 'awaiting') {
                            Fluttertoast.showToast(
                                msg: "Aguarde a abertura da Conta...",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.SNACKBAR,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.white,
                                textColor: ColorTheme.yellow,
                                fontSize: 16.0);
                          } else {
                            Modular.to.pushNamed('open-table/pay-the-bill',
                                arguments: widget.group);
                          }
                        },
                        child: Container(
                          width: 50,
                          height: 80,
                          child: Column(children: [
                            SizedBox(height: 15),
                            Image.asset(
                              'assets/icon/count.png',
                              height: 26,
                              width: 26,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "pedir conta",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 10,
                                color: ColorTheme.textGray,
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.center,
                            )
                          ]),
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: 100,
                        height: 80,
                        child: Column(children: [
                          SizedBox(height: 15),
                          Image.asset(
                            'assets/icon/rep.png',
                            height: 26,
                            width: 26,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "repetir bebida",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 10,
                              color: ColorTheme.textGray,
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ]),
                      ),
                      SizedBox(width: 43),
                    ],
                  )),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: SizedBox(
                width: 64,
                height: 64,
                child: FloatingActionButton(
                  backgroundColor: ColorTheme.blueCyan,
                  onPressed: () async {
                    var docRef = await Firestore.instance
                        .collection('seller')
                        .document(ds['seller_id'])
                        .get();
                    // print('homeController.sellerModel: ${homeController.sellerModel}');
                    // SellerModel();
                    SellerModel _seller = SellerModel(
                      adress: docRef.data['adress'],
                      avatar: docRef.data['seller_id'],
                      background_image: docRef.data['background_image'],
                      category_id: docRef.data['category_id'],
                      // location:'' ,
                      name: docRef.data['name'],
                      seller_id: docRef.data['seller_id'],
                      //   {this.reference,
                      //   this.seller_id,
                      //   this.adress,
                      //   this.avatar,
                      //   this.background_image,
                      //   this.category_id,
                      //   this.location,
                      //   this.name,
                      // }
                    );
                    homeController.setSeller(_seller);
                    Modular.to.pushNamed('/menu', arguments: _seller);

                    // Modular.to.pushNamed('/menu');
                  },
                  child: Image.asset(
                    'assets/icon/menuOpen.png',
                    height: 37,
                    width: 40,
                    color: Colors.white,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          }
        });
  }
}

class BlankSpacer extends StatelessWidget {
  const BlankSpacer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
    );
  }
}
