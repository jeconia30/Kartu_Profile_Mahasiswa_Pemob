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
