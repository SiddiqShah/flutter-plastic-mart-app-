<?php
header("Access-Control-Allow-Origin: *");
  header("Access-Control-Allow-Headers: *");
  header("Content-Type: application/json");
include 'config.php';

$data = json_decode(file_get_contents("php://input"), true);

if (
    isset($data['id']) &&
    isset($data['product']) && isset($data['quality']) &&
    isset($data['quantity']) && isset($data['price_per_dozen']) &&
    isset($data['total_price'])
) {
    $id = intval($data['id']);
    $product = $conn->real_escape_string($data['product']);
    $quality = $conn->real_escape_string($data['quality']);
    $quantity = $conn->real_escape_string($data['quantity']);
    $price = (float)$data['price_per_dozen'];
    $total = (float)$data['total_price'];

    $sql = "UPDATE selected_items
            SET product='$product', quality='$quality', quantity='$quantity', price_per_dozen=$price, total_price=$total
            WHERE id=$id";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(["success" => true]);
    } else {
        echo json_encode(["success" => false, "error" => $conn->error]);
    }
} else {
    echo json_encode(["success" => false, "error" => "Missing fields"]);
}
?>