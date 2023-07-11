<?php


if(isset($_POST['lat']) && isset($_POST['lng']))
{
$latt= $_POST['lat'];
$long = $_POST['lng'];


mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
$mysqli = new mysqli("localhost", "root", "", "cars_tracker");



    /* create a prepared statement */
    $stmt = $mysqli->prepare("INSERT INTO `records` (`lattitude`,`longitude`) VALUES (?,?)");
    /* bind parameters for markers */
    $stmt->bind_param("ss", $latt, $long);
    /* execute query */
    $stmt->execute();

    echo "records updated";

}

else{
    echo "Connection failed";

}
