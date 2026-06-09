import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  List<Map<String, dynamic>> students = [];
  Map<String, bool> attendanceMap = {};

  bool attendanceSaved = false;
  bool editMode = true;

  String? selectedYear = "I Year";

  DateTime selectedDate = DateTime.now();

  final List<String> years = ["I Year", "II Year", "III Year", "IV Year"];

  @override
  void initState() {
    super.initState();
    awaitLoad();
  }

  @override
  void activate() {
    super.activate();
    awaitLoad();
  }

  Future<void> loadStudents() async {
    students = await DatabaseHelper.instance.getStudents();
    print("Attendance Screen Students = $students");
    setState(() {});
  }

  Future<void> awaitLoad() async {
    await loadStudents();
    await loadAttendance();
  }

  Future<void> loadAttendance() async {
    final data = await DatabaseHelper.instance.getAttendanceByDate(
      currentDateKey(),
    );

    attendanceMap.clear();

    for (var row in data) {
      attendanceMap[row['rollNo']] = row['status'] == 1;
    }

    setState(() {});
  }

  void checkAttendanceStatus() {
    if (selectedYear == null) return;

    List<Map<String, dynamic>> filteredStudents = students
        .where((student) => student["year"] == selectedYear)
        .toList();

    bool hasAttendance = filteredStudents.any(
      (student) => attendanceMap.containsKey(student["rollNo"]),
    );

    setState(() {
      attendanceSaved = hasAttendance;
      editMode = !hasAttendance;
    });
  }

  String currentDateKey() {
    return DateFormat('yyyy-MM-dd').format(selectedDate);
  }

  int getPresentCount(List<Map<String, dynamic>> filteredStudents) {
    return filteredStudents.where((student) {
      return attendanceMap[student["rollNo"]] == true;
    }).length;
  }

  int getAbsentCount(List<Map<String, dynamic>> filteredStudents) {
    return filteredStudents.length - getPresentCount(filteredStudents);
  }

  Future<void> saveAttendance() async {
    print("Attendance Map = $attendanceMap");
    for (var entry in attendanceMap.entries) {
      print("Saving ${entry.key} -> ${entry.value}");
      await DatabaseHelper.instance.markAttendance(
        rollNo: entry.key,
        date: currentDateKey(),
        present: entry.value,
      );
    }
    print(await DatabaseHelper.instance.getAllAttendance());
    setState(() {
      attendanceSaved = true;
      editMode = false;
    });
    await loadAttendance();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Attendance Saved")));
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
            DropdownButtonFormField<String>(
              value: selectedYear,

              decoration: const InputDecoration(
                labelText: "Select Year",
                labelStyle: TextStyle(fontSize: 14),
                border: OutlineInputBorder(),
              ),

              items: years.map((year) {
                return DropdownMenuItem(
                  value: year,
                  child: Text(
                    year,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),

              onChanged: (value) async {
                setState(() {
                  selectedYear = value;
                });
                await loadAttendance();
                checkAttendanceStatus();
              },
            ),

            const SizedBox(height: 15),

            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_month),

              label: Text(
                DateFormat('dd-MM-yyyy').format(selectedDate),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2035),
                );

                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                  await loadAttendance();
                  checkAttendanceStatus();
                }
              },
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: filteredStudents.length,

                itemBuilder: (context, index) {
                  String rollNo = filteredStudents[index]["rollNo"];

                  bool isPresent = attendanceMap[rollNo] ?? false;

                  final isDark =
                      Theme.of(context).brightness == Brightness.dark;

                  return Card(
                    color: isDark
                        ? Theme.of(context).cardTheme.color
                        : (isPresent
                              ? Colors.green.shade100
                              : Colors.red.shade100),

                    child: ListTile(
                      isThreeLine: true,
                      title: Text(
                        filteredStudents[index]["name"],
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            filteredStudents[index]["rollNo"],
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),

                          const SizedBox(height: 8),

                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: editMode
                                      ? () {
                                          setState(() {
                                            attendanceMap[rollNo] = true;
                                          });
                                        }
                                      : null,

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isPresent
                                        ? Colors.green
                                        : null,
                                  ),

                                  child: const Text("PRESENT"),
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: ElevatedButton(
                                  onPressed: editMode
                                      ? () {
                                          setState(() {
                                            attendanceMap[rollNo] = false;
                                          });
                                        }
                                      : null,

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: !isPresent
                                        ? Colors.red
                                        : null,
                                  ),

                                  child: const Text("ABSENT"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            if (attendanceSaved)
              const Text(
                "Attendance Saved",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

            Text("Total Students : ${filteredStudents.length}"),

            Text("Present : ${getPresentCount(filteredStudents)}"),

            Text("Absent : ${getAbsentCount(filteredStudents)}"),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: editMode
                    ? saveAttendance
                    : () {
                        setState(() {
                          editMode = true;
                        });
                      },

                child: Text(
                  editMode ? "Save Attendance" : "Modify Attendance",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
