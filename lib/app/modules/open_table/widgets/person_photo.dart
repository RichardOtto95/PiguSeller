import 'package:pigu_seller/app/modules/staff_list/staff_list_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PersonPhoto extends StatelessWidget {
  final double size;
  final double marRight;
  final double marLeft;
  final double marBottom;
  final avatar;
  final Function goTo;
  const PersonPhoto({
    this.goTo,
    this.avatar,
    Key key,
    this.size = 64.0,
    this.marRight = 20,
    this.marLeft = 20,
    this.marBottom = 8,
  }) : super(key: key);
//
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: goTo,
      child: Container(
          width: wXD(size, context),
          height: wXD(size, context),
          margin: EdgeInsets.only(bottom: marBottom, right: marRight),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(90),
            border: Border.all(width: 3.0, color: const Color(0xffbdaea7)),
            boxShadow: [
              BoxShadow(
                color: const Color(0x29000000),
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: avatar != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: avatar,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Image.asset('assets/img/defaultUser.png'),
                  ),
                )),
    );
  }
}
