import 'package:pigu_seller/app/modules/multiple_checkouts/multiple_checkouts_controller.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../confirmed_checkouts.dart';
import '../multiple_checkouts_page.dart';

class FloatMenu extends StatelessWidget {
  final String click;
  final Function tapOnGoing;
  final Function tapPaid;

  FloatMenu({Key key, this.click, this.tapOnGoing, this.tapPaid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Modular.get<MultipleCheckoutsController>();
    return Container(
        width: MediaQuery.of(context).size.width * 0.53,
        height: MediaQuery.of(context).size.height * 0.07,
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
        alignment: Alignment.center,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              controller.clickLabel == 'onGoing'
                  ? Container()
                  : InkWell(
                      onTap: () {
                        controller.setClickLabel('onGoing');
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MultipleCheckoutsPage();
                        }));
                      },
                      child: FloatMenuButton(
                          title: "Em andamento", onTap: tapOnGoing)),
              controller.clickLabel == 'paid'
                  ? Container()
                  : InkWell(
                      onTap: () {
                        controller.setClickLabel('paid');
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ConfirmedCheckoutsPage();
                        }));
                      },
                      child: FloatMenuButton(
                          title: "Checkouts concluídos", onTap: tapPaid)),
            ]));
  }
}

class FloatMenuButton extends StatelessWidget {
  final String title;
  final Function onTap;
  const FloatMenuButton({
    Key key,
    this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 40,
        padding: EdgeInsets.only(left: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: ColorTheme.textGray,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
