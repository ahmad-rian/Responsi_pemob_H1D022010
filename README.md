# APK Keuangan

Aplikasi Manajemen Keuangan dengan fokus pada pengelolaan pengeluaran.

## Deskripsi Proyek

Aplikasi ini dikembangkan sebagai bagian dari Responsi Ahmad Rian Syaifullah Ritonga dengan NIM H1D022010.

### Spesifikasi Proyek

- **Jenis Aplikasi**: Aplikasi Manajemen Keuangan
- **Tema UI**: Gelap Biru
- **Font**: Roboto

### Struktur Database

Tabel: pengeluaran

- id (int, PK, auto-increment)
- expense (String)
- cost (Integer)
- category (String)

## Fitur Utama

1. **Autentikasi Pengguna**

   - Login
   - Registrasi

2. **Manajemen Pengeluaran**

   - Menambah pengeluaran baru
   - Melihat daftar pengeluaran
   - Mengedit pengeluaran yang ada
   - Menghapus pengeluaran

## Komponen Utama

### 1. API Service (api_service.dart)

File ini berisi logika untuk berkomunikasi dengan backend API.

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://103.196.155.42/api';

  Future login(String email, String password) async {
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

  Future register(String name, String email, String password) async {
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
```

### 2. Auth Provider (auth_provider.dart)

Provider ini mengelola state autentikasi dalam aplikasi.

```dart
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;

  String? get token => _token;

  bool get isAuthenticated => _token != null;

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  void logout() {
    _token = null;
    notifyListeners();
  }
}
```

### 3. Screen Login dan Register

Screens ini digunakan untuk menangani autentikasi pengguna.

Screenshot :

<div style="display: flex; flex-wrap: wrap; gap: 10px; justify-content: space-between;">
<img src="/img
/login.png" alt="Login" style="width: 48%; max-width: 300px;"/>
  <img src="/img/register.png" alt="register" style="width: 48%; max-width: 300px;"/>
  <img src="/img/regis_ok.png" alt="berhasil regis" style="width: 48%; max-width: 300px;"/>
  <img src="/img/login_ok.png" alt="berhasil login" style="width: 48%; max-width: 300px;"/>
</div>

### 4. pengeluaran provider

Provider ini bertanggung jawab atas pengelolaan pengeluaran, termasuk pengambilan, penambahan, pembaruan, dan penghapusan pengeluaran dari API.

```dart
import 'package:apk_keuangan/models/pengeluaran.dart';
import 'package:apk_keuangan/services/pengeluaran_service.dart';
import 'package:flutter/foundation.dart';

class PengeluaranProvider with ChangeNotifier {
  List<Pengeluaran> _pengeluarans = [];
  final PengeluaranService _apiService = PengeluaranService();
  bool _isLoading = false;
  String _error = '';

  List<Pengeluaran> get pengeluarans => _pengeluarans;
  bool get isLoading => _isLoading;
  String get error => _error;

  void setToken(String token) {
    _apiService.setToken(token);
  }

  Future<void> fetchPengeluarans() async {
    try {
      _setLoading(true);
      _pengeluarans = await _apiService.getPengeluarans();
      _setError('');
      _setLoading(false);
    } catch (e) {
      _setError('Failed to fetch pengeluarans: $e');
      _setLoading(false);
    }
  }

  Future<void> addPengeluaran(Pengeluaran pengeluaran) async {
    try {
      _setLoading(true);
      final newPengeluaran = await _apiService.createPengeluaran(pengeluaran);
      _pengeluarans.add(newPengeluaran);
      _setError('');
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to add pengeluaran: $e');
      _setLoading(false);
    }
  }

  Future<void> updatePengeluaran(Pengeluaran pengeluaran) async {
    _setLoading(true);
    try {
      if (pengeluaran.id != null) {
        final updatedPengeluaran =
            await _apiService.updatePengeluaran(pengeluaran.id, pengeluaran);
        final index = _pengeluarans.indexWhere((p) => p.id == pengeluaran.id);
        if (index != -1) {
          _pengeluarans[index] = updatedPengeluaran;
          _setError('');
          notifyListeners();
        }
      } else {
        _setError('Pengeluaran ID is null, cannot update');
      }
    } catch (e) {
      _setError('Failed to update pengeluaran: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deletePengeluaran(int id) async {
    try {
      _setLoading(true);
      final success = await _apiService.deletePengeluaran(id);
      if (success) {
        _pengeluarans.removeWhere((p) => p.id == id);
        _setError('');
      } else {
        _setError('Failed to delete pengeluaran');
      }
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete pengeluaran: $e');
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }
}

```

### 5. pengeluaran_service

Service ini menangani komunikasi dengan API backend terkait data pengeluaran, menyediakan fungsi untuk CRUD (Create, Read, Update, Delete) pengeluaran.

```dart
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
```

### 6. pengeluaran_form dan pengeluaran_list

Form untuk menambahkan dan mengedit pengeluaran serta tampilan untuk melakukan update dan delete.

Screenshot :

<div style="display: flex; flex-wrap: wrap; gap: 10px; justify-content: space-between;">
<img src="/img
/create.png" alt="create pengeluaran" style="width: 48%; max-width: 300px;"/>
  <img src="/img/list.png" alt="list " style="width: 48%; max-width: 300px;"/>
  <img src="/img/update.png" alt="update" style="width: 48%; max-width: 300px;"/>
  <img src="/img/delete.png" alt="delete" style="width: 48%; max-width: 300px;"/>
</div>
