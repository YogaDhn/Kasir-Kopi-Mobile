import 'package:material_ui/material_ui.dart';
import 'package:uas_pmobile/models/menu_item.dart';
import 'package:uas_pmobile/pages/menu_form_page.dart';
import 'package:uas_pmobile/pages/order_page.dart';
import 'package:uas_pmobile/screens/transaction_history_screen.dart';
import 'package:uas_pmobile/services/menu_storage_service.dart';
import 'package:uas_pmobile/theme/app_theme.dart';
import 'package:uas_pmobile/widgets/neo_badge.dart';
import 'package:uas_pmobile/widgets/neo_button.dart';
import 'package:uas_pmobile/widgets/neo_card.dart';
import 'package:uas_pmobile/widgets/neo_empty_state.dart';

class MenuListPage extends StatefulWidget {
  const MenuListPage({super.key});

  @override
  State<MenuListPage> createState() => _MenuListPageState();
}

class _MenuListPageState extends State<MenuListPage> {
  List<MenuItem> _menuList = [];
  bool _isLoading = true;
  String _selectedFilter = 'semua'; // 'semua', 'minuman', 'makanan'

  @override
  void initState() {
    super.initState();
    _loadMenuData();
  }

  Future<void> _loadMenuData() async {
    setState(() => _isLoading = true);
    final List<MenuItem> items = await MenuStorageService.loadMenuItems();
    setState(() {
      _menuList = items;
      _isLoading = false;
    });
  }

  List<MenuItem> get _filteredList {
    if (_selectedFilter == 'minuman') {
      return _menuList.where((m) => m.isMinuman).toList();
    } else if (_selectedFilter == 'makanan') {
      return _menuList.where((m) => m.isMakanan).toList();
    }
    return _menuList;
  }

  Future<void> _navigateToAddMenu() async {
    final dynamic newItem = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MenuFormPage()),
    );

    if (newItem is MenuItem) {
      await MenuStorageService.addMenuItem(newItem);
      await _loadMenuData();
      if (mounted) {
        _showToast('Menu "${newItem.nama}" berhasil ditambahkan.');
      }
    }
  }

  Future<void> _navigateToEditMenu(MenuItem item) async {
    final dynamic updatedItem = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MenuFormPage(initialItem: item)),
    );

    if (updatedItem is MenuItem) {
      await MenuStorageService.updateMenuItem(updatedItem);
      await _loadMenuData();
      if (mounted) {
        _showToast('Menu "${updatedItem.nama}" berhasil diperbarui.');
      }
    }
  }

  Future<void> _confirmDeleteMenu(MenuItem item) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: NeoCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: AppDecorations.neoBox(
                        color: AppColors.primaryCoral,
                        radius: 8,
                        shadowOffset: const Offset(2, 2),
                      ),
                      child: const Icon(Icons.delete_outline,
                          size: 24, color: AppColors.textMain),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Hapus Menu?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textMain,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Apakah Anda yakin ingin menghapus "${item.nama}" dari daftar menu?',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMain,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: NeoButton(
                        label: 'Batal',
                        backgroundColor: AppColors.surfaceCard,
                        onPressed: () => Navigator.pop(dialogContext, false),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: NeoButton(
                        label: 'Hapus',
                        backgroundColor: AppColors.primaryCoral,
                        onPressed: () => Navigator.pop(dialogContext, true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmed == true) {
      await MenuStorageService.deleteMenuItem(item.id);
      await _loadMenuData();
      if (mounted) {
        _showToast('Menu "${item.nama}" telah dihapus.');
      }
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
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
  }

  void _navigateToOrderPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OrderPage(menuList: _menuList)),
    );
  }

  void _navigateToHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TransactionHistoryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kasir Warung Kopi'),
        actions: [
          // Tombol Akses Riwayat Transaksi & Profit
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined),
            tooltip: 'Riwayat & Profit',
            onPressed: _navigateToHistory,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: NeoBadge(
                label: '${_menuList.length}',
                backgroundColor: AppColors.secondaryYellow,
                icon: Icons.coffee,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.5),
          child: Container(color: AppColors.borderDark, height: 2.5),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.borderDark,
                strokeWidth: 3,
              ),
            )
          : _menuList.isEmpty
              ? NeoEmptyState(
                  title: 'Belum Ada Data',
                  message:
                      'Daftar menu warung kopi masih kosong. Tambahkan menu baru untuk mulai melayani pesanan.',
                  actionLabel: 'Tambah Menu Pertama',
                  onAction: _navigateToAddMenu,
                )
              : Column(
                  children: [
                    // Filter Kategori Tab
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Row(
                        children: [
                          _buildFilterChip('semua', 'Semua (${_menuList.length})'),
                          const SizedBox(width: 8),
                          _buildFilterChip('minuman',
                              'Minuman (${_menuList.where((m) => m.isMinuman).length})'),
                          const SizedBox(width: 8),
                          _buildFilterChip('makanan',
                              'Makanan (${_menuList.where((m) => m.isMakanan).length})'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(
                              child: Text(
                                'Tidak ada menu dalam kategori ini.',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 8, 16, 110),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final MenuItem item = filtered[index];
                                final bool isMakanan = item.isMakanan;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: NeoCard(
                                    padding: const EdgeInsets.all(12),
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
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: AppColors.borderDark,
                                                width: 2.0),
                                          ),
                                          child: Icon(
                                            isMakanan
                                                ? Icons.restaurant
                                                : Icons.local_cafe,
                                            size: 24,
                                            color: AppColors.textMain,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // Kolom nama, kategori, & harga
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      item.nama,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color:
                                                            AppColors.textMain,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  NeoBadge(
                                                    label: isMakanan
                                                        ? 'Makanan'
                                                        : 'Minuman',
                                                    backgroundColor: isMakanan
                                                        ? AppColors.primaryCoral
                                                        : AppColors.secondaryYellow,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                AppFormatters.rupiah(item.harga),
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.textMuted,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Tombol Edit
                                        _buildActionButton(
                                          icon: Icons.edit_outlined,
                                          color: AppColors.accentTeal,
                                          onTap: () =>
                                              _navigateToEditMenu(item),
                                        ),
                                        const SizedBox(width: 8),
                                        // Tombol Hapus
                                        _buildActionButton(
                                          icon: Icons.delete_outline,
                                          color: AppColors.primaryCoral,
                                          onTap: () =>
                                              _confirmDeleteMenu(item),
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
                child: NeoButton(
                  label: 'Tambah Menu',
                  icon: Icons.add,
                  backgroundColor: AppColors.surfaceCard,
                  onPressed: _navigateToAddMenu,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: NeoButton(
                  label: 'Buat Pesanan',
                  icon: Icons.shopping_bag_outlined,
                  backgroundColor: _menuList.isNotEmpty
                      ? AppColors.secondaryYellow
                      : const Color(0xFFE5E7EB),
                  onPressed:
                      _menuList.isNotEmpty ? _navigateToOrderPage : null,
                ),
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

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color,
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
        child: Icon(icon, size: 20, color: AppColors.textMain),
      ),
    );
  }
}
