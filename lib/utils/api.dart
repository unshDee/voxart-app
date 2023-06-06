import 'package:http/http.dart' as http;
import 'dart:convert';

class TestApi {
  final bool success;

  TestApi({required this.success});

  factory TestApi.fromJson(Map<String, dynamic> json) {
    return TestApi(success: json['success']);
  }
}

class ApiManager {
  static final ApiManager _instance = ApiManager._internal();

  factory ApiManager() {
    return _instance;
  }

  ApiManager._internal();

  String? _apiUrl;
  Map<String, dynamic> _result = {
    'actionTaken': 'N/A',
    'generatedImgs': [],
    'generatedImgsFormat': 'jpeg',
    'prompt': '',
    'promptSentiment': '',
    'sentimentConfidence': 0
  };

  set result(Map<String, dynamic> res) {
    _result = res;
  }

  set apiUrl(String url) {
    _apiUrl = url;
  }

  Map<String, dynamic> get result {
    return _result;
  }

  String get apiUrl {
    if (_apiUrl == null) {
      throw Exception('API URL has not been set.');
    }
    return _apiUrl!;
  }

  Future<http.Response> generate(
      {Map<String, String>? headers, Map<String, dynamic>? body}) async {
    final url = Uri.parse('$apiUrl/generate');
    final response = await http.post(url, headers: headers, body: jsonEncode(body));
    print(response.body.toString());
    _result = jsonDecode(response.body);
    return response;
  }

  Future<bool> test({Map<String, String>? headers}) async {
    final url = Uri.parse(apiUrl);
    final response = await http.get(url, headers: headers);
    return jsonDecode(response.body)['success'];
  }
}
