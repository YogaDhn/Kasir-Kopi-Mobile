import 'package:material_ui/material_ui.dart';
import 'package:uas_pmobile/models/menu_item.dart';
import 'package:uas_pmobile/models/order_item.dart';
import 'package:uas_pmobile/pages/checkout_page.dart';
import 'package:uas_pmobile/theme/app_theme.dart';
import 'package:uas_pmobile/widgets/neo_badge.dart';
import 'package:uas_pmobile/widgets/neo_button.dart';
import 'package:uas_pmobile/widgets/neo_card.dart';
import 'package:uas_pmobile/widgets/neo_empty_state.dart';
import 'package:uas_pmobile/widgets/neo_quantity_stepper.dart';

class OrderPage extends StatefulWidget {
  final List<MenuItem> menuList;

  const OrderPage({super.key, required this.menuList});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late final Map<String, int> _quantities;
  String _selectedFilter = 'semua';

  @override
  void initState() {
    super.initState();
    _quantities = {for (final item in widget.menuList) item.id: 0};
  }

  int get _totalItems =>
      _quantities.values.fold(0, (sum, count) => sum + count);

  int get _totalPrice {
    int total = 0;
    for (final menu in widget.menuList) {
      final int qty = _quantities[menu.id] ?? 0;
      total += menu.harga * qty;
    }
    return total;
  }

  List<MenuItem> get _filteredList {
    if (_selectedFilter == 'minuman') {
      return widget.menuList.where((m) => m.isMinuman).toList();
    } else if (_selectedFilter == 'makanan') {
      return widget.menuList.where((m) => m.isMakanan).toList();
    }
    return widget.menuList;
  }

  void _increment(String id) {
    setState(() {
      _quantities[id] = (_quantities[id] ?? 0) + 1;
    });
  }

  void _decrement(String id) {
    final int current = _quantities[id] ?? 0;
    if (current > 0) {
      setState(() {
        _quantities[id] = current - 1;
      });
    }
  }

  void _resetOrder() {
    setState(() {
      for (final key in _quantities.keys) {
        _quantities[key] = 0;
      }
    });
  }

  Future<void> _proceedToCheckout() async {
    final List<OrderItem> selected = [];
    for (final menu in widget.menuList) {
      final int qty = _quantities[menu.id] ?? 0;
      if (qty > 0) {
        selected.add(OrderItem(menu: menu, jumlah: qty));
      }
    }

    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Pilih minimal 1 item menu untuk dipesan.',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          backgroundColor: AppColors.borderDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.borderDark, width: 2.0),
          ),
        ),
      );
      return;
    }

    final dynamic success = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutPage(orderItems: selected),
      ),
    );

    if (success == true && mounted) {
      _resetOrder();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Transaksi selesai dan disimpan ke riwayat.',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textMain,
            ),
          ),
          backgroundColor: AppColors.secondaryYellow,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.borderDark, width: 2.0),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.menuList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Pesanan Baru'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(2.5),
            child: Container(color: AppColors.borderDark, height: 2.5),
          ),
        ),
        body: NeoEmptyState(
          title: 'Belum Ada Data Menu',
          message:
              'Menu warung kopi belum tersedia. Silakan tambahkan menu terlebih dahulu di halaman utama.',
          actionLabel: 'Kembali ke Menu',
          onAction: () => Navigator.pop(context),
        ),
      );
    }

    final filtered = _filteredList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan Baru'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_totalItems > 0)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: GestureDetector(
                  onTap: _resetOrder,
                  child: const NeoBadge(
                    label: 'Reset',
                    backgroundColor: AppColors.primaryCoral,
                    icon: Icons.refresh,
                  ),
                ),
              ),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.5),
          child: Container(color: AppColors.borderDark, height: 2.5),
        ),
      ),
      body: Column(
        children: [
          // Filter Kategori Tab
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                _buildFilterChip('semua', 'Semua (${widget.menuList.length})'),
                const SizedBox(width: 8),
                _buildFilterChip(
                  'minuman',
                  'Minuman (${widget.menuList.where((m) => m.isMinuman).length})',
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  'makanan',
                  'Makanan (${widget.menuList.where((m) => m.isMakanan).length})',
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final MenuItem item = filtered[index];
                final int qty = _quantities[item.id] ?? 0;
                final int itemSubtotal = item.harga * qty;
                final bool isMakanan = item.isMakanan;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: NeoCard(
                    padding: const EdgeInsets.all(12),
                    color: qty > 0
                        ? AppColors.surfaceCardAlt
                        : AppColors.surfaceCard,
                    child: Row(
                      children: [
                        // Pembedaan Ikon & Warna Kategori
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isMakanan
                                ? AppColors.primaryCoral
                                : AppColors.secondaryYellow,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: AppColors.borderDark, width: 2.0),
                          ),
                          child: Icon(
                            isMakanan ? Icons.restaurant : Icons.local_cafe,
                            size: 24,
                            color: AppColors.textMain,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Nama menu, kategori, & harga
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.nama,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textMain,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  NeoBadge(
                                    label: isMakanan ? 'Makanan' : 'Minuman',
                                    backgroundColor: isMakanan
                                        ? AppColors.primaryCoral
                                        : AppColors.secondaryYellow,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                AppFormatters.rupiah(item.harga),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              if (qty > 0) ...[
                                const SizedBox(height: 2),
                                Text(
                                  'Subtotal: ${AppFormatters.rupiah(itemSubtotal)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textMain,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Stepper kuantitas +/- (48x48dp per tombol)
                        NeoQuantityStepper(
                          value: qty,
                          onIncrement: () => _increment(item.id),
                          onDecrement: () => _decrement(item.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.surfaceCard,
          border: Border(
            top: BorderSide(color: AppColors.borderDark, width: 2.5),
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$_totalItems Item Dipilih',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppFormatters.rupiah(_totalPrice),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textMain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              NeoButton(
                label: 'Ringkasan Bayar',
                icon: Icons.arrow_forward,
                backgroundColor: _totalItems > 0
                    ? AppColors.accentTeal
                    : const Color(0xFFE5E7EB),
                onPressed: _totalItems > 0 ? _proceedToCheckout : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final bool isSelected = _selectedFilter == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondaryYellow : AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderDark, width: 2.0),
            boxShadow: [
              if (isSelected)
                const BoxShadow(
                  color: AppColors.borderDark,
                  offset: Offset(2, 2),
                  blurRadius: 0,
                ),
            ],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: AppColors.textMain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
