# RA Attendance Monitoring System

## Overview

RA Attendance Monitoring System is a Flutter-based mobile application developed for the Robotics and Automation Department to simplify student attendance management. The application enables faculty members to manage student records, mark daily attendance, view attendance statistics, and generate attendance reports in PDF format.

The application uses SQLite for local data storage, ensuring fast performance and offline functionality.

---

## Features

### Dashboard

* View total number of students.
* View year-wise student statistics.
* View today's attendance statistics.
* Supports Light Mode and Dark Mode.

### Student Management

* Add new students.
* Delete existing students.
* View students year-wise.
* Roll number validation (numeric only).

### Attendance Management

* Mark attendance as Present or Absent.
* Select attendance date using calendar.
* Modify previously saved attendance.
* View attendance counts instantly.

### Reports

* Generate year-wise attendance reports.
* View attendance percentage of each student.
* Export attendance reports as PDF.
* Automatic attendance calculations using SQLite data.

### User Interface

* Responsive Material Design UI.
* Department-themed splash screen.
* Custom application icon.
* Light and Dark theme support.

---

## Technologies Used

* Flutter
* Dart
* SQLite (sqflite)
* PDF Package
* Printing Package
* Intl Package

---

## Database Structure

### Students Table

| Column | Type    |
| ------ | ------- |
| id     | INTEGER |
| rollNo | TEXT    |
| name   | TEXT    |
| year   | TEXT    |

### Attendance Table

| Column | Type    |
| ------ | ------- |
| id     | INTEGER |
| rollNo | TEXT    |
| date   | TEXT    |
| status | INTEGER |

#### Status Values

* 1 → Present
* 0 → Absent

---

## Application Workflow

1. Add student details.
2. Store student records in SQLite database.
3. Select year and attendance date.
4. Mark attendance for students.
5. Save attendance records.
6. Generate attendance reports.
7. Export reports as PDF.

---

## Project Structure

```text
lib/
│
├── database/
│   └── database_helper.dart
│
├── screens/
│   ├── splash_screen.dart
│   ├── dashboard_home.dart
│   ├── add_student_screen.dart
│   ├── view_students_screen.dart
│   ├── mark_attendance_screen.dart
│   ├── reports_screen.dart
│   └── about_screen.dart
│
├── theme/
│   ├── app_colors.dart
│   └── app_theme.dart
│
└── main.dart
```

---

## Installation

### Clone Repository

```bash
git clone <repository-url>
```

### Navigate to Project

```bash
cd ra_attendance_management
```

### Install Dependencies

```bash
flutter pub get
```

### Run Application

```bash
flutter run
```

---

## Requirements

* Flutter SDK 3.x or later
* Android Studio / VS Code
* Android Device or Emulator

---

## Future Enhancements

* Student profile editing.
* Search and filter students.
* Excel report generation.
* Cloud database synchronization.
* Faculty authentication.
* Attendance analytics and charts.

---

## Developed For

Robotics and Automation Department

Sri Ramakrishna Engineering College, Coimbatore

---

## Author

**Rithick P**

B.E. Robotics and Automation

Sri Ramakrishna Engineering College
