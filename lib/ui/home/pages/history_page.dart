import 'package:calendar_timeline_sbk/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance_app/ui/home/bloc/get_attendance_by_date/get_attendance_by_date_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/core.dart';
import '../widgets/history_attendace.dart';
import '../widgets/history_location.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    final currentDate = DateTime.now().toString().substring(0, 10);
    context.read<GetAttendanceByDateBloc>().add(
          GetAttendanceByDateEvent.fetchByDate(currentDate),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18.0),
        children: [
          CalendarTimeline(
            initialDate: DateTime.now(),
            firstDate: DateTime(2019, 1, 15),
            lastDate: DateTime.now().add(const Duration(days: 7)),
            onDateSelected: (date) {
              final selectedDate = date.toString().substring(0, 10);

              context.read<GetAttendanceByDateBloc>().add(
                    GetAttendanceByDateEvent.fetchByDate(selectedDate),
                  );
            },
            leftMargin: 20,
            monthColor: AppColors.grey,
            dayColor: AppColors.black,
            activeDayColor: Colors.white,
            activeBackgroundDayColor: AppColors.primary,
            showYears: true,
          ),
          const SpaceHeight(45.0),
          BlocBuilder<GetAttendanceByDateBloc, GetAttendanceByDateState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return const SizedBox.shrink();
                },
                error: (message) {
                  return Center(
                    child: Text(message),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                loaded: (attendanceList) {
                  if (attendanceList.isEmpty) {
                    return const Center(
                        child: Text('No attendance data available.'));
                  }

                  // Ambil data pertama dari list (atau ubah logika sesuai kebutuhan Anda)
                  final attendance = attendanceList.first;

                  // Pisahkan latlongIn menjadi latitude dan longitude
                  final latlongInParts = attendance.latlongIn!.split(',');
                  final latitudeIn = double.parse(latlongInParts.first);
                  final longitudeIn = double.parse(latlongInParts.last);

                  final latlongOutParts = attendance.latlongOut!.split(',');
                  final latitudeOut = double.parse(latlongOutParts.first);
                  final longitudeOut = double.parse(latlongOutParts.last);

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      HistoryAttendance(
                        statusAbsen: 'Datang',
                        time: attendance.timeIn ?? '',
                        date: attendance.date.toString(),
                      ),
                      const SpaceHeight(10.0),
                      HistoryLocation(
                        latitude: latitudeIn,
                        longitude: longitudeIn,
                      ),
                      const SpaceHeight(25),
                      HistoryAttendance(
                        statusAbsen: 'Pulang',
                        isAttendanceIn: false,
                        time: attendance.timeOut ?? '',
                        date: attendance.date.toString(),
                      ),
                      const SpaceHeight(10.0),
                      HistoryLocation(
                        isAttendance: false,
                        latitude: latitudeOut,
                        longitude: longitudeOut,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
