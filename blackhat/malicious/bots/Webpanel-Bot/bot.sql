-- phpMyAdmin SQL Dump
-- version 3.4.5
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Erstellungszeit: 07. Jun 2012 um 16:36
-- Server Version: 5.5.16
-- PHP-Version: 5.3.8

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Datenbank: `bot`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `panel_done`
--

CREATE TABLE IF NOT EXISTS `panel_done` (
  `taskID` int(11) NOT NULL,
  `botID` int(11) NOT NULL,
  KEY `botID` (`botID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `panel_grabber`
--

CREATE TABLE IF NOT EXISTS `panel_grabber` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `PCname` text COLLATE latin1_german1_ci NOT NULL,
  `ToolName` text COLLATE latin1_german1_ci NOT NULL,
  `LinkTool` text COLLATE latin1_german1_ci NOT NULL,
  `LoginName` text COLLATE latin1_german1_ci NOT NULL,
  `PassGrabb` text COLLATE latin1_german1_ci NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_german1_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `panel_tasks`
--

CREATE TABLE IF NOT EXISTS `panel_tasks` (
  `taskID` int(11) NOT NULL AUTO_INCREMENT,
  `command` text COLLATE latin1_german1_ci NOT NULL,
  `startTime` int(11) NOT NULL,
  `endTime` int(11) NOT NULL,
  `botsUsed` int(11) NOT NULL,
  `botsLeft` int(11) NOT NULL,
  PRIMARY KEY (`taskID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_german1_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `panel_victims`
--

CREATE TABLE IF NOT EXISTS `panel_victims` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `PCName` text COLLATE latin1_german1_ci NOT NULL,
  `BotVersion` text COLLATE latin1_german1_ci NOT NULL,
  `InstTime` int(11) NOT NULL,
  `ConTime` int(11) NOT NULL,
  `Country` text COLLATE latin1_german1_ci NOT NULL,
  `CName` text COLLATE latin1_german1_ci NOT NULL,
  `WinVersion` text COLLATE latin1_german1_ci NOT NULL,
  `HWID` text COLLATE latin1_german1_ci NOT NULL,
  `IP` text COLLATE latin1_german1_ci NOT NULL,
  `taskID` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_german1_ci AUTO_INCREMENT=1 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
