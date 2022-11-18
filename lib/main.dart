import 'package:flutter/material.dart';
import 'dart:io';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  String _orderStd='전체';
  List<String> orderStdArr=['전체','기간 임박순','기간 많은 순','이름','미사용','사용완료'];


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

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
                          hint:Text('$_orderStd'),
                          onChanged: (value){
                            setState(() {
                              _orderStd=value!;
                            });
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
                  children: [
                    Gifticon(remainDate: '3',),
                    Gifticon(remainDate: '4',),
                    Gifticon(remainDate: '27',),
                    Gifticon(remainDate: '30',),
                    Gifticon(remainDate: '100',),
                    Gifticon(remainDate: '3123',),
                    Gifticon(remainDate: '32',),
                    Gifticon(remainDate: '28',),
                    Gifticon(remainDate: '1',),
                  ],),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(context: context, builder: (context)=>AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)), title: Text("RegisterImage"),
              content:
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  imageShow(),
                  SizedBox(height: 30),
                  Text("chicken"),
                  SizedBox(height: 30),
                  Text("2022/11/07")
                ],
              )
          )
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add,size:40),
        backgroundColor: Colors.white,
        foregroundColor: Colors.red,
        shape: RoundedRectangleBorder(side: BorderSide(width: 2,color: Colors.red),borderRadius: BorderRadius.circular(100)),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
        showDialog(context: context, builder: (context)=>AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)), title: Text("ShowImage"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('imgs/flutter_image.png', width: 60, height:120),
              SizedBox(height:20),
              Text("이름"),
              SizedBox(height:20),
              Text("유효기한"),
              SizedBox(height:20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children:[ElevatedButton(onPressed: (){}, child: Text("사용완료")),
                SizedBox(width:10),
                ElevatedButton(onPressed: (){}, child: Text("수정")), SizedBox(width: 10),
                ElevatedButton(onPressed: (){

                }, child: Text("삭제"),)],),
            ],
          ),
        ),
        );
      },
    );
  }

}

class imageShow extends StatefulWidget {
  const imageShow({Key? key}) : super(key: key);

  @override
  State<imageShow> createState() => _imageShowState();
}

class _imageShowState extends State<imageShow> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(
          children: [
            InkWell(
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.white54,
              ),
              onTap: (){ showModalBottomSheet(context: context, builder: ((builder)=>bottomSheet()));},
            )
          ],
        )
    );
  }
}

class bottomSheet extends StatefulWidget {
  const bottomSheet({Key? key}) : super(key: key);

  @override
  State<bottomSheet> createState() => _bottomSheetState();
}

class _bottomSheetState extends State<bottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text('Choose Photo', style: TextStyle(fontSize: 20)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                  icon: Icon(Icons.camera, size: 50),
                  onPressed: (){

                  },
                  label: Text('Camera', style: TextStyle(fontSize: 20))
              ),
              TextButton.icon(
                  icon: Icon(Icons.photo_library, size: 50),
                  onPressed: (){

                  },
                  label: Text('Gallery', style: TextStyle(fontSize: 20))
              )
            ],
          )

        ],
      ),
    );
  }

}



