<?php



// Queries

$q_1 = "SELECT product_id, name, species, price, stock 
			FROM Products
			INNER JOIN
				Specieses
			USING(species_id)";


$q_3 = "WITH ProdCountTable AS (
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
					status != 'cancel'
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
				ProdCount = (SELECT max(ProdCount) FROM ProdCountTable)";

$q_4 = "WITH TotalIncomeTable AS (
			SELECT employee_id, sum(total) AS TotalIncome
				FROM
					Orders
				INNER JOIN
					Statuses
				USING(status_id)
				WHERE
					status != 'cancel'
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
				TotalIncome = (SELECT max(TotalIncome) FROM TotalIncomeTable)";

$q_5 = "SELECT c.customer_id, name, order_id, total, order_date 
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
				status = 'received'";

$q_6 = "SELECT customer_id, name, phone, address
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
			)";

$q_7 = "SELECT c.customer_id, name, phone, address, OrdersCount
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
				OrdersCount > 1";




