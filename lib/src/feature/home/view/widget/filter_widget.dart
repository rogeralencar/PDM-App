import 'package:flutter/material.dart';

import '../../repository/categories_data.dart';
import '../page/category_selector_screen.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({super.key});

  @override
  FilterWidgetState createState() => FilterWidgetState();
}

class FilterWidgetState extends State<FilterWidget> {
  List<String> _selectedCategoriesNames = [];
  String _selectedFilter = 'Mais vendidos';

  void _selectCategory() async {
    final updatedCategories = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CategorySelectionScreen(
          selectedCategoryNames: _selectedCategoriesNames,
        ),
      ),
    );

    if (updatedCategories != null) {
      List<Category> selectedCategories = categoryList
          .where((category) => updatedCategories.contains(category.name))
          .toList();

      setState(() {
        _selectedCategoriesNames =
            selectedCategories.map((category) => category.name).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _selectCategory,
            child: const Text('Select Category'),
          ),
        ),
        const Divider(),
        Expanded(
          child: DropdownButton<String>(
            isExpanded: true,
            value: _selectedFilter,
            onChanged: (String? newValue) {
              setState(() {
                _selectedFilter = newValue!;
              });
            },
            items: <String>[
              'Mais vendidos',
              'Preco crescente',
              'Preco decrescente',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
