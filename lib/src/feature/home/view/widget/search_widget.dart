import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  final bool isInRoute;
  final String search;
  final Function(String) searchSubmitted;

  SearchWidget({
    super.key,
    this.isInRoute = true,
    required this.search,
    required this.searchSubmitted,
  }) {
    _searchController.text = search;
  }

  @override
  Widget build(BuildContext context) {
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
          onSubmitted: !isInRoute
              ? (value) {
                  Modular.to.pushNamed(
                    'productOverview/',
                    arguments: {
                      'search': value,
                    },
                  );
                }
              : searchSubmitted,
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
