<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$prid = $_POST['itemid'];
$prname = $_POST['itemname'];
$prdesc = $_POST['itemdesc'];
$prqty = $_POST['itemqty'];
$prcon = $_POST['itemcon'];
$prtrade = $_POST['itemtrade'];

$sqlupdate = "UPDATE `apps_items` SET `item_name`='$prname',`item_desc`='$prdesc',`item_qty`='$prqty',`item_con`='$prcon',`item_trade`='$prtrade' WHERE `item_id`='$prid'";

if ($conn->query($sqlupdate) === TRUE) {
	$response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>