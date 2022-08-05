<?php
	include "db.php";
	include "sql.php";

	if(isset($_POST["queryid"])) {

		if ($_POST["queryid"] == 'q1') {
			$query = $q_1;
		}
		else if ($_POST["queryid"] == 'q2') {
			$query = "SELECT order_id, customer_id , employee_id, status, order_date 
						FROM 
							Orders 
						INNER JOIN
							Statuses
						USING(status_id)
						WHERE order_date BETWEEN CURDATE() - INTERVAL" . $_POST["x_weeks"] . "WEEK AND CURDATE()
						ORDER BY
							order_date";
		}
		else if ($_POST["queryid"] == 'q3') {
			$query = $q_3;
		}
		else if ($_POST["queryid"] == 'q4') {
			$query = $q_4;
		}
		else if ($_POST["queryid"] == 'q5') {
			$query = $q_5;
		}
		else if ($_POST["queryid"] == 'q6') {
			$query = $q_6;
		}
		else if ($_POST["queryid"] == 'q7') {
			$query = $q_7;
		}
		else if ($_POST["queryid"] == 'q8'){
			$query = "";
		}
	}
	else if(isset($_POST["procid"])) {
		if ($_POST["procid"] == 'p1') {
			# code...
		}
		else if ($_POST["procid"] == 'p2') {
			# code...
		}
		else {
			# code...
		}
	 }

	if (!isset($query)) {
		if (isset($_POST["procid"]) || isset($_POST["queryid"]) || isset($_POST["funcid"])) {
			$error = "The query/operation was not recognized";
		}
	}
	else {
		$result = mysqli_query($connection , $query);
		if (!$result) {
			$error = $result->error;
		}
		else {
			$row_count = mysqli_num_rows($result);
		}
	 }
	

?>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">

		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" 
		integrity="sha384-0evHe/X+R7YkIZDRvuzKMRqM+OrBnVFBL6DOitfPri4tjfHxaWutUpFmBp4vmVor" crossorigin="anonymous">
		<link rel="icon" href="images/favicon.ico">
		<link rel="stylesheet" href="css/style.css">
	</head>
	<body>
		<header>
			<div class="wrapper container">
				<a id="logo" href="#">
					<img src="images/logo.png">
				</a>	
			</div>
		</header>
		<div class="container">
			<div class="row text-center m-5">
				<h1>From furry to finned </h1>
				<h3>if your pets could talk, they would talk about us.</h3>
			</div>
			<div class="flex">
				<div class="con">
					<div class="row"><h4>Queries</h4></div>
					<div class="row">
						<button type="button" class="btn mybtn" data-bs-toggle="modal"
						data-bs-target="#query1Modal">1</button>
		
						<button type="button" class="btn mybtn" data-bs-toggle="modal"
							data-bs-target="#query2Modal">2</button>
			
						<button type="button" class="btn mybtn" data-bs-toggle="modal"
							data-bs-target="#query3Modal">3</button>
			
						<button type="button" class="btn mybtn" data-bs-toggle="modal"
							data-bs-target="#query4Modal">4</button>
			
						<button type="button" class="btn mybtn" data-bs-toggle="modal"
							data-bs-target="#query5Modal">5</button>
			
						<button type="button" class="btn mybtn" data-bs-toggle="modal"
							data-bs-target="#query6Modal">6</button>
			
						<button type="button" class="btn mybtn" data-bs-toggle="modal"
							data-bs-target="#query7Modal">7</button>
			
						<button type="button" class="btn mybtn" data-bs-toggle="modal"
							data-bs-target="#query8Modal">8</button>
					</div>
				</div>
				<div class="con">
					<div class="row"><h4>Procedures</h4></div>
					<div class="row">
						<button type="button" class="btn mybtn" data-bs-toggle="modal"
						data-bs-target="#Proced1Modal">1</button>
						<button type="button" class="btn mybtn" data-bs-toggle="modal"
						data-bs-target="#Proced2Modal">2</button>
						<button type="button" class="btn mybtn" data-bs-toggle="modal"
						data-bs-target="#Proced3Modal">3</button>
					</div>
				</div>
				<div class="con">
					<div class="row"><h4>Functions</h4></div>
					<div class="row">
						<button type="button" class="btn mybtn" data-bs-toggle="modal"
						data-bs-target="#Func1Modal">1</button>
					</div>
				</div>
			</div>
			<?php

				if (isset($error)) {
					echo '<div class="m-5 flex">
							<div class="alert myalert alert-danger" role="alert">
								<h5 class="alert-heading">Error!</h5>
								<hr>
								<p>' . $error . '.</p>
							</div>
						</div>';
				}
				if (isset($row_count)) {
					if($row_count == 0 && (isset($_POST["queryid"]) || isset($_POST["procid"]))) {
						echo '<div class="m-5 flex">
								<div class="alert myalert alert-warning" role="alert">
									<h5 class="alert-heading">The table is empty!</h5>
									<hr>
									<p>The query/procedure succeeded but the resulting table is empty, and the columns cannot be loaded.</p>
								</div>
							</div>';
					}
					else if ($row_count > 0){
						echo '<div class="m-5 flex">
								<div class="alert myalert alert-success" role="alert">
									<h5 class="alert-heading">Done successfully!</h5>
									<hr>
									<p>Number of rows returned '. $row_count . '.</p>
								</div>
							</div>';
						echo '<table class="table">
								<thead class="thead">
									<tr>';
									$row = mysqli_fetch_assoc($result);
									foreach ($row as $key => $value) {
										echo  '<th scope="col">' . $key . '</th>';
									}	
							echo	'</tr>
								</thead>
								<tbody>';
									while ($row) {
										echo '<tr>';
										foreach ($row as $key => $value) {
											echo  '<td>' . $value . '</td>';
										}
										echo '</tr>';
										$row = mysqli_fetch_assoc($result);
									} 
							echo '</tbody>
							</table>';
					}
				}
				
			?>
		</div>
		<!-- Queries modals -->
		<form action="#" method="post">
			<div class="modal fade" id="query1Modal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog">
				  <div class="modal-content">
					<div class="modal-header">
					  <h5 class="modal-title" id="exampleModalLabel">The first query</h5>
					  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<input type="text" name="queryid" value="q1" hidden>
					<div class="modal-body">Show of all products and stock quantity.</div>
					<div class="modal-footer">
					  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
					  <button type="submit" class="btn btn-primary">Execute</button>
					</div>
				  </div>
				</div>
			</div>
		</form>
		<form action="#" method="post">
			<div class="modal fade" id="query2Modal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog">
				  <div class="modal-content">
					<div class="modal-header">
					  <h5 class="modal-title" id="exampleModalLabel">The second query</h5>
					  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<input type="text" name="queryid" value="q2" hidden>
					<div class="modal-body">Show all the orders in the last X weeks.</div>
					<div class="row-5 m-2">
						
						<label for="week" id="title_label">Number of weeks.</label>
						<input type="number" class="form-control" id="week" min="0" name="x_weeks" required>
					</div>
					<div class="modal-footer">
					  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
					  <button type="submit" class="btn btn-primary">Execute</button>
					</div>
				  </div>
				</div>
			</div>
		</form>
		<form action="#" method="post">
			<div class="modal fade" id="query3Modal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog">
				  <div class="modal-content">
					<div class="modal-header">
					  <h5 class="modal-title" id="exampleModalLabel">The third query</h5>
					  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<input type="text" name="queryid" value="q3" hidden>
					<div class="modal-body">Show the employee who sold the most products.</div>
					<div class="modal-footer">
					  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
					  <button type="submit" class="btn btn-primary">Execute</button>
					</div>
				  </div>
				</div>
			</div>
		</form>
		<form action="#" method="post">
			<div class="modal fade" id="query4Modal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog">
				  <div class="modal-content">
					<div class="modal-header">
					  <h5 class="modal-title" id="exampleModalLabel">The fourth query</h5>
					  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<input type="text" name="queryid" value="q4" hidden>
					<div class="modal-body">Show the employee who brought in the most money.</div>
					<div class="modal-footer">
					  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
					  <button type="submit" class="btn btn-primary">Execute</button>
					</div>
				  </div>
				</div>
			</div>
		</form>
		<form action="#" method="post">
			<div class="modal fade" id="query5Modal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog">
				  <div class="modal-content">
					<div class="modal-header">
					  <h5 class="modal-title" id="exampleModalLabel">The fifth query</h5>
					  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<input type="text" name="queryid" value="q5" hidden>
					<div class="modal-body">Show active orders and the customer who ordered.</div>
					<div class="modal-footer">
					  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
					  <button type="submit" class="btn btn-primary">Execute</button>
					</div>
				  </div>
				</div>
			</div>
		</form>
		<form action="#" method="post">
			<div class="modal fade" id="query6Modal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog">
				  <div class="modal-content">
					<div class="modal-header">
					  <h5 class="modal-title" id="exampleModalLabel">The sixth query</h5>
					  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<input type="text" name="queryid" value="q6" hidden>
					<div class="modal-body">Show the customers who have not placed any orders.</div>
					<div class="modal-footer">
					  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
					  <button type="submit" class="btn btn-primary">Execute</button>
					</div>
				  </div>
				</div>
			</div>
		</form>
		<form action="#" method="post">
			<div class="modal fade" id="query7Modal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog">
				  <div class="modal-content">
					<div class="modal-header">
					  <h5 class="modal-title" id="exampleModalLabel">The seventh query</h5>
					  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<input type="text" name="queryid" value="q7" hidden>
					<div class="modal-body">Show the customers who have made more than one order.</div>
					<div class="modal-footer">
					  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
					  <button type="submit" class="btn btn-primary">Execute</button>
					</div>
				  </div>
				</div>
			</div>
		</form>
		<form action="#" method="post">
			<div class="modal fade" id="query8Modal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog">
				  <div class="modal-content">
					<div class="modal-header">
					  <h5 class="modal-title" id="exampleModalLabel">The eighth query</h5>
					  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<input type="text" name="queryid" value="q8" hidden>
					<div class="modal-body">Show income X months back.</div>
					<div class="row-5 m-2">
						<label for="month" id="title_label">Number of months.</label>
						<input type="number" class="form-control" id="month" min="0" name="x_month" required>
					</div>
					<div class="modal-footer">
					  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
					  <button type="submit" class="btn btn-primary">Execute</button>
					</div>
				  </div>
				</div>
			</div>
		</form>
		<!-- Procedures modals -->
		<form action="#" method="post">
			<div class="modal fade" id="Proced1Modal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog">
				  <div class="modal-content">
					<div class="modal-header">
					  <h5 class="modal-title" id="exampleModalLabel">The first procedure</h5>
					  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<input type="text" name="procid" value="p1" hidden>
					<div class="modal-body">Update delivery for an order, updates the end of delivery for an existing order.</div>
					<div class="row-5 m-2">
						<label for="P1OrderID">Order ID</label>
						<select class="form-select mb-4" id="P1OrderID" name="order_id" required>
							<?php
								// $proc1_order_id = $order_id;
								// while($row = mysqli_fetch_assoc($proc_order_id)) {
								// 	echo '<option value="' . $row . '">' . $row . '</option>';
								// }
							?>
						</select>
					</div>
					<div class="row-5 m-2">
						<label for="P1empID">Delivery guy ID</label>
						<select class="form-select mb-4" id="P1empID"  name="employee_id" required>
							<option value="1">One</option>
							<option value="2">Two</option>
							<option value="3">Three</option>
						</select>
					</div>
					<div class="modal-footer">
					  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
					  <button type="submit" class="btn btn-primary">Execute</button>
					</div>
				  </div>
				</div>
			</div>
		</form>
		<form action="#" method="post">
			<div class="modal fade" id="Proced2Modal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog">
				  <div class="modal-content">
					<div class="modal-header">
					  <h5 class="modal-title" id="exampleModalLabel">The first procedure</h5>
					  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<input type="text" name="procid" value="p2" hidden>
					<div class="modal-body">List of the Y best selling products in the last X days.</div>
					<div class="row-5 m-2">
						<label for="y_prod" id="title_label">Number of products - Y.</label>
						<input type="number" class="form-control" id="y_prod" min="0" name="y_prod" required>
					</div>
					<div class="row-5 m-2">
						<label for="x_days" id="title_label">Number of days - X.</label>
						<input type="number" class="form-control" id="x_days" min="0" name="x_days" required>
					</div>
					<div class="modal-footer">
					  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
					  <button type="submit" class="btn btn-primary">Execute</button>
					</div>
				  </div>
				</div>
			</div>
		</form>
		<form action="#" method="post">
			<div class="modal fade" id="Proced3Modal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog">
				  <div class="modal-content">
					<div class="modal-header">
					  <h5 class="modal-title" id="exampleModalLabel">The third procedure</h5>
					  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<input type="text" name="procid" value="p2" hidden>
					<div class="modal-body">Granting a 0-100 percent discount for an order.</div>
					<div class="row-5 m-2">
						<label for="customRange2" class="form-label">Discount percentage<span id="range"> - 30</span></label>
						<input type="range" class="form-range" min="0" max="100" id="meter" value="30" required>
					</div>
					<div class="row-5 m-2">
						<label for="p3OrderID">Order ID</label>
						<select class="form-select mb-4" id="p3OrderID" name="order_id" required>
						<?php
								// $proc3_order_id = $order_id;
								// while($row = mysqli_fetch_assoc($proc3_order_id)) {
								// 	echo '<option value="' . $row . '">' . $row . '</option>';
								// }
								// mysqli_free_result($order_id);
						?>
						</select>
					</div>
					<div class="modal-footer">
					  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
					  <button type="submit" class="btn btn-primary">Execute</button>
					</div>
				  </div>
				</div>
			</div>
		</form>
		<!-- Functions modals -->
		<form action="#" method="post">
			<div class="modal fade" id="Func1Modal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog">
				  <div class="modal-content">
					<div class="modal-header">
					  <h5 class="modal-title" id="exampleModalLabel">The first function</h5>
					  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<input type="text" name="funcid" value="f1" hidden>
					<div class="modal-body">The amount of income in a certain month.</div>
					<div class="row-5 m-2">
						<label for="func_name">Seller name:</label>
						<input type="func_name" name="text" required>
					</div>
					<div class="row-5 m-2">
						<label for="month">Year:</label>
						<input type="year" name="year" required>
					</div>
					<div class="row-5 m-2">
						<label for="month">Month:</label>
						<select id="month" name="month" required>
							<option value="1" selected>January</option>
							<option value="2">February</option>
							<option value="3">March</option>
							<option value="4">April</option>
							<option value="5">May</option>
							<option value="6">June</option>
							<option value="7">July</option>
							<option value="8">August</option>
							<option value="9">September</option>
							<option value="10">October</option>
							<option value="11">November</option>
							<option value="12">December</option>
						</select>
					</div>
					<div class="row-5 m-2">
						<label for="f1OrderID">Order ID</label>
						<select class="form-select mb-4" id="f1OrderID" name="order_id" required>
							<option value="1">One</option>
							<option value="2">Two</option>
							<option value="3">Three</option>
						</select>
					</div>
					<div class="modal-footer">
					  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
					  <button type="submit" class="btn btn-primary">Execute</button>
					</div>
				  </div>
				</div>
			</div>
		</form>
		<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.5/dist/umd/popper.min.js" integrity="sha384-Xe+8cL9oJa6tN/veChSP7q+mnSPaj5Bcu9mPX5F5xIGE0DVittaqT5lorf0EI7Vk" crossorigin="anonymous"></script>	
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.min.js" integrity="sha384-kjU+l4N0Yf4ZOJErLsIcvOU2qSb74wXpOhqTvwVx3OElZRweTnQ6d31fXEoRD1Jy" crossorigin="anonymous"></script>
		<script src="js/script.js"></script>
	</body>
</html>
<?php
//close DB connection
mysqli_close($connection);
?>