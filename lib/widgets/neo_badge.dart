import 'package:material_ui/material_ui.dart';
import 'package:uas_pmobile/theme/app_theme.dart';

class NeoBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const NeoBadge({
    super.key,
    required this.label,
    this.backgroundColor = AppColors.secondaryYellow,
    this.textColor = AppColors.textMain,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(99.0),
        border: Border.all(color: AppColors.borderDark, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: AppColors.borderDark,
            offset: Offset(1.5, 1.5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
