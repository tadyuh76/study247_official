import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/error_screen.dart';
import 'package:study247/core/shared/loading_screen.dart';
import 'package:study247/utils/unfocus.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/router/authenticated_router.dart';
import 'package:study247/router/unauthenticated_router.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(authControllerProvider).when(
          data: (userModel) {
            return MaterialApp.router(
              builder: (context, child) => Unfocus(child: child!),
              debugShowCheckedModeBanner: false,
              scrollBehavior: const MaterialScrollBehavior().copyWith(
                dragDevices: {
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.touch,
                  PointerDeviceKind.stylus,
                  PointerDeviceKind.unknown,
                },
              ),
              theme: ThemeData(
                fontFamily: Constants.fontName,
                scaffoldBackgroundColor: Colors.white,
                appBarTheme: const AppBarTheme(foregroundColor: Palette.black),
                colorScheme:
                    ThemeData().colorScheme.copyWith(primary: Palette.primary),
              ),
              routerConfig: userModel == null
                  ? unauthenticatedRouter
                  : authenticatedRouter,
            );
          },
          error: (error, stk) => const ErrorScreen(),
          loading: () => const LoadingScreen(),
        );
  }
}
