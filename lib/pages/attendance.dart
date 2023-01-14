import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String _timeString = "";
  String _dateString = "";
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _getTime();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedTime = DateFormat('hh:mm:ss').format(now);
    final String formattedDate = DateFormat('dd MMMM yyyy').format(now);
    setState(() {
      _timeString = formattedTime;
      _dateString = formattedDate;
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check In"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _timeString,
                style: const TextStyle(
                    fontSize: 32,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                _dateString,
                style: const TextStyle(fontSize: 20, color: Colors.black54),
              ),
              const SizedBox(
                height: 32,
              ),
              getCheckInButton(false),
              const SizedBox(
                height: 32,
              ),
              Text(getLastCheckedText())
            ],
          ),
        ),
      )),
    );
  }

  String getLastCheckedText() {
    return "Last checked in at ";
  }

  Widget getCheckInButton(bool isCheckedIn) {
    return GestureDetector(
      onTap: check,
      child: ClipOval(
          child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: const [
              Colors.tealAccent,
              Colors.teal,
            ],
          ),
        ),
        width: 200,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: isCheckedIn
                  ? const AssetImage("assets/image/Logout.png")
                  : const AssetImage("assets/image/Enter.png"),
              width: 64,
              height: 64,
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              isCheckedIn ? "Check Out" : "Check In",
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )
          ],
        ),
      )),
    );
  }

  void check() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("You are using mock location"),
        backgroundColor: Colors.red,
      ),
    );
  }
}
