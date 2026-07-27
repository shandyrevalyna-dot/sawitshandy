# 🌴 SawitShandy — Sistem Informasi Perkebunan Sawit (CodeIgniter 4)

Aplikasi CRUD lengkap: Login, Dashboard (statistik + grafik), Data Kebun, Data Blok Kebun,
dan Data Hasil Panen. Tema warna hijau–putih, style ditulis inline di `app/Views/templates/header.php`
(tidak ada file `.css` terpisah — hanya CDN Bootstrap untuk grid/komponen dasar).

## Login default
- Username: `admin`
- Password: `admin123`

## Struktur penting
```
app/Controllers/   -> Auth, Dashboard, Kebun, BlokKebun, HasilPanen
app/Models/         -> UserModel, KebunModel, BlokKebunModel, HasilPanenModel
app/Views/          -> auth/, dashboard/, kebun/, blok/, panen/, templates/
app/Database/Migrations/ -> struktur tabel
app/Database/Seeds/      -> data admin default
database_sawitshandy.sql -> alternatif import manual lewat phpMyAdmin
```

## 1) Jalankan di VS Code (lokal, XAMPP/Laragon)

1. Install XAMPP/Laragon (PHP 8.2+, MySQL) dan Composer.
2. Buka folder project ini di VS Code.
3. Buka terminal VS Code, install dependency framework:
   ```
   composer install
   ```
4. Buat database kosong bernama `sawitshandy` lewat phpMyAdmin.
5. File `.env` sudah disediakan — sesuaikan bila perlu (host/user/password DB Anda).
6. Jalankan migrasi tabel + seeder admin:
   ```
   php spark migrate
   php spark db:seed UserSeeder
   ```
7. Jalankan server lokal:
   ```
   php spark serve
   ```
8. Buka `http://localhost:8080` di browser → login dengan admin/admin123.

> Alternatif langkah 6: kalau tidak mau pakai spark, import langsung file
> `database_sawitshandy.sql` lewat phpMyAdmin ke database `sawitshandy`.

## 2) Alur kerja aplikasi (ringkas)

1. **Login** (`/login`) → cek username/password ke tabel `users`, set session.
2. **Dashboard** (`/dashboard`) → ambil total kebun, total luas lahan, total produksi
   bulan berjalan, dan rekap 6 bulan terakhir untuk grafik (Chart.js).
3. **Data Kebun** (`/kebun`) → CRUD lengkap (tambah/edit/hapus) ke tabel `kebun`.
4. **Data Blok Kebun** (`/blok`) → CRUD, terhubung ke `kebun_id` (relasi kebun).
5. **Data Hasil Panen** (`/panen`) → CRUD, terhubung ke `kebun_id` dan `blok_id`.

Semua halaman di atas dilindungi filter `auth` (lihat `app/Config/Filters.php` dan
`app/Filters/AuthFilter.php`) — otomatis redirect ke `/login` jika belum login.

## 3) Hosting ke InfinityFree (gratis)

InfinityFree tidak menyediakan akses SSH/Composer, jadi vendor (framework) harus
disiapkan **di komputer lokal dulu**, baru diupload lengkap.

### A. Siapkan project untuk upload
1. Di lokal, pastikan sudah `composer install` (folder `vendor/` sudah ada).
2. Ubah `.env`:
   ```
   CI_ENVIRONMENT = production
   app.baseURL = 'http://namadomainanda.infinityfreeapp.com/'
   database.default.hostname = sqlxxx.infinityfree.com   (sesuai info dari InfinityFree)
   database.default.database = if0_xxxxxxx_sawitshandy
   database.default.username = if0_xxxxxxx
   database.default.password = ******
   ```
3. Pastikan FTP client Anda menampilkan hidden files (agar `.env` ikut terupload),
   atau gunakan File Manager bawaan InfinityFree.

### B. Document root
Document root InfinityFree adalah folder `htdocs`, sedangkan CI4 punya folder
`public` sebagai document root aplikasinya. Opsi termudah untuk shared hosting:

1. Upload **seluruh isi** folder `public/` CodeIgniter ke dalam `htdocs/` (root domain).
2. Upload semua folder lain (`app/`, `system/` atau `vendor/`, `writable/`, `.env`, dst)
   ke **satu level di atas `htdocs`**, misal ke folder `sawitshandy_core/` di luar `htdocs`.
3. Edit file `index.php` yang ada di dalam `htdocs/` (hasil dari `public/index.php`),
   ubah path include-nya agar menunjuk ke lokasi `app`, `system`/`vendor`, `writable`
   yang baru (path relatif, contoh: `../sawitshandy_core/app/Config/Paths.php`),
   menyesuaikan struktur folder final Anda.
4. Set permission folder `writable/` menjadi `755` atau `777` lewat File Manager
   InfinityFree agar CodeIgniter bisa menulis cache/log/session.

### C. Setup database di InfinityFree
1. Di cPanel InfinityFree → **MySQL Databases** → buat database baru, catat:
   hostname, nama database, username, password (semua sudah diberi prefix `if0_...`).
2. Buka **phpMyAdmin** dari cPanel InfinityFree, pilih database yang baru dibuat.
3. Import file `database_sawitshandy.sql` (sudah disediakan di project ini) — ini
   akan membuat semua tabel (`users`, `kebun`, `blok_kebun`, `hasil_panen`) beserta
   1 akun admin default.
4. Update kembali `.env` di server dengan kredensial DB InfinityFree tadi (langkah A.2).

### D. Uji coba
1. Buka `http://namadomainanda.infinityfreeapp.com/`.
2. Harusnya langsung diarahkan ke halaman login SawitShandy.
3. Login dengan admin/admin123, lalu segera ganti password lewat phpMyAdmin
   (update kolom `password` dengan hash bcrypt baru) untuk keamanan produksi.

## 4) Tema warna
Semua warna (hijau tua `#14532d`, hijau `#16a34a`, hijau muda `#86efac`, putih) dan
efek gradasi diatur lewat CSS variable + `<style>` inline di
`app/Views/templates/header.php` dan `app/Views/auth/login.php` — tidak ada file
`.css` terpisah, sesuai permintaan.
