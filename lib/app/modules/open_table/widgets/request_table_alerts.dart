import 'package:pigu_seller/app/modules/staff_list/staff_list_page.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:flutter/material.dart';

class RequestTableAlerts extends StatelessWidget {
  final Function onTap;
  final String avatar;

  const RequestTableAlerts({Key key, this.onTap, this.avatar})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
            child: Image.asset(
          'assets/img/elipse.png',
          height: wXD(70, context),
          width: wXD(70, context),
        )),
        Positioned(
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: wXD(60, context),
              height: wXD(60, context),
              margin: EdgeInsets.all(8),
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
              child: CircleAvatar(
                radius: 85,
                backgroundColor: Color(0xfffafafa),
                child: CircleAvatar(
                  backgroundImage: avatar != null
                      ? NetworkImage(avatar)
                      : AssetImage('assets/img/defaultUser.png'),
                  backgroundColor: Colors.white,
                  // child: ,
                  radius: 82,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
