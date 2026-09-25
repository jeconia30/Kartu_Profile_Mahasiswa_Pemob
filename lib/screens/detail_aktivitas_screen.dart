import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/activity_provider.dart';
import '../theme/app_colors.dart';
import '../utils/date_formatter.dart';
import '../routes/app_router.dart';

class DetailAktivitasScreen extends StatelessWidget {
  final String activityId;
  const DetailAktivitasScreen({super.key, required this.activityId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ActivityProvider>();
    final activity = provider.getById(activityId);
    final hasDescription = activity.description?.isNotEmpty == true;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detail Aktivitas'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              activity.isFavorite ? Icons.star : Icons.star_border,
              color: AppColors.mint,
            ),
            onPressed: () => provider.toggleFavorite(activity.id),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.mint),
              ),
              child: Text(activity.category, style: const TextStyle(color: AppColors.mint)),
            ),
            const SizedBox(height: 16),
            Text(
              activity.title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Jatuh tempo: ${DateFormatter.format(activity.dueDate)}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Text(
              hasDescription ? activity.description! : 'Tidak ada deskripsi',
              style: TextStyle(
                color: hasDescription ? AppColors.textPrimary : AppColors.textSecondary,
                fontSize: 15,
                fontStyle: hasDescription ? FontStyle.normal : FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              value: activity.isDone,
              onChanged: (_) => provider.toggleDone(activity.id),
              title: const Text('Selesai', style: TextStyle(color: AppColors.textPrimary)),
              activeColor: AppColors.mint,
              tileColor: AppColors.card,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRouter.tambahEditAktivitas,
                      arguments: activity.id,
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.mint),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Edit', style: TextStyle(color: AppColors.mint)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _confirmDelete(context, provider, activity.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.danger,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Hapus', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, ActivityProvider provider, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Hapus aktivitas?', style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'Data ini tidak bisa dikembalikan.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteActivity(id);
              Navigator.pop(context); // tutup dialog
              Navigator.pop(context); // kembali dari detail
            },
            child: const Text('Hapus', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}