class MenuItem {
  final String id;
  final String nama;
  final int harga;
  final String kategori; // 'minuman' atau 'makanan'

  const MenuItem({
    required this.id,
    required this.nama,
    required this.harga,
    this.kategori = 'minuman',
  });

  bool get isMinuman => kategori.toLowerCase() == 'minuman';
  bool get isMakanan => kategori.toLowerCase() == 'makanan';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'harga': harga,
      'kategori': kategori,
    };
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    final String rawNama = json['nama'] as String? ?? '';
    final String? rawKategori = json['kategori'] as String?;

    String resolvedKategori;
    if (rawKategori != null && rawKategori.trim().isNotEmpty) {
      resolvedKategori = rawKategori.trim().toLowerCase();
    } else {
      final String lowerName = rawNama.toLowerCase();
      if (lowerName.contains('roti') ||
          lowerName.contains('pisang') ||
          lowerName.contains('goreng') ||
          lowerName.contains('mie') ||
          lowerName.contains('snack') ||
          lowerName.contains('nasi') ||
          lowerName.contains('kentang') ||
          lowerName.contains('makan')) {
        resolvedKategori = 'makanan';
      } else {
        resolvedKategori = 'minuman';
      }
    }

    return MenuItem(
      id: json['id'] as String? ?? '',
      nama: rawNama,
      harga: (json['harga'] as num?)?.toInt() ?? 0,
      kategori: resolvedKategori,
    );
  }

  MenuItem copyWith({
    String? id,
    String? nama,
    int? harga,
    String? kategori,
  }) {
    return MenuItem(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      harga: harga ?? this.harga,
      kategori: kategori ?? this.kategori,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nama == other.nama &&
          harga == other.harga &&
          kategori == other.kategori;

  @override
  int get hashCode =>
      id.hashCode ^ nama.hashCode ^ harga.hashCode ^ kategori.hashCode;
}
