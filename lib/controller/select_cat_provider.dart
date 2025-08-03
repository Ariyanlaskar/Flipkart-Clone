import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the currently selected category (null means nothing selected)
final selectedCategoryProvider = StateProvider<String?>((ref) => null);
