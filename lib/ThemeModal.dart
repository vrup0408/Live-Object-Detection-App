import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:obj_detection_app/theme_shared_prefrences.dart';

class ThemeModal extends ChangeNotifier{
  late bool _isDark;
  late ThemeSharedPrefrences themeSharedPrefrences;
  bool get isDark => _isDark;

  ThemeModal(){
    _isDark=false;
    themeSharedPrefrences = ThemeSharedPrefrences();
    getThemePrefrences();
  }

  set isDark(bool value){
    _isDark = value;
    themeSharedPrefrences.setTheme(value);
    notifyListeners();
  }

  getThemePrefrences() async{
    _isDark = await themeSharedPrefrences.getTheme();
    notifyListeners();
  }
}