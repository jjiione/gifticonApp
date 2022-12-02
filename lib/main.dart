import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'provider_class.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

//===========Hayeeon==============
import 'package:auto_size_text/auto_size_text.dart';

import 'package:gifticonapp/gifticonInfo.dart';
import 'UpdateProvider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//================================

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => image_data(),),
        ChangeNotifierProvider(
          create: (BuildContext context) => Updater(),),

      ],
      builder : (context, child) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        initialRoute: '/',
        routes:{
          '/':(context) => const LoginPage(),
          '/registerUser':(context)=>const RegisterUserPage(),
          '/mainPage':(context)=> const MyHomePage(title: 'CAUPON'),
        }
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
  //==========HaYeeoon==========
  //var posts=<Post>[];
  bool changed = false;

  @override
  void initState(){
    context.read<Updater>().setPosts();
    super.initState();
  }
  //=================================


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
      {required Uint8List bytes, required String url}) async {
    http.Response response = await http.put(Uri.parse(url), body: bytes);
    print(response.statusCode);

    return response.statusCode;

  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    var orderStd=context.watch<Updater>().order;
    var posts=context.watch<Updater>().gifticons;

    return Consumer<Updater>(
        builder: (context, update, child){
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
                            DropdownButton(items: orderStdArr.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
                                hint: Text('$orderStd'),
                                onChanged: (value) {
                                  context.read<Updater>().changeOrder(value!);
                                  context.read<Updater>().setPosts();
                                }),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 2, 0),
                              child: Text("Row Count: "),
                            ),
                            DropdownButton(items: List.generate(3,(i) => DropdownMenuItem(value: i + 2, child: Text("${i + 2}"))),
                                hint: Text('$_rowCount'),
                                onChanged: (value) {
                                  setState(() {
                                    _rowCount = value!;
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
                          String remain_str='0';
                          int remain=int.parse(DateTime.now().difference(DateTime.parse(post.date)).inDays.toString());
                          if (remain>0){
                            remain_str='+${remain}';
                          }else {
                            remain_str = '${remain}';
                          }
                          return Gifticon(id:post.id,name:post.couponName,url:"", remainDate:remain_str,date:post.date);
                        }).toList(),
                      ),
                    ),
                  )
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    title: Text("RegisterImage"),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                              child: Stack(
                                children: [
                                  InkWell(
                                    child: CircleAvatar(
                                      radius: 80,
                                      child: context.watch<image_data>().image == null
                                          ? Image.asset('assets/basic.jpg')
                                          : Image.file(
                                          context.watch<image_data>().image!),
                                    ),
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: ((builder) => bottomSheet()));
                                    },
                                  ),
                                ],
                              )),
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
                          SizedBox(
                            height: 15,
                          ),
                          context.watch<image_data>().read_date == null
                              ? Text('유효기간 : null')
                              : Text(
                              '유효기간 : ${context.watch<image_data>().read_date}'),
                          ElevatedButton(
                              onPressed: () async {
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
                                    data: {"url": image_setting});
                                imageUrl = response_posturl.data.toString();
                                imageUrl =
                                    imageUrl.substring(6, imageUrl.indexOf('}'));
                                print("==================imageUrl");
                                print(imageUrl);

                                final response = await dio.post(
                                    'http://54.180.193.160:8080/app/coupon/register',
                                    data: {
                                      "brand": register_brand,
                                      "couponName": register_name,
                                      "date":
                                      "2022-12-21 00:00:00.000",
                                      "imageUrl": imageUrl,
                                      "isUsed": "False",
                                      "timer": 10,
                                      "user": "testuser"
                                    });

                                // _uploadToSignedURL(
                                //     bytes: context.read<image_data>().image!.readAsBytesSync(),
                                //     url: imageUrl
                                // );

                                Navigator.pop(context);
                              },
                              child: Text(
                                "Enter",
                                style: TextStyle(fontSize: 20),
                              ))
                        ],
                      ),
                    ),
                  ),
                );
              },
              tooltip: 'Register',
              child: const Icon(Icons.add, size: 40),
              backgroundColor: Colors.white,
              foregroundColor: Colors.red,
              shape: RoundedRectangleBorder(side: BorderSide(width: 2, color: Colors.red), borderRadius: BorderRadius.circular(100)),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          );
        });
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
                    await context.read<image_data>().crop_image();
                    await context.read<image_data>().textDetect();
                    if (!mounted) return;
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
  //=============Hayeeon===============
  int? id;
  String brand;
  String remainDate;
  String? name;
  String? url;
  String? date;

  Gifticon({this.id=1,this.name,this.brand='',this.url,this.remainDate='0',this.date=''});
  //============================

  // String remainDate;
  // Gifticon({required this.remainDate, Key? key}) : super(key: key);
  @override
  State<Gifticon> createState() => _GifticonState();
}

class _GifticonState extends State<Gifticon> {

  bool exist=true;
  bool delete=false;
  TextEditingController tecname=TextEditingController();
  TextEditingController tecdate=TextEditingController();
  // String name='';
  // String date='';

  @override
  Widget build(BuildContext context) {
    //String remainDate=widget.remainDate;
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
                    child: Image.network('https://images.unsplash.com/photo-1547721064-da6cfb341d50'),
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
                            Text("D",style:TextStyle(color: Colors.white)),
                            Text("${widget.remainDate}",style:TextStyle(color:Colors.red)),
                          ],
                        ),
                        Text("${widget.name}",style:TextStyle(color:Colors.white)),
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
                    Text("${widget.name}"),
                    SizedBox(height: 20),
                    Text("유효기한"),
                    SizedBox(height: 20),
                    Text("${widget.date}"),
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
                                            widget.name = tecname.text;
                                            widget.date = tecdate.text;
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
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: const LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool showSpinner = false;
  final _authentication = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  onChanged: (value) {
                    email = value;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  onChanged: (value) {
                    password = value;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        setState(() {
                          showSpinner = true;
                        });
                        final currentUser =
                        await _authentication.signInWithEmailAndPassword(
                            email: email, password: password);
                        if (currentUser.user != null) {
                          _formKey.currentState!.reset();
                          if (!mounted) return;
                          setState(() {
                            showSpinner = false;
                          });
                          Navigator.pushNamed(context, '/mainPage');
                        }
                      } catch (e) {
                        print(e);
                      }

                    },
                    child: const Text('Enter')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('If you did not register, '),
                    TextButton(
                      child: const Text('Register your email.'),
                      onPressed: () {
                        Navigator.pushNamed(context, '/registerUser');
                      },
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}

class RegisterUserPage extends StatelessWidget {
  const RegisterUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: const RegisterForm(),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _authentication = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String userName = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                onChanged: (value) {
                  email = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                onChanged: (value) {
                  password = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'User Name',
                ),
                onChanged: (value) {
                  userName = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      final newUser =
                      await _authentication.createUserWithEmailAndPassword(
                          email: email, password: password);

                      await FirebaseFirestore.instance
                          .collection('user')
                          .doc(newUser.user!.uid)
                          .set({
                        'userName': userName,
                        'email': email,
                      });

                      if (newUser.user != null) {
                        _formKey.currentState!.reset();
                        if (!mounted) return;
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Text('Enter')),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('If you already registered, '),
                  TextButton(
                    child: const Text('Login with your email.'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              )
            ],
          )),
    );
  }
}
