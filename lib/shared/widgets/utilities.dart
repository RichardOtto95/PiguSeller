import 'package:flutter/cupertino.dart';

double wXD(double value, BuildContext context) {
  double _finalValue = MediaQuery.of(context).size.width * value / 360;
  return _finalValue;
}

double hXD(double value, BuildContext context) {
  double _finalValue = MediaQuery.of(context).size.height * value / 640;
  return _finalValue;
}

double maxHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double maxWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}
