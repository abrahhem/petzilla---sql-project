<?php
	include "db.php";
	$orders_query = "SELECT order_id FROM petzilla_Orders 
	INNER JOIN
		petzilla_Statuses
	USING(Status_id)
	WHERE
		Status = 'received'
	OR
		status = 'approved'";
	
	$seller_names_query = "SELECT name 
							FROM petzilla_Employees e
							INNER JOIN
								petzilla_Personal_info
							USING(PInfo_id)
							INNER JOIN
								petzilla_Jobs
							USING(job_id)
							WHERE
								job = 'seller'";

	$delivery_guy_query = "SELECT employee_id FROM petzilla_Employees
		INNER JOIN
			petzilla_Jobs
		USING(job_id)
		WHERE
			job = 'delivery'";
	
	

	
	$seller_names_result = mysqli_query($connection , $seller_names_query);
	$orders_result = mysqli_query($connection , $orders_query);
	$delivery_guy_result = mysqli_query($connection , $delivery_guy_query);


	if (!$orders_result || !$delivery_guy_result || !$seller_names_result) {
	die("DB query failed.");
	}