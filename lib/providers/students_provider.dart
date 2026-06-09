import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../database/database_helper.dart';

final studentsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  return await DatabaseHelper.instance.getStudents();
});
