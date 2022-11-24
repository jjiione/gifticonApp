import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
class Updater extends ChangeNotifier{
  bool isChanged=true;

  // register or update gifticons

  void update(){
    isChanged=!isChanged;
    notifyListeners();
  }
}