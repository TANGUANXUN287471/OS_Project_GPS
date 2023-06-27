<?php
if(!isset($_POST)){
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
	die();
}

include_once("dbconnect.php");

$name = $_POST['name'];
$num = $_POST['num'];
$phone = $_POST['phone'];
$email = $_POST['email'];
$state = $_POST['state'];
$city = $_POST['city'];
$lat = $_POST['lat'];
$long = $_POST['long'];

$sqlinsert = "INSERT INTO `user_table`(`user_name`, `user_matric`, `user_phone`, `user_email`,`user_state`, `user_city`, `user_lat`, `user_long`) VALUES ('$name','$num','$phone','$email','$state','$city','$lat','$long')";

if($conn->query($sqlinsert)== TRUE){
	$response = array('status' => 'success','data' => null);
sendJsonResponse($response);

}else{
	$response = array('status' => 'failed','data' => null);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray){
	header('Content-Type: application/json');
	echo json_encode($sentArray);
}

?>
