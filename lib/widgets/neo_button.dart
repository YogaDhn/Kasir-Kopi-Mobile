import 'package:material_ui/material_ui.dart';
import 'package:uas_pmobile/theme/app_theme.dart';

class NeoButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final double minHeight;
  final double radius;
  final bool isFullWidth;
  final EdgeInsetsGeometry padding;

  const NeoButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColors.secondaryYellow,
    this.textColor = AppColors.textMain,
    this.icon,
    this.minHeight = 48.0,
    this.radius = 10.0,
    this.isFullWidth = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
  });

  @override
  State<NeoButton> createState() => _NeoButtonState();
}

class _NeoButtonState extends State<NeoButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null;
    final Color effectiveBg =
        isEnabled ? widget.backgroundColor : const Color(0xFFE5E7EB);
    final Color effectiveText =
        isEnabled ? widget.textColor : AppColors.textMuted;
    final Offset shadowOffset = isEnabled
        ? (_isPressed ? const Offset(1.0, 1.0) : const Offset(3.0, 3.0))
        : const Offset(1.0, 1.0);

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        transform: Matrix4.translationValues(
          _isPressed ? 2.0 : 0.0,
          _isPressed ? 2.0 : 0.0,
          0.0,
        ),
        padding: widget.padding,
        constraints: BoxConstraints(
          minHeight: widget.minHeight,
          minWidth: widget.isFullWidth ? double.infinity : 0,
        ),
        decoration: AppDecorations.neoBox(
          color: effectiveBg,
          radius: widget.radius,
          shadowOffset: shadowOffset,
        ),
        child: Row(
          mainAxisSize:
              widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, size: 20, color: effectiveText),
              const SizedBox(width: 8),
            ],
            Text(
              widget.label,
              style: TextStyle(
                color: effectiveText,
                fontWeight: FontWeight.w800,
                fontSize: 15,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
