import 'package:flutter/material.dart';
import 'package:flutter_attendance_app/data/datasource/attendance_remote_datasource.dart';
import 'package:flutter_attendance_app/data/datasource/auth_remote_datasource.dart';
import 'package:flutter_attendance_app/ui/auth/bloc/login/login_bloc.dart';
import 'package:flutter_attendance_app/ui/auth/bloc/logout/logout_bloc.dart';
import 'package:flutter_attendance_app/ui/auth/bloc/update_user_register_face/update_user_register_face_bloc.dart';
import 'package:flutter_attendance_app/ui/home/bloc/checkin_attendence/checkin_attendence_bloc.dart';
import 'package:flutter_attendance_app/ui/home/bloc/checkout_attendance/checkout_attendence_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/core.dart';
import 'ui/auth/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) =>
              UpdateUserRegisterFaceBloc(AttendanceRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) =>
              CheckinAttendenceBloc(AttendanceRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) =>
              CheckoutAttendenceBloc(AttendanceRemoteDatasource()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Intensive Club batch 16',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          dividerTheme:
              DividerThemeData(color: AppColors.light.withOpacity(0.5)),
          dialogTheme: const DialogTheme(elevation: 0),
          textTheme: GoogleFonts.kumbhSansTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: AppBarTheme(
            centerTitle: true,
            color: AppColors.white,
            elevation: 0,
            titleTextStyle: GoogleFonts.kumbhSans(
              color: AppColors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        home: const SplashPage(),
      ),
    );
  }
}
