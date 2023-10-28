import 'package:pigu_seller/app/modules/home/home_controller.dart';
import 'package:pigu_seller/app/modules/menu_list/widgets/horizontal_item.dart';
import 'package:pigu_seller/app/modules/menu_list/widgets/item_menu.dart';
import 'package:pigu_seller/app/modules/menu_list/widgets/menu_slide.dart';
import 'package:pigu_seller/app/modules/staff_list/staff_list_page.dart';
import 'package:pigu_seller/shared/color_theme.dart';
import 'package:pigu_seller/shared/widgets/empty_state.dart';
import 'package:pigu_seller/shared/widgets/navbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'menu_list_controller.dart';

class MenuListPage extends StatefulWidget {
  final String title;
  const MenuListPage({Key key, this.title = "MenuList"}) : super(key: key);

  @override
  _MenuListPageState createState() => _MenuListPageState();
}

class _MenuListPageState
    extends ModularState<MenuListPage, MenuListController> {
  final homeController = Modular.get<HomeController>();

  bool click = false;
  bool clickItem = false;
  String item;

  CarouselController _controller;
  CarouselController _controller2;
  String sellerCategory;
  Future<dynamic> _task;
  List arrayAux = [];
  num listings = 0;
  String sellId;
  num highlindex;

  @override
  void initState() {
    super.initState();

    _controller = new CarouselController();
    _controller2 = new CarouselController();
    setSeller();
    _task = getListing();

    super.initState();
  }

  setSeller() async {
    DocumentSnapshot user = await Firestore.instance
        .collection('users')
        .document(homeController.user.uid)
        .get();
    QuerySnapshot _listings = await Firestore.instance
        .collection('listings')
        .where("seller_id", isEqualTo: user.data['seller_id'])
        .getDocuments();
    setState(() {
      sellId = user.data['seller_id'];
      homeController.setSellerId(sellId);
      listings = _listings.documents.length;
      // print(
      //     'liiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiistingslistingslistings:::::: $listings');
    });
  }

  Future<dynamic> getListing() async {
    QuerySnapshot _listing = await Firestore.instance
        .collection("listings")
        .where('seller_id', isEqualTo: homeController.sellerId)
        .getDocuments();

    _listing.documents.forEach((element) {
      arrayAux.add(element.data);
    });

    arrayAux.asMap().forEach((i, element) async {
      DocumentSnapshot _sellerCategory = await Firestore.instance
          .collection("sellers")
          .document(homeController.sellerId)
          .collection("categories")
          .document(element['category_id'])
          .get();
      setState(() {
        element['highlindex'] = _sellerCategory.data['highlindex'];
        element['status'] = _sellerCategory.data['label'];
      });
      // print('arrayAux : $element');
    });
    await Future.delayed(Duration(seconds: 1));

    arrayAux.sort((a, b) {
      return a['highlindex'].compareTo(b['highlindex']);
    });
    arrayAux.forEach((element) {
      // print('arrayAux: ${element['title_ptbr']} status :${element['status']}');
    });
    return arrayAux;
  }

  Widget finalItem(int lenght, int index) {
    index++;
    if (index == lenght) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.05,
      );
    } else {
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // print('%%%%%%%% VALORES: ${size.height}, ${size.width} %%%%%%%%%%');

    // print('arrayAuxarrayAuxarrayAuxarrayAuxarrayAux : $arrayAux');
    // print('sellIdsellIdsellIdsellIdsellIdsellIdsellId    :$sellId');
    return WillPopScope(onWillPop: () {
      // homeController.setRouterMenu(null);
      // setState(() {
      //   click = !click;
      // });
      Modular.to.pop();
    }, child: Observer(builder: (_) {
      return Scaffold(
        backgroundColor: Color(0xffFAFAFA),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                  stream: Firestore.instance
                      .collection('sellers')
                      .where('id', isEqualTo: homeController.sellerId)
                      .snapshots(),
                  builder: (context, snapshotSeller) {
                    if (sellId == null || sellId != null && listings == 0) {
                      return NavTableBar(
                        haveImage: false,
                        title: '',
                        imageURL: '',
                      );
                    } else {
                      QuerySnapshot qs = snapshotSeller.data;
                      return NavTableBar(
                        haveImage: false,
                        title: qs.documents[0].data['name'],
                        imageURL: qs.documents[0].data['avatar'],
                      );
                    }
                  }),
              (sellId == null || sellId != null && listings == 0)
                  ? Expanded(
                      child: Column(
                        children: [
                          Spacer(
                            flex: 1,
                          ),
                          EmptyStateList(
                            image: 'assets/img/empty_list.png',
                            title: 'Menu ainda não cadastrado.',
                            description:
                                'Entre em contato com o suporte para inclusão no sistema.',
                          ),
                          Spacer(
                            flex: 2,
                          )
                        ],
                      ),
                    )
                  : (sellId != null && listings != 0)
                      ? Expanded(
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: size.width * .055,
                                        top: 15,
                                        bottom: 9),
                                    child: Text(
                                      "Sugestões",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: size.height * .023,
                                        color: ColorTheme.textColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Container(
                                    width: size.width,
                                    height: size.height * 0.3,
                                    child: StreamBuilder(
                                        stream: Firestore.instance
                                            .collection("listings")
                                            .where('seller_id',
                                                isEqualTo:
                                                    homeController.sellerId)
                                            .where('highlighted',
                                                isEqualTo: true)
                                            // !!!!!!!!!!ATENÇÃO se o seller_id estiver null ele trará todos os itens que tem o highlighted igual a true!!!!!!!!!!.
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Container();
                                          } else {
                                            return new ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemCount: snapshot
                                                    .data.documents.length,
                                                itemBuilder: (context, index) {
                                                  int count = snapshot
                                                      .data.documents.length;
                                                  DocumentSnapshot ds = snapshot
                                                      .data.documents[index];
                                                  Widget finalItem(
                                                      int lenght, int index) {
                                                    index++;
                                                    if (index == lenght) {
                                                      return SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                      );
                                                    } else {
                                                      return SizedBox();
                                                    }
                                                  }

                                                  return Row(
                                                    children: [
                                                      SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.05),
                                                      new InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            item = ds['id'];
                                                            // print(
                                                            //     'item : $item');

                                                            controller
                                                                .setclickItem(
                                                                    !clickItem);
                                                          });
                                                        },
                                                        child: ItemMenu(
                                                            image: ds['image'],
                                                            name: ds['label'],
                                                            note: ds[
                                                                'description'],
                                                            price:
                                                                formatedCurrency(
                                                                    ds['price'])),
                                                      ),
                                                      finalItem(count, index)
                                                    ],
                                                  );
                                                });
                                          }
                                        }),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    height: 1,
                                    color: ColorTheme.textGray,
                                  ),
                                  // comeco do menu
                                  StreamBuilder(
                                      stream: Firestore.instance
                                          .collection("sellers")
                                          .document(homeController.sellerId)
                                          .collection('categories')
                                          .orderBy('highlindex',
                                              descending: false)
                                          .snapshots(),
                                      builder: (context, snapshotCategories) {
                                        if (!snapshotCategories.hasData) {
                                          return Container();
                                        } else {
                                          return new Container(
                                              // width: wXD(375, context),
                                              // height: 47,
                                              height: wXD(40, context),
                                              child: CarouselSlider.builder(
                                                options: CarouselOptions(
                                                    height: wXD(50, context),
                                                    enlargeCenterPage: true,
                                                    enableInfiniteScroll: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    autoPlay: false,
                                                    viewportFraction: .3,
                                                    aspectRatio: 10.0,
                                                    initialPage: 0,
                                                    onScrolled: (adsa) {
                                                      // print('entrou: $adsa ');
                                                    },
                                                    onPageChanged:
                                                        (index, reason) {
                                                      snapshotCategories
                                                          .data.documents
                                                          .asMap()
                                                          .forEach(
                                                              (i, element) {
                                                        if (element.data[
                                                                'highlindex'] !=
                                                            highlindex) {
                                                        } else {
                                                          _controller2.animateToPage(
                                                              i,
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      300));
                                                        }
                                                      });
                                                    }),
                                                carouselController:
                                                    _controller2,
                                                itemCount: snapshotCategories
                                                    .data.documents.length,
                                                itemBuilder: (context, index,
                                                    realIndex) {
                                                  return InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          highlindex =
                                                              snapshotCategories
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data[
                                                                  'highlindex'];
                                                        });
                                                        snapshotCategories
                                                            .data.documents
                                                            .asMap()
                                                            .forEach(
                                                                (i, element) {
                                                          if (element.data[
                                                                  'highlindex'] ==
                                                              highlindex) {
                                                            _controller2.animateToPage(
                                                                i,
                                                                curve:
                                                                    Curves.ease,
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        300));
                                                            for (var i = 0;
                                                                i <
                                                                    arrayAux
                                                                        .length;
                                                                i++) {
                                                              //ANIMAÇÃO DA LISTA DE PRODUTOS
                                                              if (arrayAux[i][
                                                                      'highlindex'] ==
                                                                  highlindex) {
                                                                _controller.animateToPage(i,
                                                                    curve: Curves
                                                                        .ease,
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            300));
                                                                break;
                                                              }
                                                            }
                                                          }
                                                        });
                                                      },
                                                      child: Container(
                                                        height:
                                                            wXD(30, context),
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                bottom: BorderSide(
                                                                    width: 2.0,
                                                                    color: highlindex ==
                                                                            snapshotCategories.data.documents[index].data[
                                                                                'highlindex']
                                                                        ? ColorTheme
                                                                            .primaryColor
                                                                        : Color(
                                                                            0xffFAFAFA)))),
                                                        child: Center(
                                                          child: Text(
                                                            "${snapshotCategories.data.documents[index].data['label']}",
                                                            // 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize:
                                                                  size.width *
                                                                      .035,
                                                              // fontSize: 14,
                                                              color: highlindex ==
                                                                      snapshotCategories
                                                                              .data
                                                                              .documents[
                                                                                  index]
                                                                              .data[
                                                                          'highlindex']
                                                                  ? ColorTheme
                                                                      .darkCyanBlue
                                                                  : ColorTheme
                                                                      .textGray,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                            // overflow:
                                                            //     TextOverflow
                                                            //         .ellipsis,
                                                          ),
                                                        ),
                                                      ));
                                                },
                                              ));
                                        }
                                      }),
                                  Expanded(
                                    child: FutureBuilder(
                                        future: _task,
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Container();
                                          } else {
                                            return Container(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                child: CarouselSlider.builder(
                                                  itemCount:
                                                      snapshot.data.length,
                                                  itemBuilder: (context, index,
                                                      realIndex) {
                                                    var ds =
                                                        snapshot.data[index];
                                                    return HorizontalItem(
                                                      title: ds['label'],
                                                      note: ds['description'],
                                                      // price: ds['price'].toString(),
                                                      price: formatedCurrency(
                                                          ds['price']),
                                                      onTap: () {
                                                        setState(() {
                                                          item = ds['id'];
                                                          // print('item : $item');

                                                          controller
                                                              .setclickItem(
                                                                  !clickItem);
                                                        });
                                                      },
                                                    );
                                                  },
                                                  options: CarouselOptions(
                                                      scrollDirection: Axis
                                                          .vertical,
                                                      autoPlay: false,
                                                      viewportFraction: 0.2,
                                                      autoPlayInterval:
                                                          Duration(
                                                              milliseconds:
                                                                  300),
                                                      aspectRatio: 2.0,
                                                      initialPage: 1,
                                                      onPageChanged:
                                                          (index, reason) {
                                                        var ds = snapshot
                                                            .data[index];
                                                        if (highlindex !=
                                                            ds['highlindex']) {
                                                          setState(() {
                                                            highlindex = ds[
                                                                'highlindex'];
                                                          });
                                                          _controller2.animateToPage(
                                                              index,
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      300));
                                                        }
                                                      }),
                                                  carouselController:
                                                      _controller,
                                                ));
                                          }
                                        }),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: controller.clickItem,
                                child: Stack(
                                  children: [
                                    Positioned(
                                        // bottom: 0,
                                        child: StreamBuilder(
                                      stream: Firestore.instance
                                          .collection('listings')
                                          .where('seller_id',
                                              isEqualTo:
                                                  homeController.sellerId)
                                          .where('id', isEqualTo: item)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Container();
                                        } else {
                                          QuerySnapshot df = snapshot.data;
                                          return MenuSlide(
                                            onTap: () {
                                              setState(() {
                                                controller.setclickItem(false);
                                              });
                                            },
                                            name: df.documents[0].data['label'],
                                            note: df.documents[0]
                                                .data['description'],
                                            image:
                                                df.documents[0].data['image'],
                                          );
                                        }
                                      },
                                    )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(ColorTheme.yellow),
                          ),
                        )
            ],
          ),
        ),
      );
      // }
      // });
    }));
  }
}

class BlankItem extends StatelessWidget {
  const BlankItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      height: wXD(85, context),
    );
  }
}

String formatedCurrency(var value) {
  var newValue = new NumberFormat("#,##0.00", "pt_BR");
  return newValue.format(value);
}
