import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../database/database_helper.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class ReportsScreen extends StatefulWidget {
  final String? initialYear;

  const ReportsScreen({super.key, this.initialYear});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<Map<String, dynamic>> students = [];
  Map<String, Map<String, dynamic>> attendanceStats = {};

  String? selectedYear = "I Year";

  final List<String> years = ["I Year", "II Year", "III Year", "IV Year"];

  Future<void> generatePdf(List<Map<String, dynamic>> filteredStudents) async {
    filteredStudents.sort(
      (a, b) => int.parse(
        a["rollNo"].toString(),
      ).compareTo(int.parse(b["rollNo"].toString())),
    );
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,

            children: [
              pw.Text(
                'Robotics & Automation Attendance Report',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 10),
              pw.Text(
                'Year : $selectedYear',
                style: const pw.TextStyle(fontSize: 14),
              ),

              pw.SizedBox(height: 20),

              pw.TableHelper.fromTextArray(
                headers: ['Roll No', 'Name', 'Present', 'Total', '%'],

                data: filteredStudents.map((student) {
                  var stats = attendanceStats[student["rollNo"].toString()];

                  int present = stats?["present"] ?? 0;
                  int total = stats?["total"] ?? 0;
                  double percentage = stats?["percentage"] ?? 0.0;

                  return [
                    student["rollNo"],

                    student["name"],

                    present.toString(),

                    total.toString(),

                    percentage.toStringAsFixed(1),
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialYear ?? "I Year";
    loadStudents();
  }

  @override
  void activate() {
    super.activate();
    loadStudents();
  }

  Future<void> loadStudents() async {
    students = await DatabaseHelper.instance.getStudents();

    attendanceStats.clear();

    for (var student in students) {
      attendanceStats[student["rollNo"].toString()] = await DatabaseHelper
          .instance
          .getStudentAttendanceStats(student["rollNo"].toString());
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredStudents = students.where((student) {
      return student["year"] == selectedYear;
    }).toList();

    filteredStudents.sort(
      (a, b) => int.parse(
        a["rollNo"].toString(),
      ).compareTo(int.parse(b["rollNo"].toString())),
    );

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
                border: OutlineInputBorder(),
              ),
              dropdownStyleData: DropdownStyleData(
                width: MediaQuery.of(context).size.width - 32,
                maxHeight: 250,
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

            const SizedBox(height: 20),

            if (selectedYear != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text(
                    "Download PDF",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    generatePdf(filteredStudents);
                  },
                ),
              ),

            Expanded(
              child: filteredStudents.isEmpty
                  ? const Center(child: Text("No Students Found"))
                  : ListView.builder(
                      itemCount: filteredStudents.length,

                      itemBuilder: (context, index) {
                        var student = filteredStudents[index];

                        return Card(
                          child: ListTile(
                            title: Text(student["name"]),

                            subtitle: Text(student["rollNo"]),

                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                Text(
                                  "${attendanceStats[student["rollNo"].toString()]?["present"] ?? 0}/"
                                  "${attendanceStats[student["rollNo"].toString()]?["total"] ?? 0}",
                                ),

                                Text(
                                  "${(attendanceStats[student["rollNo"].toString()]?["percentage"] ?? 0.0).toStringAsFixed(1)}%",
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
