import 'package:http/http.dart' as http;

class CallApi{
  final String _url="https://jsonplaceholder.typicode.com/posts";

  getPostData() async{
    http.Response response=await http.get(
      Uri.parse(_url)
    );
    try{
      if (response.statusCode==200){
        return response;
      }else{
        return 'failed';
      }
    }catch(e){
      print(e);
      return 'failed';
    }
  }

}
class Post{
  final int? userid;
  final int? id;
  final String? title;
  final String? body;

  Post(
  {required this.userid,
  required this.id,
  required this.title,
  required this.body}
      );

  factory Post.fromJson(Map<String, dynamic> json){
    return Post(
      userid:json["userid"],
      id:json["id"],
      title:json["title"],
      body:json["body"],
    );
  }

}