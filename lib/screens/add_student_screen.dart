import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../database/database_helper.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  List<Map<String, dynamic>> students = [];

  Future<void> loadStudents() async {
    students = await DatabaseHelper.instance.getStudents();

    setState(() {});
  }

  final rollController = TextEditingController();

  final nameController = TextEditingController();

  String? selectedYear = "I Year";

  final List<String> years = ["I Year", "II Year", "III Year", "IV Year"];

  Future<void> addStudent() async {
    if (rollController.text.trim().isEmpty ||
        nameController.text.trim().isEmpty ||
        selectedYear == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please Enter all the Details")),
      );
      return;
    }
    bool exists = students.any(
      (student) => student["rollNo"] == rollController.text.trim(),
    );
    if (int.tryParse(rollController.text.trim()) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Roll Number must be numeric")),
      );
      return;
    }
    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Roll Number Already Exists")),
      );
      return;
    }
    await DatabaseHelper.instance.insertStudent({
      "rollNo": rollController.text.trim(),
      "name": nameController.text.trim(),
      "year": selectedYear,
    });
    await loadStudents();
    rollController.clear();
    nameController.clear();

    setState(() {
      selectedYear = null;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Student Added Successfully")));
  }

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Student")),
      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: rollController,
              style: const TextStyle(fontWeight: FontWeight.bold),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: "Roll Number",
                labelStyle: TextStyle(fontSize: 14),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: nameController,
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                labelText: "Student Name",
                labelStyle: TextStyle(fontSize: 14),
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: selectedYear,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                labelText: "Year",
                labelStyle: TextStyle(fontSize: 14),
              ),

              items: years.map((year) {
                return DropdownMenuItem(value: year, child: Text(year));
              }).toList(),

              onChanged: (value) {
                setState(() {
                  selectedYear = value;
                });
              },
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,

              height: 50,

              child: ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style,
                onPressed: addStudent,

                child: const Text(
                  "Add Student",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    rollController.dispose();
    nameController.dispose();
    super.dispose();
  }
}
