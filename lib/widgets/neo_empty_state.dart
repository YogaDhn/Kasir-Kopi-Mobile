import 'package:material_ui/material_ui.dart';
import 'package:uas_pmobile/theme/app_theme.dart';
import 'package:uas_pmobile/widgets/neo_button.dart';

class NeoEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const NeoEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.coffee_outlined,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: AppDecorations.neoBox(
                color: AppColors.secondaryYellow,
                radius: 16,
                shadowOffset: const Offset(4, 4),
              ),
              child: Icon(icon, size: 38, color: AppColors.textMain),
            ),
            const SizedBox(height: 18),
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
                height: 1.4,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              NeoButton(
                label: actionLabel!,
                onPressed: onAction,
                backgroundColor: AppColors.accentTeal,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
