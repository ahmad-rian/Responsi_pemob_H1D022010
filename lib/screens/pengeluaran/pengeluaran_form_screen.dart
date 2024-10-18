import 'package:apk_keuangan/custom_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/pengeluaran_provider.dart';
import '../../models/pengeluaran.dart';

class PengeluaranFormScreen extends StatefulWidget {
  final Pengeluaran? pengeluaran;

  PengeluaranFormScreen({this.pengeluaran});

  @override
  _PengeluaranFormScreenState createState() => _PengeluaranFormScreenState();
}

class _PengeluaranFormScreenState extends State<PengeluaranFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _expenseController = TextEditingController();
  final _costController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.pengeluaran != null) {
      _expenseController.text = widget.pengeluaran!.expense;
      _costController.text = widget.pengeluaran!.cost.toString();
      _categoryController.text = widget.pengeluaran!.category;
    }
  }

  @override
  void dispose() {
    _expenseController.dispose();
    _costController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final pengeluaran = Pengeluaran(
        id: widget.pengeluaran?.id,
        expense: _expenseController.text,
        cost: int.parse(_costController.text),
        category: _categoryController.text,
        updatedAt: DateTime.now(),
        createdAt: widget.pengeluaran?.createdAt ?? DateTime.now(),
      );

      if (widget.pengeluaran == null) {
        Provider.of<PengeluaranProvider>(context, listen: false)
            .addPengeluaran(pengeluaran)
            .then((_) {
          showSuccessAlert(context);
        }).catchError((_) {
          showFailedAlert(context);
        });
      } else {
        Provider.of<PengeluaranProvider>(context, listen: false)
            .updatePengeluaran(pengeluaran)
            .then((_) {
          showSuccessAlert(context);
        }).catchError((_) {
          showFailedAlert(context);
        });
      }

      Navigator.of(context).pop();
    }
  }

  void showSuccessAlert(BuildContext context) {
    showCustomAlert(
      context,
      title: 'Pengeluaran Tersimpan',
      message: 'Data pengeluaran berhasil disimpan.',
      color: Colors.green,
      icon: Icons.check_circle,
    );
  }

  void showFailedAlert(BuildContext context) {
    showCustomAlert(
      context,
      title: 'Gagal Menyimpan',
      message: 'Terjadi kesalahan saat menyimpan data pengeluaran.',
      color: Colors.red,
      icon: Icons.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pengeluaran == null
            ? 'Tambah Pengeluaran'
            : 'Edit Pengeluaran'),
        backgroundColor: Color(0xFF1E88E5),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _expenseController,
                decoration: InputDecoration(
                  labelText: 'Expense',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white10,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon masukkan expense';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _costController,
                decoration: InputDecoration(
                  labelText: 'Cost',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white10,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon masukkan cost';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Mohon masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white10,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon masukkan category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.pengeluaran == null
                    ? 'Simpan Pengeluaran'
                    : 'Update Pengeluaran'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Color(0xFF1E88E5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
