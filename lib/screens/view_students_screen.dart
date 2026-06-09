import 'package:flutter/material.dart';
import 'package:ra_attendance_management/screens/add_student_screen.dart';
import '../database/database_helper.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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

  Future<void> showDeleteDialog(Map<String, dynamic> student) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Student"),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Are you sure you want to delete ${student["name"]}?"),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),

                  const SizedBox(width: 10),

                  ElevatedButton(
                    onPressed: () async {
                      await DatabaseHelper.instance.deleteStudent(
                        student["rollNo"].toString(),
                      );

                      await loadStudents();

                      if (context.mounted) {
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Student Deleted")),
                        );
                      }
                    },
                    child: const Text("Delete"),
                  ),
                ],
              ),
            ],
          ),
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
            DropdownButtonFormField2<String>(
              value: selectedYear,

              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                labelText: "Select Year",
                labelStyle: TextStyle(fontSize: 14),
              ),
              dropdownStyleData: DropdownStyleData(
                width: MediaQuery.of(context).size.width - 32,
                maxHeight: 250,
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

                            subtitle: Text(
                              filteredStudents[index]["rollNo"].toString(),
                            ),

                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                showDeleteDialog(filteredStudents[index]);
                              },
                            ),
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
