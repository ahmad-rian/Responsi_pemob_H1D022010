import 'dart:convert';
import 'package:apk_keuangan/models/pengeluaran.dart';
import 'package:http/http.dart' as http;

class PengeluaranService {
  final String baseUrl = 'https://responsi.webwizards.my.id/api';
  String _token = '';

  void setToken(String token) {
    _token = token;
  }

  Future<List<Pengeluaran>> getPengeluarans() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/keuangan/pengeluaran'),
        headers: {'Authorization': 'Bearer $_token'},
      );
      return _handleListResponse(response);
    } catch (e) {
      print('Error fetching pengeluarans: $e');
      rethrow;
    }
  }

  Future<Pengeluaran> createPengeluaran(Pengeluaran pengeluaran) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/keuangan/pengeluaran'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token'
        },
        body: json.encode(pengeluaran.toJson()),
      );
      return _handleSingleResponse(response);
    } catch (e) {
      print('Error creating pengeluaran: $e');
      rethrow;
    }
  }

  Future<Pengeluaran> updatePengeluaran(
      int? id, Pengeluaran pengeluaran) async {
    if (id == null) {
      throw Exception('ID cannot be null for update');
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/keuangan/pengeluaran/$id/update'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token'
        },
        body: json.encode(pengeluaran.toJson()),
      );
      return _handleSingleResponse(response);
    } catch (e) {
      print('Error updating pengeluaran: $e');
      rethrow;
    }
  }

  Future<bool> deletePengeluaran(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/keuangan/pengeluaran/$id/delete'),
        headers: {'Authorization': 'Bearer $_token'},
      );
      return _handleDeleteResponse(response);
    } catch (e) {
      print('Error deleting pengeluaran: $e');
      rethrow;
    }
  }

  List<Pengeluaran> _handleListResponse(http.Response response) {
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == true && jsonResponse['data'] is List) {
        return (jsonResponse['data'] as List)
            .map((data) => Pengeluaran.fromJson(data))
            .toList();
      }
    }
    throw Exception('Failed to load pengeluarans: ${response.body}');
  }

  Pengeluaran _handleSingleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
        return Pengeluaran.fromJson(jsonResponse['data']);
      }
    }
    throw Exception('Operation failed: ${response.body}');
  }

  bool _handleDeleteResponse(http.Response response) {
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['status'] == true;
    }
    throw Exception('Failed to delete pengeluaran: ${response.body}');
  }
}
