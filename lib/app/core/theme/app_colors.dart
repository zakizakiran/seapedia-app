import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xff428475); // Blue ocean
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1E40AF);

  static const Color secondary = Color(0xFFF97316); // Orange for CTA
  static const Color secondaryLight = Color(0xFFFA8D47);
  static const Color secondaryDark = Color(0xFFEA580C);
  
  static const Color accentGreen = Color(0xFF1CB55C); // Green for buyer UI accents
  static const Color accentGreenLight = Color(0xFF4ADE80);

  static const Color statusPacking = Color(
    0xFFF59E0B,
  ); // Yellow - Sedang Dikemas
  static const Color statusWaitingDriver = Color(
    0xFFF97316,
  ); // Orange - Menunggu Pengirim
  static const Color statusDelivering = Color(
    0xFF3B82F6,
  ); // Blue - Sedang Dikirim
  static const Color statusCompleted = Color(
    0xFF10B981,
  ); // Green - Pesanan Selesai
  static const Color statusReturned = Color(0xFFEF4444); // Red - Dikembalikan

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  static const Color textPrimary = grey900;
  static const Color textSecondary = grey600;
  static const Color textTertiary = grey400;
  static const Color textOnPrimary = white;

  static const Color background = white;
  static const Color backgroundSecondary = grey50;
  static const Color surface = white;
  static const Color surfaceSecondary = grey100;

  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFECECA);

  static const Color success = Color(0xFF059669);
  static const Color successLight = Color(0xFFD1FAE5);

  static const Color warning = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFEF3C7);
}
