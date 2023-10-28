import 'package:pigu_seller/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MesainfoAppbar extends StatelessWidget {
  var primaryColor = Color.fromRGBO(254, 132, 0, 1);
  var darkPrimaryColor = Color.fromRGBO(249, 153, 94, 1);
  var lightPrimaryColor = Color.fromRGBO(246, 183, 42, 1);
  var primaryText = Color.fromRGBO(22, 16, 18, 1);
  var secondaryText = Color.fromRGBO(84, 74, 65, 1);
  var accentColor = Color.fromRGBO(114, 74, 134, 1);
  var divisorColor = Color.fromRGBO(189, 174, 167, 1);
  final String title;
  final String imageURL;
  final Function iconOnTap;
  final Icon iconButton;
  final Function goToTableInfo;
  var mesaName = "Gordice";

  MesainfoAppbar(
      {Key key,
      this.title,
      this.imageURL,
      this.iconOnTap,
      this.iconButton,
      this.goToTableInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var styleMenu = TextStyle(fontSize: 12, color: Colors.grey[600]);
    List menuOption = [
      Text('Mudar Anfitrião', style: styleMenu),
      Text('Arquivar mesa', style: styleMenu),
      Text('Remover Participante', style: styleMenu),
      Text('Silenciar Notificações', style: styleMenu),
      Text('Adicionar Participantes', style: styleMenu),
    ];
    return Container(
      height: 57,
      color: ColorTheme.primaryColor,
      child: Row(
        children: [
          SizedBox(
            width: 16,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              'assets/icon/back.png',
              height: 36,
              width: 36,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: goToTableInfo,
            child: Container(
              width: 50.0,
              height: 50.0,
              margin: EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                border: Border.all(width: 3.0, color: Color(0xff95A5A6)),
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
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: imageURL,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: Color(0xfffafafa),
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ),
          ),
          (iconOnTap != null)
              ? (iconButton != null)
                  ? InkWell(onTap: iconOnTap, child: iconButton)
                  : Icon(
                      Icons.favorite_border,
                      color: Color(0xfffafafa),
                    )
              : Container(),
          SizedBox(
            width: 30,
          ),
        ],
      ),
    );
  }
}
