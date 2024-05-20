import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stay_indie/buttons/PrimaryButton.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/models/SingleFormPage.dart';
import 'package:stay_indie/screens/loginSignUpFlow/SplashScreen.dart';
import 'package:stay_indie/screens/templates/stepper_form.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../archive/HomeScreen.dart';
import 'package:stay_indie/utilities/input_fields.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.isRegistering}) : super(key: key);
  static const String id = 'registerpage';

  static Route<void> route({bool isRegistering = false}) {
    return MaterialPageRoute(
      builder: (context) => RegisterPage(isRegistering: isRegistering),
    );
  }

  final bool isRegistering;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  Future<void> _signUp() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    final email = _emailController.text;
    final password = _passwordController.text;
    final username = _usernameController.text;
    try {
      await supabase.auth.signUp(
          email: email, password: password, data: {'username': username});
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => StepperForm(
              title: 'Profile Set Up',
              pages: SingleFormPage.profileSetUp,
              onSubmit: (formValues) async {
                Profile.updateProfile(
                    supabase.auth.currentUser!.id, formValues);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              },
            ),
          ),
          (route) => false);
    } on AuthException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (error) {
      context.showErrorSnackBar(message: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: formPadding,
          children: [
            InputFields(children: [
              TextFormField(
                controller: _emailController,
                decoration:
                    kPlainTextFieldDecoration.copyWith(labelText: 'Email'),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              kDivider,
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration:
                    kPlainTextFieldDecoration.copyWith(labelText: 'Password'),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Required';
                  }
                  if (val.length < 6) {
                    return '6 characters minimum';
                  }
                  return null;
                },
              ),
            ]),
            formSpacer,
            InputFields(children: [
              TextFormField(
                controller: _usernameController,
                decoration:
                    kPlainTextFieldDecoration.copyWith(labelText: 'Username'),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Required';
                  }
                  final isValid = RegExp(r'^[A-Za-z0-9_]{3,24}$').hasMatch(val);
                  if (!isValid) {
                    return '3-24 long with alphanumeric or underscore';
                  }
                  return null;
                },
              ),
            ]),
            formSpacer,
            TextButton(
              style: kPrimaryButtonStyle,
              onPressed: _isLoading ? null : _signUp,
              child: const Text('Register'),
            ),
            formSpacer,
            TextButton(
              style: kTextButtonStyle,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('I already have an account'),
            )
          ],
        ),
      ),
    );
  }
}
