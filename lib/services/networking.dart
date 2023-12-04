import 'package:http/http.dart' as http;
import 'dart:convert';
class NetworkHelper{
  NetworkHelper({required this.url});
  String url;
   getData()async {
    http.Response response = await http.get(Uri.parse(url));
    if(response.statusCode==200) {
      var data = jsonDecode(response.body);
      return data;
    }
    else{
      print(response.statusCode);
    }
  }
}

