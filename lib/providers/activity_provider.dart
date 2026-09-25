import 'package:flutter/material.dart';
import '../models/activity.dart';

enum StatusFilter { semua, selesai, belum }

class ActivityProvider extends ChangeNotifier {
  final List<Activity> _activities = [];
  int _idCounter = 0;

  ActivityProvider() {
    _seedDummyData();
  }

  List<Activity> get activities => List.unmodifiable(_activities);
  List<Activity> get favorites =>
      _activities.where((a) => a.isFavorite).toList();

  int get totalAktivitas => _activities.length;
  int get totalSelesai => _activities.where((a) => a.isDone).length;
  int get totalFavorit => _activities.where((a) => a.isFavorite).length;

  Activity getById(String id) => _activities.firstWhere((a) => a.id == id);

  // Dipakai layar Daftar Aktivitas: pencarian + filter kategori + filter status digabung
  List<Activity> getFiltered({
    String query = '',
    String kategori = 'Semua',
    StatusFilter status = StatusFilter.semua,
  }) {
    return _activities.where((a) {
      final matchQuery =
          query.isEmpty || a.title.toLowerCase().contains(query.toLowerCase());
      final matchKategori = kategori == 'Semua' || a.category == kategori;
      final matchStatus = status == StatusFilter.semua ||
          (status == StatusFilter.selesai && a.isDone) ||
          (status == StatusFilter.belum && !a.isDone);
      return matchQuery && matchKategori && matchStatus;
    }).toList();
  }

  String _generateId() {
    _idCounter++;
    return 'A${_idCounter.toString().padLeft(3, '0')}';
  }

  void addActivity({
    required String title,
    required String category,
    String? description,
    required DateTime dueDate,
  }) {
    _activities.add(
      Activity(
        id: _generateId(),
        title: title,
        category: category,
        description: description,
        dueDate: dueDate,
      ),
    );
    notifyListeners();
  }

  // Edit: buka data lama lewat getById, simpan perubahan pada ID yang sama
  void updateActivity({
    required String id,
    required String title,
    required String category,
    String? description,
    required DateTime dueDate,
  }) {
    final index = _activities.indexWhere((a) => a.id == id);
    if (index == -1) return;
    _activities[index].title = title;
    _activities[index].category = category;
    _activities[index].description = description;
    _activities[index].dueDate = dueDate;
    notifyListeners();
  }

  void deleteActivity(String id) {
    _activities.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  void toggleFavorite(String id) {
    getById(id).isFavorite = !getById(id).isFavorite;
    notifyListeners();
  }

  void toggleDone(String id) {
    getById(id).isDone = !getById(id).isDone;
    notifyListeners();
  }

  void _seedDummyData() {
    final now = DateTime.now();
    final dummy = [
      {'title': 'Kerjakan Tugas HCI', 'category': 'Akademik', 'desc': 'Analisis prinsip desain interaksi', 'offset': 1},
      {'title': 'Rapat Panitia PALETTIX', 'category': 'Organisasi', 'desc': 'Bahas estimasi anggaran danus', 'offset': 2},
      {'title': 'Lari Pagi', 'category': 'Kesehatan', 'desc': null, 'offset': 0},
      {'title': 'Belajar Flutter Provider', 'category': 'Akademik', 'desc': 'Latihan state management', 'offset': 3},
      {'title': 'Beli Perlengkapan Kuliah', 'category': 'Pribadi', 'desc': null, 'offset': 1},
      {'title': 'Revisi Laporan Etika Profesi', 'category': 'Akademik', 'desc': 'Perbaiki studi kasus Tokopedia', 'offset': 4},
      {'title': 'Latihan Presentasi PKM-PM', 'category': 'Organisasi', 'desc': 'Simulasi presentasi proposal', 'offset': 5},
      {'title': 'Cek Kesehatan Rutin', 'category': 'Kesehatan', 'desc': null, 'offset': 6},
      {'title': 'Video Call Keluarga', 'category': 'Pribadi', 'desc': 'Kabari orang tua di Kisaran', 'offset': 0},
      {'title': 'Baca Materi Jaringan Sosial', 'category': 'Lainnya', 'desc': 'Baca jurnal analisis jaringan sosial', 'offset': 2},
    ];

    for (final d in dummy) {
      _activities.add(
        Activity(
          id: _generateId(),
          title: d['title'] as String,
          category: d['category'] as String,
          description: d['desc'] as String?,
          dueDate: now.add(Duration(days: d['offset'] as int)),
        ),
      );
    }
  }
}