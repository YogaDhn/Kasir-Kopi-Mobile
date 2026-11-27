import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_pmobile/main.dart';
import 'package:uas_pmobile/models/menu_item.dart';
import 'package:uas_pmobile/models/order_item.dart';
import 'package:uas_pmobile/models/transaction_record.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App bar displays Kasir Warung Kopi', (WidgetTester tester) async {
    await tester.pumpWidget(const KasirWarungKopiApp());
    await tester.pumpAndSettle();

    expect(find.text('Kasir Warung Kopi'), findsOneWidget);
  });

  test('MenuItem model serialization and category fallback test', () {
    const item1 = MenuItem(id: '1', nama: 'Kopi Tubruk', harga: 8000, kategori: 'minuman');
    final json1 = item1.toJson();
    final parsed1 = MenuItem.fromJson(json1);
    expect(parsed1.kategori, 'minuman');
    expect(parsed1.isMinuman, true);

    // Test fallback kategori dari nama makanan untuk data lama
    final legacyFoodJson = {'id': '2', 'nama': 'Pisang Goreng Spesial', 'harga': 12000};
    final parsedLegacy = MenuItem.fromJson(legacyFoodJson);
    expect(parsedLegacy.kategori, 'makanan');
    expect(parsedLegacy.isMakanan, true);
  });

  test('TransactionRecord serialization and calculation test', () {
    const menu = MenuItem(id: '1', nama: 'Kopi Susu Aren', harga: 15000);
    final orderItem = OrderItem(menu: menu, jumlah: 2);
    expect(orderItem.subtotal, 30000);

    final transaction = TransactionRecord(
      id: 'tx_1',
      tanggalWaktu: DateTime(2026, 11, 27, 9, 30),
      items: [orderItem],
      totalBayar: 30000,
      uangTunai: 50000,
      kembalian: 20000,
    );

    final json = transaction.toJson();
    final parsed = TransactionRecord.fromJson(json);

    expect(parsed.totalBayar, 30000);
    expect(parsed.kembalian, 20000);
    expect(parsed.totalItemCount, 2);
    expect(parsed.itemsSummary, '2x Kopi Susu Aren');
  });
}
