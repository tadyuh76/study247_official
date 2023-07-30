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

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordRetypeController = TextEditingController();
  final _nameController = TextEditingController();

  bool _passwordHide = true;
  bool _loading = false;

  void _signUp(WidgetRef ref, BuildContext context) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final passwordRetype = _passwordRetypeController.text.trim();
    final name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      showSnackBar(context, "Bạn chưa điền đầy đủ các thông tin");
      return;
    }
    if (password != passwordRetype) {
      showSnackBar(context, "Mật khẩu nhập lại không khớp");
      return;
    }

    setState(() => _loading = true);
    ref
        .read(authControllerProvider.notifier)
        .signUpWithEmailAndPassword(context, email, password, name);
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.lightGrey,
      resizeToAvoidBottomInset: false,
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
                      // const SizedBox(height: 40),
                      _renderSignUpTopPart(),
                      const SizedBox(height: 40),
                      _renderSignUpBottomPart(context),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Constants.defaultPadding * 2,
                horizontal: Constants.defaultPadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _renderMobileLogo(),
                  _renderSignUpTopPart(),
                  _renderSignUpBottomPart(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _renderSignUpBottomPart(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          text: "Đăng kí",
          primary: true,
          onTap: () => _signUp(ref, context),
          loading: _loading,
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
              "Đã có tài khoản? ",
              style: TextStyle(fontSize: 14, color: Palette.black),
            ),
            GestureDetector(
              onTap: () => context.go("/"),
              child: const Text(
                "Đăng nhập.",
                style: TextStyle(fontSize: 14, color: Palette.primary),
              ),
            )
          ],
        )
      ],
    );
  }

  Column _renderSignUpTopPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Đăng kí",
          style: TextStyle(
              fontSize: Responsive.isDesktop(context) ? 32 : 20,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: Constants.defaultPadding / 2),
        TextField(
          style: const TextStyle(fontSize: 14, height: 1.8),
          controller: _nameController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.person),
            hintText: "Tên",
            hintStyle: TextStyle(fontSize: 14, color: Palette.darkGrey),
          ),
        ),
        const SizedBox(height: Constants.defaultPadding),
        TextField(
          style: const TextStyle(fontSize: 14, height: 1.8),
          controller: _emailController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.email),
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
            prefixIcon: const Icon(Icons.lock),
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
        TextField(
          style: const TextStyle(fontSize: 14, height: 1.8),
          controller: _passwordRetypeController,
          obscureText: _passwordHide,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.lock),
            hintText: "Nhập lại mật khẩu",
            hintStyle: TextStyle(fontSize: 14, color: Palette.darkGrey),
          ),
        ),
        const SizedBox(height: Constants.defaultPadding),
      ],
    );
  }

  Row _renderMobileLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/logo.png",
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
