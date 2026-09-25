import 'package:flutter/material.dart';
import '../screens/main_screen.dart';
import '../screens/detail_aktivitas_screen.dart';
import '../screens/tambah_edit_aktivitas_screen.dart';

class AppRouter {
  static const String main = '/';
  static const String detailAktivitas = '/detail-aktivitas';
  static const String tambahEditAktivitas = '/tambah-edit-aktivitas';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case detailAktivitas:
        final id = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => DetailAktivitasScreen(activityId: id),
        );

      case tambahEditAktivitas:
        final id = settings.arguments as String?; // null = mode tambah
        return MaterialPageRoute(
          builder: (_) => TambahEditAktivitasScreen(activityId: id),
        );

      case main:
      default:
        return MaterialPageRoute(builder: (_) => const MainScreen());
    }
  }
}