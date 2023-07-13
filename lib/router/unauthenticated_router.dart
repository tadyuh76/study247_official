import 'package:go_router/go_router.dart';
import 'package:study247/features/auth/screens/sign_in_screen.dart';
import 'package:study247/features/auth/screens/sign_up_screen.dart';

final unauthenticatedRouter = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const SignInScreen(),
      routes: [
        GoRoute(
          path: "signup",
          builder: (context, state) => const SignUpScreen(),
        ),
      ],
    ),
  ],
);
