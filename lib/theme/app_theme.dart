import 'package:material_ui/material_ui.dart';

class AppColors {
  static const Color bgCanvas = Color(0xFFFFFDF5);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceCardAlt = Color(0xFFFFF9EB);
  static const Color borderDark = Color(0xFF121212);
  static const Color primaryCoral = Color(0xFFFF6B6B);
  static const Color secondaryYellow = Color(0xFFFFE66D);
  static const Color accentTeal = Color(0xFF4ECDC4);
  static const Color accentLilac = Color(0xFFA78BFA);
  static const Color textMain = Color(0xFF121212);
  static const Color textMuted = Color(0xFF4B5563);
  static const Color dangerRed = Color(0xFFEF4444);
  static const Color successGreen = Color(0xFF22C55E);
}

class AppDecorations {
  static BoxDecoration neoBox({
    Color color = AppColors.surfaceCard,
    double radius = 12.0,
    double borderWidth = 2.5,
    Offset shadowOffset = const Offset(4.0, 4.0),
    Color borderColor = AppColors.borderDark,
    Color shadowColor = AppColors.borderDark,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow: [
        if (shadowOffset != Offset.zero)
          BoxShadow(
            color: shadowColor,
            offset: shadowOffset,
            blurRadius: 0,
          ),
      ],
    );
  }
}

class AppFormatters {
  static String rupiah(int amount) {
    final String str = amount.toString();
    final StringBuffer buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    final String formattedNumber = buffer.toString().split('').reversed.join();
    return 'Rp$formattedNumber';
  }
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.bgCanvas,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.secondaryYellow,
        primary: AppColors.borderDark,
        secondary: AppColors.secondaryYellow,
        surface: AppColors.bgCanvas,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgCanvas,
        foregroundColor: AppColors.textMain,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textMain,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}
