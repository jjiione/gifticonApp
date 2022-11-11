import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gifticonapp/gifticonInfo.dart';

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
      initialRoute: '/',
      routes: {
        '/':(context)=>const MyHomePage(title: 'Gifticon App'),
        '/register':(context)=>RegisterPage(),
        '/gifticon':(context)=>GifticonPage(),

      },
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;
  int _rowCount=3;
  String _orderStd='전체';
  List<String> orderStdArr=['전체','기간 임박순','기간 많은 순','이름','미사용','사용완료'];
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
          Navigator.pushNamed(context, '/register');
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
        Navigator.pushNamed(context, '/gifticon',arguments: GifticonInfo("id", "name", "img", DateTime(2022,10,7),3 ));
      },
    );
  }
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register Page"),
        ),
        body:Center(
          child:Text("Register Page")
        )
    );
  }
}

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



