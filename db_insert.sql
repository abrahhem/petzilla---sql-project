CREATE DATABASE petzilla;


CREATE TABLE `petzilla`.`Personal_info` (
  `PInfo_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `phone` VARCHAR(20) NOT NULL,
  `address` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`PInfo_id`)
);

CREATE TABLE `petzilla`.`Customers` (
  `customer_id` INT NOT NULL AUTO_INCREMENT,
  `PInfo_id` INT NOT NULL UNIQUE,
  PRIMARY KEY (`customer_id`),
  FOREIGN KEY (PInfo_id) REFERENCES Personal_info (PInfo_id)
  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `petzilla`.`specieses` (
  `species_id` INT NOT NULL AUTO_INCREMENT,
  `species` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`species_id`)
);


CREATE TABLE `petzilla`.`Pets` (
  `pet_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `age` FLOAT NOT NULL,
  `speies_id` INT NOT NULL,
  PRIMARY KEY (`pet_id`),
  FOREIGN KEY (speies_id) REFERENCES specieses (species_id)
  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `petzilla`.`customers_pets` (
  `customer_id` INT NOT NULL,
  `pet_id` INT NOT NULL UNIQUE,
  PRIMARY KEY (`customer_id`, `pet_id`),
  FOREIGN KEY (customer_id) REFERENCES Customers (customer_id)
  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (pet_id) REFERENCES Pets (pet_id)
  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `petzilla`.`Jobs` (
  `job_id` INT NOT NULL,
  `job` VARCHAR(12) NOT NULL,
  PRIMARY KEY (`job_id`)
);

CREATE TABLE `petzilla`.`Statuses` (
  `Status_id` INT NOT NULL,
  `Status` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`Status_id`)
);

CREATE TABLE `petzilla`.`Employees` (
  `employee_id` INT NOT NULL AUTO_INCREMENT,
  `PInfo_id` INT NOT NULL UNIQUE,
  `job_id` INT NOT NULL,
  PRIMARY KEY (`employee_id`),
  FOREIGN KEY (PInfo_id) REFERENCES Personal_info (PInfo_id)
  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (job_id) REFERENCES Jobs (job_id)
  ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE `petzilla`.`Orders` (
  `order_id` INT NOT NULL AUTO_INCREMENT,
  `customer_id` INT NOT NULL,
  `employee_id` INT NOT NULL,
  `status_id` INT NOT NULL,
  `total` FLOAT NULL DEFAULT 0,
  `order_date` DATE NOT NULL,
  PRIMARY KEY (`order_id`),
  FOREIGN KEY (customer_id) REFERENCES Customers (customer_id)
  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (employee_id) REFERENCES Employees (employee_id)
  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (status_id) REFERENCES Statuses (status_id)
  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `petzilla`.`Shipments` (
  `Shipment` INT NOT NULL AUTO_INCREMENT,
  `order_id` INT NOT NULL UNIQUE,
  `employee_id` INT NOT NULL,
  `shipment_date` DATE NULL,
  PRIMARY KEY (`Shipment`),
  FOREIGN KEY (order_id) REFERENCES Orders (order_id)
  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (employee_id) REFERENCES Employees (employee_id)
  ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE `petzilla`.`Products` (
  `product_id` INT NOT NULL AUTO_INCREMENT,
  `species_id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `price` FLOAT NOT NULL,
  `stock` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`product_id`),
  FOREIGN KEY (species_id) REFERENCES specieses (species_id)
  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `petzilla`.`stock_history` (
  `SH_id` INT NOT NULL AUTO_INCREMENT,
  `product_id` INT NOT NULL,
  `employee_id` INT NOT NULL,
  `stock` INT NOT NULL,
  `SH_date` DATE NOT NULL,
  PRIMARY KEY (`SH_id`),
  FOREIGN KEY (employee_id) REFERENCES Employees (employee_id)
  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (product_id) REFERENCES Products (product_id)
  ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE `petzilla`.`OrdersItems` (
  `order_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `quantity` INT NOT NULL DEFAULT 1,
  PRIMARY KEY (`order_id`, `product_id`),
  FOREIGN KEY (order_id) REFERENCES Orders (order_id)
  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (product_id) REFERENCES Products (product_id)
  ON DELETE CASCADE ON UPDATE CASCADE
);


DELIMITER $$
CREATE  TRIGGER UpdateTotal_OrdersItems_insert AFTER INSERT ON OrdersItems FOR EACH ROW 
	BEGIN
		UPDATE Orders o 
			 SET total = 
             CASE
				WHEN (SELECT SUM(p.price*oi.quantity) FROM OrdersItems OI INNER JOIN Products p USING(product_id) WHERE oi.order_id = o.order_id) > 180
					THEN (SELECT SUM(p.price*oi.quantity) FROM OrdersItems OI INNER JOIN Products p USING(product_id) WHERE oi.order_id = o.order_id)
					ELSE (SELECT SUM(p.price*oi.quantity) FROM OrdersItems OI INNER JOIN Products p USING(product_id) WHERE oi.order_id = o.order_id) + 25
			END
            WHERE
				o.order_id = new.order_id;
	END;$$
DELIMITER ;

DROP Trigger UpdateTotal_OrdersItems_1;

DELIMITER $$
CREATE TRIGGER UpdateTotal_OrdersItems_delete AFTER DELETE ON OrdersItems FOR EACH ROW 
	BEGIN
		UPDATE Orders o 
			 SET total = 
             CASE
				WHEN (SELECT SUM(p.price*oi.quantity) FROM OrdersItems OI INNER JOIN Products p USING(product_id) WHERE oi.order_id = o.order_id) > 180
					THEN (SELECT SUM(p.price*oi.quantity) FROM OrdersItems OI INNER JOIN Products p USING(product_id) WHERE oi.order_id = o.order_id)
					ELSE (SELECT SUM(p.price*oi.quantity) FROM OrdersItems OI INNER JOIN Products p USING(product_id) WHERE oi.order_id = o.order_id) + 25
			END
            WHERE
				o.order_id = old.order_id;
	END;$$
DELIMITER ; 

DELIMITER $$
CREATE TRIGGER UpdateTotal_OrdersItems_update AFTER UPDATE ON OrdersItems FOR EACH ROW 
	BEGIN
		IF(old.quantity != new.quantity)
        THEN
			UPDATE Orders o 
				 SET total = 
				 CASE
					WHEN (SELECT SUM(p.price*oi.quantity) FROM OrdersItems OI INNER JOIN Products p USING(product_id) WHERE oi.order_id = o.order_id) > 180
						THEN (SELECT SUM(p.price*oi.quantity) FROM OrdersItems OI INNER JOIN Products p USING(product_id) WHERE oi.order_id = o.order_id)
						ELSE (SELECT SUM(p.price*oi.quantity) FROM OrdersItems OI INNER JOIN Products p USING(product_id) WHERE oi.order_id = o.order_id) + 25
				END
				WHERE
					o.order_id = new.order_id;
		END IF;
	END;$$
DELIMITER; 

DELIMITER $$
CREATE  TRIGGER StockChange_insert AFTER INSERT ON stock_history FOR EACH ROW 
	BEGIN
		UPDATE Products p 
			SET stock = new.stock
            WHERE
				p.product_id = new.product_id;
	END;$$
DELIMITER ;


DELIMITER $$
CREATE  TRIGGER StockChange_update AFTER UPDATE ON stock_history FOR EACH ROW 
	BEGIN
		IF(old.stock != new.stock)
        THEN
			UPDATE Products p 
				SET stock = new.stock
				WHERE
					p.product_id = new.product_id;
		END IF;
	END;$$
DELIMITER ;


INSERT INTO `petzilla`.`jobs` VALUES ('1', 'storekeeper'), ('2', 'seller'), ('3', 'delivery');
INSERT INTO `petzilla`.`Statuses` VALUES ('1', 'cancelled'), ('2', 'received'), ('3', 'sent');


INSERT INTO `petzilla`.`Personal_info` (`name`, `phone`, `address`) VALUES ('JENNIFER DAVIS', '9534099999', '939 Probolinggo, La Corua'),
('GRACE MOSTEL', '9534400000', '397 Sunnyvale Avenue, Allende'), ('CUBA OLIVIER', '8678099999', '1014 Loja Manor,, Ambattur'),
('FAY KILMER', '8051100000', '992 Klerksdorp, Amersfoort'), ('DUSTIN TAUTOU', '8051499999', '334 Monghyr Lane, Arak'), 
('SIDNEY CROWE', '8298500000', '659 Vaduz Drive, Ashdod'), ('MORGAN HOPKINS', '9534299999', '125 Citt del Vaticano Boulevard, Atlixco'),
('DAN STREEP', '8877099999', '183 Haiphong Street, Baicheng'), ('KEVIN GARLAND', '7631599999', '624 Oshawa Boulevard, Balurghat'),
('CATE MCQUEEN', '9204699999', '771 Yaound Manor, Beira'), ('JANE JACKMAN', '7209099999', '97 Mogiljov Lane, Bhavnagar'),
('EWAN WILLIAMS', '8603500000', '152 Kitwe Parkway, Bislig'), ('LUCILLE DEE', '8797999999', '1342 Abha Boulevard, Bucuresti'),
('GEOFFREY HESTON', '9031999999', '1378 Alvorada Avenue, Caracas'), ('BEN HARRIS', '9279599999', '1947 Poos de Caldas Boulevard, Chiayi'),
('JULIA ZELLWEGER', '8603400000', '734 Tanshui Avenue, Florencia'), ('REESE WEST', '8797100000', '1049 Matamoros Parkway, Gulbarga'),
('JAYNE SILVERSTONE', '9031700000', '68 Ponce Parkway, Hanoi'), ('GROUCHO WILLIAMS', '9263300000', '791 Salinas Street, Hoshiarpur'),
('VIVIEN BASINGER	', '9031399999', '955 Bamenda Way, Ikerre'), ('KENNETH TORN', '8092999999', '1148 Saarbrcken Parkway, Iwaki'),
('SPENCER PECK', '9263900000', '60 Poos de Caldas Street,  Jodhpur'), ('MILLA KEITEL', '8797500000', '320 Brest Avenue, Kaduna'),
('DUSTIN TAUTOU', '9279399999', '886 Tonghae Place, Kamyin'), ('DAN HARRIS', '7209000000', '1191 Sungai Petani Boulevard, Kansas City'),
('PENELOPE PINKETT', '7209799999', '184 Mandaluyong Street, La Paz'), ('ED GUINESS', '9204642991', '596 Huixquilucan, Naala-Porto'), 
('JEFF SILVERSTONE', '3890099234', '1786 Salinas, Nam Dinh'), ('DEBBIE AKROYD', '6544099111', '909 Garland Manor, Niznekamsk'),
('RUSSELL CLOSE', '8544092456', '734 Bchar, Okara');

INSERT INTO `petzilla`.`Customers` (`PInfo_id`) VALUES	('11'), ('12'), ('13'), ('14'), ('15'), ('16'), 
														('17'), ('19'), ('20'), ('21'), ('22'), ('23'), ('24'), ('25'), ('26'),
                                                        ('27'), ('28'), ('29'), ('30');

INSERT INTO `petzilla`.`Specieses` (`Species`) VALUES ('Dog'), ('Cat');

INSERT INTO `petzilla`.`Pets` (`name`, `age`, `speies_id`) VALUES ('Bob', '2', '1'), ('Soha', '1', '2'), ('Boo', '4', '1'), ('Simba', '3', '2'),
('Gunther', '6', '2'), ('Bruno', '5', '1'), ('Klaus', '8', '1'), ('Koko', '3', '1'), ('Flab jack', '1', '2'), ('Abbas', '3', '2'), ('Tyler', '6', '1'),
('Willie', '3', '1'), ('Nagaya', '7', '2'), ('Zeus', '8', '1'), ('Gumboll', '3', '2'), ('Yoda', '2', '1'), ('Hiccup', '6', '2'),
('Zeke', '8', '1'), ('Chad', '9', '2'), ('Snoopy', '5', '1'), ('Scooby-doo', '6', '1'), ('Clifford', '7', '2'), ('Dinky', '2', '2'),
('Maggie', '1', '1'), ('Griffen', '3', '2'), ('Dean', '4', '1'), ('Garfield', '3', '2'), ('Dixie', '6', '2'), ('Cookie', '2', '2'),
('Dillon', '3', '2'), ('Eddy', '1', '2'), ('Eva', '7', '2'), ('Kissy', '4', '1'), ('Bug', '2', '1'), ('Chocolate', '3', '1'),
('Bullet', '4', '2'), ('Cocoa', '1', '2');


INSERT INTO `petzilla`.`customers_pets` VALUES ('15', '1'), ('14', '2'), ('13', '3'), ('12', '4'),
('11', '5'), ('10', '6'), ('9', '7'), ('8', '8'), ('7', '9'), ('6', '10'), ('5', '11'), ('4', '12'), ('3', '13'),
('2', '14'), ('2', '15'), ('1', '16'), ('1', '17'), ('2', '18'), ('1', '19'), ('3', '20'), ('4', '21'), ('10', '22'),
('12', '23'), ('14', '24'), ('15', '25'), ('13', '26'), ('15', '27'), ('7', '28'), ('1', '29'), ('3', '30'), ('5', '31'),
('11', '32'), ('6', '33'), ('10', '34'), ('4', '35'), ('1', '36'), ('7', '37');

INSERT INTO `petzilla`.`Employees` (`PInfo_id`, `job_id`) VALUES ('1', '1'), ('2', '1'), ('3', '1'),
('4', '3'), ('5', '3'), ('6', '2'), ('7', '2'), ('8', '2'), ('9', '2'), ('10', '2'), ('18', '2');



INSERT INTO `petzilla`.`Orders` (`customer_id`, `employee_id`, `status_id`, `order_date`) VALUES ('1', '6', '1', '2022-02-15'),
('2', '6', '2', '2022-02-21'), ('3', '7', '2', '2022-02-27'), ('4', '7', '2', '2022-03-05'), ('5', '8', '2', '2022-03-11'),
('6', '8', '2', '2022-03-17'), ('7', '9', '2', '2022-03-23'), ('8', '9', '2', '2022-03-30'), ('9', '10', '3', '2022-04-02'),
('1', '6', '3', '2022-04-08'), ('3', '7', '3', '2022-04-14'), ('5', '8', '3', '2022-04-20'), ('7', '9', '3', '2022-04-26'),
('9', '10', '1', '2022-05-01'), ('2', '11', '3', '2022-05-07'), ('4', '11', '3', '2022-05-13'), ('6', '10', '3', '2022-05-19'),
('8', '9', '2', '2022-05-25'), ('1', '8', '2', '2022-06-04'), ('4', '7', '2', '2022-06-10'), ('7', '6', '2', '2022-06-16'),
('2', '6', '2', '2022-06-21'), ('5', '8', '2', '2022-06-27'), ('8', '10', '1', '2022-07-02'), ('3', '7', '2', '2022-07-08'),
('6', '9', '2', '2022-07-14'), ('9', '11', '2', '2022-07-20'), ('4', '6', '2', '2022-07-26'), ('7', '9', '3', '2022-04-18'),
('5', '7', '3', '2022-04-21'), ('8', '10', '2', '2022-04-24'),('6', '8', '3', '2022-04-27'), ('9', '11', '2', '2022-04-30'),
('1', '10', '3', '2022-05-03'), ('5', '11', '2', '2022-05-06'), ('9', '11', '3', '2022-05-06'), ('2', '6', '2', '2022-05-09'),
('6', '7', '1', '2022-05-12'), ('3', '8', '2', '2022-05-15'), ('7', '9', '2', '2022-05-18'), ('4', '10', '2', '2022-05-21'),
('8', '11', '2', '2022-05-24'), ('5', '11', '2', '2022-05-27'), ('9', '10', '2', '2022-05-30'), ('1', '9', '2', '2022-06-02'),
('6', '8', '2', '2022-06-05'), ('2', '7', '2', '2022-06-08'), ('8', '6', '2', '2022-06-11'), ('3', '11', '3', '2022-06-14'),
('9', '11', '2', '2022-06-17'), ('1', '10', '3', '2022-06-20'), ('2', '10', '2', '2022-06-23'), ('3', '9', '3', '2022-06-26'),
('4', '9', '1', '2022-06-29'), ('5', '8', '2', '2022-07-01'), ('6', '8', '3', '2022-07-04'), ('7', '7', '2', '2022-07-07'),
('8', '7', '2', '2022-07-10'), ('9', '6', '2', '2022-07-13');


INSERT INTO `petzilla`.`Products` (`species_id`, `name`, `price`, `stock`) VALUES ('1', 'Dry food', '30.9', '831'),
('1', 'Toys', '12.5', '3221'), ('1', 'Cages', '86.3', '1400'), ('2', 'Leashes', '43.3', '2001'),
('2', 'Water vessel', '24.3', '4310'), ('2', 'Sand', '9.9', '3921'), ('1', 'Pesticides', '42.1', '3021'),
('2', 'Hygiene products', '14.8', '432'), ('2', 'Beds and mattresses', '120', '292'), ('1', 'Training and discipline equipment', '39.3', '1102');




INSERT INTO `petzilla`.`OrdersItems` (`order_id`, `product_id`, `quantity`) VALUES ('1', '10', '2'), ('1', '9', '3'), ('1', '8', '5'), ('1', '7', '13'),
('2', '6', '12'), ('2', '5', '9'), ('2', '4', '13'), ('3', '3', '7'), ('3', '2', '6'), ('4', '1', '9'),('4', '3', '10'), ('5', '2', '19'), ('5', '3', '3'),
('5', '4', '2'), ('6', '5', '3'), ('6', '6', '15'), ('7', '7', '7'), ('7', '8', '8'), ('8', '9', '9'), ('8', '10', '11'), ('9', '1', '2'), ('9', '3', '8'),
('9', '5', '2'),('10', '7', '17'), ('10', '9', '1'), ('11', '2', '9'), ('11', '4', '2'), ('12', '6', '3'), ('13', '8', '4'), ('13', '10', '7'), ('13', '1', '10'),
('14', '4', '11'), ('15', '7', '3'), ('16', '10', '2'), ('16', '2', '1'), ('16', '5', '3'), ('17', '8', '2'), ('17', '3', '5'), ('18', '6', '10'), ('19', '9', '2'),
('19', '4', '8'), ('20', '7', '4'), ('21', '10', '6'), ('22', '5', '6'), ('23', '8', '5'), ('23', '6', '7'), ('23', '9', '8'), ('23', '7', '9'), ('23', '10', '4'),
('23', '1', '3'), ('24', '5', '9'), ('24', '9', '7'), ('25', '2', '4'), ('26', '6', '3'), ('26', '10', '1'), ('27', '3', '9'), ('27', '7', '7'), ('28', '4', '2'),
('28', '8', '7'), ('28', '5', '5'), ('29', '9', '6'), ('29', '6', '2'), ('29', '10', '1'), ('30', '1', '5'), ('30', '6', '7'), ('30', '2', '2'), ('30', '7', '3'),
('31', '3', '8'), ('31', '8', '3'), ('31', '4', '8'), ('32', '9', '1'), ('33', '5', '7'), ('33', '10', '1'), ('34', '1', '5'), ('34', '7', '4'), ('35', '2', '1'),
('36', '8', '3'), ('36', '3', '1'), ('37', '9', '2'), ('38', '4', '3'), ('39', '10', '4'), ('40', '1', '1'), ('41', '8', '5'), ('41', '2', '8'),('41', '9', '1'),
('42', '3', '9'), ('42', '10', '4'), ('43', '1', '3'), ('44', '9', '1'), ('44', '2', '2'), ('44', '10', '3'), ('45', '1', '2'), ('46', '10', '4'), ('47', '1', '6'),
('48', '1', '5'), ('48', '2', '7'), ('48', '3', '8'), ('49', '4', '9'), ('50', '5', '3'), ('50', '6', '2'), ('51', '7', '3'), ('52', '8', '4'), ('52', '9', '5'),
('53', '10', '6'), ('54', '10', '6'), ('55', '9', '8'), ('56', '8', '7'), ('56', '7', '4'), ('56', '6', '3'), ('57', '5', '2'), ('57', '4', '1'), ('57', '3', '1'),
('58', '2', '3'), ('58', '1', '4'), ('59', '1', '9');