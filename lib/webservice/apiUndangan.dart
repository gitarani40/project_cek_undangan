import 'dart:convert';
import 'package:project_cek_undangan/model/Undangan.dart';
import 'package:http/http.dart' as http;

class ApiUndangan{
  final url = "http://192.168.43.174:80/api_undangan/getListUndangan.php";
  Future<List<Undangan>?> getUndanganAll() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200){
      return undanganFromJson(response.body);
    }else{   
      print('Error ${response.toString()}');
      return null;
    }
  }

  Future<Undangan?> cekUndangan(String email) async {
    final response = await http.get(Uri.parse("http://192.168.43.174:80/api_undangan/cekUndangan.php?email=$email"));
    if (response.statusCode == 200){
      final result = json.decode(response.body);
      return Undangan.fromJson(result[0]);
    }else{
      print('Error ${response.toString()}');
      return null;
    }
  }

  Future<bool> updateKehadiran(Undangan undangan) async {
    final response = await http
        .get(Uri.parse("http://192.168.43.174:80/api_undangan/updateKehadiran.php?undangan_id=${undangan.undanganId}"));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> resetKehadiran() async{
    final response = await http.get(Uri.parse("http://192.168.43.174:80/api_undangan/resetKehadiran.php"));
    if(response.statusCode==200)
      return true;
    else
      return false;
  }

}
