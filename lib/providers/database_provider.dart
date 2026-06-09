import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../database/database_helper.dart';

final databaseProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper.instance;
});
