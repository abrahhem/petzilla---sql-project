<?php 
	$dbhost = "127.0.0.1";
	$dbuser = "root";
	$dbpass = "Lilka1234";
	$dbname = "sakila";
	
	$connection = mysqli_connect($dbhost, $dbuser, $dbpass, $dbname);
	
	
	if(!$connection){
		die("DB connection failed: " . mysqli_connect_errno() . "(" . mysqli_connect_errno() . ")");
	}
	$temp		 = "SELECT address, city
						FROM `sakila`.`address`
						INNER JOIN
							`sakila`.`city`
						USING(city_id);";
	
	$temp_result = mysqli_query($connection , $temp);
	
	if (!$temp_result) {
		die($temp_result->error);
	}
	echo mysqli_num_rows($temp_result);
	
?>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">

		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" 
		integrity="sha384-0evHe/X+R7YkIZDRvuzKMRqM+OrBnVFBL6DOitfPri4tjfHxaWutUpFmBp4vmVor" crossorigin="anonymous">
	</head>
	<body>
		<div class="container">
			<?php
				if(isset($_POST["date"])) {
					echo $_POST["date"];
				}
			?>
			<table class="table">
				<thead>
					<tr>
						<?php
							$row = mysqli_fetch_assoc($temp_result);
							foreach ($row as $key => $value) {
								echo  '<th scope="col">' . $key . '</th>';
							}
						?>
					</tr>
				</thead>
				<tbody>
						<?php
							while ($row) {
								echo '<tr>';
								foreach ($row as $key => $value) {
									echo  '<td>' . $value . '</td>';
								}
								echo '</tr>';
								$row = mysqli_fetch_assoc($temp_result);
							} 
						?>
				</tbody>
			</table>
		</div>
		<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.5/dist/umd/popper.min.js" integrity="sha384-Xe+8cL9oJa6tN/veChSP7q+mnSPaj5Bcu9mPX5F5xIGE0DVittaqT5lorf0EI7Vk" crossorigin="anonymous"></script>	
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.min.js" integrity="sha384-kjU+l4N0Yf4ZOJErLsIcvOU2qSb74wXpOhqTvwVx3OElZRweTnQ6d31fXEoRD1Jy" crossorigin="anonymous"></script>
	</body>
</html>
<?php
	//close DB connection
	mysqli_close($connection);
?>

	

