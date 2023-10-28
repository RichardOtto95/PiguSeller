import 'package:pigu_seller/app/core/models/seller_model.dart';
import 'package:pigu_seller/app/core/services/auth/auth_controller.dart';
import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/app/modules/user_profile/widgets/card_seller.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:pigu_seller/shared/widgets/empty_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'establishment_controller.dart';

class EstablishmentPage extends StatefulWidget {
  final SellerModel seller;
  const EstablishmentPage({Key key, this.seller}) : super(key: key);

  @override
  _EstablishmentPageState createState() => _EstablishmentPageState();
}

class _EstablishmentPageState
    extends ModularState<EstablishmentPage, EstablishmentController> {
  final homeController = Modular.get<HomeController>();
  final authController = Modular.get<AuthController>();

  var primaryColor = Color.fromRGBO(254, 214, 165, 1);
  var darkPrimaryColor = Color.fromRGBO(249, 153, 94, 1);
  var lightPrimaryColor = Color.fromRGBO(246, 183, 42, 1);
  var primaryText = Color.fromRGBO(22, 16, 18, 1);
  var secondaryText = Color.fromRGBO(84, 74, 65, 1);
  var accentColor = Color.fromRGBO(114, 74, 134, 1);
  var divisorColor = Color.fromRGBO(189, 174, 167, 1);
  int lastOrientation = -1;
  var stateButton = false;
  var fav;
  DocumentSnapshot sellds;
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var orientationn = MediaQuery.of(context).orientation.index;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Modular.to.pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: ColorTheme.primaryColor,
          ),
        ),
        backgroundColor: ColorTheme.white,
        elevation: 0,
      ),
      backgroundColor: ColorTheme.white,
      body: SingleChildScrollView(
          child: orientationn == Orientation.landscape.index
              ? Container(
                  height: 600,
                  child: body(orientationn, context),
                )
              : Container(
                  height: MediaQuery.of(context).size.height - 100,
                  child: body(orientationn, context))),
    ));
  }

  Widget body(int orientation, context) {
    double wXD(double size, BuildContext context) {
      double finalSize = MediaQuery.of(context).size.width * size / 375;
      return finalSize;
    }

    return Stack(
      children: <Widget>[
        StreamBuilder(
          stream: Firestore.instance
              .collection('sellers')
              .document(homeController.sellerId)
              .snapshots(),
          builder: (context, snapshot) {
            DocumentSnapshot ds = snapshot.data;

            if (ds.exists) {
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: ColorTheme.white,
                    height: wXD(400, context),
                    child: CardSeller(
                      avatar: ds.data['avatar'],
                      address: ds.data['address'],
                      backgroundImage: ds.data['bg_image'],
                      orientation: '',
                      name: ds.data['name'],
                    ),
                  ),
                  Spacer(),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(bottom: wXD(40, context)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                homeController.setRouterMenu('seller-profile');
                                Modular.to.pushNamed('menu-list');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child:
                                        Image.asset("assets/icon/menuOpen.png"),
                                    width: wXD(50, context),
                                    height: wXD(50, context),
                                  ),
                                  SizedBox(
                                    width: wXD(10, context),
                                  ),
                                  Text("Ver",
                                      style: TextStyle(
                                          color: ColorTheme.textColor,
                                          fontSize: wXD(22, context),
                                          fontWeight: FontWeight.w300)),
                                  SizedBox(
                                    width: wXD(10, context),
                                  ),
                                  Text("menu",
                                      style: TextStyle(
                                          color: ColorTheme.textColor,
                                          fontSize: wXD(22, context),
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              );
            } else if (!ds.exists) {
              return Column(
                children: [
                  Spacer(
                    flex: 1,
                  ),
                  EmptyStateList(
                    image: 'assets/img/empty_list.png',
                    title: 'Estabelecimento ainda não cadastrado.',
                    description:
                        'Entre em contato com o suporte para inclusão no sistema.',
                  ),
                  Spacer(
                    flex: 2,
                  )
                ],
              );
            } else {
              return Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
              ));
            }
          },
        ),
      ],
    );
  }
}
