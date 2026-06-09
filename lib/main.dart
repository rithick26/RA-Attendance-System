import 'package:flutter/material.dart';
import 'package:ra_attendance_management/screens/splash_screen.dart';
import 'package:ra_attendance_management/theme/app_colors.dart';
import 'screens/view_students_screen.dart';
import 'screens/mark_attendance_screen.dart';
import 'screens/reports_screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/about_screen.dart';
import 'screens/dashboard_home.dart';
import 'theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.instance.database;

  var students = await DatabaseHelper.instance.getStudents();

  print(students);

  runApp(const AttendanceApp());
}

class AttendanceApp extends StatefulWidget {
  const AttendanceApp({super.key});

  @override
  State<AttendanceApp> createState() => _AttendanceAppState();
}

class _AttendanceAppState extends State<AttendanceApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void changeTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: SplashScreen(themeMode: _themeMode, onThemeChanged: changeTheme),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final Function(ThemeMode) onThemeChanged;

  const DashboardScreen({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  int _currentIndex = 0;

  int firstYearPresent = 0;
  int firstYearAbsent = 0;
  int secondYearPresent = 0;
  int secondYearAbsent = 0;
  int thirdYearPresent = 0;
  int thirdYearAbsent = 0;
  int fourthYearPresent = 0;
  int fourthYearAbsent = 0;

  List<Widget> get _screens => [
    DashboardHome(
      totalStudents: totalStudents,
      firstYear: firstYear,
      secondYear: secondYear,
      thirdYear: thirdYear,
      fourthYear: fourthYear,

      firstYearPresent: firstYearPresent,
      firstYearAbsent: firstYearAbsent,
      secondYearPresent: secondYearPresent,
      secondYearAbsent: secondYearAbsent,
      thirdYearPresent: thirdYearPresent,
      thirdYearAbsent: thirdYearAbsent,
      fourthYearPresent: fourthYearPresent,
      fourthYearAbsent: fourthYearAbsent,
    ),
    const ViewStudentsScreen(),
    const MarkAttendanceScreen(),
    const ReportsScreen(),
  ];

  Future<void> loadStudents() async {
    final prefs = await SharedPreferences.getInstance();

    String? data = prefs.getString('students');

    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (data != null) {
      students = List<Map<String, dynamic>>.from(jsonDecode(data));

      setState(() {
        totalStudents = students.length;

        firstYear = students.where((s) => s["year"] == "I Year").length;

        secondYear = students.where((s) => s["year"] == "II Year").length;

        thirdYear = students.where((s) => s["year"] == "III Year").length;

        fourthYear = students.where((s) => s["year"] == "IV Year").length;

        firstYearPresent = students.where((s) {
          return s["year"] == "I Year" && s["attendance"][today] == true;
        }).length;

        firstYearAbsent = students.where((s) {
          return s["year"] == "I Year" &&
              s["attendance"].containsKey(today) &&
              s["attendance"][today] == false;
        }).length;

        secondYearPresent = students.where((s) {
          return s["year"] == "II Year" && s["attendance"][today] == true;
        }).length;

        secondYearAbsent = students.where((s) {
          return s["year"] == "II Year" &&
              s["attendance"].containsKey(today) &&
              s["attendance"][today] == false;
        }).length;

        thirdYearPresent = students.where((s) {
          return s["year"] == "III Year" && s["attendance"][today] == true;
        }).length;

        thirdYearAbsent = students.where((s) {
          return s["year"] == "III Year" &&
              s["attendance"].containsKey(today) &&
              s["attendance"][today] == false;
        }).length;

        fourthYearPresent = students.where((s) {
          return s["year"] == "IV Year" && s["attendance"][today] == true;
        }).length;

        fourthYearAbsent = students.where((s) {
          return s["year"] == "IV Year" &&
              s["attendance"].containsKey(today) &&
              s["attendance"][today] == false;
        }).length;
      });
    }
  }

  List<Map<String, dynamic>> students = [];

  int totalStudents = 0;
  int firstYear = 0;
  int secondYear = 0;
  int thirdYear = 0;
  int fourthYear = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ["Dashboard", "Students", "Attendance", "Reports"][_currentIndex],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<ThemeMode>(
            icon: const Icon(Icons.palette_outlined),
            onSelected: widget.onThemeChanged,
            itemBuilder: (context) => [
              const PopupMenuItem(value: ThemeMode.light, child: Text("Light")),
              const PopupMenuItem(value: ThemeMode.dark, child: Text("Dark")),
              const PopupMenuItem(
                value: ThemeMode.system,
                child: Text("System"),
              ),
            ],
          ),

          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _screens),

      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.accent, width: 1.5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                loadStudents();
                setState(() {
                  _currentIndex = index;
                });
              },
              backgroundColor: Theme.of(
                context,
              ).bottomNavigationBarTheme.backgroundColor,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Theme.of(
                context,
              ).bottomNavigationBarTheme.selectedItemColor,
              unselectedItemColor: Theme.of(
                context,
              ).bottomNavigationBarTheme.unselectedItemColor,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.groups_2),
                  label: 'Students',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.how_to_reg),
                  label: 'Attendance',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.analytics),
                  label: 'Reports',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
