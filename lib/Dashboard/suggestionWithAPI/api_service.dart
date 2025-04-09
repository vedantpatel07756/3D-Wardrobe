// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wardrope_app/Dashboard/suggestionWithAPI/fashion_model.dart';
// import '../models/fashion_item.dart';

class ApiService {
  static const String apiUrl =
      'https://apidojo-hm-hennes-mauritz-v1.p.rapidapi.com/products/list?country=jp&lang=en&currentpage=0&pagesize=30&concepts=H%26M%20MAN';
  static const Map<String, String> headers = {
    'x-rapidapi-host': 'apidojo-hm-hennes-mauritz-v1.p.rapidapi.com',
    'x-rapidapi-key': 'a8c873724amsh5b461223a833303p194db8jsn475dfabcc80c',
  };

  static Future<List<FashionItem>> fetchFashionItems() async {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body)['results'];
      return json
          .map((item) => FashionItem.fromJson(item))
          .toList();
        
    } else {
      throw Exception('Failed to load fashion items');
    }
  }
}
