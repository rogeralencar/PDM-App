import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class FilterWidget extends StatefulWidget {
  final void Function() selectCategory;
  final void Function(String?) changeSortOption;
  final String selectedFilter;

  const FilterWidget({
    Key? key,
    required this.selectCategory,
    required this.changeSortOption,
    required this.selectedFilter,
  }) : super(key: key);

  @override
  FilterWidgetState createState() => FilterWidgetState();
}

class FilterWidgetState extends State<FilterWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: widget.selectCategory,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
              ),
              child: Text(
                'select_category'.i18n(),
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
        const VerticalDivider(),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: widget.selectedFilter,
              onChanged: widget.changeSortOption,
              items: <String>[
                'top_selling'.i18n(),
                'increasing_price'.i18n(),
                'decreasing_price'.i18n(),
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
