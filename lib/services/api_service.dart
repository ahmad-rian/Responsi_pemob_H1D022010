import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://responsi.webwizards.my.id/api';

  Future<String> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('Login response body: ${response.body}'); // For debugging

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        if (responseData['data'] != null &&
            responseData['data']['token'] != null) {
          return responseData['data']['token'];
        } else {
          throw Exception('Login successful but no token received');
        }
      } else {
        print('Login failed. Status code: ${response.statusCode}');
        throw Exception(responseData['data'] ?? 'Failed to login');
      }
    } catch (e) {
      print('Exception during login: $e');
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/registrasi'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nama': name, 'email': email, 'password': password}),
      );

      print('Register response body: ${response.body}'); // For debugging

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        print('Registration successful');
      } else {
        print('Registration failed. Status code: ${response.statusCode}');
        throw Exception(responseData['data'] ?? 'Failed to register');
      }
    } catch (e) {
      print('Exception during registration: $e');
      throw Exception('Failed to register: $e');
    }
  }
}
