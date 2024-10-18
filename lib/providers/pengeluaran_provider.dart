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
