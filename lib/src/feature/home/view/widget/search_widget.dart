import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/search_provider.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(18.0),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          onChanged: (value) {
            searchProvider.setSearchText(value);
          },
          decoration: InputDecoration(
            hintText: 'Search',
            suffixIcon: const Icon(
              Icons.search,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
      ),
    );
  }
}
