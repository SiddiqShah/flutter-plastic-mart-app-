import 'dart:convert';
import 'package:http/http.dart' as http;

// Change to your IP if needed, or use localhost for emulator/XAMPP PC
const String apiBase = "http://localhost/plasticmart_api";

class ApiService {
  // Add item
  static Future<bool> addItem(Map<String, dynamic> item) async {
    final url = Uri.parse("$apiBase/add_item.php");
    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"}, // THIS IS IMPORTANT!
      body: jsonEncode(item),
    );
    final data = jsonDecode(res.body);
    return data['success'] == true;
  }

  // Get all items
  static Future<List<Map<String, dynamic>>> getItems() async {
    final url = Uri.parse("$apiBase/get_items.php");
    final res = await http.get(url);
    final data = jsonDecode(res.body);
    if (data['success'] == true) {
      return List<Map<String, dynamic>>.from(data['items']);
    }
    return [];
  }

  // Delete item
  static Future<bool> deleteItem(int id) async {
    final url = Uri.parse("$apiBase/delete_item.php");
    final res = await http.post(url, body: jsonEncode({"id": id}));
    final data = jsonDecode(res.body);
    return data['success'] == true;
  }

  // Update item
  static Future<bool> updateItem(Map<String, dynamic> item) async {
    final url = Uri.parse("$apiBase/update_item.php");
    final res = await http.post(url, body: jsonEncode(item));
    final data = jsonDecode(res.body);
    return data['success'] == true;
  }
}
