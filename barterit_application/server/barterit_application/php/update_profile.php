<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
if (isset($_POST['phone'])) {
    $phone = $_POST['phone'];
    $userid = $_POST['userid'];
    $sqlupdate = "UPDATE `apps_user` SET `user_phone` ='$phone' WHERE `user_id` ='$userid'";
    databaseUpdate($sqlupdate);
    die();
}
if (isset($_POST['password'])) {
    $password = sha1($_POST['password']);
    $userid = $_POST['userid'];
    $sqlupdate = "UPDATE `apps_user` SET `user_pass` ='$password' WHERE `user_id` = '$userid'";
    databaseUpdate($sqlupdate);
    die();
}
if (isset($_POST['name'])) {
    $name = $_POST['name'];
    $userid = $_POST['userid'];
    $sqlupdate = "UPDATE `apps_user` SET `user_name` ='$name' WHERE `user_id` ='$userid'";
    databaseUpdate($sqlupdate);
    die();
}
function databaseUpdate($sql){
    include_once("dbconnect.php");
    if ($conn->query($sql) === TRUE) {
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>