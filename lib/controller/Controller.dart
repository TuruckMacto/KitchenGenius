import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController{

    RxBool isDarkTheme = false.obs;

   ThemeMode get theme => Get.isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void switchTheme(ThemeMode mode) {
    Get.changeThemeMode(mode);
  }

}
