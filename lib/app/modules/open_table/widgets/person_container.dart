import 'package:pigu_seller/app/modules/open_table/open_table_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:pigu_seller/app/modules/open_table/widgets/person_photo.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:image_stack/image_stack.dart';

class PersonContainer extends StatefulWidget {
  final String avatar;
  final String name;
  final Function onTap;
  final Timestamp createAt;
  final String group;
  final int counter;
  final bool eventVerifier;
  final listMembers;
  final String sellerId;
  const PersonContainer({
    this.createAt,
    this.avatar,
    this.name,
    Key key,
    this.onTap,
    this.group,
    this.counter,
    this.eventVerifier,
    this.listMembers,
    this.sellerId,
  }) : super(key: key);

  @override
  _PersonContainerState createState() => _PersonContainerState();
}

class _PersonContainerState extends State<PersonContainer> {
  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  Future<dynamic> task;
  List<String> members = [];

  @override
  void initState() {
    task = getMembersAvatar();
    super.initState();
  }

  Future<dynamic> getMembersAvatar() async {
    QuerySnapshot _members = await Firestore.instance
        .collection('groups')
        .document(widget.group)
        .collection('members')
        .getDocuments();

    _members.documents.forEach((element) async {
      // print('element ======================== ${element.data}');

      DocumentSnapshot _memberss = await Firestore.instance
          .collection('users')
          .document(element.data['user_id'])
          .get();
      // print('_memberss + ======================== ${_memberss.data}');
      members.add(_memberss.data['avatar']);
    });

    await Future.delayed(Duration(seconds: 1));

    return members;
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Modular.get<HomeController>();
    final openTableController = Modular.get<OpenTableController>();
    String sellerAvatar;

    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.only(left: wXD(10, context)),
        height: wXD(85, context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    InkWell(
                      child: PersonPhoto(
                        avatar: widget.avatar,
                      ),
                    ),
                    StreamBuilder(
                        stream: Firestore.instance
                            .collection('orders')
                            .where('group_id', isEqualTo: widget.group)
                            .where('status', isEqualTo: 'order_requested')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          } else {
                            // int counter = 0;

                            if (!snapshot.hasData) {
                              return Center(
                                child: Text('Nenhuma mesa ainda'),
                              );
                            }
                            int counter = snapshot.data.documents.length;

                            return Visibility(
                                visible: counter > 0,
                                child: Positioned(
                                    left: wXD(45, context),
                                    top: wXD(10, context),
                                    child: Container(
                                        height: wXD(20, context),
                                        width: wXD(20, context),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: ColorTheme.blue),
                                        child: Text(
                                          '$counter',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: wXD(16, context),
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300),
                                        ))));
                          }
                        })
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: wXD(200, context),
                      child: Text(
                        '${widget.name}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: wXD(16, context),
                          color: ColorTheme.textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            width: wXD(180, context),
                            height: wXD(45, context),
                            child: FutureBuilder(
                                future: task,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container();
                                  } else {
                                    return Container(
                                      padding: snapshot.data.length == 1
                                          ? EdgeInsets.only(left: 0)
                                          : snapshot.data.length == 2
                                              ? EdgeInsets.only(
                                                  left: wXD(25, context))
                                              : snapshot.data.length == 3
                                                  ? EdgeInsets.only(
                                                      left: wXD(55, context))
                                                  : snapshot.data.length == 4
                                                      ? EdgeInsets.only(
                                                          left: 85)
                                                      : snapshot.data.length > 4
                                                          ? EdgeInsets.only(
                                                              left: wXD(
                                                                  90, context))
                                                          : EdgeInsets.all(0),
                                      child: ImageStack(
                                        imageList: snapshot.data,
                                        imageCount: 4,
                                        totalCount:
                                            // 2,
                                            widget.listMembers.length,
                                        imageRadius: 40,
                                        imageBorderWidth: 1,
                                      ),
                                    );
                                  }
                                })),
                      ],
                    ),

                    // Row(
                    //   children: [
                    //     Icon(
                    //       Icons.add,
                    //       size: wXD(20, context),
                    //       color: ColorTheme.textGray,
                    //     ),
                    // Stack(
                    //   children: [
                    //     Container(
                    //       child: StreamBuilder(
                    //           stream: Firestore.instance
                    //               .collection('groups')
                    //               .document(widget.group)
                    //               .collection('members')
                    //               .snapshots(),
                    //           builder: (context, snapshot) {
                    //             if (snapshot.hasData) {
                    //               return Container(
                    //                 child: Text(
                    //                   '${snapshot.data.documents.length}',
                    //                   style: TextStyle(
                    //                     fontFamily: 'Roboto',
                    //                     fontSize: wXD(16, context),
                    //                     color: ColorTheme.orange,
                    //                     fontWeight: FontWeight.w700,
                    //                   ),
                    //                   textAlign: TextAlign.center,
                    //                 ),
                    //                 width: wXD(20, context),
                    //                 height: wXD(20, context),
                    //               );
                    //             } else {
                    //               return Container(
                    //                 child: Text(
                    //                   '0',
                    //                   style: TextStyle(
                    //                     fontFamily: 'Roboto',
                    //                     fontSize: wXD(16, context),
                    //                     color: ColorTheme.orange,
                    //                     fontWeight: FontWeight.w700,
                    //                   ),
                    //                   textAlign: TextAlign.center,
                    //                 ),
                    //                 width: wXD(20, context),
                    //                 height: wXD(20, context),
                    //               );
                    //             }
                    //           }),
                    //     )
                    //   ],
                    // )
                    //   ],
                    // ),
                    // SizedBox(
                    //   width: wXD(5, context),
                    //   height: wXD(5, context),
                    // )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: 0, left: wXD(5, context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: wXD(60, context),
                            height: wXD(60, context),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                                bottomRight: Radius.circular(24),
                                bottomLeft: Radius.circular(8),
                              ),
                              color: ColorTheme.orange,
                            ),
                          ),
                          Positioned(
                              top: wXD(7, context),
                              right: wXD(7, context),
                              child: StreamBuilder(
                                  stream: Firestore.instance
                                      .collection('sellers')
                                      .document(widget.sellerId)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return CircularProgressIndicator();
                                    } else {
                                      sellerAvatar = snapshot.data['avatar'];

                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: Text('Nenhuma mesa ainda'),
                                        );
                                      }
                                      sellerAvatar = snapshot.data['avatar'];

                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(90),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          width: wXD(40, context),
                                          height: wXD(40, context),
                                          imageUrl: sellerAvatar,
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      );
                                    }
                                  }))
                        ],
                      ),
                      Container(
                        width: wXD(60, context),
                        child: Text(
                          '${DateFormat(DateFormat.ABBR_WEEKDAY, 'pt_Br').format(widget.createAt.toDate())} ${widget.createAt.toDate().hour.toString().padLeft(2, '0')}:${widget.createAt.toDate().minute.toString().padLeft(2, '0')}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: wXD(10, context),
                            color: ColorTheme.textColor,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 0,
                  width: wXD(10, context),
                  child: Container(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
