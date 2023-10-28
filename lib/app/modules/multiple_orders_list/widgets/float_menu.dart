import 'package:pigu_seller/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../canceled_list_page.dart';
import '../delivered_list_page.dart';
import '../multiple_orders_list_page.dart';
import '../refused_list_page.dart';
import '../multiple_orders_list_controller.dart';

class FloatMenu extends StatelessWidget {
  final String click;
  final Function tapOnGoing;
  final Function tapRefused;
  final Function tapCanceled;
  final Function tapDelivered;

  FloatMenu(
      {Key key,
      this.click,
      this.tapOnGoing,
      this.tapRefused,
      this.tapCanceled,
      this.tapDelivered})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Modular.get<MultipleOrdersListController>();
    return Container(
        width: 200,
        height: 121,
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          controller.clickLabel == 'onGoing'
              ? Container()
              : InkWell(
                  onTap: () {
                    controller.setClickLabel('onGoing');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return MultipleOrdersListPage();
                    }));
                  },
                  child: FloatMenuButton(
                      title: "Em andamento", onTap: tapOnGoing)),
          controller.clickLabel == 'refused'
              ? Container()
              : InkWell(
                  onTap: () {
                    controller.setClickLabel('refused');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RefusedListPage();
                    }));
                  },
                  child:
                      FloatMenuButton(title: "Recusados", onTap: tapRefused)),
          controller.clickLabel == 'canceled'
              ? Container()
              : InkWell(
                  onTap: () {
                    controller.setClickLabel('canceled');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CanceledListPage();
                    }));
                  },
                  child:
                      FloatMenuButton(title: "Cancelados", onTap: tapCanceled)),
          controller.clickLabel == 'delivered'
              ? Container()
              : InkWell(
                  onTap: () {
                    controller.setClickLabel('delivered');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return DeliveredListPage();
                    }));
                  },
                  child:
                      FloatMenuButton(title: "Entregues", onTap: tapDelivered))
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
