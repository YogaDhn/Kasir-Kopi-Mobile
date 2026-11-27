import 'package:uas_pmobile/models/order_item.dart';

class TransactionRecord {
  final String id;
  final DateTime tanggalWaktu;
  final List<OrderItem> items;
  final int totalBayar;
  final int uangTunai;
  final int kembalian;

  const TransactionRecord({
    required this.id,
    required this.tanggalWaktu,
    required this.items,
    required this.totalBayar,
    required this.uangTunai,
    required this.kembalian,
  });

  int get totalItemCount =>
      items.fold(0, (sum, item) => sum + item.jumlah);

  String get itemsSummary =>
      items.map((e) => '${e.jumlah}x ${e.menu.nama}').join(', ');

  String get formattedTime {
    final String hour = tanggalWaktu.hour.toString().padLeft(2, '0');
    final String minute = tanggalWaktu.minute.toString().padLeft(2, '0');
    return '$hour:$minute WIB';
  }

  String get formattedDate {
    const List<String> bulan = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${tanggalWaktu.day} ${bulan[tanggalWaktu.month - 1]} ${tanggalWaktu.year}';
  }

  String get dateGroupKey {
    final String year = tanggalWaktu.year.toString();
    final String month = tanggalWaktu.month.toString().padLeft(2, '0');
    final String day = tanggalWaktu.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggalWaktu': tanggalWaktu.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'totalBayar': totalBayar,
      'uangTunai': uangTunai,
      'kembalian': kembalian,
    };
  }

  factory TransactionRecord.fromJson(Map<String, dynamic> json) {
    final dynamic rawDate = json['tanggalWaktu'];
    final DateTime parsedDate = rawDate is String
        ? DateTime.tryParse(rawDate) ?? DateTime.now()
        : DateTime.now();

    final List<dynamic> rawItems = (json['items'] as List<dynamic>?) ?? [];
    final List<OrderItem> parsedItems = rawItems
        .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
        .toList();

    return TransactionRecord(
      id: json['id'] as String? ?? '',
      tanggalWaktu: parsedDate,
      items: parsedItems,
      totalBayar: (json['totalBayar'] as num?)?.toInt() ?? 0,
      uangTunai: (json['uangTunai'] as num?)?.toInt() ?? 0,
      kembalian: (json['kembalian'] as num?)?.toInt() ?? 0,
    );
  }
}
