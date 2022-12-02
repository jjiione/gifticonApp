import 'dart:convert';
import 'package:gifticonapp/gifticonInfo.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'gifticonInfo.dart';
import 'package:http/http.dart' as http;
import 'dart:async';


class Updater extends ChangeNotifier{
  String userID='';
  String order='전체'; // 현 정렬 방식을 저장
  var gifticons=<GifticonInfo>[]; // main page에 나타낼 gifticons

  void setUser(String user){
    userID=user;
  }

  // dropdownbutton 정렬 방식 변경 시, API로 데이터 GET 요청
  // URL 수정
  void setPosts(){
    GifticonAPI().getData("http://54.180.193.160:8080/app/coupon/testuser").then((response){
      Iterable list=json.decode(response.body);
      gifticons=list.map((model)=>GifticonInfo.fromJson(model)).toList();
      orderPosts();
      notifyListeners();
    });
  }

  // 기프티콘 등록 시
  void addPosts(GifticonInfo gifticon){
    gifticons.insert(0, gifticon);
    orderPosts();
    notifyListeners();
  }

  // 기프티콘 수정 시
  void modifyPosts(GifticonInfo gifticon){
    int idx=gifticons.indexWhere((item) => item.id==gifticon.id);
    gifticons[idx]=gifticon;
    orderPosts();
    notifyListeners();
  }

  // 기프티콘 삭제 시
  void deletePosts(int id){
    gifticons.removeWhere((item) => item.id==id);
    orderPosts();
    notifyListeners();
  }

  // 기프티콘을 등록, 수정, 삭제 시 main page의 정렬 방식에 따라 다르게 표시함.
  void orderPosts(){
    if (order=="전체"){
      return;
    }else if (order=='기간 임박순'){
      gifticons.sort((a,b)=>a.date!.compareTo(b.date!));  // 기간 오름차순 (attribute는 임시값)
    }else if (order=='기간 많은순'){
      gifticons.sort((a,b)=>b.date!.compareTo(a.date!));
    }else if (order=='이름'){
      gifticons.sort((a,b)=>a.couponName!.compareTo(b.couponName!));
    }else if (order=='미사용'){
      gifticons.forEach((item)=>{
        print(item.isUsed)
      });
      gifticons=gifticons.where((item) => item.isUsed=='False').toList();
    }else if (order=='사용완료'){
      gifticons=gifticons.where((item) => item.isUsed=='True').toList();
    }
  }

  // 정렬 기준 저장
  void changeOrder(String standard){
    order=standard;
    notifyListeners();
  }
}