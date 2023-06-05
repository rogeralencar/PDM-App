import 'package:flutter/material.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({super.key});

  @override
  FilterWidgetState createState() => FilterWidgetState();
}

class FilterWidgetState extends State<FilterWidget> {
  String _selectedCategory = 'Categoria';
  String _selectedPrice = 'Preço';
  String _selectedOrder = 'Ordem';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButton<String>(
            isExpanded: true,
            value: _selectedCategory,
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue!;
              });
            },
            items: <String>[
              'Categoria',
              'Categoria 1',
              'Categoria 2',
              'Categoria 3',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButton<String>(
            isExpanded: true,
            value: _selectedPrice,
            onChanged: (String? newValue) {
              setState(() {
                _selectedPrice = newValue!;
              });
            },
            items: <String>[
              'Preço',
              'Menor para maior',
              'Maior para menor',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButton<String>(
            isExpanded: true,
            value: _selectedOrder,
            onChanged: (String? newValue) {
              setState(() {
                _selectedOrder = newValue!;
              });
            },
            items: <String>[
              'Ordem',
              'A-Z',
              'Z-A',
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
