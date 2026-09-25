import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/activity_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/activity_card.dart';
import '../routes/app_router.dart';

class BerandaScreen extends StatelessWidget {
  const BerandaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Beranda'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Consumer<ActivityProvider>(
        builder: (context, provider, _) {
          final upcoming = provider.activities.take(3).toList();
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _StatBox(label: 'Total', value: '${provider.totalAktivitas}'),
                    const SizedBox(width: 12),
                    _StatBox(label: 'Selesai', value: '${provider.totalSelesai}'),
                    const SizedBox(width: 12),
                    _StatBox(label: 'Favorit', value: '${provider.totalFavorit}'),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Aktivitas Terbaru',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...upcoming.map(
                      (a) => ActivityCard(
                    activity: a,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRouter.detailAktivitas,
                      arguments: a.id,
                    ),
                    onFavoriteTap: () => provider.toggleFavorite(a.id),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    color: AppColors.mint, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}