import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_pmobile/models/menu_item.dart';

class MenuStorageService {
  static const String _storageKey = 'kasir_warung_kopi_menu_items_v1';

  static final List<MenuItem> _defaultItems = [
    const MenuItem(
      id: '1',
      nama: 'Kopi Tubruk Robusta',
      harga: 8000,
      kategori: 'minuman',
    ),
    const MenuItem(
      id: '2',
      nama: 'Kopi Susu Gula Aren',
      harga: 15000,
      kategori: 'minuman',
    ),
    const MenuItem(
      id: '3',
      nama: 'Es Kopi Hitam Dingin',
      harga: 10000,
      kategori: 'minuman',
    ),
    const MenuItem(
      id: '4',
      nama: 'Kopi Sanger Aceh',
      harga: 14000,
      kategori: 'minuman',
    ),
    const MenuItem(
      id: '5',
      nama: 'Teh Tarik Hangat',
      harga: 10000,
      kategori: 'minuman',
    ),
    const MenuItem(
      id: '6',
      nama: 'Roti Bakar Cokelat Keju',
      harga: 16000,
      kategori: 'makanan',
    ),
    const MenuItem(
      id: '7',
      nama: 'Pisang Goreng Crispy',
      harga: 12000,
      kategori: 'makanan',
    ),
  ];

  static Future<List<MenuItem>> loadMenuItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? rawJson = prefs.getString(_storageKey);

    if (rawJson == null || rawJson.trim().isEmpty) {
      await saveMenuItems(_defaultItems);
      return List<MenuItem>.from(_defaultItems);
    }

    try {
      final List<dynamic> decodedList = jsonDecode(rawJson) as List<dynamic>;
      return decodedList
          .map((item) => MenuItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return List<MenuItem>.from(_defaultItems);
    }
  }

  static Future<void> saveMenuItems(List<MenuItem> items) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList =
        items.map((item) => item.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  static Future<void> addMenuItem(MenuItem item) async {
    final List<MenuItem> current = await loadMenuItems();
    current.add(item);
    await saveMenuItems(current);
  }

  static Future<void> updateMenuItem(MenuItem updatedItem) async {
    final List<MenuItem> current = await loadMenuItems();
    final int index = current.indexWhere((m) => m.id == updatedItem.id);
    if (index != -1) {
      current[index] = updatedItem;
      await saveMenuItems(current);
    }
  }

  static Future<void> deleteMenuItem(String id) async {
    final List<MenuItem> current = await loadMenuItems();
    current.removeWhere((m) => m.id == id);
    await saveMenuItems(current);
  }
}
