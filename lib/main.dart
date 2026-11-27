import 'package:material_ui/material_ui.dart';
import 'package:uas_pmobile/pages/menu_list_page.dart';
import 'package:uas_pmobile/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KasirWarungKopiApp());
}

class KasirWarungKopiApp extends StatelessWidget {
  const KasirWarungKopiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kasir Warung Kopi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const MenuListPage(),
    );
  }
}
