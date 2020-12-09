-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema CSC4710
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `CSC4710` ;

-- -----------------------------------------------------
-- Schema CSC4710
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `CSC4710` DEFAULT CHARACTER SET latin1 ;
USE `CSC4710` ;

-- -----------------------------------------------------
-- Table `CSC4710`.`restaurant_types`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CSC4710`.`restaurant_types` ;

CREATE TABLE IF NOT EXISTS `CSC4710`.`restaurant_types` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `category` ENUM('Fast food', 'Fast casual', 'Casual dining', 'Premium casual', 'Family style', 'Fine dining') NOT NULL,
  `description` VARCHAR(200) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `CSC4710`.`address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CSC4710`.`address` ;

CREATE TABLE IF NOT EXISTS `CSC4710`.`address` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `street` VARCHAR(200) NOT NULL,
  `city` VARCHAR(100) NOT NULL,
  `state` VARCHAR(2) NOT NULL,
  `zipcode` INT NOT NULL,
  `coordinate` POINT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CSC4710`.`restaurant`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CSC4710`.`restaurant` ;

CREATE TABLE IF NOT EXISTS `CSC4710`.`restaurant` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `type` INT(11) NOT NULL,
  `manager` INT(11) NOT NULL,
  `address` INT(11) NOT NULL,
  `name` VARCHAR(200) NOT NULL,
  `phone` VARCHAR(20) NULL DEFAULT NULL,
  `website` VARCHAR(200) NULL DEFAULT NULL,
  `status` ENUM('open', 'closed', 'unavailable') NOT NULL,
  `open` TIME NOT NULL,
  `close` TIME NOT NULL,
  `day_of_week` ENUM('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thrusday', 'Friday', 'Saturday') NOT NULL,
  INDEX `rest_types_fk` (`type` ASC) VISIBLE,
  CONSTRAINT `rest_types_fk`
    FOREIGN KEY (`type`)
    REFERENCES `CSC4710`.`restaurant_types` (`id`),
  CONSTRAINT `restaurant_address_fk`
    FOREIGN KEY (`id`)
    REFERENCES `CSC4710`.`address` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `CSC4710`.`employee`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CSC4710`.`employee` ;

CREATE TABLE IF NOT EXISTS `CSC4710`.`employee` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `firstname` VARCHAR(100) NOT NULL,
  `lastname` VARCHAR(100) NOT NULL,
  `ssn` VARCHAR(15) NOT NULL,
  `holiday_status` ENUM('on', 'off') NOT NULL DEFAULT 'off',
  `phone` VARCHAR(20) NULL,
  `address` INT NULL,
  `supervisor` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `address_fk_idx` (`address` ASC) VISIBLE,
  INDEX `supervisor_fk_idx` (`supervisor` ASC) VISIBLE,
  CONSTRAINT `employee_address_fk`
    FOREIGN KEY (`address`)
    REFERENCES `CSC4710`.`address` (`id`)
    ON DELETE SET NULL
    ON UPDATE SET NULL,
  CONSTRAINT `supervisor_fk`
    FOREIGN KEY (`supervisor`)
    REFERENCES `CSC4710`.`employee` (`id`)
    ON DELETE SET NULL
    ON UPDATE SET NULL)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CSC4710`.`customer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CSC4710`.`customer` ;

CREATE TABLE IF NOT EXISTS `CSC4710`.`customer` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `firstname` VARCHAR(100) NOT NULL,
  `lastname` VARCHAR(100) NOT NULL,
  `email` VARCHAR(45) NULL,
  `phone` VARCHAR(20) NULL,
  `address` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `address_fk_idx` (`address` ASC) VISIBLE,
  CONSTRAINT `customer_address_fk`
    FOREIGN KEY (`address`)
    REFERENCES `CSC4710`.`address` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CSC4710`.`order`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CSC4710`.`order` ;

CREATE TABLE IF NOT EXISTS `CSC4710`.`order` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `customer` INT NOT NULL,
  `driver` INT NOT NULL,
  `payment_method` INT NOT NULL,
  `deliver_to` INT NOT NULL,
  `created` DATETIME NOT NULL,
  `delivered` DATETIME NULL,
  `canceled` DATETIME NULL,
  `status` ENUM('created', 'delivered', 'canceled') NOT NULL,
  `tip` DECIMAL(12,4) NULL,
  `total` DECIMAL(12,4) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `order_customer_fk_idx` (`customer` ASC) VISIBLE,
  INDEX `order_address_fk_idx` (`deliver_to` ASC) VISIBLE,
  CONSTRAINT `order_customer_fk`
    FOREIGN KEY (`customer`)
    REFERENCES `CSC4710`.`customer` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `order_address_fk`
    FOREIGN KEY (`deliver_to`)
    REFERENCES `CSC4710`.`address` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CSC4710`.`order_item`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CSC4710`.`order_item` ;

CREATE TABLE IF NOT EXISTS `CSC4710`.`order_item` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `order_id` INT NOT NULL,
  `menu_item` INT NOT NULL,
  `quantity` INT NOT NULL,
  `total` DECIMAL(12,4) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `order_item_order_fk_idx` (`order_id` ASC) VISIBLE,
  CONSTRAINT `order_item_order_fk`
    FOREIGN KEY (`order_id`)
    REFERENCES `CSC4710`.`order` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CSC4710`.`order_review`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CSC4710`.`order_review` ;

CREATE TABLE IF NOT EXISTS `CSC4710`.`order_review` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `order_id` INT NOT NULL,
  `rate` ENUM('poor', 'fair', 'average', 'good', 'excellent') NOT NULL,
  `comments` VARCHAR(500) NULL,
  `timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `order_id_UNIQUE` (`order_id` ASC) VISIBLE,
  CONSTRAINT `order_review_order_fk`
    FOREIGN KEY (`order_id`)
    REFERENCES `CSC4710`.`order` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CSC4710`.`delivery_review`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CSC4710`.`delivery_review` ;

CREATE TABLE IF NOT EXISTS `CSC4710`.`delivery_review` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `order_id` INT NOT NULL,
  `rate` ENUM('poor', 'fair', 'average', 'good', 'excellent') NOT NULL,
  `comments` VARCHAR(500) NULL,
  `timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `order_id_UNIQUE` (`order_id` ASC) VISIBLE,
  CONSTRAINT `delivery_review_order`
    FOREIGN KEY (`order_id`)
    REFERENCES `CSC4710`.`order` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CSC4710`.`seasonal`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CSC4710`.`seasonal` ;

CREATE TABLE IF NOT EXISTS `CSC4710`.`seasonal` (
  `employee_id` INT NOT NULL,
  `start_date` DATETIME NOT NULL,
  `end_date` DATETIME NOT NULL,
  `hourly_wage` DECIMAL(12,4) NOT NULL,
  `weekly_hours` INT NOT NULL,
  PRIMARY KEY (`employee_id`),
  CONSTRAINT `seasonal_employee_fk`
    FOREIGN KEY (`employee_id`)
    REFERENCES `CSC4710`.`employee` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CSC4710`.`parttime`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CSC4710`.`parttime` ;

CREATE TABLE IF NOT EXISTS `CSC4710`.`parttime` (
  `employee_id` INT NOT NULL,
  `start_date` DATETIME NOT NULL,
  `end_date` DATETIME NOT NULL,
  `hourly_wage` DECIMAL(12,4) NOT NULL,
  `weekly_hours` INT NOT NULL,
  PRIMARY KEY (`employee_id`),
  CONSTRAINT `partime_employee_fk0`
    FOREIGN KEY (`employee_id`)
    REFERENCES `CSC4710`.`employee` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CSC4710`.`fulltime`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CSC4710`.`fulltime` ;

CREATE TABLE IF NOT EXISTS `CSC4710`.`fulltime` (
  `employee_id` INT NOT NULL,
  `start_date` DATETIME NOT NULL,
  `end_date` DATETIME NOT NULL,
  `hourly_wage` DECIMAL(12,4) NOT NULL,
  `weekly_hours` INT NOT NULL,
  CONSTRAINT `fulltime_employee_fk`
    FOREIGN KEY (`employee_id`)
    REFERENCES `CSC4710`.`employee` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CSC4710`.`employee_productivity`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CSC4710`.`employee_productivity` ;

CREATE TABLE IF NOT EXISTS `CSC4710`.`employee_productivity` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `employee_id` INT NOT NULL,
  `clocked_in` DATETIME NOT NULL,
  `clocked_out` DATETIME NULL,
  `assigned_hours` INT NOT NULL,
  `hours_earned` INT NULL,
  `goal` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `employee_productivity_employee_idx` (`employee_id` ASC) VISIBLE,
  CONSTRAINT `employee_productivity_employee`
    FOREIGN KEY (`employee_id`)
    REFERENCES `CSC4710`.`employee` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
