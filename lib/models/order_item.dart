import 'package:uas_pmobile/models/menu_item.dart';

class OrderItem {
  final MenuItem menu;
  int jumlah;

  OrderItem({
    required this.menu,
    this.jumlah = 1,
  });

  int get subtotal => menu.harga * jumlah;

  Map<String, dynamic> toJson() {
    return {
      'menu': menu.toJson(),
      'jumlah': jumlah,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      menu: MenuItem.fromJson(json['menu'] as Map<String, dynamic>),
      jumlah: (json['jumlah'] as num?)?.toInt() ?? 1,
    );
  }

  OrderItem copyWith({
    MenuItem? menu,
    int? jumlah,
  }) {
    return OrderItem(
      menu: menu ?? this.menu,
      jumlah: jumlah ?? this.jumlah,
    );
  }
}
