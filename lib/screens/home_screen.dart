import 'package:apk_keuangan/screens/pengeluaran/pengeluaran_form_screen.dart';
import 'package:apk_keuangan/screens/pengeluaran/pengeluaran_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/pengeluaran_provider.dart';
import './login_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Disable back button
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pengeluaran Manager'),
          automaticallyImplyLeading: false, // Remove back button
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).logout();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFinancialSummary(context),
                SizedBox(height: 24),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _navigateToPengeluaranForm(context),
          child: Icon(Icons.add),
          tooltip: 'Tambah Pengeluaran',
        ),
      ),
    );
  }

  Widget _buildFinancialSummary(BuildContext context) {
    return Consumer<PengeluaranProvider>(
      builder: (context, pengeluaranProvider, child) {
        double totalPengeluaran = pengeluaranProvider.pengeluarans
            .fold(0, (sum, item) => sum + item.cost);

        return Card(
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Pengeluaran',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(totalPengeluaran),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          icon: Icon(Icons.list),
          label: Text('Lihat Semua Pengeluaran'),
          onPressed: () => _navigateToPengeluaranList(context),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton.icon(
          icon: Icon(Icons.add),
          label: Text('Tambah Pengeluaran Baru'),
          onPressed: () => _navigateToPengeluaranForm(context),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ],
    );
  }

  void _navigateToPengeluaranList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PengeluaranListScreen(),
      ),
    );
  }

  void _navigateToPengeluaranForm(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PengeluaranFormScreen(),
      ),
    );
  }
}
