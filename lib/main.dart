import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
<<<<<<< Updated upstream
import 'package:gifticonapp/gifticonInfo.dart';
=======
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'provider_class.dart';
import 'package:http/http.dart';


// image crop을 사용하기 위해,
// android >> app >> src >> main >> AndroidManifest의 맨 하단 부근에,

/*
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        의 바로 밑에,
       <activity
           android:name="com.yalantis.ucrop.UCropActivity"
           android:screenOrientation="portrait"
           android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>
           를 붙여넣을것.
 */

// google_ml_kit를 사용하기 위해,
// android >> app >> src >> build.gradle에
// defaultConfig의 minSdkVersion을 21로 변경하고,
// 맨 하단의 dependencies에 다음 코드를 입력
// implementation 'com.google.mlkit:text-recognition-korean:16.0.0-beta5'
>>>>>>> Stashed changes

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => image_data(),
      builder: (context, child) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
<<<<<<< Updated upstream
      initialRoute: '/',
      routes: {
        '/':(context)=>const MyHomePage(title: 'Gifticon App'),
        '/register':(context)=>RegisterPage(),
        '/gifticon':(context)=>GifticonPage(),

      },
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
=======
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
=======
  final name_controller = TextEditingController();
  final brand_controller = TextEditingController();
  String? register_name;
  String? register_brand;
  String? register_date;
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
          Navigator.pushNamed(context, '/register');
=======
          showDialog(context: context, builder: (context)=>AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)), title: Text("RegisterImage"),
              content:
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                      child: Stack(
                        children: [
                          InkWell(
                            child: CircleAvatar(
                              radius: 80,
                              //backgroundImage: AssetImage('assets/basic.jpg'),
                              // backgroundImage: context.watch<image_data>().image == null
                              //   ? AssetImage('assets/basic.jpg')
                              //   : FileImage(File(context.watch<image_data>().image!.path)) as ImageProvider,
                              child: context.watch<image_data>().image == null
                                  ? Image.asset('assets/basic.jpg')
                                  : Image.file(context.watch<image_data>().image!),
                            ),
                            onTap: (){ showModalBottomSheet(context: context, builder: ((builder)=>bottomSheet()));},
                          )
                        ],
                      )
                    ),
                      SizedBox(height: 15),
                      TextField(
                        decoration: InputDecoration(
                          hintText: '쿠폰이름',
                          border: UnderlineInputBorder(),
                        ),
                        controller: name_controller,
                        onChanged: (value) {
                          //register_name = value;
                          register_name = name_controller.text;
                          print('register_name is : ');
                          print(register_name);
                        },
                      ),
                      SizedBox(height: 15),
                      TextField(
                        decoration: InputDecoration(
                          hintText: '브랜드이름',
                          border: UnderlineInputBorder(),
                        ),
                        controller: brand_controller,
                        onChanged: (value) {
                          //register_name = value;
                          register_brand = brand_controller.text;
                          print('register_brand is : ');
                          print(register_brand);
                        },
                      ),
                      SizedBox(height: 15,),

                      context.watch<image_data>().read_date == null
                          ? Text('유효기간 : null')
                          : Text('유효기간 : ${context.watch<image_data>().read_date}'),
                      ElevatedButton(onPressed: (){
                        context.read<image_data>().read_date;
                        context.read<image_data>().image;
                        context.read<image_data>().read_name;
                        register_date = context.read<image_data>().read_date;
                        print("send register_name : ${register_name}");
                        print("send register_brand : $register_brand");
                        print("send register_date : ${context.read<image_data>().parsed_date}");
                        print("send image : ${context.read<image_data>().image!.path.toString()}");

                        // "brand": "string",
                        // "couponName": "string",
                        // "date": "string",
                        // "id": 0,
                        // "imageUrl": "string",
                        // "isUsed": "string",
                        // "timer": 0,
                        // "user": "string"

                        //send to db.

                        Navigator.pop(context);
                      }, child: Text("Enter", style: TextStyle(fontSize: 20),))
                    ],
                  ),
                ),
          )
          );
>>>>>>> Stashed changes
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add,size:40),
        backgroundColor: Colors.white,
        foregroundColor: Colors.red,
        shape: RoundedRectangleBorder(side: BorderSide(width: 2,color: Colors.red),borderRadius: BorderRadius.circular(100)),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
<<<<<<< Updated upstream
}

class Gifticon extends StatelessWidget {
  final String remainDate;
  Gifticon({this.remainDate='0'});
=======
  Widget imageShow(){
    return Center(
        child: Stack(
          children: [
            InkWell(
              child: CircleAvatar(
                radius: 80,
                //backgroundImage: AssetImage('assets/basic.jpg'),
                backgroundImage: context.watch<image_data>().image == null
                    ? AssetImage('assets/basic.jpg')
                    : FileImage(File(context.watch<image_data>().image!.path)) as ImageProvider,
              ),
              onTap: (){ showModalBottomSheet(context: context, builder: ((builder)=>bottomSheet()));},
            )
          ],
        )
    );
  }
  Widget bottomSheet(){
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
                  onPressed: () async {
                    await context.read<image_data>().getImage(ImageSource.camera);
                    context.read<image_data>().crop_image();

                  },
                  label: Text('Camera', style: TextStyle(fontSize: 20))
              ),
              TextButton.icon(
                  icon: Icon(Icons.photo_library, size: 50),
                  onPressed: () async {
                    await context.read<image_data>().getImage(ImageSource.gallery);
                    await context.read<image_data>().crop_image();
                    await context.read<image_data>().textDetect();
                    if (!mounted) return;

                    String? barcode_id;
                    String? expire_date;
                    //한글이 있는지, 없는지?
                    final regExp = RegExp('[가-힣]+');
                    String temp_text = '한글글';

                    if (regExp.hasMatch(temp_text)){
                      //한글인경우
                      //숫자로 parsing이 되는지 확인해서 숫자가 있으면
                      //해당 element를 숫자로만 된걸로 대체.
                    }


                    // Navigator.push(context,
                    //     MaterialPageRoute(
                    //         builder:
                    //             (context)=>MlResultPage(ml_result: context.read<image_data>().ml_result,
                    //               image: context.read<image_data>().image,)
                    //     )
                    // );

                  },
                  label: Text('Gallery', style: TextStyle(fontSize: 20))
              ),
            ],
          )

        ],
      ),
    );
  }
}

class MlResultPage extends StatefulWidget {
  MlResultPage({Key? key, this.image, this.ml_result}) : super(key: key);
  File? image;
  String? ml_result;

  @override
  State<MlResultPage> createState() => _MlResultPageState(ml_result:ml_result);
}

class _MlResultPageState extends State<MlResultPage> {
  _MlResultPageState({this.image, this.ml_result});
  File? image;
  String? ml_result;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ml_Result Page'),
      ),
      body: Center(
        child: Column(
          children: [
            /*
            Container(
                constraints: const BoxConstraints(
                  minHeight: 100,
                  minWidth: 100,
                  maxHeight: 200,
                  maxWidth: 200,
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                    child: image == null
                        ? Text('')
                        : Image.file(File(image!.path)))
            ),
            */
            Text(ml_result!),
          ],
        ),
      ),
    );
  }
}

class Gifticon extends StatefulWidget {
  String remainDate;
  Gifticon({required this.remainDate, Key? key}) : super(key: key);
  @override
  State<Gifticon> createState() => _GifticonState();
}
>>>>>>> Stashed changes

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



