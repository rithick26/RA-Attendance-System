import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../database/database_helper.dart';

class DashboardData {
  final int totalStudents;

  final int firstYear;
  final int secondYear;
  final int thirdYear;
  final int fourthYear;

  final int firstYearPresent;
  final int firstYearAbsent;

  final int secondYearPresent;
  final int secondYearAbsent;

  final int thirdYearPresent;
  final int thirdYearAbsent;

  final int fourthYearPresent;
  final int fourthYearAbsent;

  const DashboardData({
    required this.totalStudents,

    required this.firstYear,
    required this.secondYear,
    required this.thirdYear,
    required this.fourthYear,

    required this.firstYearPresent,
    required this.firstYearAbsent,

    required this.secondYearPresent,
    required this.secondYearAbsent,

    required this.thirdYearPresent,
    required this.thirdYearAbsent,

    required this.fourthYearPresent,
    required this.fourthYearAbsent,
  });
}

final dashboardProvider = FutureProvider<DashboardData>((ref) async {
  final students = await DatabaseHelper.instance.getStudents();

  String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final attendanceToday = await DatabaseHelper.instance.getAttendanceByDate(
    today,
  );

  int totalStudents = students.length;

  int firstYear = students.where((s) => s["year"] == "I Year").length;
  int secondYear = students.where((s) => s["year"] == "II Year").length;
  int thirdYear = students.where((s) => s["year"] == "III Year").length;
  int fourthYear = students.where((s) => s["year"] == "IV Year").length;

  int firstYearPresent = 0;
  int secondYearPresent = 0;
  int thirdYearPresent = 0;
  int fourthYearPresent = 0;

  for (var attendance in attendanceToday) {
    String rollNo = attendance["rollNo"];
    bool present = attendance["status"] == 1;

    var student = students.firstWhere(
      (s) => s["rollNo"] == rollNo,
      orElse: () => {},
    );

    if (student.isEmpty) continue;

    String year = student["year"];

    if (year == "I Year" && present) {
      firstYearPresent++;
    } else if (year == "II Year" && present) {
      secondYearPresent++;
    } else if (year == "III Year" && present) {
      thirdYearPresent++;
    } else if (year == "IV Year" && present) {
      fourthYearPresent++;
    }
  }

  return DashboardData(
    totalStudents: totalStudents,

    firstYear: firstYear,
    secondYear: secondYear,
    thirdYear: thirdYear,
    fourthYear: fourthYear,

    firstYearPresent: firstYearPresent,
    firstYearAbsent: firstYear - firstYearPresent,

    secondYearPresent: secondYearPresent,
    secondYearAbsent: secondYear - secondYearPresent,

    thirdYearPresent: thirdYearPresent,
    thirdYearAbsent: thirdYear - thirdYearPresent,

    fourthYearPresent: fourthYearPresent,
    fourthYearAbsent: fourthYear - fourthYearPresent,
  );
});
