
CREATE TABLE IF NOT EXISTS `oph3z_motel` (
  `id` int(11) NOT NULL DEFAULT 0,
  `names` text NOT NULL DEFAULT '[]',
  `info` text NOT NULL DEFAULT '[]',
  `employees` text NOT NULL DEFAULT '[]',
  `rooms` longtext NOT NULL CHECK (json_valid(`rooms`)),
  `history` text NOT NULL DEFAULT '[]',
  `bucketcache` text NOT NULL DEFAULT '[]',
  `request` text NOT NULL DEFAULT '[]',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;