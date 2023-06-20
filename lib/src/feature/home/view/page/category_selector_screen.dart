import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../repository/categories_data.dart';

class CategorySelectionScreen extends StatefulWidget {
  final List<String> selectedCategoriesNames;
  final bool isInRoute;

  const CategorySelectionScreen({
    Key? key,
    this.isInRoute = true,
    required this.selectedCategoriesNames,
  }) : super(key: key);

  @override
  CategorySelectionScreenState createState() => CategorySelectionScreenState();
}

class CategorySelectionScreenState extends State<CategorySelectionScreen> {
  List<String> _selectedCategoryNames = [];
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _selectedCategoryNames = List<String>.from(widget.selectedCategoriesNames);
  }

  void _toggleCategory(String categoryName) {
    setState(() {
      if (categoryName.isEmpty) {
        _selectAll = !_selectAll;
        if (_selectAll) {
          _selectedCategoryNames =
              List<String>.from(categoryList.map((category) => category.name));
        } else {
          _selectedCategoryNames.clear();
        }
      } else {
        if (_selectedCategoryNames.contains(categoryName)) {
          _selectedCategoryNames.remove(categoryName);
        } else {
          _selectedCategoryNames.add(categoryName);
        }
        _selectAll = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Categories'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _toggleCategory(''),
            icon: Icon(_selectAll ? Icons.undo : Icons.done),
          ),
        ],
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
          widget.isInRoute
              ? Navigator.of(context).pop(_selectedCategoryNames)
              : Modular.to.pushNamed(
                  '/home/productOverview/',
                  arguments: {
                    'selectedCategoriesNames': _selectedCategoryNames,
                  },
                );
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
