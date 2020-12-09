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
  `zipcode` VARCHAR(20) NOT NULL,
  `latitude` DECIMAL(11,8) NULL,
  `longitude` DECIMAL(11,8) NULL,
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
  `day_of_week` INT NOT NULL,
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
  `phone` VARCHAR(30) NULL,
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
  `phone` VARCHAR(30) NULL,
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
-- Table `CSC4710`.`driver`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CSC4710`.`driver` ;

CREATE TABLE IF NOT EXISTS `CSC4710`.`driver` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `firstname` VARCHAR(100) NOT NULL,
  `lastname` VARCHAR(100) NOT NULL,
  `email` VARCHAR(45) NULL,
  `phone` VARCHAR(30) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CSC4710`.`credentials`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CSC4710`.`credentials` ;

CREATE TABLE IF NOT EXISTS `CSC4710`.`credentials` (
  `userid` INT NOT NULL AUTO_INCREMENT,
  `password` VARCHAR(255) NOT NULL,
  `employee_id` INT NULL,
  `driver_id` INT NULL,
  `customer_id` INT NULL,
  `role` ENUM('manager', 'employee', 'customer', 'driver') NOT NULL,
  PRIMARY KEY (`userid`),
  INDEX `credentials_employee_fk_idx` (`employee_id` ASC) VISIBLE,
  INDEX `credentials_driver_fk_idx` (`driver_id` ASC) VISIBLE,
  INDEX `credentials_customer_id_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `credentials_employee_fk`
    FOREIGN KEY (`employee_id`)
    REFERENCES `CSC4710`.`employee` (`id`)
    ON DELETE SET NULL
    ON UPDATE SET NULL,
  CONSTRAINT `credentials_driver_fk`
    FOREIGN KEY (`driver_id`)
    REFERENCES `CSC4710`.`driver` (`id`)
    ON DELETE SET NULL
    ON UPDATE SET NULL,
  CONSTRAINT `credentials_customer_id`
    FOREIGN KEY (`customer_id`)
    REFERENCES `CSC4710`.`customer` (`id`)
    ON DELETE SET NULL
    ON UPDATE SET NULL)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CSC4710`.`credit_card`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CSC4710`.`credit_card` ;

CREATE TABLE IF NOT EXISTS `CSC4710`.`credit_card` (
  `credit_card_id` VARCHAR(255) NOT NULL,
  `branch` VARCHAR(45) NOT NULL,
  `expiration_month` INT NOT NULL,
  `expiration_year` INT NOT NULL,
  PRIMARY KEY (`credit_card_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CSC4710`.`google_pay`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CSC4710`.`google_pay` ;

CREATE TABLE IF NOT EXISTS `CSC4710`.`google_pay` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `comments` VARCHAR(45) NULL,
  `uid` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CSC4710`.`paypal`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CSC4710`.`paypal` ;

CREATE TABLE IF NOT EXISTS `CSC4710`.`paypal` (
  `id` INT(16) NOT NULL,
  `comments` VARCHAR(45) NULL,
  `uid` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CSC4710`.`payment_method`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CSC4710`.`payment_method` ;

CREATE TABLE IF NOT EXISTS `CSC4710`.`payment_method` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `userid` INT NOT NULL,
  `credit_card_id` VARCHAR(255) NULL,
  `paypal_id` INT NULL,
  `google_pay_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `payment_method_credentials_fk_idx` (`userid` ASC) VISIBLE,
  INDEX `payment_method_credit_card_fk_idx` (`credit_card_id` ASC) VISIBLE,
  INDEX `payment_method_google_pay_fk_idx` (`google_pay_id` ASC) VISIBLE,
  INDEX `payment_method_paypal_fk_idx` (`paypal_id` ASC) VISIBLE,
  CONSTRAINT `payment_method_credentials_fk`
    FOREIGN KEY (`userid`)
    REFERENCES `CSC4710`.`credentials` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `payment_method_credit_card_fk`
    FOREIGN KEY (`credit_card_id`)
    REFERENCES `CSC4710`.`credit_card` (`credit_card_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `payment_method_google_pay_fk`
    FOREIGN KEY (`google_pay_id`)
    REFERENCES `CSC4710`.`google_pay` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `payment_method_paypal_fk`
    FOREIGN KEY (`paypal_id`)
    REFERENCES `CSC4710`.`paypal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CSC4710`.`order`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CSC4710`.`order` ;

CREATE TABLE IF NOT EXISTS `CSC4710`.`order` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `userid` INT NOT NULL,
  `driver` INT NOT NULL,
  `payment_method` INT NOT NULL,
  `deliver_to` INT NOT NULL,
  `created` DATETIME NOT NULL,
  `delivered` DATETIME NULL,
  `canceled` DATETIME NULL,
  `status` ENUM('created', 'delivered', 'canceled') NOT NULL,
  `tip` DECIMAL(12,4) NULL DEFAULT 0,
  `total` DECIMAL(12,4) NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `order_address_fk_idx` (`deliver_to` ASC) VISIBLE,
  INDEX `order_driver_fk_idx` (`driver` ASC) VISIBLE,
  INDEX `order_credentials_fk_idx` (`userid` ASC) VISIBLE,
  INDEX `order_payment_method_fk_idx` (`payment_method` ASC) VISIBLE,
  CONSTRAINT `order_address_fk`
    FOREIGN KEY (`deliver_to`)
    REFERENCES `CSC4710`.`address` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `order_driver_fk`
    FOREIGN KEY (`driver`)
    REFERENCES `CSC4710`.`driver` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `order_credentials_fk`
    FOREIGN KEY (`userid`)
    REFERENCES `CSC4710`.`credentials` (`userid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `order_payment_method_fk`
    FOREIGN KEY (`payment_method`)
    REFERENCES `CSC4710`.`payment_method` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CSC4710`.`menu`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CSC4710`.`menu` ;

CREATE TABLE IF NOT EXISTS `CSC4710`.`menu` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `restaurant_id` INT NOT NULL,
  `title` VARCHAR(100) NOT NULL,
  `content` TEXT(2000) NULL,
  `enabled` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `menu_restaurant_fk_idx` (`restaurant_id` ASC) VISIBLE,
  CONSTRAINT `menu_restaurant_fk`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `CSC4710`.`restaurant` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
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
  INDEX `order_item_menu_idx` (`menu_item` ASC) VISIBLE,
  CONSTRAINT `order_item_order_fk`
    FOREIGN KEY (`order_id`)
    REFERENCES `CSC4710`.`order` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `order_item_menu`
    FOREIGN KEY (`menu_item`)
    REFERENCES `CSC4710`.`menu` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
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


-- -----------------------------------------------------
-- Table `CSC4710`.`ingredients`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CSC4710`.`ingredients` ;

CREATE TABLE IF NOT EXISTS `CSC4710`.`ingredients` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `allergen` VARCHAR(20) NULL,
  `diet_adherence_tag` VARCHAR(45) NULL,
  `name` VARCHAR(75) NOT NULL,
  `price` DECIMAL(11,8) NULL,
  `size` DECIMAL(11,8) NULL,
  `calories` INT NULL,
  `promotion_tag` VARCHAR(45) NULL,
  `unit` ENUM('kg', 'oz', 'g', 'mg', 'l') NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CSC4710`.`menu_items`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CSC4710`.`menu_items` ;

CREATE TABLE IF NOT EXISTS `CSC4710`.`menu_items` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `menu_id` INT NULL,
  `ingredient_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `menu_items_menu_fk_idx` (`menu_id` ASC) VISIBLE,
  INDEX `menu_items_ingredients_fk_idx` (`ingredient_id` ASC) VISIBLE,
  CONSTRAINT `menu_items_menu_fk`
    FOREIGN KEY (`menu_id`)
    REFERENCES `CSC4710`.`menu` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `menu_items_ingredients_fk`
    FOREIGN KEY (`ingredient_id`)
    REFERENCES `CSC4710`.`ingredients` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
