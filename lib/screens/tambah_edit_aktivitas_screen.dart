import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../providers/activity_provider.dart';
import '../theme/app_colors.dart';
import '../utils/validators.dart';

class TambahEditAktivitasScreen extends StatefulWidget {
  final String? activityId;
  const TambahEditAktivitasScreen({super.key, this.activityId});

  @override
  State<TambahEditAktivitasScreen> createState() => _TambahEditAktivitasScreenState();
}

class _TambahEditAktivitasScreenState extends State<TambahEditAktivitasScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String? _selectedCategory;
  DateTime? _selectedDueDate; // null = belum dipilih (wajib diisi)
  String? _dueDateError;

  bool get isEdit => widget.activityId != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      final activity = context.read<ActivityProvider>().getById(widget.activityId!);
      _titleController.text = activity.title;
      _descController.text = activity.description ?? '';
      _selectedCategory = activity.category;
      _selectedDueDate = activity.dueDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDueDate = picked;
        _dueDateError = null;
      });
    }
  }

  void _submit() {
    final formValid = _formKey.currentState!.validate();
    final dueDateValid = Validators.validateDueDate(_selectedDueDate) == null;
    setState(() => _dueDateError = Validators.validateDueDate(_selectedDueDate));

    if (!formValid || !dueDateValid) return;

    final provider = context.read<ActivityProvider>();
    final desc = _descController.text.trim().isEmpty ? null : _descController.text.trim();

    if (isEdit) {
      provider.updateActivity(
        id: widget.activityId!,
        title: _titleController.text.trim(),
        category: _selectedCategory!,
        description: desc,
        dueDate: _selectedDueDate!,
      );
    } else {
      provider.addActivity(
        title: _titleController.text.trim(),
        category: _selectedCategory!,
        description: desc,
        dueDate: _selectedDueDate!,
      );
    }
    Navigator.pop(context);
  }

  // Batal: keluar tanpa menyimpan apa pun — tidak memanggil provider sama sekali
  void _batal() {
    Navigator.pop(context);
  }

  InputDecoration _decoration(String label, {String? helper}) {
    return InputDecoration(
      labelText: label,
      helperText: helper,
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      helperStyle: const TextStyle(color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Aktivitas' : 'Tambah Aktivitas'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: _decoration('Judul Aktivitas', helper: '3–80 karakter'),
                validator: Validators.validateTitle,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                dropdownColor: AppColors.card,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: _decoration('Kategori'),
                items: Activity.kategoriList
                    .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                validator: Validators.validateCategory,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: _decoration('Deskripsi (opsional)', helper: 'Maks 300 karakter'),
                maxLines: 3,
                maxLength: 300,
                validator: Validators.validateDescription,
              ),
              const SizedBox(height: 8),
              ListTile(
                tileColor: AppColors.card,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                title: Text(
                  _selectedDueDate == null
                      ? 'Pilih tanggal jatuh tempo'
                      : 'Jatuh tempo: ${_selectedDueDate!.day}/${_selectedDueDate!.month}/${_selectedDueDate!.year}',
                  style: TextStyle(
                    color: _selectedDueDate == null
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                ),
                trailing: const Icon(Icons.calendar_today, color: AppColors.mint),
                onTap: _pickDate,
              ),
              if (_dueDateError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 12),
                  child: Text(_dueDateError!,
                      style: const TextStyle(color: AppColors.danger, fontSize: 12)),
                ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _batal,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.textSecondary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mint,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text(
                        isEdit ? 'Simpan' : 'Tambah',
                        style: const TextStyle(color: AppColors.background, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}