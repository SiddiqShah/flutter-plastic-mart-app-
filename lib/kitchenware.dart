import 'package:flutter/material.dart';
import 'api_service.dart';

class Kitchenware extends StatefulWidget {
  const Kitchenware({super.key});

  @override
  State<Kitchenware> createState() => _KitchenwareState();
}

class _KitchenwareState extends State<Kitchenware> {
  final List<Map<String, dynamic>> products = [
    {'name': 'Knives', 'price': 150.0},
    {'name': 'Spoons', 'price': 200.0},
    {'name': 'Cups', 'price': 300.0},
    {'name': 'Potato masher', 'price': 70.0},
    {'name': 'Garlic press', 'price': 95.0},
    {'name': 'Bowls', 'price': 115.0},
  ];
  final List<String> qualities = ['Small', 'Medium', 'Large'];
  final List<String> quantities = List.generate(
    10,
    (index) => '${index + 1} dozen${index == 0 ? '' : 's'}',
  );

  String? selectedProduct;
  String? selectedQuality;
  String? selectedQuantity;
  double? selectedPrice;
  int? editingId;

  List<Map<String, dynamic>> selectedItems = [];

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    final items = await ApiService.getItems();
    setState(() {
      selectedItems =
          items
              .where(
                (item) => products.any((p) => p['name'] == item['product']),
              )
              .toList();
    });
  }

  void _addOrUpdateToTable() async {
    if (selectedProduct != null &&
        selectedQuality != null &&
        selectedQuantity != null &&
        selectedPrice != null) {
      int dozenCount = int.parse(selectedQuantity!.split(' ')[0]);
      double totalPrice = dozenCount * selectedPrice!;

      final item = {
        "product": selectedProduct,
        "quality": selectedQuality,
        "quantity": selectedQuantity,
        "price_per_dozen": selectedPrice,
        "total_price": totalPrice,
      };

      bool success;
      if (editingId != null) {
        item['id'] = editingId;
        success = await ApiService.updateItem(item);
      } else {
        success = await ApiService.addItem(item);
      }

      if (success) {
        fetchItems();
        _resetSelection();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Database error')));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select all fields")));
    }
  }

  void _editItem(Map<String, dynamic> item) {
    setState(() {
      editingId = int.tryParse(item['id'].toString());
      selectedProduct = item['product'];
      selectedQuality = item['quality'];
      selectedQuantity = item['quantity'];
      selectedPrice = double.tryParse(item['price_per_dozen'].toString());
    });
  }

  void _deleteItem(int id) async {
    await ApiService.deleteItem(id);
    fetchItems();
    if (editingId == id) _resetSelection();
  }

  void _resetSelection() {
    setState(() {
      editingId = null;
      selectedProduct = null;
      selectedQuality = null;
      selectedQuantity = null;
      selectedPrice = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchenware'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedProduct,
              hint: const Text('Select Product'),
              items:
                  products
                      .map(
                        (product) => DropdownMenuItem<String>(
                          value: product['name'] as String,
                          child: Text(
                            '${product['name']} - Rs. ${product['price']}/dozen',
                          ),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  selectedProduct = value;
                  if (value != null) {
                    selectedPrice =
                        products.firstWhere(
                          (product) => product['name'] == value,
                        )['price'];
                  }
                });
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedQuality,
              hint: const Text('Select Quality'),
              items:
                  qualities
                      .map(
                        (quality) => DropdownMenuItem(
                          value: quality,
                          child: Text(quality),
                        ),
                      )
                      .toList(),
              onChanged: (value) => setState(() => selectedQuality = value),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedQuantity,
              hint: const Text('Select Quantity (dozens)'),
              items:
                  quantities
                      .map((q) => DropdownMenuItem(value: q, child: Text(q)))
                      .toList(),
              onChanged: (value) => setState(() => selectedQuantity = value),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addOrUpdateToTable,
              child: Text(editingId != null ? 'Update Item' : 'Add to Table'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
            const SizedBox(height: 20),
            const Text(
              'Selected Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Product')),
                    DataColumn(label: Text('Quality')),
                    DataColumn(label: Text('Quantity')),
                    DataColumn(label: Text('Price/Dozen')),
                    DataColumn(label: Text('Total Price')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows:
                      selectedItems.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(Text(item['product'])),
                            DataCell(Text(item['quality'])),
                            DataCell(Text(item['quantity'])),
                            DataCell(Text('Rs. ${item['price_per_dozen']}')),
                            DataCell(
                              Text(
                                'Rs. ${double.parse(item['total_price'].toString()).toStringAsFixed(2)}',
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () => _editItem(item),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed:
                                        () => _deleteItem(
                                          int.parse(item['id'].toString()),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ),
            if (selectedItems.isNotEmpty) ...[
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Grand Total:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rs. ${selectedItems.fold(0.0, (sum, item) => sum + double.parse(item['total_price'].toString())).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
