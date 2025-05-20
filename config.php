<?php
// Database config for XAMPP
$host = "localhost";
$user = "root";
$password = "";
$dbname = "plasticmart_db";

$conn = new mysqli($host, $user, $password, $dbname);
if ($conn->connect_error) {
    die(json_encode(["success" => false, "error" => $conn->connect_error]));
}
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Content-Type: application/json");
?>