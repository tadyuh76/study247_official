import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/responsive/border_widget.dart';
import 'package:study247/core/responsive/responsive.dart';
import 'package:study247/core/shared/widgets/custom_button.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/auth/widgets/web_landing.dart';
import 'package:study247/utils/show_snack_bar.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordHide = true;
  bool _loading = false;

  void _signIn(WidgetRef ref, BuildContext context) {
    setState(() {
      _loading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      showSnackBar(context, "Bạn chưa nhập hết các thông tin!");
      setState(() {
        _loading = false;
      });
      return;
    }

    ref
        .read(authControllerProvider.notifier)
        .signInWithEmailAndPassword(context, email, password);

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Palette.lightGrey,
      body: Responsive(
        desktopLayout: Row(
          children: [
            Expanded(
              flex: 3,
              child: BorderWidget(
                right: true,
                child: Container(
                  color: Palette.white,
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      _renderLoginTopPart(),
                      const SizedBox(height: 40),
                      _renderLoginBottomPart(context),
                    ],
                  ),
                ),
              ),
            ),
            const Expanded(flex: 5, child: WebLanding()),
          ],
        ),
        mobileLayout: SizedBox.expand(
          child: SafeArea(
            child: Container(
              color: Palette.white,
              padding: const EdgeInsets.symmetric(
                vertical: Constants.defaultPadding * 2,
                horizontal: Constants.defaultPadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _renderMobileLogo(),
                  _renderLoginTopPart(),
                  _renderLoginBottomPart(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row _renderMobileLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/Logo.png",
          width: 60,
          height: 60,
        ),
        const Text(
          Constants.appName,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  Column _renderLoginBottomPart(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          text: "Đăng nhập",
          primary: true,
          loading: _loading,
          onTap: () {
            setState(() {
              _loading = true;
            });
            _signIn(ref, context);
            setState(() {
              _loading = false;
            });
          },
        ),
        const SizedBox(height: Constants.defaultPadding),
        const Text(
          "hoặc",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Palette.darkGrey,
          ),
        ),
        const SizedBox(height: Constants.defaultPadding / 2),
        _googleSignInButton(context),
        const SizedBox(height: Constants.defaultPadding),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Chưa có tài khoản? ",
              style: TextStyle(fontSize: 14, color: Palette.black),
            ),
            GestureDetector(
              onTap: () => context.go("/signup"),
              child: const Text(
                "Đăng kí.",
                style: TextStyle(fontSize: 14, color: Palette.primary),
              ),
            )
          ],
        )
      ],
    );
  }

  Column _renderLoginTopPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Đăng nhập",
          style: TextStyle(
            fontSize: Responsive.isDesktop(context) ? 32 : 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: kIsWeb ? 20 : 10),
        TextField(
          style: const TextStyle(fontSize: 14, height: 1.8),
          controller: _emailController,
          decoration: const InputDecoration(
            isDense: true,
            prefixIcon: Icon(Icons.email_rounded, size: 24),
            hintText: "Email",
            hintStyle: TextStyle(fontSize: 14, color: Palette.darkGrey),
          ),
        ),
        const SizedBox(height: Constants.defaultPadding),
        TextField(
          style: const TextStyle(fontSize: 14, height: 1.8),
          controller: _passwordController,
          obscureText: _passwordHide,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_rounded),
            hintText: "Mật khẩu",
            hintStyle: const TextStyle(
              fontSize: 14,
              color: Palette.darkGrey,
            ),
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _passwordHide = !_passwordHide),
              child: Icon(
                _passwordHide
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
              ),
            ),
          ),
        ),
        const SizedBox(height: Constants.defaultPadding),
      ],
    );
  }

  // GestureDetector _facebookSignInButton(BuildContext context) {
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         _loading = true;
  //       });

  //       ref.read(authControllerProvider.notifier).signInWithFacebook(context);
  //     },
  //     child: Container(
  //       width: 40,
  //       height: 40,
  //       decoration: const BoxDecoration(
  //         color: Palette.primary,
  //         shape: BoxShape.circle,
  //       ),
  //       alignment: Alignment.center,
  //       child: const Icon(Icons.facebook, color: Palette.white),
  //     ),
  //   );
  // }

  GestureDetector _googleSignInButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _loading = true;
        });

        ref.read(authControllerProvider.notifier).signInWithGoogle(context);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Palette.primary,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          IconPaths.google,
          colorFilter: const ColorFilter.mode(
            Palette.white,
            BlendMode.srcIn,
          ),
          width: 24,
        ),
      ),
    );
  }
}
