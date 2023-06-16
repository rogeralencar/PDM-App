import 'package:flutter/material.dart';

import '../../repository/categories_data.dart';

class CategorySelectionScreen extends StatefulWidget {
  final List<String> selectedCategoryNames;

  const CategorySelectionScreen({
    Key? key,
    required this.selectedCategoryNames,
  }) : super(key: key);

  @override
  CategorySelectionScreenState createState() => CategorySelectionScreenState();
}

class CategorySelectionScreenState extends State<CategorySelectionScreen> {
  List<String> _selectedCategoryNames = [];

  @override
  void initState() {
    super.initState();
    if (widget.selectedCategoryNames.length == 1) {
      _selectedCategoryNames = widget.selectedCategoryNames[0]
          .split(',')
          .map((category) => category.trim())
          .toList();
    } else {
      _selectedCategoryNames = List<String>.from(widget.selectedCategoryNames);
    }
  }

  void _toggleCategory(String categoryName) {
    setState(() {
      if (_selectedCategoryNames.contains(categoryName)) {
        _selectedCategoryNames.remove(categoryName);
      } else {
        _selectedCategoryNames.add(categoryName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Categories'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: categoryList.length,
        itemBuilder: (context, index) {
          final category = categoryList[index];
          final isSelected = _selectedCategoryNames.contains(category.name);
          return ListTile(
            onTap: () => _toggleCategory(category.name),
            iconColor: Theme.of(context).colorScheme.secondary,
            title: Text(category.name),
            leading: Icon(category.iconData),
            trailing: isSelected ? const Icon(Icons.check_circle) : null,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop(_selectedCategoryNames);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
