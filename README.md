# Kartu Profil Mahasiswa (Flutter)

Proyek latihan individu: kartu profil mahasiswa dibuat dengan `Container`,
`Column`, `Row`, `Text`, `Icon`, `CircleAvatar`/`Image`, dan `ElevatedButton`.
Foto profil sudah dimasukkan sebagai asset di `assets/images/foto_profil.jpeg`
dan dua kartu ditampilkan sekaligus (nama pendek & nama panjang) untuk
menguji konsistensi layout.

## Cara menjalankan

File `android/`, `ios/`, `web/`, dll (folder platform) belum disertakan di
zip ini supaya ukurannya kecil — cukup jalankan perintah berikut di dalam
folder proyek ini, itu akan membuatkan folder platform tanpa menimpa
`lib/main.dart` atau `pubspec.yaml` yang sudah ada:

```bash
flutter create --project-name kartu_profil_mahasiswa .
flutter pub get
flutter run
```

Setelah `flutter run`, ambil screenshot hasil tampilan (di emulator/device)
untuk dilampirkan ke laporan PDF.

## Struktur

```
kartu_profil_mahasiswa/
├── lib/
│   └── main.dart          # StudentProfileCard + 2 contoh data (pendek & panjang)
├── assets/
│   └── images/
│       └── foto_profil.jpeg
├── pubspec.yaml            # sudah mendaftarkan asset foto
└── README.md
```

## Mengganti data / foto

- Ganti teks `name`, `nim`, `major` pada pemanggilan `StudentProfileCard(...)`
  di `lib/main.dart` sesuai data yang diinginkan.
- Untuk mengganti foto, timpa file `assets/images/foto_profil.jpeg` dengan
  foto lain (nama file boleh sama agar tidak perlu mengubah kode), lalu
  jalankan `flutter pub get` ulang.

  # Study Planner — Tugas Individu Pemrograman Mobile

## Package yang digunakan
- flutter (SDK bawaan)
- provider ^6.1.2

## Arsitektur & alur data
State aplikasi dipegang oleh satu sumber tunggal: `ActivityProvider`
(ChangeNotifier), disuntikkan di root lewat `ChangeNotifierProvider`
di `main.dart`. Semua layar membaca data yang sama lewat
`context.watch<ActivityProvider>()` atau `Consumer`, sehingga
perubahan di satu layar (misal toggle favorit) langsung terlihat
di layar lain tanpa passing data manual.

## Contoh alur satu fitur: Tambah Aktivitas
1. User mengisi form di `TambahEditAktivitasScreen`.
2. Saat tombol "Tambah" ditekan, `_submit()` memvalidasi form
   lewat `Validators`, lalu memanggil
   `context.read<ActivityProvider>().addActivity(...)`.
3. `ActivityProvider` menambahkan `Activity` baru ke list internal
   dan memanggil `notifyListeners()`.
4. Semua widget yang mendengarkan provider (Beranda, Daftar
   Aktivitas) otomatis rebuild dan menampilkan data baru.
5. Navigator.pop() mengembalikan user ke layar sebelumnya.

## Cara menjalankan
1. `flutter pub get`
2. `flutter run`
