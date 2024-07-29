import 'package:flutter/material.dart';
import 'package:new_exp/const/constants.dart';
import '../../db_helper/db_helper_class.dart';
import '../../model/item.dart';
import '../../shared_prefrance/prefrance.dart';

class ExpensePage extends StatefulWidget {
  final Item? item;

  const ExpensePage({super.key, this.item});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final DbHelper _dbHelper = DbHelper();
  late int _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    if (widget.item != null) {
      _nameController.text = widget.item!.itemName;
      _priceController.text = widget.item!.itemPrice.toString();
      _descriptionController.text = widget.item!.itemDescription;
    }
  }

  Future<void> _loadUserId() async {
    _userId = (await PrefrenceManager.getUserId())!;
  }

  Future<void> _addItem() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      _showErrorDialog('Please fill in all fields');
      return;
    }

    final item = Item(
      itemName: _nameController.text,
      itemPrice: double.tryParse(_priceController.text) ?? 0.0,
      itemDescription: _descriptionController.text,
      userId: _userId,
    );

    try {
      await _dbHelper.insertItem(item);
      Navigator.pop(context, true); // Return to Homescreen with refresh flag

      // Show SnackBar after item is successfully added
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Item added successfully!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      _showErrorDialog('Failed to add item');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.item == null ? "Add Itme" : "Update Item",style: TextStyle(fontFamily: myConstants.PlaywriteAT),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(fontFamily: myConstants.RobotoL),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  hintText: 'Price',
                  hintStyle: TextStyle(fontFamily: myConstants.RobotoL),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: TextStyle(fontFamily: myConstants.RobotoL),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: _addItem,
              child: Text(
                widget.item == null ? "Add Item" : "Update Item",
                style: TextStyle(
                  fontFamily: myConstants.RobotoR,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
