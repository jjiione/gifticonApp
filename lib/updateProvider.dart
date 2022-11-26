import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'post.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class Updater extends ChangeNotifier{
  String order='전체'; // 현 정렬 방식을 저장
  var posts=<Post>[]; // main page에 나타낼 gifticons

  // provider test func
  void initPosts(){
    posts=[];
    notifyListeners();
  }

  // dropdownbutton 정렬 방식 변경 시, API로 데이터 GET 요청
  void setPosts(){
    CallApi().getPostData().then((response){
      Iterable list=json.decode(response.body);
      posts=list.map((model)=>Post.fromJson(model)).toList();
      notifyListeners();
    });
  }

  // 기프티콘 등록 시
  void addPosts(Post post){
    posts.insert(0, post);
    orderPosts();
    notifyListeners();
  }

  // 기프티콘 수정 시
  void modifyPosts(Post newPost){
    int idx=posts.indexWhere((item) => item.id==newPost.id);
    posts[idx]=newPost;
    orderPosts();
    notifyListeners();
  }

  // 기프티콘 삭제 시
  void deletePosts(String id){
    posts.removeWhere((item) => item.id==id);
    orderPosts();
    notifyListeners();
  }

  // 기프티콘을 등록, 수정, 삭제 시 main page의 정렬 방식에 따라 다르게 표시함.
  void orderPosts(){
    if (order=="전체"){
      return;
    }else if (order=='기간 임박순'){
      posts.sort((a,b)=>a.id!.compareTo(b.id!));  // 기간 오름차순 (attribute는 임시값)
    }else if (order=='기간 많은순'){
      posts.sort((a,b)=>b.id!.compareTo(a.id!));
    }else if (order=='이름'){
      posts.sort((a,b)=>a.title!.compareTo(b.title!));
    }else if (order=='미사용'){
      posts=posts.where((item) => item.title=='미사용').toList();
    }else if (order=='사용완료'){
      posts=posts.where((item) => item.title=='사용완료').toList();
    }
  }

  // 정렬 기준 저장
  void changeOrder(String standard){
    order=standard;
    notifyListeners();
  }
}
