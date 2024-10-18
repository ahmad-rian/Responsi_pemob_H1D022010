import 'package:apk_keuangan/providers/pengeluaran_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pengeluaran_form_screen.dart';

class PengeluaranListScreen extends StatefulWidget {
  @override
  _PengeluaranListScreenState createState() => _PengeluaranListScreenState();
}

class _PengeluaranListScreenState extends State<PengeluaranListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PengeluaranProvider>(context, listen: false)
          .fetchPengeluarans();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Pengeluaran'),
        backgroundColor: Color(0xFF1E88E5),
      ),
      body: Consumer<PengeluaranProvider>(
        builder: (context, pengeluaranProvider, child) {
          if (pengeluaranProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (pengeluaranProvider.error.isNotEmpty) {
            return Center(
              child: Text(
                pengeluaranProvider.error,
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final pengeluarans = pengeluaranProvider.pengeluarans;
          if (pengeluarans.isEmpty) {
            return Center(child: Text('Tidak ada pengeluaran.'));
          }

          return ListView.builder(
            itemCount: pengeluarans.length,
            itemBuilder: (context, index) {
              final pengeluaran = pengeluarans[index];
              return ListTile(
                title: Text(pengeluaran.expense),
                subtitle:
                    Text('Rp${pengeluaran.cost} - ${pengeluaran.category}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PengeluaranFormScreen(pengeluaran: pengeluaran),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        bool? confirmDelete =
                            await _showDeleteConfirmation(context);
                        if (confirmDelete == true) {
                          pengeluaranProvider
                              .deletePengeluaran(pengeluaran.id!);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PengeluaranFormScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF1E88E5),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Penghapusan'),
        content: Text('Apakah Anda yakin ingin menghapus pengeluaran ini?'),
        actions: <Widget>[
          TextButton(
            child: Text('Batal'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Hapus'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }
}
