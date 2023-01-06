// ignore_for_file: file_names

import 'package:curnect/src/pages/Login.dart';
import 'package:curnect/src/pages/forgetPassword/enterEmail.dart';
import 'package:curnect/src/pages/forgetPassword/enterPasscode.dart';
import 'package:curnect/src/pages/signup/SignupOne.dart';
import 'package:curnect/src/pages/verification/select_category.dart';
import 'package:curnect/src/style/animation/SlideInAnimation.dart';
import 'package:curnect/src/style/onBoarding.dart';
import 'package:go_router/go_router.dart';

import '../common_widgets/splash_screen.dart';
import '../pages/dash_board/dashboard.dart';
import '../pages/forgetPassword/resetPassword.dart';

class Routing {
  final GoRouter router = GoRouter(routes: <GoRoute>[
    GoRoute(
        path: '/',
        pageBuilder: (_, state) {
          // ignore: prefer_const_constructors
          return SlideInAnimation(
              key: state.pageKey, child: const SplashScreen());
        },
        routes: <GoRoute>[
          GoRoute(
            path: 'onboarding',
            pageBuilder: (_, state) {
              return SlideInAnimation(
                  key: state.pageKey, child: const OnBoardingScreen());
            },
          ),
          GoRoute(
            path: 'signup',
            pageBuilder: (_, state) {
              return SlideInAnimation(
                  key: state.pageKey, child: const SignupPageOne());
            },
          ),
          GoRoute(
            path: 'signin',
            name: 'signin',
            pageBuilder: (_, state) {
              return SlideInAnimation(
                  key: state.pageKey, child: const LoginPage());
            },
          ),
          GoRoute(
            path: 'verify',
            pageBuilder: (_, state) {
              return SlideInAnimation(
                  key: state.pageKey, child: const SelectCategory());
            },
          ),
          GoRoute(
            path: 'resetenteremail',
            pageBuilder: (_, state) {
              return SlideInAnimation(
                  key: state.pageKey, child: const EnterEmail());
            },
          ),
          GoRoute(
            name: "getyourcode",
            path: 'getyourcode',
            pageBuilder: (_, state) {
              Map<String, dynamic> sample = state.extra as Map<String, dynamic>;

              return SlideInAnimation(
                  key: state.pageKey, child: GetYourCode(userData: sample));
            },
          ),
          GoRoute(
            name: "resetpasword",
            path: 'resetpasword',
            pageBuilder: (_, state) {
              Map<String, dynamic> sample = state.extra as Map<String, dynamic>;
              return SlideInAnimation(
                  key: state.pageKey,
                  child: ResetPassword(id: sample["userId"]));
            },
          ),
          GoRoute(
            name: "calendar",
            path: 'calendar',
            pageBuilder: (_, state) {
              return SlideInAnimation(
                  key: state.pageKey, child: const Dashboard());
            },
          )
        ])
  ]);

  // this function returns the router to the material routing system
}
