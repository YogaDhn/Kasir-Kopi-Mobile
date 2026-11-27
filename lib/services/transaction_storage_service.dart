import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_pmobile/models/transaction_record.dart';

class TransactionStorageService {
  static const String _storageKey = 'kasir_warung_kopi_transactions_v1';

  static Future<List<TransactionRecord>> loadTransactions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? rawJson = prefs.getString(_storageKey);

    if (rawJson == null || rawJson.trim().isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decodedList = jsonDecode(rawJson) as List<dynamic>;
      final List<TransactionRecord> list = decodedList
          .map((item) => TransactionRecord.fromJson(item as Map<String, dynamic>))
          .toList();
      // Urutkan dari yang terbaru
      list.sort((a, b) => b.tanggalWaktu.compareTo(a.tanggalWaktu));
      return list;
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveTransaction(TransactionRecord transaction) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<TransactionRecord> current = await loadTransactions();
    current.insert(0, transaction);

    final List<Map<String, dynamic>> jsonList =
        current.map((item) => item.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  static Future<void> clearTransactions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static int calculateTodayProfit(List<TransactionRecord> transactions) {
    final DateTime now = DateTime.now();
    return transactions
        .where((t) => isSameDay(t.tanggalWaktu, now))
        .fold(0, (sum, t) => sum + t.totalBayar);
  }

  static int calculateTodayCount(List<TransactionRecord> transactions) {
    final DateTime now = DateTime.now();
    return transactions.where((t) => isSameDay(t.tanggalWaktu, now)).length;
  }
}
