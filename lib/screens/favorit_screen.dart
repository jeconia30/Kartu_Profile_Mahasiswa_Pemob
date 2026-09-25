import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/activity_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/activity_card.dart';
import '../routes/app_router.dart';

class FavoritScreen extends StatelessWidget {
  const FavoritScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Favorit'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Consumer<ActivityProvider>(
        builder: (context, provider, _) {
          final favorites = provider.favorites;
          if (favorites.isEmpty) {
            return const Center(
              child: Text('Belum ada aktivitas favorit',
                  style: TextStyle(color: AppColors.textSecondary)),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: favorites
                .map((a) => ActivityCard(
              activity: a,
              onTap: () => Navigator.pushNamed(
                context,
                AppRouter.detailAktivitas,
                arguments: a.id,
              ),
              onFavoriteTap: () => provider.toggleFavorite(a.id),
            ))
                .toList(),
          );
        },
      ),
    );
  }
}