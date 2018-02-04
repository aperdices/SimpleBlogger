-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema blog
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema blog
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `blog` DEFAULT CHARACTER SET latin1 ;
USE `blog` ;

-- -----------------------------------------------------
-- Table `blog`.`USER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `blog`.`USER` (
  `USERNAME` VARCHAR(32) NOT NULL,
  `PASSWORD` VARCHAR(64) NOT NULL,
  `NAME` VARCHAR(32) NULL,
  `LASTNAME` VARCHAR(64) NULL,
  `EMAIL` VARCHAR(64) NULL,
  `CREATION_DATE` DATETIME NOT NULL,
  `MODIFICATION_DATE` DATETIME NULL,
  `ENABLED` TINYINT(1) NOT NULL DEFAULT TRUE,
  PRIMARY KEY (`USERNAME`));


-- -----------------------------------------------------
-- Table `blog`.`ENTRY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `blog`.`ENTRY` (
  `ENTRY_ID` INT NOT NULL AUTO_INCREMENT,
  `USERNAME` VARCHAR(32) NOT NULL,
  `TITLE` VARCHAR(256) NOT NULL,
  `DESCRIPTION` VARCHAR(1024) NULL,
  `BODY` TEXT NULL,
  `CREATION_DATE` DATETIME NOT NULL,
  `MODIFICATION_DATE` DATETIME NULL,
  `PUBLISHED` TINYINT(1) NOT NULL DEFAULT FALSE,
  PRIMARY KEY (`ENTRY_ID`),
  INDEX `FK_REL_USER_ENTRY_idx` (`USERNAME` ASC),
  CONSTRAINT `FK_REL_USER_ENTRY`
    FOREIGN KEY (`USERNAME`)
    REFERENCES `blog`.`USER` (`USERNAME`));


-- -----------------------------------------------------
-- Table `blog`.`TAG`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `blog`.`TAG` (
  `TAG_ID` INT NOT NULL AUTO_INCREMENT,
  `TAGNAME` VARCHAR(32) NOT NULL,
  `CREATION_DATE` DATETIME NOT NULL,
  `MODIFICATION_DATE` DATETIME NULL,
  PRIMARY KEY (`TAG_ID`));


-- -----------------------------------------------------
-- Table `blog`.`REL_ENTRY_TAG`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `blog`.`REL_ENTRY_TAG` (
  `ENTRY_ID` INT NOT NULL,
  `TAG_ID` INT NOT NULL,
  PRIMARY KEY (`ENTRY_ID`, `TAG_ID`),
  INDEX `FK_REL_ENTRY_TAG2_idx` (`TAG_ID` ASC),
  INDEX `FK_REL_ENTRY_TAG_idx` (`ENTRY_ID` ASC),
  CONSTRAINT `FK_REL_ENTRY_TAG`
    FOREIGN KEY (`ENTRY_ID`)
    REFERENCES `blog`.`ENTRY` (`ENTRY_ID`)
    ON DELETE restrict
    ON UPDATE restrict,
  CONSTRAINT `FK_REL_ENTRY_TAG2`
    FOREIGN KEY (`TAG_ID`)
    REFERENCES `blog`.`TAG` (`TAG_ID`)
    ON DELETE restrict
    ON UPDATE restrict);


-- -----------------------------------------------------
-- Table `blog`.`ROLE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `blog`.`ROLE` (
  `ROLE` VARCHAR(64) NOT NULL,
  `DESCRIPTION` VARCHAR(128) NULL,
  `CREATION_DATE` DATETIME NOT NULL,
  `MODIFICATION_DATE` DATETIME NULL,
  PRIMARY KEY (`ROLE`));


-- -----------------------------------------------------
-- Table `blog`.`REL_USER_ROLE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `blog`.`REL_USER_ROLE` (
  `ROLE` VARCHAR(64) NOT NULL,
  `USERNAME` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`ROLE`, `USERNAME`),
  INDEX `FK_REL_USER_ROLE2_idx` (`USERNAME` ASC),
  INDEX `FK_REL_USER_ROLE_idx` (`ROLE` ASC),
  CONSTRAINT `FK_REL_USER_ROLE`
    FOREIGN KEY (`ROLE`)
    REFERENCES `blog`.`ROLE` (`ROLE`)
    ON DELETE restrict
    ON UPDATE restrict,
  CONSTRAINT `FK_REL_USER_ROLE2`
    FOREIGN KEY (`USERNAME`)
    REFERENCES `blog`.`USER` (`USERNAME`)
    ON DELETE restrict
    ON UPDATE restrict);


-- -----------------------------------------------------
-- Table `blog`.`PAGE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `blog`.`PAGE` (
  `PAGE_ID` INT NOT NULL AUTO_INCREMENT,
  `USERNAME` VARCHAR(32) NOT NULL,
  `TITLE` VARCHAR(256) NOT NULL,
  `BODY` TEXT NULL,
  `CREATION_DATE` DATETIME NOT NULL,
  `MODIFICATION_DATE` DATETIME NULL,
  `MENU_ORDER` INT NOT NULL DEFAULT 0,
  `MENU_TITLE` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`PAGE_ID`),
  INDEX `FK_REL_USER_PAGE_idx` (`USERNAME` ASC),
  CONSTRAINT `FK_REL_USER_PAGE`
    FOREIGN KEY (`USERNAME`)
    REFERENCES `blog`.`USER` (`USERNAME`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `blog`.`RESOURCE_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `blog`.`RESOURCE_TYPE` (
  `RESOURCE_TYPE_ID` VARCHAR(8) NOT NULL,
  `DESCRIPTION` VARCHAR(64) NOT NULL,
  `CREATION_DATE` DATETIME NOT NULL,
  `MODIFICATION_DATE` DATETIME NULL,
  PRIMARY KEY (`RESOURCE_TYPE_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `blog`.`RESOURCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `blog`.`RESOURCE` (
  `RESOURCE_ID` INT NOT NULL,
  `NAME` VARCHAR(64) NOT NULL,
  `CREATION_DATE` DATETIME NOT NULL,
  `MODIFICATION_DATE` DATETIME NULL,
  `RESOURCE_TYPE_ID` VARCHAR(8) NOT NULL,
  `DATA` BLOB() NOT NULL,
  PRIMARY KEY (`RESOURCE_ID`),
  INDEX `fk_RESOURCE_RESOURCE_TYPE1_idx` (`RESOURCE_TYPE_ID` ASC),
  CONSTRAINT `FK_RESOURCE_RESOURCE_TYPE1`
    FOREIGN KEY (`RESOURCE_TYPE_ID`)
    REFERENCES `blog`.`RESOURCE_TYPE` (`RESOURCE_TYPE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `blog`.`REL_ENTRY_RESOURCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `blog`.`REL_ENTRY_RESOURCE` (
  `ENTRY_ID` INT NOT NULL,
  `RESOURCE_ID` INT NOT NULL,
  PRIMARY KEY (`ENTRY_ID`, `RESOURCE_ID`),
  INDEX `fk_ENTRY_has_RESOURCE_RESOURCE1_idx` (`RESOURCE_ID` ASC),
  INDEX `fk_ENTRY_has_RESOURCE_ENTRY1_idx` (`ENTRY_ID` ASC),
  CONSTRAINT `fk_ENTRY_has_RESOURCE_ENTRY1`
    FOREIGN KEY (`ENTRY_ID`)
    REFERENCES `blog`.`ENTRY` (`ENTRY_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ENTRY_has_RESOURCE_RESOURCE1`
    FOREIGN KEY (`RESOURCE_ID`)
    REFERENCES `blog`.`RESOURCE` (`RESOURCE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `blog`.`REL_PAGE_RESOURCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `blog`.`REL_PAGE_RESOURCE` (
  `PAGE_ID` INT NOT NULL,
  `RESOURCE_ID` INT NOT NULL,
  PRIMARY KEY (`PAGE_ID`, `RESOURCE_ID`),
  INDEX `fk_PAGE_has_RESOURCE_RESOURCE1_idx` (`RESOURCE_ID` ASC),
  INDEX `fk_PAGE_has_RESOURCE_PAGE1_idx` (`PAGE_ID` ASC),
  CONSTRAINT `fk_PAGE_has_RESOURCE_PAGE1`
    FOREIGN KEY (`PAGE_ID`)
    REFERENCES `blog`.`PAGE` (`PAGE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PAGE_has_RESOURCE_RESOURCE1`
    FOREIGN KEY (`RESOURCE_ID`)
    REFERENCES `blog`.`RESOURCE` (`RESOURCE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
