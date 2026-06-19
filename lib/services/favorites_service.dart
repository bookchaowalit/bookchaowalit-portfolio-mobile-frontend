import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages user's favorite projects using SharedPreferences.
class FavoritesService {
  static const _key = 'favorite_project_indices';
  static FavoritesService? _instance;
  SharedPreferences? _prefs;
  Set<int> _favorites = {};
  
  // Callback to notify listeners of changes
  VoidCallback? onChanged;

  FavoritesService._();

  static FavoritesService get instance {
    _instance ??= FavoritesService._();
    return _instance!;
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final stored = _prefs?.getStringList(_key) ?? [];
    _favorites = stored.map((e) => int.tryParse(e)).whereType<int>().toSet();
  }

  Set<int> get favorites => Set.unmodifiable(_favorites);

  bool isFavorite(int index) => _favorites.contains(index);

  void toggleFavorite(int index) {
    if (_favorites.contains(index)) {
      _favorites.remove(index);
    } else {
      _favorites.add(index);
    }
    _save();
    onChanged?.call();
  }

  void addFavorite(int index) {
    if (_favorites.add(index)) {
      _save();
      onChanged?.call();
    }
  }

  void removeFavorite(int index) {
    if (_favorites.remove(index)) {
      _save();
      onChanged?.call();
    }
  }

  Future<void> _save() async {
    await _prefs?.setStringList(
      _key,
      _favorites.map((e) => e.toString()).toList(),
    );
  }
}