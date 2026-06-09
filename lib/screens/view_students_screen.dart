import 'package:flutter/material.dart';
import 'package:ra_attendance_management/screens/add_student_screen.dart';
import 'package:ra_attendance_management/screens/reports_screen.dart';
import '../database/database_helper.dart';

class ViewStudentsScreen extends StatefulWidget {
  const ViewStudentsScreen({super.key});

  @override
  State<ViewStudentsScreen> createState() => _ViewStudentsScreenState();
}

class _ViewStudentsScreenState extends State<ViewStudentsScreen> {
  List<Map<String, dynamic>> students = [];

  String? selectedYear = "I Year";

  final List<String> years = ["I Year", "II Year", "III Year", "IV Year"];

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  @override
  void activate() {
    super.activate();
    loadStudents();
  }

  Future<void> loadStudents() async {
    students = await DatabaseHelper.instance.getStudents();

    setState(() {});
  }

  void deleteStudentDialog() {
    if (selectedYear == null) return;

    List<Map<String, dynamic>> filteredStudents = students.where((student) {
      return student["year"] == selectedYear;
    }).toList();

    filteredStudents.sort(
      (a, b) => int.parse(
        a["rollNo"].toString(),
      ).compareTo(int.parse(b["rollNo"].toString())),
    );

    String? selectedRollNo;

    showDialog(
      context: context,

      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Delete Student"),

              content: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  DropdownButtonFormField<String>(
                    value: selectedRollNo,

                    decoration: const InputDecoration(
                      labelText: "Select Student",
                    ),

                    items: filteredStudents.map((student) {
                      return DropdownMenuItem<String>(
                        value: student["rollNo"].toString(),
                        child: Text(
                          '${student["rollNo"]} - ${student["name"]}',
                        ),
                      );
                    }).toList(),

                    onChanged: (value) {
                      setDialogState(() {
                        selectedRollNo = value;
                      });
                    },
                  ),
                ],
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    if (selectedRollNo == null) {
                      return;
                    }

                    await DatabaseHelper.instance.deleteStudent(
                      selectedRollNo!,
                    );

                    await loadStudents();

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Student Deleted")),
                    );
                  },

                  child: const Text(
                    "Delete",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredStudents = students.where((student) {
      return student["year"] == selectedYear;
    }).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedYear,

              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                labelText: "Select Year",
                labelStyle: TextStyle(fontSize: 14),
              ),

              items: years.map((year) {
                return DropdownMenuItem(
                  value: year,
                  child: Text(
                    year,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
              }).toList(),

              onChanged: (value) {
                setState(() {
                  selectedYear = value;
                });
              },
            ),

            const SizedBox(height: 20),

            if (selectedYear != null)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: Theme.of(context).elevatedButtonTheme.style,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddStudentScreen(),
                          ),
                        ).then((_) {
                          loadStudents();
                        });
                      },
                      child: const Text(
                        "Add Student",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton(
                      style: Theme.of(context).elevatedButtonTheme.style,
                      onPressed: deleteStudentDialog,
                      child: const Text(
                        "Delete Student",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton(
                      style: Theme.of(context).elevatedButtonTheme.style,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ReportsScreen(initialYear: selectedYear),
                          ),
                        );
                      },
                      child: const Text(
                        "Reports",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            Expanded(
              child: filteredStudents.isEmpty
                  ? Center(
                      child: Text(
                        "No Students Found",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredStudents.length,

                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              child: Text(
                                (index + 1).toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),

                            title: Text(filteredStudents[index]["name"]),

                            subtitle: Text(filteredStudents[index]["rollNo"]),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddStudentScreen()),
          ).then((_) {
            loadStudents();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
