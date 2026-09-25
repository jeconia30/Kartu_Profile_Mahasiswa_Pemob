class Validators {
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Judul aktivitas wajib diisi';
    }
    final length = value.trim().length;
    if (length < 3) return 'Judul minimal 3 karakter';
    if (length > 80) return 'Judul maksimal 80 karakter';
    return null;
  }

  static String? validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kategori wajib dipilih';
    }
    return null;
  }

  // Description bersifat opsional — hanya divalidasi kalau diisi
  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    if (value.trim().length > 300) return 'Deskripsi maksimal 300 karakter';
    return null;
  }

  static String? validateDueDate(DateTime? value) {
    if (value == null) return 'Tanggal jatuh tempo wajib dipilih';
    return null;
  }
}