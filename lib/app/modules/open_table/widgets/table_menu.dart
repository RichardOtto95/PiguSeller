import 'package:pigu_seller/app/modules/chat/widgets/float_menu.dart';
import 'package:flutter/material.dart';

class TableMenu extends StatelessWidget {
  final Function onTap1;
  final Function onTap2;
  final Function onTap3;
  final Function ofTap;
  const TableMenu({Key key, this.onTap1, this.onTap2, this.onTap3, this.ofTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ofTap,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              right: 3,
              top: 3,
              child: Container(
                  width: MediaQuery.of(context).size.width * .5,
                  // height: 161,
                  padding: EdgeInsets.only(left: 14, top: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x29000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FloatMenuButton(
                          title: "Em andamento",
                          onTap: onTap1,
                        ),
                        FloatMenuButton(
                          title: "Recusadas",
                          onTap: onTap2,
                        ),
                        FloatMenuButton(
                          title: "Quitadas",
                          onTap: onTap3,
                        ),
                      ])),
            ),
          ],
        ),
      ),
    );
  }
}
