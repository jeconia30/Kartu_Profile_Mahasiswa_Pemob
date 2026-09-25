import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/activity_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/activity_card.dart';
import '../routes/app_router.dart';

class DaftarAktivitasScreen extends StatefulWidget {
  const DaftarAktivitasScreen({super.key});

  @override
  State<DaftarAktivitasScreen> createState() => _DaftarAktivitasScreenState();
}

class _DaftarAktivitasScreenState extends State<DaftarAktivitasScreen> {
  String _filterKategori = 'Semua';
  StatusFilter _filterStatus = StatusFilter.semua;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Daftar Aktivitas'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.mint,
        onPressed: () => Navigator.pushNamed(context, AppRouter.tambahEditAktivitas),
        child: const Icon(Icons.add, color: AppColors.background),
      ),
      body: Consumer<ActivityProvider>(
        builder: (context, provider, _) {
          final kategoriOptions = [
            'Semua',
            ...{for (final a in provider.activities) a.category},
          ];
          final list = provider.getFiltered(
            query: _query,
            kategori: _filterKategori,
            status: _filterStatus,
          );

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Pencarian
                TextField(
                  controller: _searchController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  onChanged: (value) => setState(() => _query = value),
                  decoration: InputDecoration(
                    hintText: 'Cari judul aktivitas...',
                    hintStyle: const TextStyle(color: AppColors.textSecondary),
                    prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.card,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Filter status
                Row(
                  children: [
                    _StatusChip(
                      label: 'Semua',
                      selected: _filterStatus == StatusFilter.semua,
                      onTap: () => setState(() => _filterStatus = StatusFilter.semua),
                    ),
                    const SizedBox(width: 8),
                    _StatusChip(
                      label: 'Selesai',
                      selected: _filterStatus == StatusFilter.selesai,
                      onTap: () => setState(() => _filterStatus = StatusFilter.selesai),
                    ),
                    const SizedBox(width: 8),
                    _StatusChip(
                      label: 'Belum',
                      selected: _filterStatus == StatusFilter.belum,
                      onTap: () => setState(() => _filterStatus = StatusFilter.belum),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Filter kategori
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: kategoriOptions.map((k) {
                      final selected = k == _filterKategori;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(k),
                          selected: selected,
                          onSelected: (_) => setState(() => _filterKategori = k),
                          selectedColor: AppColors.mint,
                          backgroundColor: AppColors.card,
                          labelStyle: TextStyle(
                            color: selected ? AppColors.background : AppColors.textSecondary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: list.isEmpty
                      ? const Center(
                      child: Text('Tidak ada aktivitas yang cocok',
                          style: TextStyle(color: AppColors.textSecondary)))
                      : ListView(
                    children: list
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

class _StatusChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _StatusChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.mint,
      backgroundColor: AppColors.card,
      labelStyle: TextStyle(color: selected ? AppColors.background : AppColors.textSecondary),
    );
  }
}