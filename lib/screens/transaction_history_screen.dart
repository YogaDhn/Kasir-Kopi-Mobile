import 'package:material_ui/material_ui.dart';
import 'package:uas_pmobile/models/transaction_record.dart';
import 'package:uas_pmobile/services/transaction_storage_service.dart';
import 'package:uas_pmobile/theme/app_theme.dart';
import 'package:uas_pmobile/widgets/neo_badge.dart';
import 'package:uas_pmobile/widgets/neo_button.dart';
import 'package:uas_pmobile/widgets/neo_card.dart';
import 'package:uas_pmobile/widgets/neo_empty_state.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  List<TransactionRecord> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final List<TransactionRecord> data =
        await TransactionStorageService.loadTransactions();
    setState(() {
      _transactions = data;
      _isLoading = false;
    });
  }

  Map<String, List<TransactionRecord>> get _groupedTransactions {
    final Map<String, List<TransactionRecord>> map = {};
    for (final t in _transactions) {
      final String key = t.formattedDate;
      map.putIfAbsent(key, () => []).add(t);
    }
    return map;
  }

  Future<void> _confirmClearHistory() async {
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
                      child: const Icon(Icons.delete_sweep,
                          size: 24, color: AppColors.textMain),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Hapus Riwayat?',
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
                const Text(
                  'Semua riwayat transaksi akan dihapus dari penyimpanan. Tindakan ini tidak dapat dibatalkan.',
                  style: TextStyle(
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
                        label: 'Hapus Semua',
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
      await TransactionStorageService.clearTransactions();
      await _loadHistory();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Riwayat transaksi telah dibersihkan.',
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
      }
    }
  }

  void _showDetailReceipt(TransactionRecord record) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: NeoCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Struk Pembayaran',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textMain,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(dialogContext),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${record.formattedDate} • ${record.formattedTime}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(color: AppColors.borderDark, thickness: 1.5),
                const SizedBox(height: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 220),
                  child: SingleChildScrollView(
                    child: Column(
                      children: record.items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${item.jumlah}x ${item.menu.nama}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textMain,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                AppFormatters.rupiah(item.subtotal),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textMain,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(color: AppColors.borderDark, thickness: 1.5),
                const SizedBox(height: 8),
                _buildReceiptRow('Total Bayar', AppFormatters.rupiah(record.totalBayar), isBold: true),
                const SizedBox(height: 4),
                _buildReceiptRow('Uang Tunai', AppFormatters.rupiah(record.uangTunai)),
                const SizedBox(height: 4),
                _buildReceiptRow('Kembalian', AppFormatters.rupiah(record.kembalian)),
                const SizedBox(height: 20),
                NeoButton(
                  label: 'Tutup',
                  backgroundColor: AppColors.secondaryYellow,
                  onPressed: () => Navigator.pop(dialogContext),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 15 : 13,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: AppColors.textMain,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
            color: AppColors.textMain,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final int todayProfit =
        TransactionStorageService.calculateTodayProfit(_transactions);
    final int todayCount =
        TransactionStorageService.calculateTodayCount(_transactions);
    final grouped = _groupedTransactions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat & Profit'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_transactions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                tooltip: 'Hapus Semua Riwayat',
                onPressed: _confirmClearHistory,
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
          : _transactions.isEmpty
              ? const NeoEmptyState(
                  title: 'Belum Ada Riwayat Transaksi',
                  message:
                      'Belum ada transaksi kasir yang selesai. Lakukan pesanan dan pembayaran untuk mencatat profit.',
                  icon: Icons.receipt_long_outlined,
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. Dashboard Profit Harian
                      NeoCard(
                        color: AppColors.secondaryYellow,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Profit Hari Ini',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textMain,
                                  ),
                                ),
                                NeoBadge(
                                  label: '$todayCount Transaksi',
                                  backgroundColor: AppColors.surfaceCard,
                                  icon: Icons.bolt,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppFormatters.rupiah(todayProfit),
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1,
                                  color: AppColors.textMain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Omzet akumulatif transaksi yang sukses hari ini.',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Ringkasan Rekap Harian
                      NeoCard(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Rekap Omzet Per Tanggal',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textMain,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...grouped.entries.map((entry) {
                              final String dateStr = entry.key;
                              final List<TransactionRecord> dailyList = entry.value;
                              final int dailyTotal = dailyList.fold(
                                  0, (sum, t) => sum + t.totalBayar);
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.bgCanvas,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: AppColors.borderDark, width: 1.5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dateStr,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textMain,
                                          ),
                                        ),
                                        Text(
                                          '${dailyList.length} transaksi selesai',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      AppFormatters.rupiah(dailyTotal),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.textMain,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 2. Daftar Riwayat Transaksi
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Semua Transaksi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textMain,
                            ),
                          ),
                          NeoBadge(
                            label: '${_transactions.length} Total',
                            backgroundColor: AppColors.accentTeal,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _transactions.length,
                        itemBuilder: (context, index) {
                          final TransactionRecord record = _transactions[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () => _showDetailReceipt(record),
                              child: NeoCard(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 3),
                                              decoration: BoxDecoration(
                                                color: AppColors.bgCanvas,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                    color: AppColors.borderDark,
                                                    width: 1.5),
                                              ),
                                              child: Text(
                                                record.formattedTime,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w800,
                                                  color: AppColors.textMain,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              record.formattedDate,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.textMuted,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          AppFormatters.rupiah(record.totalBayar),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.textMain,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      record.itemsSummary,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textMain,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Tunai: ${AppFormatters.rupiah(record.uangTunai)} • Kembali: ${AppFormatters.rupiah(record.kembalian)}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.chevron_right,
                                          size: 18,
                                          color: AppColors.textMain,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
