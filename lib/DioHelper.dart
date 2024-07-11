import 'package:dio/dio.dart';
class DioHelper{
  final Dio dio = Dio();

  Future<List> getData() async{
    final Response res = await dio.get('https://dummyjson.com/products');
    return res.data["products"];
  }
}