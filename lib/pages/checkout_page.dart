import 'package:material_ui/material_ui.dart';
import 'package:uas_pmobile/models/order_item.dart';
import 'package:uas_pmobile/models/transaction_record.dart';
import 'package:uas_pmobile/services/transaction_storage_service.dart';
import 'package:uas_pmobile/theme/app_theme.dart';
import 'package:uas_pmobile/widgets/neo_badge.dart';
import 'package:uas_pmobile/widgets/neo_button.dart';
import 'package:uas_pmobile/widgets/neo_card.dart';

class CheckoutPage extends StatefulWidget {
  final List<OrderItem> orderItems;

  const CheckoutPage({super.key, required this.orderItems});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cashController = TextEditingController();

  int get _totalAmount =>
      widget.orderItems.fold(0, (sum, item) => sum + item.subtotal);

  int get _enteredCash {
    final String clean = _cashController.text.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(clean) ?? 0;
  }

  int get _change => _enteredCash - _totalAmount;

  @override
  void dispose() {
    _cashController.dispose();
    super.dispose();
  }

  void _applyQuickCash(int amount) {
    setState(() {
      _cashController.text = '$amount';
    });
  }

  Future<void> _handleCompletePayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final TransactionRecord record = TransactionRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tanggalWaktu: DateTime.now(),
      items: List<OrderItem>.from(widget.orderItems),
      totalBayar: _totalAmount,
      uangTunai: _enteredCash,
      kembalian: _change,
    );

    await TransactionStorageService.saveTransaction(record);

    if (!mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: NeoCard(
            color: AppColors.surfaceCard,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: AppDecorations.neoBox(
                    color: AppColors.accentTeal,
                    radius: 12,
                    shadowOffset: const Offset(3, 3),
                  ),
                  child: const Icon(Icons.check, size: 32, color: AppColors.textMain),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pembayaran Berhasil!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textMain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total Tagihan: ${AppFormatters.rupiah(_totalAmount)}\n'
                  'Uang Diterima: ${AppFormatters.rupiah(_enteredCash)}\n'
                  'Kembalian: ${AppFormatters.rupiah(_change)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMain,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                NeoButton(
                  label: 'Selesai & Transaksi Baru',
                  backgroundColor: AppColors.secondaryYellow,
                  isFullWidth: true,
                  onPressed: () {
                    Navigator.pop(dialogContext); // Close dialog
                    Navigator.pop(context, true); // Pop CheckoutPage
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final bool isCashSufficient = _enteredCash >= _totalAmount && _enteredCash > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringkasan Bayar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.5),
          child: Container(color: AppColors.borderDark, height: 2.5),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Rincian Pesanan
                NeoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Daftar Pesanan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textMain,
                            ),
                          ),
                          NeoBadge(
                            label: '${widget.orderItems.length} Menu',
                            backgroundColor: AppColors.accentLilac,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.orderItems.length,
                        separatorBuilder: (context, index) => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(
                            color: AppColors.borderDark,
                            thickness: 1,
                            height: 1,
                          ),
                        ),
                        itemBuilder: (context, index) {
                          final item = widget.orderItems[index];
                          return Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.menu.nama,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textMain,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${item.jumlah} x ${AppFormatters.rupiah(item.menu.harga)}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
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
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryYellow,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColors.borderDark, width: 2.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Tagihan:',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textMain,
                              ),
                            ),
                            Text(
                              AppFormatters.rupiah(_totalAmount),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textMain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Pembayaran Tunai
                NeoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pembayaran Tunai',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textMain,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _cashController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textMain,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.bgCanvas,
                          prefixIcon: const Icon(Icons.payments_outlined,
                              color: AppColors.borderDark),
                          hintText: 'Masukkan nominal uang tunai',
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMuted,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppColors.borderDark, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppColors.borderDark, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppColors.borderDark, width: 2.5),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nominal uang tunai wajib diisi.';
                          }
                          final int entered = int.tryParse(
                                  value.replaceAll(RegExp(r'[^0-9]'), '')) ??
                              0;
                          if (entered < _totalAmount) {
                            final int lack = _totalAmount - entered;
                            return 'Uang pembayaran kurang ${AppFormatters.rupiah(lack)}.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      // Pilihan Uang Cepat (Quick Cash)
                      const Text(
                        'Pilihan Cepat:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildQuickCashChip(
                            label: 'Uang Pas',
                            amount: _totalAmount,
                            color: AppColors.accentTeal,
                          ),
                          if (_totalAmount < 20000)
                            _buildQuickCashChip(
                              label: 'Rp20.000',
                              amount: 20000,
                              color: AppColors.surfaceCard,
                            ),
                          if (_totalAmount < 50000)
                            _buildQuickCashChip(
                              label: 'Rp50.000',
                              amount: 50000,
                              color: AppColors.surfaceCard,
                            ),
                          if (_totalAmount < 100000)
                            _buildQuickCashChip(
                              label: 'Rp100.000',
                              amount: 100000,
                              color: AppColors.surfaceCard,
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Tampilan Kembalian
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isCashSufficient
                              ? const Color(0xFFDCFCE7) // Soft Green
                              : AppColors.bgCanvas,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isCashSufficient
                                ? AppColors.successGreen
                                : AppColors.borderDark,
                            width: 2.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Kembalian:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textMain,
                              ),
                            ),
                            Text(
                              isCashSufficient
                                  ? AppFormatters.rupiah(_change)
                                  : 'Rp0',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: isCashSufficient
                                    ? AppColors.textMain
                                    : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                NeoButton(
                  label: 'Selesaikan Transaksi',
                  icon: Icons.check_circle_outline,
                  backgroundColor: AppColors.accentTeal,
                  isFullWidth: true,
                  minHeight: 52,
                  onPressed: _handleCompletePayment,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickCashChip({
    required String label,
    required int amount,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () => _applyQuickCash(amount),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textMain,
          ),
        ),
      ),
    );
  }
}
