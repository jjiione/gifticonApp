import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gifticonapp/gifticonInfo.dart';
import 'package:gifticonapp/updateProvider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:gifticonapp/post.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Updater>(
      create:(_)=>Updater(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        initialRoute: '/',
        routes: {
          '/':(context)=>const MyHomePage(title: 'Gifticon App'),
          '/register':(context)=>RegisterPage(),
          '/gifticon':(context)=>GifticonPage(),

        },
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _rowCount=3;
  List<String> orderStdArr=['전체','기간 임박순','기간 많은순','이름','미사용','사용완료'];
  var posts=<Post>[];
  bool changed=false;
  @override
  void initState(){
    context.read<Updater>().setPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    var orderStd=context.watch<Updater>().order;
    var posts=context.watch<Updater>().posts;

    return Consumer<Updater>(
      builder: (context,update,child){
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        children: [
                          Text("Order by: "),
                          DropdownButton(items: orderStdArr.map((i)=> DropdownMenuItem(value:i,child: Text(i))).toList(),
                              hint:Text('$orderStd'),
                              onChanged: (value){
                            context.read<Updater>().changeOrder(value!);
                            if (value=='이름'){
                              context.read<Updater>().setPosts();
                            }else if (value=='기간 임박순'){
                              context.read<Updater>().initPosts();
                            }


                              }),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,0,2,0),
                            child: Text("Row Count: "),
                          ),
                          DropdownButton(items: List.generate(3,(i)=> DropdownMenuItem(value:i+2,child: Text("${i+2}"))),
                              hint: Text('$_rowCount'),
                              onChanged: (value){
                                setState(() {
                                  _rowCount=value!;
                                });
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Expanded(
                    child: GridView.count(crossAxisCount: _rowCount, shrinkWrap: true,
                        childAspectRatio: (itemWidth / itemHeight),
                        scrollDirection: Axis.vertical,
                        children: posts.map((post){
                          return Gifticon(remainDate:'${post.id}');
                        }).toList()
                    ),
                  ),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.pushNamed(context, '/register');
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add,size:40),
            backgroundColor: Colors.white,
            foregroundColor: Colors.red,
            shape: RoundedRectangleBorder(side: BorderSide(width: 2,color: Colors.red),borderRadius: BorderRadius.circular(100)),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      },
    );
  }
}

class Gifticon extends StatelessWidget {
  final String remainDate;
  Gifticon({this.remainDate='0'});

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(3),
        decoration:BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color:Colors.black.withOpacity(0.9),
        ),
        child: Container(
          margin: EdgeInsets.all(0.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  heightFactor: 1.2,
                  child: Container(
                    child: Image.network('https://picsum.photos/250?image=9'),
                    margin: EdgeInsets.only(bottom:20),
                    decoration:BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color:Colors.white,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: FractionallySizedBox(
                  widthFactor: 1,
                  heightFactor: 0.5,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("D-",style:TextStyle(color: Colors.white)),
                            Text("${remainDate}",style:TextStyle(color:Colors.red)),
                          ],
                        ),
                        Text("name",style:TextStyle(color:Colors.white)),
                      ],
                    ),
                ),
              ),
              ),
            ],
          ),
        ),
      ),
      onTap: (){
        Navigator.pushNamed(context, '/gifticon',arguments: GifticonInfo("id", "name", "img", DateTime(2022,10,7),3 ));
      },
    );
  }
}

// 쿠폰 등록 임시 페이지
class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register Page"),
        ),
        body:Center(
          child:ElevatedButton(onPressed: (){
          },child:const Text("update"))
        )
    );
  }
}

// 쿠폰 상세 임시 페이지
class GifticonPage extends StatelessWidget {
  const GifticonPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final info=ModalRoute.of(context)?.settings.arguments as GifticonInfo;
    return Scaffold(
      appBar: AppBar(
        title:Text("Gifticon Page"),
      ),
      body: Center(
        child:Text(info.id)
      ),
    );
  }
}



