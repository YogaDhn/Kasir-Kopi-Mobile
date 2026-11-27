import 'package:material_ui/material_ui.dart';
import 'package:uas_pmobile/models/menu_item.dart';
import 'package:uas_pmobile/theme/app_theme.dart';
import 'package:uas_pmobile/widgets/neo_button.dart';
import 'package:uas_pmobile/widgets/neo_card.dart';

class MenuFormPage extends StatefulWidget {
  final MenuItem? initialItem;

  const MenuFormPage({super.key, this.initialItem});

  @override
  State<MenuFormPage> createState() => _MenuFormPageState();
}

class _MenuFormPageState extends State<MenuFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late final TextEditingController _hargaController;
  late String _selectedKategori;

  bool get _isEditMode => widget.initialItem != null;

  @override
  void initState() {
    super.initState();
    _namaController =
        TextEditingController(text: widget.initialItem?.nama ?? '');
    _hargaController = TextEditingController(
      text: widget.initialItem != null ? '${widget.initialItem!.harga}' : '',
    );
    _selectedKategori = widget.initialItem?.kategori.toLowerCase() ?? 'minuman';
    if (_selectedKategori != 'makanan') {
      _selectedKategori = 'minuman';
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String nama = _namaController.text.trim();
    final int harga = int.parse(
      _hargaController.text.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    final String id = widget.initialItem?.id ??
        DateTime.now().millisecondsSinceEpoch.toString();

    final MenuItem result = MenuItem(
      id: id,
      nama: nama,
      harga: harga,
      kategori: _selectedKategori,
    );
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Ubah Menu' : 'Tambah Menu Baru'),
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
          padding: EdgeInsets.fromLTRB(16, 20, 16, bottomInset + 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                NeoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informasi Menu',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textMain,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Kategori Menu'),
                      const SizedBox(height: 8),
                      // Pemilih Kategori Neo-Brutalism
                      Row(
                        children: [
                          Expanded(
                            child: _buildCategoryOption(
                              label: 'Minuman',
                              kategoriValue: 'minuman',
                              icon: Icons.local_cafe,
                              activeColor: AppColors.secondaryYellow,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildCategoryOption(
                              label: 'Makanan',
                              kategoriValue: 'makanan',
                              icon: Icons.restaurant,
                              activeColor: AppColors.primaryCoral,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _buildLabel('Nama Menu'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _namaController,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMain,
                        ),
                        decoration: _buildInputDecoration(
                          hintText: _selectedKategori == 'minuman'
                              ? 'Contoh: Kopi Susu Aren'
                              : 'Contoh: Roti Bakar Cokelat',
                          prefixIcon: _selectedKategori == 'minuman'
                              ? Icons.local_cafe_outlined
                              : Icons.restaurant_outlined,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama menu wajib diisi.';
                          }
                          if (value.trim().length < 3) {
                            return 'Nama menu minimal 3 karakter.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      _buildLabel('Harga (Rupiah)'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _hargaController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMain,
                        ),
                        decoration: _buildInputDecoration(
                          hintText: 'Contoh: 15000',
                          prefixIcon: Icons.payments_outlined,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Harga menu wajib diisi.';
                          }
                          final String clean =
                              value.replaceAll(RegExp(r'[^0-9]'), '');
                          final int? parsed = int.tryParse(clean);
                          if (parsed == null || parsed <= 0) {
                            return 'Harga harus berupa angka lebih dari 0.';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                NeoButton(
                  label: _isEditMode ? 'Simpan Perubahan' : 'Tambah ke Menu',
                  icon: _isEditMode ? Icons.check : Icons.add,
                  backgroundColor: AppColors.secondaryYellow,
                  isFullWidth: true,
                  minHeight: 52,
                  onPressed: _handleSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryOption({
    required String label,
    required String kategoriValue,
    required IconData icon,
    required Color activeColor,
  }) {
    final bool isSelected = _selectedKategori == kategoriValue;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedKategori = kategoriValue;
        });
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? activeColor : AppColors.bgCanvas,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderDark, width: 2.0),
          boxShadow: [
            if (isSelected)
              const BoxShadow(
                color: AppColors.borderDark,
                offset: Offset(2.5, 2.5),
                blurRadius: 0,
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: AppColors.textMain,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: AppColors.textMain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.textMain,
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.bgCanvas,
      hintText: hintText,
      hintStyle: const TextStyle(
        color: AppColors.textMuted,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Icon(prefixIcon, color: AppColors.borderDark),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.borderDark, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.borderDark, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.borderDark, width: 2.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.dangerRed, width: 2.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.dangerRed, width: 2.5),
      ),
      errorStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        color: AppColors.dangerRed,
      ),
    );
  }
}
