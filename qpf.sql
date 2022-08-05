
-- 1
SELECT product_id, name, species, price, stock 
	FROM Products
    INNER JOIN
		Specieses
	USING(species_id);
    
-- 2
SELECT order_id, customer_id , employee_id, status, order_date 
	FROM 
		Orders 
    INNER JOIN
		Statuses
	USING(status_id)
    WHERE order_date BETWEEN CURDATE() - INTERVAL 90 WEEK AND CURDATE()
    ORDER BY
		order_date;
        
-- 3
WITH ProdCountTable AS (
    SELECT employee_id, sum(quantity) AS ProdCount
			FROM
				OrdersItems
			INNER JOIN
				Orders
			USING(order_id)
            INNER JOIN
				Statuses
			USING(status_id)
			WHERE
				status != "cancel"
			GROUP BY
				employee_id
)
SELECT e.employee_id, name, phone, address, ProdCount 
	FROM
		Employees e
	INNER JOIN
		Personal_info
	USING(PInfo_id)
	INNER JOIN 
		ProdCountTable
	USING(employee_id)
	WHERE 
		ProdCount = (SELECT max(ProdCount) FROM ProdCountTable);

-- 4
WITH TotalIncomeTable AS (
	SELECT employee_id, sum(total) AS TotalIncome
		FROM
			Orders
		INNER JOIN
			Statuses
		USING(status_id)
        WHERE
			status != "cancel"
		GROUP BY
			employee_id
)
SELECT e.employee_id, name, phone, address, TotalIncome 
	FROM
		Employees e
	INNER JOIN
		Personal_info
	USING(PInfo_id)
	INNER JOIN 
		TotalIncomeTable
	USING(employee_id)
	WHERE 
		TotalIncome = (SELECT max(TotalIncome) FROM TotalIncomeTable);
        
-- 5
SELECT c.customer_id, name, order_id, total, order_date 
	FROM
		Customers c
	INNER JOIN
		Orders o
	USING(customer_id)
	INNER JOIN
		Personal_info
	USING(PInfo_id)
    INNER JOIN
		Statuses
	USING(status_id)
	WHERE
		status = 'received';

-- 6

SELECT customer_id, name, phone, address
	FROM
		Customers c
	INNER JOIN
		Personal_info
	USING(PInfo_id)
	WHERE NOT EXISTS (
		SELECT customer_id 
        FROM
			Orders o 
		WHERE
			o.customer_id = c.customer_id
    );
-- 7
SELECT c.customer_id, name, phone, address, OrdersCount
	FROM
		Customers c
	INNER JOIN
		Personal_info
	USING(PInfo_id)
	INNER JOIN (
		SELECT customer_id, count(order_id) AS OrdersCount 
			FROM
				Orders
			GROUP BY
				customer_id
		) AS OrdersCountTable
	USING(customer_id)
	WHERE
		OrdersCount > 1;


DELIMITER $$
CREATE PROCEDURE Discount(IN ordetID INT, IN DiscountPercentage INT)  
BEGIN
	UPDATE Orders SET total = total - total * (DiscountPercentage/100) WHERE order_id = ordetID ;
END $$
DELIMITER ;

CALL Discount(1, 50);



DELIMITER $$
CREATE PROCEDURE BestSellingProducts(IN x_days int, IN y_prod int)  
BEGIN
	SELECT product_id, name, price, stock, sold_units
		FROM
			Products
		INNER JOIN (
			SELECT product_id, sum(quantity) AS sold_units
				FROM
					OrdersItems
				INNER JOIN
					Orders o
				USING(order_id)
                INNER JOIN
					Statuses
				USING(status_id)
                WHERE
					order_date BETWEEN CURDATE() - INTERVAL x_days DAY AND CURDATE()
				AND
					status != "cancel"
				GROUP BY
					product_id
		)QuantitySumTable
		USING(product_id)
		ORDER BY
			sold_units DESC
		LIMIT y_prod;
END $$
DELIMITER ;

CALL BestSellingProducts(560, 10);


DELIMITER $$
CREATE PROCEDURE FinishOrder(IN ordetID INT, IN DeliveryGuyID INT)  
BEGIN
	IF( (SELECT status_id FROM Orders WHERE order_id = ordetID)!= (SELECT status_id FROM Statuses WHERE status = 'sent') )
	THEN
		INSERT INTO Shipments (`order_id`, `employee_id`, `shipment_date`) VALUES (ordetID, DeliveryGuyID, now());
		UPDATE Orders SET status_id = (SELECT status_id FROM Statuses WHERE status = 'sent') WHERE order_id = ordetID;
	END IF;
END $$
DELIMITER ;

CALL FinishOrder(3,4);
DROP PROCEDURE FinishOrder;

DELIMITER $$
CREATE FUNCTION actor_count(seller_name VARCHAR(45),income_year INT, income_month INT)  RETURNS INTEGER
	BEGIN
		DECLARE income_count INTEGER default 0;
        SELECT count(total) INTO income_count
			FROM
				Orders
			INNER JOIN
				Employee
			USING(employee_id)
            INNER JOIN
				Jobs
			USING(job_id)
            INNER JOIN
				Personal_info
			USING(PInfo_id)
            WHERE
				name = seller_name
			AND
				job = 'seller'
			AND
				year(order_date) = income_year
			AND
				month(order_date) = income_month;
		RETURN income_count;
	END$$
DELIMITER ;


DROP TABLE OrdersItems;
DROP TABLE Shipments;
DROP TABLE customers_pets;
DROP TABLE Pets;
DROP TABLE stock_history;
DROP TABLE Products;
DROP TABLE Specieses;
DROP TABLE Orders;
DROP TABLE Customers;
DROP TABLE Statuses;
DROP TABLE Employees;
DROP TABLE jobs;
DROP TABLE Personal_info;








