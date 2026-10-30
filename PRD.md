# Product Requirement Document (PRD)

## 1. Document Overview
- **Nama Project:** Hitung Koin : Money Manager
- **Platform:** Mobile (Android & iOS) — Flutter Framework
- **Arsitektur:** Offline-First (Local Database: SQLite)
- **Target Audience:** Individu yang ingin mencatat keuangan pribadi secara praktis, aman, dan tanpa ketergantungan koneksi internet.

## 2. Product Vision & Goals
Menjadi aplikasi pengelola keuangan pribadi *full-offline* yang kaya fitur, aman, dan ringan, yang membantu pengguna melacak transaksi, mengelola anggaran, serta menyimpan bukti pembayaran tanpa perlu khawatir masalah privasi atau sinyal internet.

## 3. Scope & Advanced Features

### A. Core Features (Pencatatan & Pengelolaan)
- **CRUD Transaksi:** Catat pemasukan, pengeluaran, dan transfer antar dompet.
- **Multi-Dompet / Accounts:** Kelola saldo terpisah (Cash, Bank, E-Wallet).
- **Multi-Mata Uang Manual:** Set mata uang utama dan kurs konversi manual untuk mata uang asing.
- **Sistem Anggaran (Budgeting):** Atur batasan pengeluaran per kategori dengan indikator *progress bar*.

### B. Advanced Features & Enhancements
- **Lampiran Bukti Struk (Optional):**
  - Mengambil foto struk langsung dari kamera atau memilih gambar dari galeri HP.
  - Menyimpan path lokasi file gambar ke database SQLite dan menampilkan thumbnail pada rincian transaksi.
  - Preview gambar full screen dengan fitur zoom.
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

## 4. Technical Architecture & Database Schema

### Tech Stack
- **Framework:** Flutter (Dart) - 3.38.7
- **Local Database:** sqflite
- **State Management:** GetX (Clean Architecture + MVVM)
- **Build Tooling:** Gradle 8.13, AGP 8.11.1, Java 17, Core Library Desugaring (`desugar_jdk_libs:2.1.4`)
- **Key Packages:** path_provider, image_picker, flutter_local_notifications, pdf, csv, local_auth.

### Database Schema (SQLite)
```sql
-- Tabel Accounts
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

-- Tabel Recurring Transactions
CREATE TABLE recurring_transactions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    account_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    amount REAL NOT NULL,
    type TEXT NOT NULL,
    frequency TEXT NOT NULL, -- 'daily', 'weekly', 'monthly', 'yearly'
    next_run_date TEXT NOT NULL,
    note TEXT,
    is_active INTEGER DEFAULT 1
);

-- Tabel Currencies
CREATE TABLE currencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT UNIQUE NOT NULL, -- 'IDR', 'USD'
    symbol TEXT NOT NULL, -- 'Rp', '$'
    exchange_rate REAL NOT NULL,
    is_default INTEGER DEFAULT 0
);
```

## 5. Non-Functional Requirements
- **Performance:** Aplikasi dibuka kurang dari 2 detik; pencarian transaksi responsif di bawah 100ms.
- **Storage Optimization:** Gambar struk di-compress otomatis sebelum disimpan ke memori lokal untuk menghemat kapasitas HP.
- **Security & Privacy:** Seluruh data tersimpan 100% di perangkat pengguna tanpa transmisi ke server luar.
