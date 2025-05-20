<?php
header("Access-Control-Allow-Origin: *");
  header("Access-Control-Allow-Headers: *");
  header("Content-Type: application/json");
include 'config.php';

$sql = "SELECT * FROM selected_items ORDER BY created_at DESC";
$result = $conn->query($sql);

$items = [];
if ($result) {
    while ($row = $result->fetch_assoc()) {
        $items[] = $row;
    }
    echo json_encode(["success" => true, "items" => $items]);
} else {
    echo json_encode(["success" => false, "error" => $conn->error]);
}
?>