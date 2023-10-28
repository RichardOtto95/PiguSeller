import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestAlerts extends StatelessWidget {
  final String orderId;
  final Function onTap;
  final String avatar;
  final String listingId;
  const RequestAlerts(
      {Key key, this.onTap, this.avatar, this.orderId, this.listingId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double wXD(double size) {
      double finalSize = MediaQuery.of(context).size.width * size / 375;
      return finalSize;
    }

    return StreamBuilder(
      stream: Firestore.instance
          .collection('orders')
          .document(orderId)
          .collection('cart_item')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(ColorTheme.primaryColor),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done ||
            snapshot.connectionState == ConnectionState.active) {
          if (!snapshot.hasData ||
              snapshot.hasData == null ||
              snapshot.data.documents.length == 0 ||
              snapshot.data.documents.length == null) {
            return Container();
          } else {
            var ds = snapshot.data.documents[0].data;

            return StreamBuilder(
              stream: Firestore.instance
                  .collection('listings')
                  .document(ds['listing_id'])
                  .snapshots(),
              builder: (context, snapshot2) {
                if (snapshot2.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(ColorTheme.primaryColor),
                  ));
                } else if (!snapshot.hasData ||
                    snapshot.data.documents.length == 0 ||
                    snapshot.data.documents.length == null) {
                  return Container();
                } else {
                  DocumentSnapshot dds = snapshot2.data;

                  return Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                          height: wXD(73),
                          width: wXD(73),
                          child: Image.asset(
                            'assets/img/elipse.png',
                            height: wXD(73),
                            width: wXD(73),
                          )),
                      Positioned(
                        // top: 2,
                        // left: 2,
                        child: InkWell(
                          onTap: onTap,
                          child: Container(
                            width: wXD(64),
                            height: wXD(64),
                            margin: EdgeInsets.all(wXD(8)),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(90),
                              border: Border.all(
                                  width: wXD(3), color: ColorTheme.textGray),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x29000000),
                                  offset: Offset(0, 3),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: wXD(85),
                              backgroundColor: Color(0xfffafafa),
                              child: CircleAvatar(
                                backgroundImage: dds['image'] != null
                                    ? NetworkImage(dds['image'])
                                    : AssetImage('assets/img/defaultUser.png'),
                                backgroundColor: Colors.white,
                                // child: ,
                                radius: wXD(82),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}
