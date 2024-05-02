import 'package:flutter/material.dart';
import 'package:flutter_attendance_app/data/datasource/attendance_remote_datasource.dart';
import 'package:flutter_attendance_app/data/datasource/auth_remote_datasource.dart';
import 'package:flutter_attendance_app/data/datasource/permission_remote_datasource.dart';
import 'package:flutter_attendance_app/ui/auth/bloc/login/login_bloc.dart';
import 'package:flutter_attendance_app/ui/auth/bloc/logout/logout_bloc.dart';
import 'package:flutter_attendance_app/ui/auth/bloc/update_user_register_face/update_user_register_face_bloc.dart';
import 'package:flutter_attendance_app/ui/home/bloc/add_permission/add_permission_bloc.dart';
import 'package:flutter_attendance_app/ui/home/bloc/checkin_attendence/checkin_attendence_bloc.dart';
import 'package:flutter_attendance_app/ui/home/bloc/checkout_attendance/checkout_attendence_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/core.dart';
import 'data/datasource/firebase_messanging_remote_datasource.dart';
import 'ui/auth/splash_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessagingRemoteDatasource().initialize();
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
        BlocProvider(
          create: (context) => AddPermissionBloc(PermissionRemoteDatasource()),
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
