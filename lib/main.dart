import 'package:flutter/material.dart';
import 'package:ra_attendance_management/screens/splash_screen.dart';
import 'package:ra_attendance_management/theme/app_colors.dart';
import 'screens/view_students_screen.dart';
import 'screens/mark_attendance_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/about_screen.dart';
import 'screens/dashboard_home.dart';
import 'theme/app_theme.dart';
import 'database/database_helper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'providers/theme_provider.dart';
import 'providers/dashboard_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  runApp(const ProviderScope(child: AttendanceApp()));
}

class AttendanceApp extends ConsumerWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Attendance App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const SplashScreen(),
    );
  }
}

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final dashboardAsync = ref.watch(dashboardProvider);
    final screens = [
      dashboardAsync.when(
        data: (data) => DashboardHome(
          totalStudents: data.totalStudents,

          firstYear: data.firstYear,
          secondYear: data.secondYear,
          thirdYear: data.thirdYear,
          fourthYear: data.fourthYear,

          firstYearPresent: data.firstYearPresent,
          firstYearAbsent: data.firstYearAbsent,

          secondYearPresent: data.secondYearPresent,
          secondYearAbsent: data.secondYearAbsent,

          thirdYearPresent: data.thirdYearPresent,
          thirdYearAbsent: data.thirdYearAbsent,

          fourthYearPresent: data.fourthYearPresent,
          fourthYearAbsent: data.fourthYearAbsent,
        ),

        loading: () => const Center(child: CircularProgressIndicator()),

        error: (error, stack) => Center(child: Text(error.toString())),
      ),

      const ViewStudentsScreen(),
      const MarkAttendanceScreen(),
      const ReportsScreen(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ["Dashboard", "Students", "Attendance", "Reports"][_currentIndex],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: isDark,

                  thumbIcon: WidgetStateProperty.resolveWith<Icon?>((states) {
                    return states.contains(WidgetState.selected)
                        ? const Icon(Icons.nightlight_round, size: 14)
                        : const Icon(Icons.wb_sunny, size: 14);
                  }),

                  onChanged: (value) {
                    ref.read(themeProvider.notifier).state = value
                        ? ThemeMode.dark
                        : ThemeMode.light;
                  },
                ),
              ],
            ),
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
      body: screens[_currentIndex],

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
