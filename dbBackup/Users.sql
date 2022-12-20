-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Anamakine: mysql:3306
-- Üretim Zamanı: 19 Ara 2022, 13:31:16
-- Sunucu sürümü: 10.9.3-MariaDB-1:10.9.3+maria~ubu2204
-- PHP Sürümü: 8.0.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `Users`
--

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `moneyTransfer`
--

CREATE TABLE `moneyTransfer` (
  `id` int(11) NOT NULL,
  `recipientUserId` int(11) NOT NULL,
  `senderUserId` int(11) NOT NULL,
  `transferType` int(11) NOT NULL,
  `transferAmount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `recyclingHistory`
--

CREATE TABLE `recyclingHistory` (
  `id` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `recyclingResponseId` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `totalCount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `recyclingResponse`
--

CREATE TABLE `recyclingResponse` (
  `id` int(255) NOT NULL,
  `materiel` varchar(256) NOT NULL,
  `materielType` varchar(256) NOT NULL,
  `carbonResponse` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `userAccount`
--

CREATE TABLE `userAccount` (
  `balance` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `userId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `firstName` varchar(256) NOT NULL,
  `surName` varchar(256) NOT NULL,
  `phone` varchar(25) NOT NULL,
  `email` varchar(256) NOT NULL,
  `pasword` varchar(256) NOT NULL,
  `hash` varchar(256) NOT NULL,
  `userType` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Tablo döküm verisi `users`
--

INSERT INTO `users` (`id`, `firstName`, `surName`, `phone`, `email`, `pasword`, `hash`, `userType`) VALUES
(1, '', '', '', '', '', '', '');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `userTypes`
--

CREATE TABLE `userTypes` (
  `typeName` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `moneyTransfer`
--
ALTER TABLE `moneyTransfer`
  ADD PRIMARY KEY (`id`),
  ADD KEY `senderUserId` (`senderUserId`),
  ADD KEY `recipientUserId` (`recipientUserId`);

--
-- Tablo için indeksler `recyclingHistory`
--
ALTER TABLE `recyclingHistory`
  ADD PRIMARY KEY (`id`),
  ADD KEY `recyclingResponseId` (`recyclingResponseId`),
  ADD KEY `userId` (`userId`);

--
-- Tablo için indeksler `recyclingResponse`
--
ALTER TABLE `recyclingResponse`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `userAccount`
--
ALTER TABLE `userAccount`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userId` (`userId`);

--
-- Tablo için indeksler `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `hash` (`hash`),
  ADD KEY `userType` (`userType`);

--
-- Tablo için indeksler `userTypes`
--
ALTER TABLE `userTypes`
  ADD PRIMARY KEY (`typeName`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `moneyTransfer`
--
ALTER TABLE `moneyTransfer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Tablo için AUTO_INCREMENT değeri `recyclingHistory`
--
ALTER TABLE `recyclingHistory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Tablo için AUTO_INCREMENT değeri `recyclingResponse`
--
ALTER TABLE `recyclingResponse`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- Tablo için AUTO_INCREMENT değeri `userAccount`
--
ALTER TABLE `userAccount`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Tablo için AUTO_INCREMENT değeri `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `moneyTransfer`
--
ALTER TABLE `moneyTransfer`
  ADD CONSTRAINT `moneyTransfer_ibfk_1` FOREIGN KEY (`recipientUserId`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `moneyTransfer_ibfk_2` FOREIGN KEY (`senderUserId`) REFERENCES `users` (`id`);

--
-- Tablo kısıtlamaları `recyclingHistory`
--
ALTER TABLE `recyclingHistory`
  ADD CONSTRAINT `recyclingHistory_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `recyclingHistory_ibfk_2` FOREIGN KEY (`recyclingResponseId`) REFERENCES `recyclingResponse` (`id`);

--
-- Tablo kısıtlamaları `userAccount`
--
ALTER TABLE `userAccount`
  ADD CONSTRAINT `userAccount_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Tablo kısıtlamaları `userTypes`
--
ALTER TABLE `userTypes`
  ADD CONSTRAINT `userTypes_ibfk_1` FOREIGN KEY (`typeName`) REFERENCES `users` (`userType`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
