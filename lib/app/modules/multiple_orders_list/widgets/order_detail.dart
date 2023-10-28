import 'package:pigu_seller/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetail extends StatelessWidget {
  final String userID;
  final Function onTap;
  final Function onTables;
  final String code;
  final String hash;
  final String note;
  final Timestamp createdAt;

  const OrderDetail(
      {Key key,
      this.onTap,
      this.code,
      this.hash,
      this.note,
      this.createdAt,
      this.onTables,
      this.userID})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double wXD(double size) {
      double finalSize = MediaQuery.of(context).size.width * size / 375;
      return finalSize;
    }

    double maxWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          left: wXD(15),
          top: wXD(8),
          bottom: wXD(8),
        ),
        height: wXD(75),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: ColorTheme.textGray),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
              stream: Firestore.instance
                  .collection('users')
                  .document(userID)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  String nameUser = snapshot.data['username'];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: wXD(300),
                        child: Text(
                          "$nameUser / Comanda $code",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: wXD(16),
                            color: Color(0xff3C3C3B),
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: wXD(5),
                      ),
                      StreamBuilder(
                          stream: Firestore.instance
                              .collection('listings')
                              .document(hash)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container();
                            } else {
                              return Container(
                                width: wXD(299),
                                child: Text(
                                  "${snapshot.data['label']}",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: wXD(16),
                                    color: Color(0xff3C3C3B),
                                    fontWeight: FontWeight.w300,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }
                          }),
                      Container(
                        width: wXD(299),
                        child: Text(
                          '$note',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: wXD(16),
                            color: ColorTheme.textGray,
                            fontWeight: FontWeight.w300,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            Column(
              children: [
                InkWell(
                  onTap: onTables,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        vertical: maxWidth * .015, horizontal: wXD(10)),
                    width: maxWidth * .1,
                    height: maxWidth * .1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: ColorTheme.gray),
                    ),
                    child: Image.asset(
                      'assets/icon/menuOpen.png',
                      height: wXD(40),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Text(
                  '${DateFormat(DateFormat.ABBR_WEEKDAY, 'pt_Br').format(createdAt.toDate())}, ${createdAt.toDate().hour.toString().padLeft(2, '0')}:${createdAt.toDate().minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: wXD(10),
                    color: ColorTheme.textColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            SizedBox()
          ],
        ),
      ),
    );
  }
}
