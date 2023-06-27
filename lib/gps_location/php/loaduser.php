<?php

if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$sqlloaditems = "SELECT * FROM `user_table`";

$result = $conn->query($sqlloaditems);
if ($result->num_rows > 0) {
    $user["user"] = array();
    while ($row = $result->fetch_assoc()) {
        $itemlist = array();
        $itemlist['user_id'] = $row['user_id'];
        $itemlist['user_name'] = $row['user_name'];
        $itemlist['user_matric'] = $row['user_matric'];
        $itemlist['user_phone'] = $row['user_phone'];
        $itemlist['user_email'] = $row['user_email'];
        $itemlist['user_datereg'] = $row['user_datereg'];
        $itemlist['user_state'] = $row['user_state'];
        $itemlist['user_city'] = $row['user_city'];
        $itemlist['user_lat'] = $row['user_lat'];
        $itemlist['user_long'] = $row['user_long'];
        array_push($user["user"], $itemlist);
    }
    $response = array('status' => 'success', 'data' => $user);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>
