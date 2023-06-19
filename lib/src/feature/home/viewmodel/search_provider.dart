import 'package:flutter/foundation.dart';

class SearchProvider extends ChangeNotifier {
  String _searchText = '';

  String get searchText => _searchText;

  void setSearchText(String text) {
    _searchText = text;
    notifyListeners();
  }
}
