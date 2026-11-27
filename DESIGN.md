# Sistem Desain Neo-Brutalism: Kasir Warung Kopi (`uas_pmobile`)

> **Design Read:** Aplikasi kasir mobile (Point of Sale) untuk warung kopi lokal, mengadopsi bahasa visual Neo-Brutalism (bold black borders, hard offset shadows tanpa blur, palet warna kontras tinggi, surface krem hangat yang bersih).
> **Antislop Dials:** ENERGY 2 (Seimbang & Tegas) / RHYTHM 2 (Variasi Konten Terstruktur) / MOTION 1 (Taktil, Cepat & Responsif).

---

## 1. Konsep & Identitas Visual

Aplikasi kasir membutuhkan kecepatan operasional, kejelasan informasi harga/pesanan di bawah berbagai kondisi pencahayaan warung, dan kemudahan tap jari kasir saat transaksi padat. 

Gaya **Neo-Brutalism** dipilih bukan sekadar sebagai tren grafis, melainkan untuk fungsi nyata:
1. **Ketegasan Batas Visual (High Affordance):** Garis hitam tebal (2px–2.5px) memperjelas batas setiap tombol kuantitas, kartu menu, dan input form sehingga kasir tidak salah tekan.
2. **Umpan Balik Taktil (Physicality):** Hard offset shadow (tanpa blur) memberikan ilusi tombol mekanik/fisik kalkulator kasir klasik.
3. **Keterbacaan Ekstrem:** Permukaan krem hangat (`#FFFDF5`) dipadukan dengan teks hitam pekat (`#121212`) memberikan rasio kontras sangat tinggi (>15:1) yang ramah mata tanpa membuat silau.

---

## 2. Token Desain & Palet Warna (Color System)

Mengacu pada referensi visual terlampir, warna menggunakan kombinasi surface krem hangat dengan aksen warna pop yang jenuh namun nyaman di mata:

### Palet Warna Utama

| Token | Nilai Hex | Flutter `Color` | Peran & Penggunaan |
|---|---|---|---|
| `bgCanvas` | `#FFFDF5` | `Color(0xFFFFFDF5)` | Latar belakang utama aplikasi (Warm Cream) |
| `surfaceCard` | `#FFFFFF` | `Color(0xFFFFFFFF)` | Permukaan kartu menu, input field, modal sheet |
| `borderDark` | `#121212` | `Color(0xFF121212)` | Border outline tebal, hard shadow, dan teks utama |
| `primaryCoral` | `#FF6B6B` | `Color(0xFFFF6B6B)` | Tombol aksi penting, badge pesanan baru, indikator batal |
| `secondaryYellow`| `#FFE66D` | `Color(0xFFFFE66D)` | Tab aktif, highlight harga total, badge kategori utama |
| `accentTeal` | `#4ECDC4` | `Color(0xFF4ECDC4)` | Tombol proses bayar, badge lunas/sukses, toggle aktif |
| `accentLilac` | `#A78BFA` | `Color(0xFFA78BFA)` | Kategori minuman kopi, kartu sekunder, tag tambahan |
| `textMuted` | `#4B5563` | `Color(0xFF4B5563)` | Label pendukung (sub-keterangan, varian produk) |
| `dangerRed` | `#EF4444` | `Color(0xFFEF4444)` | Pesan error validasi, tombol hapus transaksi |

### Rasio Kontras WCAG AA (Semua Lolos)
- Hitam `#121212` di atas Cream `#FFFDF5`: **18.2:1** (Lolos AAA)
- Hitam `#121212` di atas Yellow `#FFE66D`: **15.4:1** (Lolos AAA)
- Hitam `#121212` di atas Teal `#4ECDC4`: **9.8:1** (Lolos AAA)
- Hitam `#121212` di atas Coral `#FF6B6B`: **6.3:1** (Lolos AA)
- Putih `#FFFFFF` di atas Hitam `#121212`: **18.5:1** (Lolos AAA)

### Definisi Dart `AppColors`
```dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color bgCanvas = Color(0xFFFFFDF5);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color borderDark = Color(0xFF121212);
  static const Color primaryCoral = Color(0xFFFF6B6B);
  static const Color secondaryYellow = Color(0xFFFFE66D);
  static const Color accentTeal = Color(0xFF4ECDC4);
  static const Color accentLilac = Color(0xFFA78BFA);
  static const Color textMain = Color(0xFF121212);
  static const Color textMuted = Color(0xFF4B5563);
  static const Color dangerRed = Color(0xFFEF4444);
}
```

---

## 3. Tipografi & Hierarki Teks

Menggunakan sans-serif geometris tegas dengan bobot bold tinggi untuk merefleksikan karakter brutalist yang kokoh.

- **Font Utama:** `Plus Jakarta Sans` / `Poppins` / Sistem Sans-serif bawaan Android & iOS.
- **Hierarki Skala:**
  - **Display 1 (Nominal Pembayaran):** 28sp / Bold 800 / Line-height 1.2
  - **Heading 1 (Nama Menu / Total Belanja):** 20sp / Bold 800 / Line-height 1.2
  - **Heading 2 (Header Section):** 16sp / Bold 700 / Line-height 1.3
  - **Body Bold (Label Tombol & Status):** 14sp / Bold 700 / Line-height 1.4
  - **Body Regular (Rincian Menu / Deskripsi):** 14sp / Medium 500 / Line-height 1.4
  - **Caption (Waktu, Kategori, Notifikasi):** 12sp / SemiBold 600 / Line-height 1.3

---

## 4. Geometri & Bayangan Neo-Brutalism (Shadows & Borders)

Karakteristik utama Neo-Brutalism adalah offset shadow solid tanpa blur filter (`blurRadius: 0`).

### Konstanta Dimensi
- **Tebal Border Standar:** `2.5dp` solid `#121212`.
- **Tebal Border Tipis (Sub-item / Divider):** `1.5dp` solid `#121212`.
- **Border Radius:**
  - Kartu & Kontainer Utama: `12.0dp`
  - Tombol & Stepper Kuantitas: `10.0dp`
  - Pill Badge / Chip Filter: `99.0dp` (Full capsule)
- **Offset Bayangan (Shadow Offset):**
  - Kartu Utama & Floating CTA: `Offset(4.0, 4.0)` warna `#121212`
  - Tombol Standar & Stepper: `Offset(3.0, 3.0)` warna `#121212`
  - State Ditekan (Pressed State): `Offset(1.0, 1.0)` atau `Offset(0.0, 0.0)` dengan translasi widget ke bawah-kanan sebesar `2dp`.

### Snippet Dekorasi Kartu & Tombol
```dart
// Dekorasi Kartu Neo-Brutalism
BoxDecoration neoCardDecoration({
  Color color = AppColors.surfaceCard,
  double radius = 12.0,
  Offset shadowOffset = const Offset(4, 4),
}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: AppColors.borderDark, width: 2.5),
    boxShadow: [
      BoxShadow(
        color: AppColors.borderDark,
        offset: shadowOffset,
        blurRadius: 0,
      ),
    ],
  );
}
```

---

## 5. Ergonomi Layar Kasir & Pencegahan RenderFlex Overflow

Layar kasir ponsel digunakan secara vertikal (portrait) dengan satu tangan atau dua jempol. Ruang vertikal dan horizontal harus dijaga agar terhindar dari *yellow-black stripes* (RenderFlex overflow).

### A. Aturan Tap Target Kasir (Touch Target Size)
- **Tombol Tambah/Kurang (+/-):** Ukuran wajib minimal **48 x 48 dp**.
- **Jarak Antar Tombol (Target Spacing):** Jarak minimal antar elemen interaktif adalah **8 dp** untuk menghindari kasir salah menekan tombol kurang saat ingin menambah.
- **Tinggi Tombol Aksi Utama (Checkout / Bayar):** Minimal **54 dp** dengan teks tebal dan kontras tinggi.
- **Tombol Kategori / Tab Filter:** Tinggi minimal **44 dp** dengan padding horizontal **16 dp**.

### B. Aturan Bebas RenderFlex Overflow
1. **Nama Menu & Rincian Harga:**
   - Wajib dibungkus dalam widget `Expanded` atau `Flexible`.
   - Gunakan `maxLines: 2` dan `overflow: TextOverflow.ellipsis` untuk nama menu panjang (contoh: "Kopi Susu Gula Aren Spesial Blend 500ml").
   - Nominal harga menggunakan `FittedBox(fit: BoxFit.scaleDown)` agar tidak terpotong pada layar beresolusi sempit (320dp-360dp).
2. **Kategori Menu:**
   - Gunakan `SingleChildScrollView(scrollDirection: Axis.horizontal)` atau `Wrap(spacing: 8, runSpacing: 8)` agar chip tidak meluap ke kanan.
3. **Form Input & Keyboard Safety:**
   - Setiap halaman input pesanan/menu wajib menggunakan `SingleChildScrollView(physics: BouncingScrollPhysics())`.
   - Tambahkan padding bawah berbasis keyboard: `padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16)`.
   - Gunakan `resizeToAvoidBottomInset: true` pada `Scaffold`.
4. **Bottom Bar Ringkasan Pesanan:**
   - Letakkan di properti `bottomNavigationBar` pada `Scaffold` yang dibungkus `SafeArea` agar tombol bayar tidak tertutup navigation bar bawaan sistem Android.

---

## 6. Standar Copywriting & Mikro-teks (Anti-Slop Copy)

Sesuai aturan antislop, mikro-teks aplikasi kasir harus ringkas, langsung pada fakta, bebas dari jargon marketing AI ("seamless", "unlock", "elevate"), dan **dilarang menggunakan tanda em dash (`—`)**.

### Kamus Pesan Antarmuka (UI Microcopy)

| Kondisi | Jangan Gunakan (AI Slop) | Gunakan (Standar Kasir) |
|---|---|---|
| **Empty State Keranjang** | *"Rasakan keajaiban kopi kami — tambahkan menu lezat sekarang!"* | **"Keranjang masih kosong."** |
| **Empty State Menu** | *"Belum ada menu yang memukau. Mulai petualangan rasa!"* | **"Belum ada data menu."** |
| **Validasi Nama Menu** | *"Harap cantumkan mahakarya nama menu Anda"* | **"Nama menu wajib diisi."** |
| **Validasi Harga** | *"Masukkan nominal harga yang masuk akal"* | **"Harga harus berupa angka (minimal Rp1.000)."** |
| **Validasi Stok** | *"Stok tidak boleh kosong"* | **"Jumlah stok tidak boleh kosong."** |
| **Kurang Bayar** | *"Transaksi belum optimal — uang Anda kurang Rp10.000"* | **"Uang pembayaran kurang Rp10.000."** |
| **Kembalian** | *"Total pengembalian dana cerdas"* | **"Kembalian: Rp15.000"** |
| **Sukses Bayar** | *"Hore! Transaksi revolusioner berhasil diselesaikan"* | **"Pembayaran berhasil disimpan."** |
| **Tombol CTA** | *"Explore Sekarang"*, *"Get Started"* | **"Bayar Sekarang"**, **"Simpan Menu"**, **"Cetak Struk"** |

---

## 7. Komponen Spesifik Flutter (Code Recipes)

### Resep 1: `NeoQuantityStepper` (Tombol +/- 48x48dp)
```dart
import 'package:flutter/material.dart';
import 'package:uas_pmobile/design_system.dart'; // import token

class NeoQuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const NeoQuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildButton(
          icon: Icons.remove,
          onTap: onDecrement,
          color: AppColors.primaryCoral,
        ),
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            border: Border.all(color: AppColors.borderDark, width: 2.0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$quantity',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textMain,
            ),
          ),
        ),
        _buildButton(
          icon: Icons.add,
          onTap: onIncrement,
          color: AppColors.accentTeal,
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48, // Memenuhi kriteria tap target minimal 48dp
        height: 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderDark, width: 2.5),
          boxShadow: const [
            BoxShadow(
              color: AppColors.borderDark,
              offset: Offset(2, 2),
              blurRadius: 0,
            ),
          ],
        ),
        child: Icon(icon, size: 22, color: AppColors.textMain),
      ),
    );
  }
}
```

### Resep 2: `NeoCardMenuItem` (Bebas RenderFlex Overflow)
```dart
Widget buildMenuItem({
  required String name,
  required int price,
  required String category,
  required VoidCallback onAdd,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: neoCardDecoration(),
    child: Row(
      children: [
        // Tag kategori berbentuk kotak mini dengan border
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.secondaryYellow,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderDark, width: 2.0),
          ),
          child: const Icon(Icons.coffee, color: AppColors.textMain, size: 28),
        ),
        const SizedBox(width: 12),
        // Nama dan harga dibungkus Expanded untuk anti-overflow
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMain,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Rp${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Tombol Tambah Pesanan
        GestureDetector(
          onTap: onAdd,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.accentTeal,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderDark, width: 2.0),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.borderDark,
                  offset: Offset(2, 2),
                  blurRadius: 0,
                ),
              ],
            ),
            child: const Text(
              '+ Tambah',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: AppColors.textMain,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
```

### Resep 3: `NeoEmptyState` (State Kosong Bebas Slop)
```dart
Widget buildEmptyState({
  required String title,
  required String message,
  required VoidCallback onAction,
  required String actionLabel,
}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: neoCardDecoration(
              color: AppColors.secondaryYellow,
              shadowOffset: const Offset(4, 4),
            ),
            child: const Icon(Icons.receipt_long, size: 40, color: AppColors.textMain),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: onAction,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              alignment: Alignment.center,
              decoration: neoCardDecoration(
                color: AppColors.primaryCoral,
                shadowOffset: const Offset(3, 3),
              ),
              child: Text(
                actionLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: AppColors.textMain,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
```

---

## 8. Checklist Verifikasi Pra-Delivery (Craftsmanship Gate)

Sebelum kode diintegrasikan ke `lib/`, pastikan checklist berikut lolos uji:

- [ ] **Batas Garis & Shadow:** Seluruh border menggunakan warna hitam `#121212` dengan tebal minimal 2.0dp dan shadow tanpa blur (`blurRadius: 0`).
- [ ] **Ergonomi Tap Target:** Tombol kuantitas (+/-) dan aksi utama berukuran minimal 48x48dp dengan jarak antar tombol minimal 8dp.
- [ ] **Bebas RenderFlex Overflow:** Semua nama item menggunakan `Expanded` + `TextOverflow.ellipsis`, list dibungkus scroll view, dan padding keyboard (`viewInsets.bottom`) aktif.
- [ ] **Kontras & Keterbacaan:** Semua teks di atas tombol atau kartu warna (Cream, Yellow, Coral, Teal) terbaca jelas dengan rasio kontras > 4.5:1.
- [ ] **Bebas AI Slop:** Tidak ada tanda em dash (`—`), tidak ada teks marketing berlebihan, tombol mati, atau section testimonial palsu.
- [ ] **Kejelasan Status:** Terdapat visualisasi empty state ("Belum ada data menu / pesanan"), loading indicator, dan pesan validasi form yang to-the-point.
