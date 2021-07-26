<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8" />
		<link rel="stylesheet" href="insert.css" />
		<link rel="stylesheet" href="pageTransition.css" />
		<link rel="stylesheet" href="dropdown.css"/>

		<!-- TODO : change title tag to the name
		of the query displayed in the page -->
		<title>edit worker</title>

		<div class="dropdown-menu">

			<div class="dropdown">
				<button class="dropbtn">workers</button>
				<div class="workers-content">
					<a href="http://localhost/myapp/insert_new_worker.php">add new worker</a>
					<a href="http://localhost/myapp/remove_worker.php">remove worker</a>
					<a href="http://localhost/myapp/edit_worker.php">edit worker</a>
					<a href="http://localhost/myapp/select_all_table_worker.php">workers full table</a>
					<a href="http://localhost/myapp/number of COVID19 workers.php">covid19 workers</a>
					<a href="http://localhost/myapp/average_salary.php">avg salary</a>
					<a href="http://localhost/myapp/count_of_workers_according_to_all_positions.php">all workers count</a>
					<a href="http://localhost/myapp/count_of_workers_per_position.php">number of workers in position</a>
					<a href="http://localhost/myapp/count_workers_by_positions.php">workers count by position</a>
					<a href="http://localhost/myapp/details_of_employees_worker_more_than_160_hours.php">best employees</a>
					<a href="http://localhost/myapp/happy_birthday_by_branches.php">employees' birthdays by branches</a>
					<a href="http://localhost/myapp/happy_birthday.php">all employees' birthdays</a>
					<a href="http://localhost/myapp/Total_salary.php">total salary</a>
					<a href="http://localhost/myapp/Worker's_deliveries.php">worker's deliveries</a>
					<a href="http://localhost/myapp/worker with most deliveries.php">best shipping worker</a>
					<a href="http://localhost/myapp/select_all_table_positions.php">position full table</a>
					<!-- <a href="http://localhost/myapp/positions.php">positions details</a> -->
				</div>
			</div>
			<div class="dropdown2">
				<button class="dropbtn2">deliveries</button>
				<div class="del-content">
					<a href="http://localhost/myapp/select_all_table_finished_deliveries.php">finished deliveries full table</a>
					<a href="http://localhost/myapp/select_all_table_deliveris.php">deliveries full table</a>
					<a href="http://localhost/myapp/select_all_table_deliver_schedueling.php">scheduling full table</a>
					<a href="http://localhost/myapp/numbers_of_deliveries_today.php">number of deliveries today</a>
					<a href="http://localhost/myapp/number_of_deliveries_to_area.php">number of deliveries to area</a>
					<a href="http://localhost/myapp/old_deliveries_not_scheduled.php">urgent deliveries</a>
					<a href="http://localhost/myapp/getDelievery.php">get delivery</a>
					<a href="http://localhost/myapp/Number_of_deliveries_and_workers_to_area.php">number of deliveries and workers to area</a>
					<a href="http://localhost/myapp/need_of_more_schedueling.php">any deliveries left to schedule?</a>
					<a href="http://localhost/myapp/deliveries_stats.php">deliveries stats</a>
					<a href="http://localhost/myapp/GetAboveAvgDeliveries.php">above avg deliveries</a>
					<a href="http://localhost/myapp/collision_of_deliveries-count.php">deliveries collision count</a>
					<a href="http://localhost/myapp/collision_of_deliveries-details.php">deliveries collision details</a>
					<a href="http://localhost/myapp/deliveries_by_branch.php">deliveries by branch</a>
					<a href="http://localhost/myapp/need cooling but not scheduled.php">unschedulaed deliveries need cooling</a>

				</div>
			</div>
			<div class="dropdown3">
				<button class="dropbtn3">vehicles</button>
				<div class="vehicles-content">
					<a href="http://localhost/myapp/has A or C license.php">employees with A or C license</a>
					<a href="http://localhost/myapp/workers_and_vehicles_available_for_delivery.php">workers and vehicles available for delivery</a>
					<a href="http://localhost/myapp/FitVehiclesForDelivery.php">vehicles for delivery</a>
					<a href="http://localhost/myapp/select_all_table_vehicles.php">vehicles full table</a>
					<a href="http://localhost/myapp/vehicles_need_maintenance.php">vehicles need maintenance</a>
				</div>
			</div>
			<div class="dropdown4">
				<button class="dropbtn4">branches</button>
				<div class="branches-content">
					<a href="http://localhost/myapp/select_all_table_branches.php">branches full table</a>
					<a href="http://localhost/myapp/most profitable branch in the last week.php">best branch this week</a>
					<a href="http://localhost/myapp/profit_by_branch_for_last_week.php">last weeks profits by branch</a>
					<a href="http://localhost/myapp/branch_with_most_deliveries.php">branches with most deliveries</a>
				</div>
			</div>
		</div>

		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

	</head>

		<body>

			<script type="text/javascript">

				$(document).ready(function(){

					$('#workers').change(function(){
						//alert("changed via jquery" + $(this).val());
						$('#formID').submit();
						//window.location.href = '?ID=' + $(this).val();
					})
				});



				//function changeID(){
					//console.log("Changed to " + document.getElementById('ID').value);
					//document.getElementById('ID').val;
					//console.log('submitted');
				//}
			</script>

			<div class="card">

			<?php

				$servername = "localhost";
				$username = "root";
				$password = "";
				$dbname = "supermarket";

				$connection = new mysqli($servername, $username, $password, $dbname);

				// let me know if connection failed
				if($connection -> connect_error) {
					die("Connection failed: " . $connection->connect_error);
				}
				
				if(isset($_GET['ID'])){
					$empID = intval($_GET['ID']);
				}
                else
					$empID = '111111111';

				// if the button is clicked
				if(isset($_POST['submitForm']))
				{
                    // $empID = "";

                    if(isset($_POST['birthDate']))
					{
						$bday = $_POST['birthDate'];

						$sql = "UPDATE `worker`
						 		SET `Date_of_Birth` = '$bday'
								WHERE `ID` = '$empID'";

						$connection -> query($sql);
					}

                    if(isset($_POST['empFN']))
                    {
						$fn = $_POST['empFN'];

						$sql = "UPDATE `worker`
						 		SET `First_Name` = '$fn'
								WHERE `ID` = '$empID'";

						 $connection -> query($sql);
                    }

                    if(isset($_POST['empLN']))
                    {
						$ln = $_POST['empLN'];

						$sql = "UPDATE `worker`
						 		SET `Last_Name` = '$ln'
								WHERE `ID` = '$empID'";

						 $connection -> query($sql);
                    }

                    if(isset($_POST['empNumber']))
                    {
						$number = $_POST['empNumber'];

						$sql = "UPDATE `worker`
						 		SET `Phone_Number` = '$number'
								WHERE `ID` = '$empID'";

						 $connection -> query($sql);
                    }

                    if(isset($_POST['empEmail']))
                    {
						$mail = $_POST['empEmail'];

						$sql = "UPDATE `worker`
						 		SET `email_address` = '$mail'
								WHERE `ID` = '$empID'";

						$result = $connection -> query($sql);
                    }

                    if(isset($_POST['Position']))
                    {
						$position = $_POST['Position'];
						
						$sql = "UPDATE `worker`
						 		SET `position` = '$position'
								WHERE `ID` = '$empID'";

						$result = $connection -> query($sql);
                    }

                    if(isset($_POST['License']))
                    {
						$license = $_POST['License'];

						$sql = "UPDATE `worker`
						 		SET `License` = '$license'
								WHERE `ID` = '$empID'";

						 $connection -> query($sql);
                    }

                    if(isset($_POST['branch']))
                    {
						$branch = $_POST['branch'];

						$sql = "UPDATE `worker`
						 		SET `branch` = '$branch'
								WHERE `ID` = '$empID'";

						$connection -> query($sql);
                    }
						
				}

				// COPY QUERY FROM XAMPP
				//fetch table rows from mysql db
				$sql = "SELECT *
                        FROM `worker`
                        WHERE `ID`='$empID'";

				// store the result of the query in a temp var
				$result = $connection -> query($sql);

				$row = $result -> fetch_assoc();

				$fn = $row["First_Name"];
				$ln = $row["Last_Name"];
				$number = $row["Phone_Number"];
				$mail = $row["email_address"];
				$position = $row["position"];
				$license = $row["License"];
				$branch = $row["branch"];
				$bday = $row["Date_of_Birth"];
				$sday = $row["Starting_Date"];

                ?>

			<!-- TODO : change title inside h tag -->
			<h1>
				edit <?php echo"$fn $ln"?>'s data
			</h1>




			<div class="form-container2">

				<?php
				
				// COPY QUERY FROM XAMPP
				//fetch table rows from mysql db
				$sql = "SELECT `ID`, `First_Name`, `Last_Name` FROM `worker`" ;

				// store the result of the query in a temp var
				$result = $connection -> query($sql);

				// make sure we have something to print
                if ($result -> num_rows <= 0) {
					echo "<h5> Can't find data </h5>";
				}

				$form = '<form method="GET" id="formID"><div class="select-container">
							<select id="workers" name="ID">';

				while ($row = $result -> fetch_assoc())
				{
					$form .= '<option value="'.$row["ID"].'" '. ($empID ==  intval($row["ID"]) ? 'selected' : '').'>'.$row["First_Name"]." ".$row["Last_Name"]." ".$row["ID"].'</option>';
				}
				// <option value="shipping">shipping					</option>
				
				//$form .= '<input type="submit" name="submitForm" value="Go"/>';
				$form .= '</select></form>';

				echo $form;

				if(isset($_GET['submitForm']))
				{
					echo "hello";
				}
				
				//close the db connection
				$connection->close();
				?>

			</div>
</div>
		




			<div class="form-container">
				<h4>
					edit the data, then press save
				</h4>

				<form method="POST" id="updateForm" action="?ID=<?php echo intval($empID); ?>#submit">

                	<h5>date of birth</h5>
                    
					<input type="date" name="birthDate" value="<?php echo"$bday"?>"">
					
                    <h5>full name</h5>
					<input type="text" name="empFN" placeholder="first name" value="<?php echo"$fn"?>" maxlength="20">
					<input type="text" name="empLN" placeholder="last name" value="<?php echo"$ln"?>" maxlength="20">
					
                    <h5>phone number & email address</h5>
					<input type="number" name="empNumber" placeholder="phone number" value="<?php echo"$number"?>" maxlength="12">
					<input type="text" name="empEmail" placeholder="email address" value="<?php echo"$mail"?>" maxlength="20">
					
                    <h5>employee's position</h5>
					<select id="Positions" name="Position">
						<option value="<?php echo"$position"?>" disabled selected><?php echo"$position"?></option>
						<option value="assistant_manager">assistant manager	</option>
						<option value="branch_manager">branch manager		</option>
						<option value="cashier">cashier						</option>
						<option value="cleaner">cleaner						</option>
						<option value="shipping">shipping					</option>
						<option value="stocker">stocker						</option>
					</select>

					<h5>employee's license type</h5>
					<select id="Licenses" name="License">
						<option value="<?php echo"$license"?>" disabled selected><?php echo"$license"?></option>
						<option value="A">A	</option>
						<option value="B">B	</option>
						<option value="C">C	</option>
					</select>
					
                    <h5>branch</h5>
					<select id="Branches" name="branch">
						<option value="<?php echo"$branch"?>" disabled selected><?php echo"$branch"?></option>
						<option value="1">1 - Jerusalem						        </option>
						<option value="2">2 - Tel Aviv						        </option>
						<option value="3">3 - Beit Shemesh					        </option>
						<option value="4">4 - Beer Sheva					        </option>
						<option value="5">5 - Haifa							        </option>
					</select>
					
                    <div class="save">
						<input type="submit" name="submitForm" value="save"/>
					</div>
				</form>

			</div>

		</div>

	</body>

</html>