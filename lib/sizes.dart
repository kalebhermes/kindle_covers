import 'package:flutter/material.dart';

bool isExtraLargeScreen(BuildContext context) {
  return MediaQuery.of(context).size.width > 1920.0;
}

bool isLargeScreen(BuildContext context) {
  return MediaQuery.of(context).size.width > 1280.0;
}

bool isMediumScreen(BuildContext context) {
  return MediaQuery.of(context).size.width > 800.0;
}
