import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'provider_class.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

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
      builder : (context, child) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  String _orderStd='전체';
  List<String> orderStdArr=['전체','기간 임박순','기간 많은 순','이름','미사용','사용완료'];
  String imageUrl='';
  String isUsed='';
  int timer=0;
  String user='';
  final name_controller = TextEditingController();
  final brand_controller = TextEditingController();
  String? register_name;
  String? register_brand;
  String? register_date;
  final List<PlatformFile> _files = [];

  // 파일 업로드 함수
  void _pickFiles() async {
    List<PlatformFile>? uploadedFiles = (await FilePicker.platform.pickFiles(
      allowMultiple: true,
    ))?.files;
    setState(() {
      for (PlatformFile file in uploadedFiles!) {
        _files.add(file);
      }
    });
    print(_files);
  }

  Future<int> _uploadToSignedURL(
      {required PlatformFile file, required String url}) async {
    print(file);
    http.Response response = await http.put(Uri.parse(url), body: file.bytes);

    return response.statusCode;

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
        onPressed: () {
          showDialog(context: context, builder: (context) =>
              AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                title: Text("RegisterImage"),
                content:
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            InkWell(
                              child: CircleAvatar(radius: 80,
                                child: context
                                    .watch<image_data>()
                                    .image == null ? Image.asset(
                                    'assets/basic.jpg') : Image.file(context
                                    .watch<image_data>()
                                    .image!),),
                              onTap: () {
                                showModalBottomSheet(context: context,
                                    builder: ((builder) => bottomSheet()));
                              },
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

                            context
                                .watch<image_data>()
                                .read_date == null
                                ? Text('유효기간 : null')
                                : Text('유효기간 : ${context
                                .watch<image_data>()
                                .read_date}'),
                            ElevatedButton(onPressed: () async {
                              var dio = Dio();
                              final response_post = await dio.post(
                                  'http://54.180.193.160:8080/app/image/set/fileName',
                                  data: {
                                    "fileName": context
                                        .read<image_data>()
                                        .image!
                                        .path
                                        .toString()
                                  });
                              final response_get = await dio.get(
                                  'http://54.180.193.160:8080/app/image/set/fileName');
                              var image_setting = response_get.data.toString();

                              final response_posturl = await dio.post(
                                  'http://54.180.193.160:8080/app/image/post/preSignedUrl',
                                  data: {
                                    "url": image_setting
                                  });
                              imageUrl = response_posturl.data.toString();
                              child:
                              ElevatedButton(
                                onPressed: () {
                                  _uploadToSignedURL(
                                      file: _files.elementAt(0),
                                      url: imageUrl
                                  );
                                },
                                child: const Text("Upload to S3"),
                              );
                              final response = await dio.post(
                                  'http://54.180.193.160:8080/app/coupon/register',
                                  data: {
                                    "brand": "${register_brand}",
                                    "couponName": "${register_name}",
                                    "date": "${context
                                        .watch<image_data>()
                                        .read_date}",
                                    "imageUrl": imageUrl,
                                    "isUsed": "False",
                                    "timer": 10,
                                    "user": "testuser"
                                  });
                              Navigator.pop(context);
                            },
                                child: Text(
                                  "Enter", style: TextStyle(fontSize: 20),))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
          );
        },

        child: const Icon(Icons.add,size:40),
        backgroundColor: Colors.white,
        foregroundColor: Colors.red,
        shape: RoundedRectangleBorder(side: BorderSide(width: 2,color: Colors.red),borderRadius: BorderRadius.circular(100)),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
                  onPressed: () async{
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
              )
            ],
          )

        ],
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

class _GifticonState extends State<Gifticon> {
  bool exist=true;
  bool delete=false;
  TextEditingController tecname=TextEditingController();
  TextEditingController tecdate=TextEditingController();
  String name='';
  String date='';
  @override
  Widget build(BuildContext context) {
    String remainDate=widget.remainDate;
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
                        Text("${name}",style:TextStyle(color:Colors.white)),
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
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(radius: 100, backgroundImage: AssetImage("assets/basic.jpg")),
                  SizedBox(height: 20),
                  Text("이름"),
                  SizedBox(height: 20),
                  Text("${name}"),
                  SizedBox(height: 20),
                  Text("유효기한"),
                  SizedBox(height: 20),
                  Text("${date}"),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [ElevatedButton(onPressed: () {
                      exist = false;

                      Navigator.pop(context);
                    }, child: Text("사용완료")),
                      SizedBox(width: 10),
                      ElevatedButton(onPressed: () {
                        showDialog(context: context, builder: (context) =>
                            AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              title: Text("수정"),
                              content: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text("이름"),
                                      Expanded(child: TextField(
                                        controller: tecname,))
                                    ],
                                  ),
                                  SizedBox(height: 30),
                                  Row(
                                    children: [
                                      Text("유효기한"),
                                      Expanded(
                                          child: TextField(controller: tecdate))
                                    ],
                                  ),
                                  SizedBox(height: 50),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(onPressed: () {
                                        setState(() {
                                          name = tecname.text;
                                          date = tecdate.text;
                                        });
                                        Navigator.pop(context);
                                      },
                                          child: Text("Enter",
                                            style: TextStyle(fontSize: 20),))
                                    ],
                                  )
                                ],
                              ),
                            ),);
                      }, child: Text("수정")), SizedBox(width: 10),
                      ElevatedButton(onPressed: () {
                        delete = true;
                        Navigator.pop(context);
                      }, child: Text("삭제"),),
                    ],),
                ],
              );
            }
          ),
        ),
        );
      },
    );
  }

}







