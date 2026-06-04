import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

class ApiService {
  ApiService() : _dio = Dio(BaseOptions(baseUrl: AppConstants.apiBaseUrl));
  final Dio _dio;

  Future<void> setToken(String token) async {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> data) async => (await _dio.post(path, data: data)).data;
  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async => (await _dio.get(path, queryParameters: query)).data;
  Future<dynamic> put(String path, Map<String, dynamic> data) async => (await _dio.put(path, data: data)).data;
  Future<void> delete(String path) async => _dio.delete(path);
}
