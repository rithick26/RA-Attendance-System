import 'package:flutter/material.dart';

class DashboardHome extends StatelessWidget {
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

  const DashboardHome({
    super.key,
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

  Widget buildStatCard(BuildContext context, String title, int count) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 22,
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 30),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      "Student Statistics",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        border: Border.all(
                          color: theme.colorScheme.primary,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Total Students : $totalStudents",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: buildStatCard(context, "I Year", firstYear),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: buildStatCard(context, "II Year", secondYear),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: buildStatCard(context, "III Year", thirdYear),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: buildStatCard(context, "IV Year", fourthYear),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      "Today's Attendance Statistics",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: buildAttendanceCard(
                            context,
                            "I Year",
                            firstYearPresent,
                            firstYearAbsent,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: buildAttendanceCard(
                            context,
                            "II Year",
                            secondYearPresent,
                            secondYearAbsent,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: buildAttendanceCard(
                            context,
                            "III Year",
                            thirdYearPresent,
                            thirdYearAbsent,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: buildAttendanceCard(
                            context,
                            "IV Year",
                            fourthYearPresent,
                            fourthYearAbsent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAttendanceCard(
    BuildContext context,
    String title,
    int present,
    int absent,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "P : $present",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),

          Text(
            "A : $absent",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
