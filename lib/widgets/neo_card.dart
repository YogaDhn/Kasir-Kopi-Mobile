import 'package:material_ui/material_ui.dart';
import 'package:uas_pmobile/theme/app_theme.dart';

class NeoCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final double radius;
  final double borderWidth;
  final Offset shadowOffset;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const NeoCard({
    super.key,
    required this.child,
    this.color = AppColors.surfaceCard,
    this.radius = 12.0,
    this.borderWidth = 2.5,
    this.shadowOffset = const Offset(4.0, 4.0),
    this.padding = const EdgeInsets.all(16.0),
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: AppDecorations.neoBox(
        color: color,
        radius: radius,
        borderWidth: borderWidth,
        shadowOffset: shadowOffset,
      ),
      child: child,
    );
  }
}
