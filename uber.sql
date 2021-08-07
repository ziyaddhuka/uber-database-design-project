-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema uber
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema uber
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `uber` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `uber` ;

-- -----------------------------------------------------
-- Table `uber`.`Fare`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `uber`.`Fare` (
  `car_type` ENUM('UBER_GO', 'UBER_XL', 'UBER_XXL') NOT NULL,
  `base_fare` DOUBLE NULL DEFAULT NULL,
  PRIMARY KEY (`car_type`),
  UNIQUE INDEX `car_type_UNIQUE` (`car_type` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `uber`.`car`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `uber`.`car` (
  `id` INT NOT NULL,
  `model` VARCHAR(45) NULL DEFAULT NULL,
  `registration_number` VARCHAR(45) NULL DEFAULT NULL,
  `brand` VARCHAR(45) NULL DEFAULT NULL,
  `type` ENUM('UBER_GO', 'UBER_XL', 'UBER_XXL') NULL DEFAULT NULL,
  `insurance_expiry` DATE NULL DEFAULT '2015-09-13',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `uber`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `uber`.`user` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `fname` VARCHAR(50) NOT NULL,
  `lname` VARCHAR(50) NOT NULL,
  `dob` DATE NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `phone_number` VARCHAR(10) NOT NULL,
  `rating` DOUBLE NULL DEFAULT NULL,
  `gender` ENUM('MALE', 'FEMALE', 'TRANSGENDER') NOT NULL,
  `created_time` DATETIME NOT NULL,
  `updated_time` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `uber`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `uber`.`customer` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `membership_type` ENUM('GOLD', 'PREMIUM', 'ORDINARY') NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `customer_user_fk`
    FOREIGN KEY (`id`)
    REFERENCES `uber`.`user` (`user_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `uber`.`offer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `uber`.`offer` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `promo_code` VARCHAR(45) NOT NULL,
  `discount_amt` DOUBLE NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `uber`.`customer_offer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `uber`.`customer_offer` (
  `customer_id` INT NOT NULL,
  `offer_id` INT NOT NULL,
  PRIMARY KEY (`customer_id`, `offer_id`),
  INDEX `co_offer_fk_idx` (`offer_id` ASC) VISIBLE,
  CONSTRAINT `co_cust_fk`
    FOREIGN KEY (`customer_id`)
    REFERENCES `uber`.`customer` (`id`),
  CONSTRAINT `co_offer_fk`
    FOREIGN KEY (`offer_id`)
    REFERENCES `uber`.`offer` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `uber`.`driver`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `uber`.`driver` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `ssn` VARCHAR(10) NOT NULL,
  `dl_no` VARCHAR(45) NOT NULL,
  `is_active` TINYINT NULL DEFAULT NULL,
  `lat` VARCHAR(45) NULL DEFAULT NULL,
  `longi` VARCHAR(45) NULL DEFAULT NULL,
  `car_id` INT NULL DEFAULT NULL,
  `dl_expiry` DATE NULL DEFAULT '2025-09-13',
  PRIMARY KEY (`id`),
  INDEX `driver_car_fk_idx` (`car_id` ASC) VISIBLE,
  CONSTRAINT `driver_car_fk`
    FOREIGN KEY (`car_id`)
    REFERENCES `uber`.`car` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `driver_user_fk`
    FOREIGN KEY (`id`)
    REFERENCES `uber`.`user` (`user_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `uber`.`payment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `uber`.`payment` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `payment_mode` VARCHAR(45) NULL DEFAULT NULL,
  `offer_id` INT NULL DEFAULT NULL,
  `ride_amount` VARCHAR(45) NULL DEFAULT NULL,
  `payment_amount` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `payment_offer_id_fk_idx` (`offer_id` ASC) VISIBLE,
  CONSTRAINT `payment_offer_id_fk`
    FOREIGN KEY (`offer_id`)
    REFERENCES `uber`.`offer` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `uber`.`rating`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `uber`.`rating` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `customer_rating` DOUBLE NULL DEFAULT NULL,
  `driver_rating` DOUBLE NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `uber`.`ride`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `uber`.`ride` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `status` ENUM('CANCELLED', 'BOOKED', 'DRIVER_ASSIGNED', 'DRIVER_REQUESTING', 'RIDE_STARTED', 'RIDE_COMPLETED') NOT NULL,
  `customer_id` INT NOT NULL,
  `driver_id` INT NOT NULL,
  `start_latitude` VARCHAR(45) NOT NULL,
  `start_longitude` VARCHAR(45) NOT NULL,
  `end_latitude` VARCHAR(45) NOT NULL,
  `end_longitude` VARCHAR(45) NOT NULL,
  `start_time` DATETIME NULL DEFAULT NULL,
  `end_time` DATETIME NULL DEFAULT NULL,
  `created_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_time` DATETIME NULL DEFAULT NULL,
  `is_surge_applied` TINYINT NULL DEFAULT NULL,
  `surge_percentage` DOUBLE NULL DEFAULT NULL,
  `ride_amount` DOUBLE NULL DEFAULT NULL,
  `payment_id` INT NULL DEFAULT NULL,
  `rating_id` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `ride_customer_id_foreign` (`customer_id` ASC) VISIBLE,
  INDEX `ride_rating_id_foreign` (`rating_id` ASC) VISIBLE,
  INDEX `ride_payment_id_foreign_idx` (`payment_id` ASC) VISIBLE,
  INDEX `ride_payment_id_foreign_idx1` (`payment_id` ASC) VISIBLE,
  INDEX `ride_driver_id_fk_idx` (`driver_id` ASC) VISIBLE,
  CONSTRAINT `ride_customer_id_foreign`
    FOREIGN KEY (`customer_id`)
    REFERENCES `uber`.`customer` (`id`),
  CONSTRAINT `ride_driver_id_fk`
    FOREIGN KEY (`driver_id`)
    REFERENCES `uber`.`driver` (`id`),
  CONSTRAINT `ride_payment_id_fk`
    FOREIGN KEY (`payment_id`)
    REFERENCES `uber`.`payment` (`id`),
  CONSTRAINT `ride_rating_id_foreign`
    FOREIGN KEY (`rating_id`)
    REFERENCES `uber`.`rating` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `uber` ;

-- -----------------------------------------------------
-- procedure find_nearby_drivers
-- -----------------------------------------------------

DELIMITER $$
USE `uber`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `find_nearby_drivers`(IN ride_id INT)
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
	declare latitude,longitude VARCHAR(45);
    declare driver_lat,driver_long VARCHAR(45);
    declare driver_id int;
    declare distance varchar(10);
    declare driver cursor for select lat,longi,id from driver where is_active=1;
    declare CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
    drop table nearby_drivers;
    create temporary table nearby_drivers(id int, distance varchar(10));
	SELECT start_latitude, start_longitude into latitude,longitude from ride where id=ride_id;
	OPEN driver;
	getDriverInfo: LOOP
		FETCH driver INTO driver_lat, driver_long, driver_id;
		IF finished = 1 THEN 
			LEAVE getDriverInfo;
		END IF;
		-- build email list
        set distance = getDistance(latitude,longitude,driver_lat,driver_long);
        if(distance < 25.0)
        then 
			insert into nearby_drivers values(driver_id,distance);
		end if;
	END LOOP getDriverInfo;
	CLOSE driver;
    select * from nearby_drivers;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure find_ride_amount
-- -----------------------------------------------------

DELIMITER $$
USE `uber`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `find_ride_amount`(IN ride_id INT, OUT ride_amt DOUBLE)
BEGIN
  declare start_latitude, start_longitude, end_latitude, end_longitude varchar(45);
  declare is_surge boolean;
  declare surge_per double;
  declare base_fare double;
  declare distance varchar(10);
  select R.start_latitude, R.start_longitude, R.end_latitude, R.end_longitude , R.is_surge_applied, R.surge_percentage , F.base_fare
  into start_latitude, start_longitude, end_latitude, end_longitude, is_surge, surge_per, base_fare from ride as R
  inner join driver D on R.driver_id = D.id 
  inner join car C on D.car_id = C.id
  inner join Fare F on F.car_type = C.type and R.id = ride_id;
  set distance = getDistance(start_latitude,start_longitude,end_latitude,end_longitude);
  if(is_surge)
  then
	set ride_amt = base_fare * distance * surge_per;
  else
	set ride_amt = base_fare * distance;
  end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function getDistance
-- -----------------------------------------------------

DELIMITER $$
USE `uber`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `getDistance`(`lat1` VARCHAR(45), `lng1` VARCHAR(45), `lat2` VARCHAR(45), `lng2` VARCHAR(45)) RETURNS varchar(10) CHARSET utf8
    READS SQL DATA
    DETERMINISTIC
begin
declare distance varchar(10);
set distance = (select (6371 * acos( 
                cos( radians(lat2) ) 
              * cos( radians( lat1 ) ) 
              * cos( radians( lng1 ) - radians(lng2) ) 
              + sin( radians(lat2) ) 
              * sin( radians( lat1 ) )) ) as distance); 
if(distance is null)
then
 return '';
else 
return distance;
end if;
end$$

DELIMITER ;
USE `uber`;

DELIMITER $$
USE `uber`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `uber`.`car_BEFORE_INSERT`
BEFORE INSERT ON `uber`.`car`
FOR EACH ROW
BEGIN
	if(NEW.insurance_expiry < sysdate)
    then
		signal sqlstate '45000' set message_text = 'Expiry date of driving license should be greater than current date'; 
    end if;
END$$

USE `uber`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `uber`.`driver_BEFORE_INSERT`
BEFORE INSERT ON `uber`.`driver`
FOR EACH ROW
BEGIN
	if(NEW.dl_expiry < sysdate)
    then
		signal sqlstate '45000' set message_text = 'Expiry date of driving license should be greater than current date'; 
    end if;
END$$

USE `uber`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `uber`.`driver_BEFORE_UPDATE`
BEFORE UPDATE ON `uber`.`driver`
FOR EACH ROW
BEGIN
	if(NEW.dl_expiry < sysdate)
    then
		signal sqlstate '45000' set message_text = 'Expiry date of driving license should be greater than current date'; 
    end if;
END$$

USE `uber`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `uber`.`ride_AFTER_INSERT`
AFTER INSERT ON `uber`.`ride`
FOR EACH ROW
BEGIN
	SET @ride_amt = 0.0;
    call find_ride_amt(NEW.id,@ride_amt);
    update ride set ride_amt = @ride_amt where id = NEW.id;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
