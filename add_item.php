<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Content-Type: application/json");
include 'config.php';

// DEBUG: See what's coming in!
$raw = file_get_contents("php://input");
$data = json_decode($raw, true);

if (!$data) {
    echo json_encode([
        "success" => false,
        "error" => "No or invalid JSON input",
        "raw" => $raw
    ]);
    exit();
}

$required = ['product', 'quality', 'quantity', 'price_per_dozen', 'total_price'];
$missing = [];
foreach ($required as $field) {
    if (!isset($data[$field])) {
        $missing[] = $field;
    }
}

if (empty($missing)) {
    $product = $conn->real_escape_string($data['product']);
    $quality = $conn->real_escape_string($data['quality']);
    $quantity = $conn->real_escape_string($data['quantity']);
    $price = (float)$data['price_per_dozen'];
    $total = (float)$data['total_price'];

    $sql = "INSERT INTO selected_items (product, quality, quantity, price_per_dozen, total_price)
            VALUES ('$product', '$quality', '$quantity', $price, $total)";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(["success" => true, "id" => $conn->insert_id]);
    } else {
        echo json_encode([
            "success" => false,
            "error" => $conn->error,
            "sql" => $sql
        ]);
    }
} else {
    echo json_encode([
        "success" => false,
        "error" => "Missing fields",
        "missing_fields" => $missing
    ]);
}
?>