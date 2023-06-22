import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';

import '../../repository/categories_data.dart';

class ProductCategories extends StatelessWidget {
  const ProductCategories({super.key});

  Widget _buildCategoryItem(
      Category category, List<String> selectedCategoriesNames) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: ElevatedButton(
        onPressed: () {
          selectedCategoriesNames.clear();
          selectedCategoriesNames.add(category.name);
          Modular.to.pushNamed(
            'productOverview/categories',
            arguments: {
              'selectedCategoriesNames': selectedCategoriesNames,
              'isInRoute': false,
            },
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 3,
        ),
        child: Container(
          padding: const EdgeInsets.all(2),
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                category.iconData,
                size: 28,
              ),
              const SizedBox(height: 6),
              Text(
                category.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> selectedCategoriesNames = [];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'categories'.i18n(),
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  selectedCategoriesNames.clear();
                  Modular.to.pushNamed(
                    'productOverview/categories',
                    arguments: {
                      'selectedCategoriesNames': selectedCategoriesNames,
                      'isInRoute': false,
                    },
                  );
                },
                child: Text(
                  'see_all'.i18n(),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.outline),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: (categoryList.length / 2).ceil(),
              itemBuilder: (BuildContext context, int index) {
                int firstIndex = index * 2;
                int secondIndex = firstIndex + 1;

                return Column(
                  children: [
                    if (firstIndex < categoryList.length)
                      _buildCategoryItem(
                        categoryList[firstIndex],
                        selectedCategoriesNames,
                      ),
                    const SizedBox(width: 16),
                    if (secondIndex < categoryList.length)
                      _buildCategoryItem(
                        categoryList[secondIndex],
                        selectedCategoriesNames,
                      ),
                  ],
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
