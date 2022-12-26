-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Anamakine: mysql:3306
-- Üretim Zamanı: 26 Ara 2022, 21:00:11
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
-- Veritabanı: `coinDB`
--

DELIMITER $$
--
-- Yordamlar
--
CREATE DEFINER=`root`@`%` PROCEDURE `add_recycling` (IN `user_id` INT, IN `recycling_response_id` INT, IN `count` INT)   this_proc:BEGIN
  START TRANSACTION;

SELECT getRecyclingPrice(recycling_response_id) INTO @price;

  IF @price is null THEN
    SELECT 'No recycling information!' AS message;
    ROLLBACK;
    leave this_proc;
  END IF;

  insert into recyclingHistory (userId, recyclingResponseId, price, count) values (user_id, recycling_response_id, @price, count);
  
  update users
    set balance = balance + ((@price / 100) * count)
    where id =user_id ;

  COMMIT;

  SELECT 'Recycling information has been recorded.' AS message;

 END$$

CREATE DEFINER=`root`@`%` PROCEDURE `transfer_money` (IN `recipient_user_id` INT, IN `sender_user_id` INT, IN `transfer_type` INT, IN `transfer_amount` FLOAT)   this_proc:BEGIN
  START TRANSACTION;
    SELECT isTransferMoney(sender_user_id,transfer_amount) INTO @moneyTranferState;

  IF NOT @moneyTranferState THEN
    SELECT 'Insufficient balance' AS message;
    ROLLBACK;
    leave this_proc;
  END IF;
  
insert into moneyTransfer (recipientUserId, senderUserId,transferType,transferAmount) values (recipient_user_id, sender_user_id,transfer_type,transfer_amount);

update users
set balance = balance - transfer_amount
where id = sender_user_id;

update users
set balance = balance + transfer_amount
where id = recipient_user_id;
  COMMIT;

  SELECT 'Transfer successful' AS message;

 END$$

--
-- İşlevler
--
CREATE DEFINER=`root`@`%` FUNCTION `getRecyclingPrice` (IN `recycling_id` INT) RETURNS FLOAT  BEGIN
  SELECT price INTO @price FROM recyclingResponse WHERE id=recycling_id;

        RETURN @price;
END$$

CREATE DEFINER=`root`@`%` FUNCTION `isTransferMoney` (IN `user_id` INT, IN `transfer_amount` FLOAT) RETURNS TINYINT(4)  BEGIN
  SELECT balance INTO @from_balance FROM users WHERE id=user_id;
    IF (@from_balance < transfer_amount) THEN
        RETURN 0;
    ELSE
        RETURN 1;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `materielTypes`
--

CREATE TABLE `materielTypes` (
  `materielType` varchar(256) NOT NULL,
  `materielTypeName` varchar(256) NOT NULL,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `moneyTransfer`
--

CREATE TABLE `moneyTransfer` (
  `id` int(11) NOT NULL,
  `recipientUserId` int(11) NOT NULL,
  `senderUserId` int(11) NOT NULL,
  `transferType` int(11) NOT NULL,
  `transferAmount` float NOT NULL,
  `createdDate` timestamp NOT NULL DEFAULT current_timestamp()
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
  `count` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `recyclingResponse`
--

CREATE TABLE `recyclingResponse` (
  `id` int(255) NOT NULL,
  `materielName` varchar(256) NOT NULL,
  `materielTypeId` int(11) NOT NULL,
  `price` float NOT NULL
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
  `password` varchar(256) NOT NULL,
  `hash` varchar(256) DEFAULT NULL,
  `recoveryCode` varchar(10) DEFAULT NULL,
  `balance` float NOT NULL DEFAULT 0,
  `birthyear` int(11) NOT NULL,
  `identityNo` varchar(11) NOT NULL,
  `userTypeId` int(11) NOT NULL DEFAULT 2
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `userTypes`
--

CREATE TABLE `userTypes` (
  `typeName` varchar(256) NOT NULL,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Tablo döküm verisi `userTypes`
--

INSERT INTO `userTypes` (`typeName`, `id`) VALUES
('root', 1)
('anonymous', 2);

-- --------------------------------------------------------

--
-- Görünüm yapısı durumu `vwMoneyTransfer`
-- (Asıl görünüm için aşağıya bakın)
--
CREATE TABLE `vwMoneyTransfer` (
`id` int(11)
,`recipientUserId` int(11)
,`senderUserId` int(11)
,`transferType` int(11)
,`transferAmount` float
,`createdDate` timestamp
,`senderFirstName` varchar(256)
,`senderLastName` varchar(256)
,`recipientFirstName` varchar(256)
,`recipientLastName` varchar(256)
);

-- --------------------------------------------------------

--
-- Görünüm yapısı durumu `vwRecyclingHistory`
-- (Asıl görünüm için aşağıya bakın)
--
CREATE TABLE `vwRecyclingHistory` (
`id` int(11)
,`userId` int(11)
,`recyclingResponseId` int(11)
,`price` int(11)
,`count` int(11)
,`materielName` varchar(256)
,`userFirstName` varchar(256)
,`userLastName` varchar(256)
);

-- --------------------------------------------------------

--
-- Görünüm yapısı durumu `vwRecyclingResponse`
-- (Asıl görünüm için aşağıya bakın)
--
CREATE TABLE `vwRecyclingResponse` (
`id` int(255)
,`materielName` varchar(256)
,`materielTypeId` int(11)
,`price` float
,`materielType` varchar(256)
,`materielTypeName` varchar(256)
);

-- --------------------------------------------------------

--
-- Görünüm yapısı durumu `vwUserRecyclingHistory`
-- (Asıl görünüm için aşağıya bakın)
--
CREATE TABLE `vwUserRecyclingHistory` (
`id` int(11)
,`userId` int(11)
,`recyclingResponseId` int(11)
,`price` int(11)
,`count` int(11)
);

-- --------------------------------------------------------

--
-- Görünüm yapısı durumu `vwUsers`
-- (Asıl görünüm için aşağıya bakın)
--
CREATE TABLE `vwUsers` (
`id` int(11)
,`firstName` varchar(256)
,`surName` varchar(256)
,`phone` varchar(25)
,`email` varchar(256)
,`hash` varchar(256)
,`recoveryCode` varchar(10)
,`balance` float
,`birthyear` int(11)
,`identityNo` varchar(11)
,`userTypeId` int(11)
,`userType` varchar(256)
);

-- --------------------------------------------------------

--
-- Görünüm yapısı `vwMoneyTransfer`
--
DROP TABLE IF EXISTS `vwMoneyTransfer`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vwMoneyTransfer`  AS SELECT `moneyTransfer`.`id` AS `id`, `moneyTransfer`.`recipientUserId` AS `recipientUserId`, `moneyTransfer`.`senderUserId` AS `senderUserId`, `moneyTransfer`.`transferType` AS `transferType`, `moneyTransfer`.`transferAmount` AS `transferAmount`, `moneyTransfer`.`createdDate` AS `createdDate`, `sender`.`firstName` AS `senderFirstName`, `sender`.`surName` AS `senderLastName`, `recipient`.`firstName` AS `recipientFirstName`, `recipient`.`surName` AS `recipientLastName` FROM ((`moneyTransfer` join `users` `sender` on(`moneyTransfer`.`senderUserId` = `sender`.`id`)) join `users` `recipient` on(`moneyTransfer`.`recipientUserId` = `recipient`.`id`))  ;

-- --------------------------------------------------------

--
-- Görünüm yapısı `vwRecyclingHistory`
--
DROP TABLE IF EXISTS `vwRecyclingHistory`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vwRecyclingHistory`  AS SELECT `recyclingHistory`.`id` AS `id`, `recyclingHistory`.`userId` AS `userId`, `recyclingHistory`.`recyclingResponseId` AS `recyclingResponseId`, `recyclingHistory`.`price` AS `price`, `recyclingHistory`.`count` AS `count`, `recyclingResponse`.`materielName` AS `materielName`, `users`.`firstName` AS `userFirstName`, `users`.`surName` AS `userLastName` FROM ((`recyclingHistory` join `recyclingResponse` on(`recyclingHistory`.`recyclingResponseId` = `recyclingResponse`.`id`)) join `users` on(`recyclingHistory`.`userId` = `users`.`id`))  ;

-- --------------------------------------------------------

--
-- Görünüm yapısı `vwRecyclingResponse`
--
DROP TABLE IF EXISTS `vwRecyclingResponse`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vwRecyclingResponse`  AS SELECT `recyclingResponse`.`id` AS `id`, `recyclingResponse`.`materielName` AS `materielName`, `recyclingResponse`.`materielTypeId` AS `materielTypeId`, `recyclingResponse`.`price` AS `price`, `materielTypes`.`materielType` AS `materielType`, `materielTypes`.`materielTypeName` AS `materielTypeName` FROM (`recyclingResponse` join `materielTypes` on(`recyclingResponse`.`materielTypeId` = `materielTypes`.`id`))  ;

-- --------------------------------------------------------

--
-- Görünüm yapısı `vwUserRecyclingHistory`
--
DROP TABLE IF EXISTS `vwUserRecyclingHistory`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vwUserRecyclingHistory`  AS SELECT `recyclingHistory`.`id` AS `id`, `recyclingHistory`.`userId` AS `userId`, `recyclingHistory`.`recyclingResponseId` AS `recyclingResponseId`, `recyclingHistory`.`price` AS `price`, `recyclingHistory`.`count` AS `count` FROM (`recyclingHistory` join `users` on(`users`.`id` = `recyclingHistory`.`userId`))  ;

-- --------------------------------------------------------

--
-- Görünüm yapısı `vwUsers`
--
DROP TABLE IF EXISTS `vwUsers`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vwUsers`  AS SELECT `users`.`id` AS `id`, `users`.`firstName` AS `firstName`, `users`.`surName` AS `surName`, `users`.`phone` AS `phone`, `users`.`email` AS `email`, `users`.`hash` AS `hash`, `users`.`recoveryCode` AS `recoveryCode`, `users`.`balance` AS `balance`, `users`.`birthyear` AS `birthyear`, `users`.`identityNo` AS `identityNo`, `users`.`userTypeId` AS `userTypeId`, `userTypes`.`typeName` AS `userType` FROM (`users` join `userTypes` on(`users`.`userTypeId` = `userTypes`.`id`))  ;

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `materielTypes`
--
ALTER TABLE `materielTypes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `materielType` (`materielType`,`materielTypeName`);

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
  ADD PRIMARY KEY (`id`),
  ADD KEY `materielTypeId` (`materielTypeId`);

--
-- Tablo için indeksler `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `email_2` (`email`),
  ADD UNIQUE KEY `identityNo` (`identityNo`),
  ADD UNIQUE KEY `hash` (`hash`),
  ADD KEY `userTypeId` (`userTypeId`);

--
-- Tablo için indeksler `userTypes`
--
ALTER TABLE `userTypes`
  ADD PRIMARY KEY (`id`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `materielTypes`
--
ALTER TABLE `materielTypes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Tablo için AUTO_INCREMENT değeri `moneyTransfer`
--
ALTER TABLE `moneyTransfer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- Tablo için AUTO_INCREMENT değeri `recyclingHistory`
--
ALTER TABLE `recyclingHistory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Tablo için AUTO_INCREMENT değeri `recyclingResponse`
--
ALTER TABLE `recyclingResponse`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Tablo için AUTO_INCREMENT değeri `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- Tablo için AUTO_INCREMENT değeri `userTypes`
--
ALTER TABLE `userTypes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
-- Tablo kısıtlamaları `recyclingResponse`
--
ALTER TABLE `recyclingResponse`
  ADD CONSTRAINT `recyclingResponse_ibfk_1` FOREIGN KEY (`materielTypeId`) REFERENCES `materielTypes` (`id`);

--
-- Tablo kısıtlamaları `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`userTypeId`) REFERENCES `userTypes` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
