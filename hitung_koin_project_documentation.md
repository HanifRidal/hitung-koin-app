# Hitung Koin : Money Manager - Complete Project Documentation

---

## 1. Product Requirement Document (PRD)

### 1.1 Document Overview

- **Nama Project:** Hitung Koin : Money Manager
- **Platform:** Mobile (Android & iOS) — Flutter Framework
- **Arsitektur:** Offline-First (Local Database: SQLite)
- **Target Audience:** Individu yang ingin mencatat keuangan pribadi secara praktis, aman, dan tanpa ketergantungan koneksi internet.

### 1.2 Product Vision & Goals

Menjadi aplikasi pengelola keuangan pribadi _full-offline_ yang kaya fitur, aman, dan ringan, yang membantu pengguna melacak transaksi, mengelola anggaran, serta menyimpan bukti pembayaran tanpa perlu khawatir masalah privasi atau sinyal internet.

### 1.3 Scope & Advanced Features

#### A. Core Features (Pencatatan & Pengelolaan)

- **CRUD Transaksi:** Catat pemasukan, pengeluaran, dan transfer antar dompet.
- **Multi-Dompet / Accounts:** Kelola saldo terpisah (Cash, Bank, E-Wallet).
- **Multi-Mata Uang Manual:** Set mata uang utama dan kurs konversi manual untuk mata uang asing.
- **Sistem Anggaran (Budgeting):** Atur batasan pengeluaran per kategori dengan indikator _progress bar_.

#### B. Advanced Features & Enhancements

- **Lampiran Bukti Struk (Optional):**
  - Mengambil foto struk langsung dari kamera atau memilih gambar dari galeri HP.
  - Menyimpan _path_ lokasi file gambar ke database SQLite dan menampilkan _thumbnail_ pada rincian transaksi.
  - Preview gambar _full screen_ dengan fitur zoom.
- **Transaksi Berulang (Recurring Transactions):**
  - Otomatisasi pencatatan rutin (harian, mingguan, bulanan, tahunan).
- **Pengingat Tagihan & Notifikasi Lokal:**
  - Jadwal pengingat jatuh tempo pembayaran via `flutter_local_notifications`.
- **Ekspor, Impor, & Backup:**
  - Ekspor riwayat transaksi ke format CSV dan PDF.
  - Backup & Restore seluruh database lokal (`.db` / `.json`).
- **Keamanan & Tampilan:**
  - Penguncian aplikasi via PIN dan Biometrik (Fingerprint/Face ID).
  - Dukungan Light Mode, Dark Mode, dan Dynamic Theme.

### 1.4 Non-Functional Requirements

- **Performance:** Aplikasi dibuka kurang dari 2 detik; pencarian transaksi responsif di bawah 100ms.
- **Storage Optimization:** Gambar struk di-compress otomatis sebelum disimpan ke memori lokal untuk menghemat kapasitas HP.
- **Security & Privacy:** Seluruh data tersimpan 100% di perangkat pengguna tanpa transmisi ke server luar.

---

## 2. Technical Architecture Document (TAD)

### 2.1 Architectural Pattern Overview

Aplikasi menggunakan **Clean Architecture** yang dikombinasikan dengan pola **MVVM (Model-View-ViewModel)** melalui framework **GetX**. Struktur ini memisahkan logika bisnis, pengelolaan data, dan antarmuka pengguna agar kode lebih _testable_, _decoupled_, dan mudah dikembangkan.

```
┌─────────────────────────────────────────────────────────────┐
│                      PRESENTATION LAYER                     │
│  [Views / UI Widgets]  ◄───►  [GetxControllers / State]    │
└──────────────────────────────┬──────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────┐
│                        DOMAIN LAYER                         │
│             [Use Cases / Business Logic / Entities]          │
└──────────────────────────────┬──────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────┐
│                         DATA LAYER                          │
│     [Repositories Impl]  ◄───►  [Data Sources (SQLite)]    │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Layering Responsibility

#### A. Presentation Layer (UI & State)

- **Views:** Komponen UI murni (Widget). Tidak menyimpan logika bisnis maupun query data. Hanya bertugas merender tampilan dan meneruskan interaksi pengguna ke Controller.
- **Controllers (`GetxController`):** Memegang _reactive state_ (`Obs` / `Rx`), memproses _input_ dari View, dan memanggil Use Cases atau Repositories.
- **Bindings (`Bindings`):** Mengatur _Dependency Injection_ (DI) menggunakan GetX, memastikan Controller dan Repository di-inisialisasi hanya saat halaman terkait dibuka (_lazy loading_).

#### B. Domain Layer (Core Business Logic)

- **Entities:** Objek data murni tanpa dependensi ke kerangka kerja luar.
- **Use Cases / Interactors:** Menampung aturan bisnis aplikasi (contoh: kalkulasi total saldo dari berbagai mata uang, kalkulasi pemakaian batas anggaran bulanan, manipulasi urutan data transaksi).

#### C. Data Layer (Data & Storage)

- **Models:** Ekstensi dari _Entities_ yang dilengkapi fungsi serialisasi data (`fromJson`, `toJson`, `toMap`, `fromMap`) untuk komunikasi dengan SQLite.
- **Data Sources:**
  - `LocalDbProvider`: Menangani relasi langsung dengan `sqflite` (membuka koneksi database, membuat tabel, _raw query_, _migration_).
  - `FileStorageService`: Menangani pembacaan dan penyimpanan file fisik (seperti foto struk, hasil ekspor CSV/PDF) di memori internal HP.
- **Repositories Implementation:** Implementasi dari antarmuka (_interface_) domain layer yang menjembatani antara data source dan domain layer.

### 2.3 Data Flow Scenario (Skenario: Menambah Transaksi Baru dengan Foto Struk)

1. **User Interaction:** Pengguna mengisi form transaksi dan memilih gambar dari kamera/galeri pada `TransactionView`.
2. **Controller Trigger:** View memanggil method `controller.addTransaction()`.
3. **Image Compression & Saving:** Controller memanggil `FileStorageService` untuk melakukan _compress_ pada gambar struk dan menyimpannya ke direktori internal aplikasi, lalu mengembalikan _string path_ file tersebut.
4. **Data Persistence:** Controller/Use Case membuat objek `TransactionModel` (termasuk `receipt_image_path`) dan meneruskannya ke `TransactionRepository`.
5. **SQLite Query:** Repository mengeksekusi perintah `INSERT` via `sqflite` ke tabel `transactions`.
6. **State Update:** Controller memperbarui _reactive state_ (`RxList<TransactionModel>`).
7. **UI Reactivity:** `TransactionView` dan `HomeView` secara otomatis melakukan _re-render_ tampilan (mengupdate saldo dan daftar riwayat) tanpa perlu _reload_ manual.

---

## 3. Tech Stack & Package Specification

### 3.1 Core Framework & Engine

- **Framework:** Flutter (3.x LTS)
- **Language:** Dart (3.x)
- **Target Platforms:** Android & iOS
- **Architecture Standard:** Clean Architecture + MVVM (GetX)

### 3.2 Package Specifications & Dependencies

| Kategori              | Package                       | Versi Target | Alasan & Kegunaan Utama                                                                         |
| --------------------- | ----------------------------- | ------------ | ----------------------------------------------------------------------------------------------- |
| **State & Route**     | `get`                         | `^4.6.6`     | State Management, Dependency Injection (DI) via Bindings, dan Navigation tanpa `BuildContext`.  |
| **Database**          | `sqflite`                     | `^2.3.0`     | Database relasional SQLite bawaan untuk operasi CRUD transaksi, kategori, dompet, dan anggaran. |
| **Database Path**     | `path`                        | `^1.9.0`     | Helper manipulasi dan penggabungan path direktori file/database.                                |
| **Camera/Gallery**    | `image_picker`                | `^1.0.7`     | Mengambil foto bukti struk dari Kamera atau Galeri.                                             |
| **File Storage**      | `path_provider`               | `^2.1.2`     | Mengakses direktori internal HP untuk menyimpan gambar struk dan DB.                            |
| **Image Compression** | `flutter_image_compress`      | `^2.1.0`     | Mengompres ukuran foto struk sebelum disimpan agar menghemat ruang penyimpanan HP.              |
| **PDF Export**        | `pdf`                         | `^3.10.8`    | Membuat dan menyusun _layout_ dokumen laporan keuangan PDF.                                     |
| **Print & Share**     | `printing`                    | `^5.12.0`    | Menampilkan _preview_ PDF, membagikan, dan mencetak file.                                       |
| **CSV Export**        | `csv`                         | `^6.0.0`     | Mengonversi data transaksi SQLite menjadi format CSV (Excel/Sheets).                            |
| **Notifications**     | `flutter_local_notifications` | `^17.0.0`    | Menjadwalkan pengingat tagihan lokal tanpa koneksi internet.                                    |
| **Biometrics**        | `local_auth`                  | `^2.1.8`     | Autentikasi Fingerprint & Face ID saat membuka aplikasi.                                        |
| **Secure Storage**    | `flutter_secure_storage`      | `^9.0.0`     | Menyimpan PIN aplikasi dan _encryption key_ secara terenkripsi di Keystore/Keychain.            |
| **Charts**            | `fl_chart`                    | `^0.66.2`    | Merender grafik visual interaktif (_Pie Chart_, _Bar/Line Chart_).                              |
| **Formatting**        | `intl`                        | `^0.19.0`    | Format mata uang (`Rp`), tanggal, dan lokalisasi bahasa.                                        |
| **UI Loaders**        | `flutter_spinkit`             | `^5.2.0`     | Indikator _loading/spinner_ kustom yang ringan.                                                 |

---

## 4. Database Schema (SQLite)

```sql
-- Tabel Accounts (Dompet/Rekening)
CREATE TABLE accounts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    balance REAL DEFAULT 0,
    icon TEXT,
    currency_code TEXT DEFAULT 'IDR'
);

-- Tabel Categories
CREATE TABLE categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    type TEXT NOT NULL, -- 'income' atau 'expense'
    icon TEXT,
    color TEXT
);

-- Tabel Transactions
CREATE TABLE transactions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    account_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    amount REAL NOT NULL,
    type TEXT NOT NULL, -- 'income', 'expense', 'transfer'
    date TEXT NOT NULL, -- Format ISO8601 YYYY-MM-DD HH:MM:SS
    note TEXT,
    receipt_image_path TEXT, -- Path lokasi file gambar struk lokal
    FOREIGN KEY (account_id) REFERENCES accounts (id),
    FOREIGN KEY (category_id) REFERENCES categories (id)
);

-- Tabel Recurring Transactions (Transaksi Berulang)
CREATE TABLE recurring_transactions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    account_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    amount REAL NOT NULL,
    type TEXT NOT NULL,
    frequency TEXT NOT NULL, -- 'daily', 'weekly', 'monthly', 'yearly'
    next_run_date TEXT NOT NULL,
    note TEXT,
    is_active INTEGER DEFAULT 1,
    FOREIGN KEY (account_id) REFERENCES accounts (id),
    FOREIGN KEY (category_id) REFERENCES categories (id)
);

-- Tabel Currencies (Mata Uang & Kurs Manual)
CREATE TABLE currencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT UNIQUE NOT NULL, -- 'IDR', 'USD'
    symbol TEXT NOT NULL, -- 'Rp', '$'
    exchange_rate REAL NOT NULL,
    is_default INTEGER DEFAULT 0
);
```

---

## 5. Folder & Directory Structure (GetX Standard)

```text
lib/
├── app/
│   ├── data/
│   │   ├── models/            # Model data (misal: transaction_model.dart)
│   │   ├── providers/         # Helper SQLite / LocalDbProvider
│   │   └── services/          # FileStorageService, ExportService, NotificationService
│   ├── modules/
│   │   ├── home/              # View & Controller untuk Dashboard Utama
│   │   │   ├── bindings/
│   │   │   ├── controllers/
│   │   │   └── views/
│   │   ├── transaction/       # View & Controller Tambah/Edit Transaksi
│   │   │   ├── bindings/
│   │   │   ├── controllers/
│   │   │   └── views/
│   │   └── report/            # View & Controller Grafik & Ekspor Laporan
│   │       ├── bindings/
│   │       ├── controllers/
│   │       └── views/
│   └── routes/                # Definisikan rute halaman (AppPages & Routes)
├── core/
│   ├── theme/                 # Konfigurasi ThemeData (Colors, Fonts)
│   ├── values/                # String Constants, Assets Path
│   └── utils/                 # Extension Method, Date Formatter, Currency Formatter
└── main.dart
```

---

## 6. Coding & Naming Conventions

- **File & Folder Name:** `snake_case` (contoh: `transaction_controller.dart`).
- **Class Name:** `PascalCase` (contoh: `TransactionController`).
- **Variables & Functions:** `camelCase` (contoh: `getMonthlyBalance()`).
- **Constants:** `lowerCamelCase` atau `SCREAMING_SNAKE_CASE` untuk variabel global.
