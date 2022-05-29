-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- 主机： 10.0.0.252
-- 生成日期： 2022-05-29 15:38:20
-- 服务器版本： 8.0.27
-- PHP 版本： 7.4.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+08:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 数据库： `GameVoucherManage`
--

-- --------------------------------------------------------

--
-- 表的结构 `Admin`
--

CREATE TABLE `Admin` (
  `Id` int NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Pwd` varchar(50) NOT NULL,
  `Role` int NOT NULL COMMENT '0-管理员  1-操作员',
  `IsTwoStep` tinyint(1) NOT NULL,
  `TwoStepCode` varchar(200) NOT NULL,
  `PageSize` int NOT NULL,
  `Status` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 转存表中的数据 `Admin`
--

INSERT INTO `Admin` (`Id`, `Name`, `Pwd`, `Role`, `IsTwoStep`, `TwoStepCode`, `PageSize`, `Status`) VALUES
(1, '111111', '683f846ec9df55ff1239000eab568276', 0, 0, '', 50, 0);

-- --------------------------------------------------------

--
-- 表的结构 `DistributionLog`
--

CREATE TABLE `DistributionLog` (
  `Id` int NOT NULL,
  `PackageName` varchar(200) NOT NULL,
  `GameName` varchar(100) NOT NULL,
  `ProductId` varchar(200) NOT NULL,
  `ProductName` varchar(500) NOT NULL,
  `Title` varchar(200) NOT NULL,
  `Description` varchar(500) NOT NULL,
  `CurrencyCode` varchar(50) NOT NULL,
  `PriceInfo` varchar(50) NOT NULL,
  `Price` decimal(10,4) NOT NULL,
  `UserId` int NOT NULL,
  `UserAccount` varchar(50) NOT NULL,
  `AdminId` int NOT NULL,
  `AdminName` varchar(50) NOT NULL,
  `Count` int NOT NULL,
  `CreateTime` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 表的结构 `ExportLog`
--

CREATE TABLE `ExportLog` (
  `Id` bigint NOT NULL,
  `PackageName` varchar(200) NOT NULL,
  `GameName` varchar(100) NOT NULL,
  `ProductId` varchar(200) NOT NULL,
  `ProductName` varchar(500) NOT NULL,
  `Title` varchar(200) NOT NULL,
  `Description` varchar(500) NOT NULL,
  `CurrencyCode` varchar(50) NOT NULL,
  `PriceInfo` varchar(50) NOT NULL,
  `Price` decimal(10,4) NOT NULL,
  `AdminId` int NOT NULL,
  `AdminName` varchar(50) NOT NULL,
  `Count` int NOT NULL,
  `Data` mediumblob NOT NULL,
  `CreateTime` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 表的结构 `Game`
--

CREATE TABLE `Game` (
  `PackageName` varchar(200) NOT NULL,
  `GameName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Status` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 表的结构 `GamePrice`
--

CREATE TABLE `GamePrice` (
  `ProductId` varchar(200) NOT NULL,
  `ProductName` varchar(500) NOT NULL,
  `PackageName` varchar(200) NOT NULL,
  `GameName` varchar(100) NOT NULL,
  `Type` varchar(50) NOT NULL,
  `Title` varchar(200) NOT NULL,
  `PriceInfo` varchar(50) NOT NULL,
  `Price` decimal(10,4) NOT NULL,
  `CurrencyCode` varchar(50) NOT NULL,
  `Description` varchar(500) NOT NULL,
  `SkuDetailsToken` varchar(500) NOT NULL,
  `Status` tinyint(1) NOT NULL,
  `UpdateTime` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 表的结构 `ImportLog`
--

CREATE TABLE `ImportLog` (
  `Id` bigint NOT NULL,
  `PackageName` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `GameName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ProductId` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ProductName` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `CurrencyCode` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `PriceInfo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Price` decimal(10,4) NOT NULL,
  `Count` int NOT NULL,
  `AdminId` int NOT NULL,
  `AdminName` varchar(50) NOT NULL,
  `CreateTime` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 表的结构 `Log`
--

CREATE TABLE `Log` (
  `Id` int NOT NULL,
  `Path` varchar(200) NOT NULL,
  `Method` varchar(50) NOT NULL,
  `QueryString` text NOT NULL,
  `Form` text NOT NULL,
  `Result` text NOT NULL,
  `Ip` varchar(100) NOT NULL,
  `SessionId` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Admin` varchar(50) NOT NULL,
  `CreateTime` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 表的结构 `Setting`
--

CREATE TABLE `Setting` (
  `Id` int NOT NULL,
  `DistributionType` int NOT NULL,
  `UserId` int NOT NULL,
  `License` varchar(5000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 转存表中的数据 `Setting`
--

INSERT INTO `Setting` (`Id`, `DistributionType`, `UserId`, `License`) VALUES
(1, 0, 0, '');

-- --------------------------------------------------------

--
-- 表的结构 `Store`
--

CREATE TABLE `Store` (
  `Id` int NOT NULL,
  `PackageName` varchar(200) NOT NULL,
  `GameName` varchar(100) NOT NULL,
  `ProductId` varchar(200) NOT NULL,
  `ProductName` varchar(500) NOT NULL,
  `Title` varchar(200) NOT NULL,
  `Description` varchar(500) NOT NULL,
  `CurrencyCode` varchar(50) NOT NULL,
  `PriceInfo` varchar(50) NOT NULL,
  `Price` decimal(10,4) NOT NULL,
  `PutUserId` bigint NOT NULL,
  `PutAccount` varchar(50) NOT NULL,
  `OutUserId` bigint NOT NULL,
  `OutAccount` varchar(50) NOT NULL,
  `OrderId` varchar(50) NOT NULL,
  `PurchaseTime` datetime NOT NULL,
  `PurchaseState` int NOT NULL,
  `PurchaseToken` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `PurchaseJson` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Signature` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `CreateTime` datetime NOT NULL,
  `Status` int NOT NULL,
  `OutboundTime` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 表的结构 `StoreDelLog`
--

CREATE TABLE `StoreDelLog` (
  `Id` int NOT NULL,
  `PackageName` varchar(200) NOT NULL,
  `GameName` varchar(100) NOT NULL,
  `ProductId` varchar(200) NOT NULL,
  `ProductName` varchar(500) NOT NULL,
  `Title` varchar(200) NOT NULL,
  `Description` varchar(500) NOT NULL,
  `CurrencyCode` varchar(50) NOT NULL,
  `PriceInfo` varchar(50) NOT NULL,
  `Price` decimal(10,4) NOT NULL,
  `PutUserId` bigint NOT NULL,
  `PutAccount` varchar(50) NOT NULL,
  `OutUserId` bigint NOT NULL,
  `OutAccount` varchar(50) NOT NULL,
  `OrderId` varchar(50) NOT NULL,
  `PurchaseTime` datetime NOT NULL,
  `PurchaseState` int NOT NULL,
  `PurchaseToken` varchar(2000) NOT NULL,
  `PurchaseJson` varchar(5000) NOT NULL,
  `Signature` varchar(5000) NOT NULL,
  `CreateTime` datetime NOT NULL,
  `Status` int NOT NULL,
  `DelTime` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 表的结构 `StoreLog`
--

CREATE TABLE `StoreLog` (
  `Id` int NOT NULL,
  `StoreId` int NOT NULL,
  `PackageName` varchar(200) NOT NULL,
  `GameName` varchar(100) NOT NULL,
  `ProductId` varchar(200) NOT NULL,
  `ProductName` varchar(500) NOT NULL,
  `OrderId` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `UserId` bigint NOT NULL,
  `UserAccount` varchar(100) NOT NULL,
  `Type` int NOT NULL,
  `CreateTime` datetime NOT NULL,
  `AdminId` int NOT NULL,
  `AdminName` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 表的结构 `User`
--

CREATE TABLE `User` (
  `Id` int NOT NULL,
  `Account` varchar(50) NOT NULL,
  `NickName` varchar(50) NOT NULL,
  `PassWord` varchar(50) NOT NULL,
  `Import` tinyint(1) NOT NULL,
  `Export` tinyint(1) NOT NULL,
  `Status` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 转储表的索引
--

--
-- 表的索引 `Admin`
--
ALTER TABLE `Admin`
  ADD PRIMARY KEY (`Id`);

--
-- 表的索引 `DistributionLog`
--
ALTER TABLE `DistributionLog`
  ADD PRIMARY KEY (`Id`);

--
-- 表的索引 `ExportLog`
--
ALTER TABLE `ExportLog`
  ADD PRIMARY KEY (`Id`);

--
-- 表的索引 `Game`
--
ALTER TABLE `Game`
  ADD PRIMARY KEY (`PackageName`);

--
-- 表的索引 `GamePrice`
--
ALTER TABLE `GamePrice`
  ADD PRIMARY KEY (`ProductId`,`PackageName`);

--
-- 表的索引 `ImportLog`
--
ALTER TABLE `ImportLog`
  ADD PRIMARY KEY (`Id`);

--
-- 表的索引 `Log`
--
ALTER TABLE `Log`
  ADD PRIMARY KEY (`Id`);

--
-- 表的索引 `Setting`
--
ALTER TABLE `Setting`
  ADD PRIMARY KEY (`Id`);

--
-- 表的索引 `Store`
--
ALTER TABLE `Store`
  ADD PRIMARY KEY (`Id`);

--
-- 表的索引 `StoreDelLog`
--
ALTER TABLE `StoreDelLog`
  ADD PRIMARY KEY (`Id`);

--
-- 表的索引 `StoreLog`
--
ALTER TABLE `StoreLog`
  ADD PRIMARY KEY (`Id`);

--
-- 表的索引 `User`
--
ALTER TABLE `User`
  ADD PRIMARY KEY (`Id`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `Admin`
--
ALTER TABLE `Admin`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- 使用表AUTO_INCREMENT `DistributionLog`
--
ALTER TABLE `DistributionLog`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `Log`
--
ALTER TABLE `Log`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `Store`
--
ALTER TABLE `Store`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `StoreDelLog`
--
ALTER TABLE `StoreDelLog`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `StoreLog`
--
ALTER TABLE `StoreLog`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `User`
--
ALTER TABLE `User`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
