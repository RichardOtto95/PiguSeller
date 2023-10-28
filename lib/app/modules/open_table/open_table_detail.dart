import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu_seller/app/modules/open_table/open_table_controller.dart';
import 'package:pigu_seller/app/modules/open_table/widgets/float_menu.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:pigu_seller/shared/widgets/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OpenTableDetailPage extends StatefulWidget {
  final DocumentSnapshot invite;
  final group;
  OpenTableDetailPage({Key key, this.invite, this.group}) : super(key: key);

  @override
  _OpenTableDetailPageState createState() => _OpenTableDetailPageState();
}

class _OpenTableDetailPageState
    extends ModularState<OpenTableDetailPage, OpenTableController> {
  bool click = false;
  bool showMenu = false;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Scaffold(
        body: SafeArea(
          child: Container(
            color: Color(0xFFEDEDED),
            child: Stack(
              children: [
                StreamBuilder(
                    stream: Firestore.instance
                        .collection("seller")
                        .where('seller_id',
                            isEqualTo: widget.invite['seller_id'])
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        return Column(
                          children: [
                            NavBar(
                              title: "",
                              iconButton: Icon(Icons.more_vert,
                                  color: ColorTheme.white),
                              iconOnTap: () {
                                setState(() {
                                  showMenu = !showMenu;
                                });
                              },
                              backPage: () {
                                Navigator.pop(context);
                              },
                            ),
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    color: ColorTheme.white,
                                    height: 106,
                                    padding: EdgeInsets.fromLTRB(22, 30, 22, 0),
                                    // padding: EdgeInsets.only(top: 30),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              'Quero Caféééé!',
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 16,
                                                color: ColorTheme.textColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              'participantes:',
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 16,
                                                color: ColorTheme.textColor,
                                                fontWeight: FontWeight.w300,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              click = !click;
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    width: 158,
                                                    height: 44,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.add,
                                                    size: 25,
                                                    color: ColorTheme.textGray,
                                                  ),
                                                  Text(
                                                    '3',
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: 16,
                                                      color: ColorTheme
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AnimatedContainer(
                                    color: ColorTheme.white,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                    height: click ? 250 : 0,
                                    //color: Colors.red,
                                    child: Container(
                                      height: 500,
                                      child: StreamBuilder(
                                          stream: Firestore.instance
                                              .collection("group")
                                              .document(
                                                  widget.invite['group_id'])
                                              .collection('members')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Container();
                                            } else {
                                              return ListView.builder(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  shrinkWrap: true,
                                                  itemCount: snapshot
                                                      .data.documents.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    DocumentSnapshot ds =
                                                        snapshot.data
                                                            .documents[index];

                                                    return new Participant(
                                                      avatar:
                                                          'https://thumbs.dreamstime.com/b/default-avatar-profile-icon-social-media-user-vector-default-avatar-profile-icon-social-media-user-vector-portrait-176194876.jpg',
                                                      name: ds['nickname'],
                                                      number: ds['phone'],
                                                      host: true,
                                                    );
                                                  });
                                            }
                                          }),
                                    ),

                                    // Participant(),
                                    // Participant(),
                                    // Participant(),
                                    // Participant(),
                                    // Participant(),
                                  ),
                                  AdicionarPessoasTitle(
                                    name: snapshot.data.documents[0]['name'],
                                    dia: snapshot.data.documents[0]
                                        ['created_at'],
                                  ),

                                  // AdicionarPessoasTitle(name: widget.invite['nickname'],),
                                  SizedBox(
                                    height: 5,
                                  ),

                                  Container(
                                    // color: Color(0xFFEDEDED),
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Stack(
                                            alignment:
                                                AlignmentDirectional.topCenter,
                                            children: [
                                              Container(
                                                //color: Colors.grey,
                                                // margin: EdgeInsets.only(
                                                //     left: 27,
                                                //     right: 27,
                                                //     bottom: 16),
                                                height: 230,
                                                width: 355,
                                              ),
                                              Positioned(
                                                top: 78,
                                                // left: 00,
                                                child: Container(
                                                  height: 105,
                                                  width: 306,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                    color:
                                                        const Color(0xFFEDEDED),
                                                  ),
                                                  child: Image.asset(
                                                    'assets/img/map.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 0,
                                                // left: 27,
                                                child: Container(
                                                  height: 125,
                                                  width: 355,
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: const Color(
                                                            0x29000000),
                                                        offset: Offset(0, 3),
                                                        blurRadius: 6,
                                                      ),
                                                    ],
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl: snapshot
                                                              .data.documents[0]
                                                          ['background_image'],
                                                      placeholder: (context,
                                                              url) =>
                                                          CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 4,
                                                left: 4,
                                                child: Container(
                                                  padding: EdgeInsets.all(4),
                                                  height: 48,
                                                  width: 48,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color(0xffF9995E)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: Container(
                                                      color: Colors.white,
                                                      child: CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: snapshot.data
                                                                .documents[0]
                                                            ['avatar'],
                                                        placeholder: (context,
                                                                url) =>
                                                            CircularProgressIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 89,
                                                right: 4,
                                                child: Container(
                                                  padding: EdgeInsets.all(6),
                                                  height: 32,
                                                  width: 38,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                    color: Colors.white,
                                                  ),
                                                  child: Image.asset(
                                                    'assets/icon/coffe.png',
                                                    height: 16,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 110,
                                                // left: 158,
                                                child: Container(
                                                  height: 44,
                                                  width: 44,
                                                  child: Image.asset(
                                                    'assets/icon/mapMarker.png',
                                                    height: 16,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 145,
                                                right: 0,
                                                child: Container(
                                                  width: 55.0,
                                                  height: 42.0,
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(21.0),
                                                      topRight:
                                                          Radius.circular(21.0),
                                                      bottomRight:
                                                          Radius.circular(21.0),
                                                      bottomLeft:
                                                          Radius.circular(58.0),
                                                    ),
                                                    color: ColorTheme.blueCyan,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: const Color(
                                                            0x29000000),
                                                        offset: Offset(0, 3),
                                                        blurRadius: 6,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Center(
                                                    child: Image.asset(
                                                      'assets/icon/sender.png',
                                                      height: 18,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 11,
                                                left: 5,
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      'assets/icon/marker.png',
                                                      height: 18,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 8,
                                                child: Text(
                                                  'SHCLS 407 Sul Bloco B Loja 26',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(15, 2, 15, 15),
                                    height: 1,
                                    color: Color(0xffBDAEA7),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/icon/menuOpen.png',
                                        height: 40,
                                        fit: BoxFit.contain,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'Ver',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          color: ColorTheme.textColor,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'menu',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          color: ColorTheme.textColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 21,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            height: 61,
                                            width: 142,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: ColorTheme
                                                        .primaryColor),
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(21)),
                                            child: Center(
                                              child: Text(
                                                'Fica pra próxima',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 16,
                                                  color: ColorTheme.textColor,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            )),
                                        SizedBox(
                                          width: 48,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            FirebaseUser user =
                                                await FirebaseAuth.instance
                                                    .currentUser();

                                            //exemplo update doc
                                            await Firestore.instance
                                                .collection("invited")
                                                .document(
                                                    widget.invite.documentID)
                                                .updateData({
                                              'role': 'accepted_invite'
                                            });
                                            //exemplo de get com "where'
                                            QuerySnapshot ref2 = await Firestore
                                                .instance
                                                .collection("group")
                                                .document(widget
                                                    .invite.data['group_id'])
                                                .collection('members')
                                                .where('user_invited',
                                                    isEqualTo: user.uid)
                                                .getDocuments();
                                            //exemplo  update list doc

                                            await ref2.documents.first.reference
                                                .updateData({
                                              'role': 'accepted_invite'
                                            });
                                            await Firestore.instance
                                                .collection('users')
                                                .document(user.uid)
                                                .updateData({
                                              'my_group':
                                                  FieldValue.arrayUnion([
                                                '${widget.invite.data['group_id'].toString()}'
                                              ])
                                            });
                                            // DocumentReference ref1 =
                                            //     await Firestore.instance
                                            //         .collection("invited")
                                            //         .where('user_invited',
                                            //             isEqualTo: user.uid)
                                            //         .getDocuments();
                                            // // DocumentSnapshot docRe =   await ref2.documents[0];
                                            // await ref1.documents[0].reference
                                            //     .updateData({
                                            //   'role': 'accepted_invite'
                                            // });

                                            //   // 'item_amount':qtdOrder,
                                            //   // 'item_price': qtdOrder == 1 ? orderConfirm['price'] :totalPrice,
                                            //   // 'item_status':'created',
                                            //   // 'listing_id': orderConfirm['listing_id'],
                                            //   // 'description_ptbr': orderConfirm['description_ptbr'],
                                            //   // 'title_ptbr': orderConfirm['title_ptbr'],
                                            //   // 'seller_id':orderConfirm['seller_id'],
                                            //   // 'user_id':user.uid,
                                            // });

                                            QuerySnapshot ref4 = await Firestore
                                                .instance
                                                .collection("chat")
                                                .where('group_id',
                                                    isEqualTo: widget
                                                        .invite['group_id'])
                                                .getDocuments();

                                            DocumentReference ref5 =
                                                await Firestore
                                                    .instance
                                                    .collection("chat")
                                                    .document(ref4.documents[0]
                                                        .documentID)
                                                    .collection("messages")
                                                    .add({
                                              'author_id': user.uid,
                                              'created_at': Timestamp.now(),
                                              'listing_images': '',
                                              'listing_note': '',
                                              'listing_title': '',
                                              'order_status': '',
                                              'text':
                                                  'Usuário adicionado ${user.displayName}  a mesa',
                                              'type': 'user-invite-table',
                                            });

                                            await Modular.to.pushNamed(
                                                '/open-table/chat',
                                                arguments:
                                                    widget.invite['group_id']);
                                          },
                                          child: Container(
                                              height: 61,
                                              width: 142,
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(
                                                          0x29000000),
                                                      offset: Offset(0, 3),
                                                      blurRadius: 6,
                                                    ),
                                                  ],
                                                  color:
                                                      ColorTheme.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          21)),
                                              child: Center(
                                                child: Text(
                                                  'Vou!',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 16,
                                                    color: ColorTheme.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 24,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    }),
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
                          child: FloatMenu())),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class Participant extends StatelessWidget {
  final bool host;
  final String name;
  final String avatar;
  final String number;
  const Participant({
    this.avatar,
    this.name,
    this.number,
    Key key,
    this.host = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      height: 69,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
          bottomLeft: Radius.circular(8.0),
        ),
        color: host ? Color(0xffdadcdc) : Colors.transparent,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 64.0,
                height: 64.0,
                margin: EdgeInsets.only(left: 15, top: 3, bottom: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  border: Border.all(width: 3.0, color: ColorTheme.textGray),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x29000000),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(90),
                    child: avatar == null
                        ? Image.asset('assets/img/defaultUser.png')
                        : Image.network(avatar, fit: BoxFit.cover)
                    // CachedNetworkImage(
                    // fit: BoxFit.cover,
                    // imageUrl: avatar,
                    // placeholder: (context, url) => CircularProgressIndicator(),
                    // errorWidget: (context, url, error) => Icon(Icons.error),
                    // ),
                    ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        '$name',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color: ColorTheme.textColor,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      host
                          ? Text(
                              'anfitrião',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                color: ColorTheme.primaryColor,
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.right,
                            )
                          : Container(),
                      SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 34,
                      ),
                      Text(
                        '$number',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color: ColorTheme.textGray,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AdicionarPessoasTitle extends StatelessWidget {
  final String name;
  final Timestamp dia;
  const AdicionarPessoasTitle({
    this.name,
    this.dia,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      padding: EdgeInsets.only(left: 30, bottom: 7),
      width: double.infinity,
      color: Color(0XFFEDEDED),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 2,
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Em',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w300),
                    ),
                    Spacer(),
                    Text(
                      '${dia.toDate().day.toString()}/${dia.toDate().month.toString()}/${dia.toDate().year.toString()}',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color: ColorTheme.textColor,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${dia.toDate().hour.toString().toString().padLeft(2, '0')}:${dia.toDate().minute.toString().toString().padLeft(2, '0')}',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color: ColorTheme.textColor,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 7,
                ),
                Text(
                  '$name',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 36,
                      color: ColorTheme.darkCyanBlue,
                      fontWeight: FontWeight.w700,
                      height: 0.9),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
