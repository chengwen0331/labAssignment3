<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['userid'];
$item_name = $_POST['itemname'];
$item_desc = $_POST['itemdesc'];
$item_price = $_POST['itemprice'];
$item_qty = $_POST['itemqty'];
$item_type = $_POST['type'];
$item_con = $_POST['itemcon'];
$item_trade = $_POST['itemtrade'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$state = $_POST['state'];
$locality = $_POST['locality'];
//$image = $_POST['image'];
$image1 = $_POST['image1'];
$image2 = $_POST['image2'];
$image3 = $_POST['image3'];

$sqlinsert = "INSERT INTO `apps_items`(`user_id`,`item_name`, `item_desc`, `item_type`, `item_price`, `item_qty`, `item_con`, `item_trade`, `item_lat`, `item_long`, `item_state`, `item_locality`) VALUES ('$userid','$item_name','$item_desc','$item_type','$item_price','$item_qty', '$item_con', '$item_trade', '$latitude','$longitude','$state','$locality')";

/*if ($conn->query($sqlinsert) === TRUE) {
	$filename = mysqli_insert_id($conn);
	$response = array('status' => 'success', 'data' => null);
	$decoded_string = base64_decode($image);
	$path = '../assets/items/'.$filename.'.png';
	file_put_contents($path, $decoded_string);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}*/

if ($conn->query($sqlinsert) === TRUE) {
    $item_id = mysqli_insert_id($conn);
    $response = array('status' => 'success', 'data' => null);

    if (!empty($image1)) {
        $decoded_string = base64_decode($image1);
        $path = '../assets/items/' . $item_id . '_1.png';
        file_put_contents($path, $decoded_string);
    }

    if (!empty($image2)) {
        $decoded_string = base64_decode($image2);
        $path = '../assets/items/' . $item_id . '_2.png';
        file_put_contents($path, $decoded_string);
    }

    if (!empty($image3)) {
        $decoded_string = base64_decode($image3);
        $path = '../assets/items/' . $item_id . '_3.png';
        file_put_contents($path, $decoded_string);
    }

    sendJsonResponse($response);
} 
else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}


function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>