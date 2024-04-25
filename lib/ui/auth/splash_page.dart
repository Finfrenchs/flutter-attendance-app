import 'package:flutter/material.dart';
import 'package:flutter_attendance_app/data/datasource/auth_local_datasource.dart';
import 'package:flutter_attendance_app/ui/auth/pages/login_page.dart';
import 'package:flutter_attendance_app/ui/home/pages/main_page.dart';

import '../../core/core.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: FutureBuilder(
        future: Future.delayed(
          const Duration(seconds: 3),
          () => AuthLocalDataSource().isUserLoggedIn(),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Stack(
              children: [
                Column(
                  children: [
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Assets.images.logoWhite.image(),
                    ),
                    const Spacer(),
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                      ),
                    ),
                    const SpaceHeight(40),
                    Assets.images.logoCodeWithBahri.image(height: 70),
                    const SpaceHeight(20.0),
                  ],
                ),
                // Container(
                //   height: double.infinity,
                //   width: double.infinity,
                //   decoration: const BoxDecoration(color: Colors.transparent),
                //   child: const Center(
                //     child: CircularProgressIndicator(
                //       color: AppColors.white,
                //     ),
                //   ),
                // ),
              ],
            );
          } else if (snapshot.hasData && snapshot.data == true) {
            return const MainPage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
