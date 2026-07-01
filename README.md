<h1 align="center">SEAPEDIA</h1>
<p align="center">
  <img src="assets/images/Logo.png" width="200" alt="Seapedia Logo">
</p>
<h3 align="center">E-Commerce Platform</h3>

<p align="center">
  <img src="https://img.shields.io/badge/platform-Flutter-blue" alt="Platform">
  <img src="https://img.shields.io/badge/dart-3.12-blue" alt="Dart Version">
</p>

## Table of Contents

- [Getting Started](#getting-started)
- [Deployment Link & API Documentation](#deployment-link--api-documentation)
- [Demo Accounts & Setup](#demo-accounts--setup)
- [Business Rules & Specific Behaviors](#business-rules--specific-behaviors)
- [Features](#features)
- [Architecture & Dependencies](#architecture--dependencies)
- [Security Notes](#security-notes)
- [End-to-End Testing Guide](#end-to-end-testing-guide)
- [Application Demo UI](#application-demo-ui)

## Getting Started

Follow these steps to set up the project locally:

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/zakizakiran/seapedia-app.git
   ```

2. Navigate to the frontend project directory:

   ```bash
   cd seapedia_app
   ```

3. Install the necessary dependencies:

   ```bash
   flutter pub get
   ```

4. **Environment Variables / API Endpoint**:
   By default, the application is already pointing to the deployed backend endpoint. Jika Anda perlu mengubahnya ke local, Anda dapat mengkonfigurasi _base API URL_ pada `lib/app/core/network/api_constants.dart`.

5. Run the app:

   ```bash
   flutter run
   ```

## Deployment Link & API Documentation

- **Backend Deployed API Endpoint**: `http://129.226.211.8/api`
- **API Documentation**: Dokumentasi lengkap API (termasuk endpoints, JWT authorization, dan format payload) diuraikan sangat lengkap di `README.md` pada repositori Backend.

## Demo Accounts & Setup

Anda dapat menggunakan kredensial _demo_ berikut untuk menelusuri aplikasi. Akun-akun ini telah disiapkan secara otomatis pada backend (_seeded data_).

| Email               | Password    | Roles         | Active Role       |
| :------------------ | :---------- | :------------ | :---------------- |
| admin@seapedia.com  | Admin@1234  | ADMIN         | ADMIN (otomatis)  |
| demo@seapedia.com   | User@1234   | BUYER, SELLER | — (wajib pilih)   |
| seller@seapedia.com | Seller@1234 | SELLER        | SELLER (otomatis) |
| driver@seapedia.com | Driver@1234 | DRIVER        | DRIVER (otomatis) |
| buyer@seapedia.com  | Buyer@1234  | BUYER         | BUYER (otomatis)  |

> **Instruksi Akun Admin**: Akun ber-role Admin tidak dapat diregistrasi melalui UI publik. Akun ini hanya bisa didapatkan dan di-_setup_ menggunakan metode migrasi data (_Seed Data_) di level basis data.

## Business Rules & Specific Behaviors

- **Single-Store Checkout Behavior**: Satu keranjang belanja (_cart_) hanya diperbolehkan menampung produk dari **satu toko yang sama**. Jika pembeli (_buyer_) mencoba menambahkan produk dari toko yang berbeda, sistem akan secara proaktif memberitahu bahwa keranjang harus dikosongkan terlebih dahulu.
- **Discount & PPN 12% Calculation**: Kalkulasi tagihan saat melakukan transaksi di-kalkulasi dan dimunculkan dengan urutan berikut: `Subtotal + Delivery Fee - Discount (Voucher/Promo) + PPN 12% = Final Total`. Promo yang sudah kedaluwarsa atau habis tidak akan dapat digunakan.
- **Driver Earnings Rule**: Pendapatan (_Earnings_) Driver berasal dari nominal _Delivery Fee_ dari pesanan yang sukses diantar. Hal ini akan terkalkulasi saat status pekerjaan berubah menjadi selesai.
- **Overdue SLA & Time Simulation**: Waktu garansi pesanan (_Service Level Agreement_) bergantung pada metode pengiriman (Instant / Next Day / Regular). Terdapat fitur eksklusif Admin yaitu **Simulate Next Day**. Saat fitur tersebut diklik, semua pesanan yang waktu berlakunya telah usai (_Overdue_) akan memicu tindakan _Auto-Return / Auto-Refund_ dengan presisi yang tercatat timestamp-nya.

## Features

- **Authentication & Multi-Role**: Register, Login, Logout, dan pemilihan peran (Active Role).
- **Public Marketplace**: Katalog publik dan halaman submit ulasan aplikasi.
- **Buyer Experience**: Top-up dummy wallet, kelola alamat, order & lacak pengiriman.
- **Seller Experience**: Profil toko, manajemen produk, memproses pengemasan barang hingga siap dikirim.
- **Driver Experience**: Sistem pencarian dan penerimaan tugas kurir (_Jobs_).
- **Admin Dashboard**: Monitoring ekosistem platform secara lengkap beserta pembuatan promo.

## Architecture & Dependencies

Aplikasi ini mengadopsi pola arsitektur **GetX** (Model-View-Controller berbasis kapabilitas reaktif):

- **State Management & Routing**: Dikelola secara modular dengan `GetxController` dan Named Routing (`AppPages`).
- **Network Layer**: Di-handle dengan `dio` dengan sokongan integrasi interseptor (_Interceptor_) otomatis untuk Token Refresh.

**Key Packages**:

- `get` (^4.7.3), `dio` (^5.9.2)
- `google_fonts`, `shared_preferences`, `intl`, `html_unescape`

## Security Notes

Aplikasi ini dibangun dengan _security measure_:

- **SQL Injection**: Aman secara _default_ karena Backend menggunakan _parameterized queries_ ORM Prisma.
- **XSS Prevention**: Teks yang disuntik (khususnya _Public Application Review_ atau nama dan deksripsi produk) diamankan pada server-side dengan logika _escape_, dan di-render normal tanpa bahaya eksekusi XSS oleh frontend `html_unescape`.
- **Input Validation**: Frontend dan Backend bersama-sama menolak _form input_ yang tidak logis, memberikan umpan balik (error UI) yang jelas.
- **Session Behavior**: Manajemen sesi ditangani via **JWT**. Access Token digunakan secara berkala dan akan diperbarui otomatis oleh Refresh Token yang berjangka waktu wajar (_expiration rules_).
- **Role-Based Access Control (RBAC)**: Validasi otoritas aksi tidak hanya dipercaya dari _Frontend UI_. Backend memiliki lapis keamanan (`AuthMiddleware`) untuk mengecek `Active Role` token secara independen untuk tiap rute terproteksi.

## End-to-End Testing Guide

Gunakan alur ringkas ini untuk demonstrasi final E2E:

1. **Public Review Flow**: Sebagai Guest (tanpa login), isi ulasan aplikasi secara anonim. Coba lihat list produk.
2. **Buyer Checkout Flow**: Login sebagai `demo@seapedia.com` dan pilih _Active Role: BUYER_. Lakukan _top-up_ saldo di dompet (_Wallet_). Lakukan checkout produk menggunakan ongkir, voucher, dan PPN 12%.
3. **Seller Processing Flow**: Ganti peran Anda menjadi **Seller** (melalui profil, atau login ulang dengan `seller@seapedia.com`). Cek "Pesanan Masuk" yang baru saja dibuat, lalu proses statusnya menjadi "Menunggu Pengirim".
4. **Driver Delivery Flow**: Buka akun Driver (`driver@seapedia.com`). Buka menu ketersediaan job. Ambil pesanan yang baru saja Anda ubah statusnya dan selesaikan pekerjaannya untuk melihat penambahan saldo _earnings_.
5. **Admin Monitoring & Overdue Simulation**: Gunakan akun `admin@seapedia.com`. Pantau jumlah pesanan. Coba lakukan pemicuan lompat hari (**Simulate Day**), lalu cek apakah pesanan yang telat diproses otomatis di-refund/dikembalikan oleh backend.

## Application Demo

Berikut adalah antarmuka dari aplikasi Seapedia untuk berbagai peran yang tersedia:

### 🛍️ Buyer (Pembeli)

<div align="center">
  <img src="assets/images/Buyer/Screenshot%202026-07-01%20085201.png" width="200" alt="Home/Discover" style="margin: 10px;">
  <img src="assets/images/Buyer/Screenshot%202026-07-01%20085305.png" width="200" alt="Product Details" style="margin: 10px;">
  <img src="assets/images/Buyer/Screenshot%202026-07-01%20085548.png" width="200" alt="Profile Summary" style="margin: 10px;">
  <img src="assets/images/Buyer/Screenshot%202026-07-01%20085624.png" width="200" alt="Wallet" style="margin: 10px;">
  <img src="assets/images/Buyer/Screenshot%202026-07-01%20090102.png" width="200" alt="My Orders" style="margin: 10px;">
  <img src="assets/images/Buyer/Screenshot%202026-07-01%20095705.png" width="200" alt="App Review Rating" style="margin: 10px;">
</div>

### 🏪 Seller (Penjual)

<div align="center">
  <img src="assets/images/Seller/Screenshot%202026-07-01%20090401.png" width="200" alt="Manage Store" style="margin: 10px;">
  <img src="assets/images/Seller/Screenshot%202026-07-01%20090544.png" width="200" alt="My Products" style="margin: 10px;">
  <img src="assets/images/Seller/Screenshot%202026-07-01%20091023.png" width="200" alt="Add Product" style="margin: 10px;">
  <img src="assets/images/Seller/Screenshot%202026-07-01%20091102.png" width="200" alt="Store Orders" style="margin: 10px;">
</div>

### 🛵 Driver (Kurir)

<div align="center">
  <img src="assets/images/Driver/Screenshot%202026-07-01%20091259.png" width="200" alt="Driver Dashboard" style="margin: 10px;">
  <img src="assets/images/Driver/Screenshot%202026-07-01%20091430.png" width="200" alt="Available Jobs" style="margin: 10px;">
  <img src="assets/images/Driver/Screenshot%202026-07-01%20091451.png" width="200" alt="Job Details" style="margin: 10px;">
  <img src="assets/images/Driver/Screenshot%202026-07-01%20091508.png" width="200" alt="Job History" style="margin: 10px;">
</div>

### 🛡️ Admin

<div align="center">
  <img src="assets/images/Admin/Screenshot%202026-07-01%20091608.png" width="200" alt="System Overview" style="margin: 10px;">
  <img src="assets/images/Admin/Screenshot%202026-07-01%20091727.png" width="200" alt="Vouchers & Promos" style="margin: 10px;">
  <img src="assets/images/Admin/Screenshot%202026-07-01%20091836.png" width="200" alt="Overdue Orders Simulation" style="margin: 10px;">
  <img src="assets/images/Admin/Screenshot%202026-07-01%20092011.png" width="200" alt="Admin Users" style="margin: 10px;">
  <img src="assets/images/Admin/Screenshot%202026-07-01%20092025.png" width="200" alt="Admin Stores" style="margin: 10px;">
  <img src="assets/images/Admin/Screenshot%202026-07-01%20092150.png" width="200" alt="Create Voucher" style="margin: 10px;">
  <img src="assets/images/Admin/Screenshot%202026-07-01%20092228.png" width="200" alt="Create Promo" style="margin: 10px;">
</div>
