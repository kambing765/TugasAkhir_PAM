import 'dart:convert';
import 'package:http/http.dart' as http;


class F1APIService {
  final String baseUrl = 'https://api.openf1.org/v1';

  Future<List<Map<String, dynamic>>> fetchDriversRaw() async {
  final url = Uri.parse('$baseUrl/drivers');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  } else {
    throw Exception('Failed to load drivers');
  }
}





}
