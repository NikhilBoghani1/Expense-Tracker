import 'package:flutter/material.dart';
import 'package:new_exp/expense_task/pages/login/login_page.dart';
import '../../../const/constants.dart';
import '../../db_helper/db_helper_class.dart';
import '../../model/item.dart';
import '../../shared_prefrance/prefrance.dart';
import '../expense_page/expense_page.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final DbHelper _dbHelper = DbHelper();
  List<Item> _items = [];
  late int _userId;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndItems();
  }

  Future<void> _loadUserIdAndItems() async {
    _userId = (await PrefrenceManager.getUserId())!;
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    final items = await _dbHelper.getItemsByUserId(_userId);
    setState(() {
      _items = items;
    });
  }

  void _toggleStatus() {
    PrefrenceManager.statusChange(false);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _toggleStatus();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showEditItemDialog(Item item) async {
    final nameController = TextEditingController(text: item.itemName);
    final priceController =
        TextEditingController(text: item.itemPrice.toString());
    final descriptionController =
        TextEditingController(text: item.itemDescription);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final updatedItem = Item(
                  itemId: item.itemId,
                  itemName: nameController.text,
                  itemPrice:
                      double.tryParse(priceController.text) ?? item.itemPrice,
                  itemDescription: descriptionController.text,
                  userId: item.userId,
                );
                await _dbHelper.updateItem(updatedItem);
                Navigator.pop(context);

                // Show SnackBar for successful update
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Item updated successfully!'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
                _fetchItems(); // Refresh list
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(Item item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _dbHelper.deleteItem(item.itemId!);
                Navigator.pop(context);

                // Show SnackBar for successful deletion
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Item deleted successfully!'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 2),
                  ),
                );
                _fetchItems(); // Refresh list
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExpensePage()),
          );

          if (result == true) {
            _fetchItems(); // Refresh items after adding
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Expenses',
          style: TextStyle(fontFamily: myConstants.PlaywriteAT),
        ),
        actions: [
          IconButton(
            onPressed: () => _showLogoutDialog(context),
            icon: const Icon(
              Icons.exit_to_app_rounded,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];

          return Dismissible(
            key: Key(item.itemId.toString()),
            // Unique key for each item
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              // Delete the item from the database
              await _dbHelper.deleteItem(item.itemId!);

              // Update the state to remove the item from the list
              _items.removeAt(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Item deleted successfully!'),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Card(
              elevation: 10,
              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: ListTile(
                leading: const Icon(Icons.monetization_on, color: Colors.black),
                title: Text(item.itemName),
                subtitle: Text('${item.itemPrice} - ${item.itemDescription}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      // onPressed: () => _showEditItemDialog(item),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExpensePage(
                              item: item,
                            ),
                          ),
                        );
                      },
                    ),
                    // IconButton(
                    //   icon: const Icon(Icons.delete, color: Colors.red),
                    //   onPressed: () => _showDeleteConfirmationDialog(item),
                    // ),
                  ],
                ),
                // onTap: () => _showEditItemDialog(item),
              ),
            ),
          );
        },
      ),
    );
  }
}
