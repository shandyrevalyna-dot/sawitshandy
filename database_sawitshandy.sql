-- ============================================
-- Database: sawitshandy
-- Digunakan sebagai alternatif import manual via phpMyAdmin
-- (jika tidak menjalankan `php spark migrate` di lokal)
-- ============================================

CREATE TABLE IF NOT EXISTS `users` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nama` VARCHAR(100) NOT NULL,
  `username` VARCHAR(50) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `created_at` DATETIME NULL,
  `updated_at` DATETIME NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- password default: admin123 (sudah di-hash dengan bcrypt)
INSERT INTO `users` (`nama`, `username`, `password`, `created_at`, `updated_at`)
VALUES ('Administrator', 'admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NOW(), NOW());

CREATE TABLE IF NOT EXISTS `kebun` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `kode_kebun` VARCHAR(20) NOT NULL UNIQUE,
  `nama_kebun` VARCHAR(100) NOT NULL,
  `lokasi` VARCHAR(150) NOT NULL,
  `luas_lahan` DECIMAL(10,2) NOT NULL,
  `tahun_tanam` YEAR NOT NULL,
  `keterangan` TEXT NULL,
  `created_at` DATETIME NULL,
  `updated_at` DATETIME NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `blok_kebun` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `kebun_id` INT(11) UNSIGNED NOT NULL,
  `kode_blok` VARCHAR(20) NOT NULL UNIQUE,
  `nama_blok` VARCHAR(100) NOT NULL,
  `luas_blok` DECIMAL(10,2) NOT NULL,
  `jumlah_pohon` INT(11) NOT NULL,
  `status_blok` ENUM('Aktif','Tidak Aktif','Replanting') NOT NULL DEFAULT 'Aktif',
  `created_at` DATETIME NULL,
  `updated_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_blok_kebun` FOREIGN KEY (`kebun_id`) REFERENCES `kebun` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `hasil_panen` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `kebun_id` INT(11) UNSIGNED NOT NULL,
  `blok_id` INT(11) UNSIGNED NOT NULL,
  `jumlah_panen` DECIMAL(10,2) NOT NULL,
  `tanggal_panen` DATE NOT NULL,
  `created_at` DATETIME NULL,
  `updated_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_panen_kebun` FOREIGN KEY (`kebun_id`) REFERENCES `kebun` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_panen_blok` FOREIGN KEY (`blok_id`) REFERENCES `blok_kebun` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
