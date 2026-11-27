import 'package:material_ui/material_ui.dart';
import 'package:uas_pmobile/theme/app_theme.dart';

class NeoQuantityStepper extends StatelessWidget {
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final int minValue;

  const NeoQuantityStepper({
    super.key,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
    this.minValue = 0,
  });

  @override
  Widget build(BuildContext context) {
    final bool canDecrement = value > minValue;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildStepperButton(
          icon: Icons.remove,
          onTap: canDecrement ? onDecrement : null,
          bgColor: canDecrement ? AppColors.primaryCoral : const Color(0xFFE5E7EB),
          isEnabled: canDecrement,
        ),
        const SizedBox(width: 8), // Memastikan jarak antar target minimal 8dp
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderDark, width: 2.0),
          ),
          child: Text(
            '$value',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textMain,
            ),
          ),
        ),
        const SizedBox(width: 8), // Memastikan jarak antar target minimal 8dp
        _buildStepperButton(
          icon: Icons.add,
          onTap: onIncrement,
          bgColor: AppColors.accentTeal,
          isEnabled: true,
        ),
      ],
    );
  }

  Widget _buildStepperButton({
    required IconData icon,
    required VoidCallback? onTap,
    required Color bgColor,
    required bool isEnabled,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48, // Memenuhi kriteria tap target kasir minimal 48dp
        height: 48,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderDark, width: 2.0),
          boxShadow: [
            if (isEnabled)
              const BoxShadow(
                color: AppColors.borderDark,
                offset: Offset(2, 2),
                blurRadius: 0,
              ),
          ],
        ),
        child: Icon(
          icon,
          size: 22,
          color: isEnabled ? AppColors.textMain : AppColors.textMuted,
        ),
      ),
    );
  }
}
