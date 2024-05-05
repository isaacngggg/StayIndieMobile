import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stay_indie/constants.dart';

import 'SplashScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'testRegisterPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const String id = 'loginpage';

  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => const LoginPage());
  }

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await supabase.auth.signInWithPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.of(context)
          .pushNamedAndRemoveUntil(SplashScreen.id, (route) => false);
    } on AuthException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (e) {
      context.showErrorSnackBar(message: e.toString());
    }
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              // clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0),
                  ),
                  color: kBackgroundColour10),
              padding: EdgeInsets.all(16.0),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Login',
                      style: kHeading1,
                    ),
                    formSpacer,
                    Container(
                      decoration: kMultiInputBoxDecoraction,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: kPlainTextFieldDecoration.copyWith(
                                labelText: 'Email'),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          kDivider,
                          TextFormField(
                            controller: _passwordController,
                            decoration: kPlainTextFieldDecoration.copyWith(
                                labelText: 'Password'),
                            obscureText: true,
                          ),
                        ],
                      ),
                    ),
                    formSpacer,
                    TextButton(
                      onPressed: _isLoading ? null : _signIn,
                      child: const Text('Login'),
                      style: kPrimaryButtonStyle,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, RegisterPage.id, (route) => false);
                      },
                      child: const Text('Register'),
                      style: kTextButtonStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
