import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gona_market_app/core/utils/show_error_dialog.dart';
import 'package:gona_market_app/core/widgets/button.dart';
import 'package:gona_market_app/core/widgets/custom_snackbar.dart';
import 'package:gona_market_app/core/widgets/text_inputs.dart';
import 'package:gona_market_app/data/services/api_service.dart';
import 'package:gona_market_app/data/services/auth_service.dart';
import 'package:gona_market_app/logic/providers/cart_provider.dart';
import 'package:gona_market_app/logic/providers/login_provider.dart';
import 'package:gona_market_app/presentation/routes/app_routes.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Dio _dio;
  late ApiService _apiService;
  late AuthService _authService;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    _apiService = ApiService(_dio, baseUrl: dotenv.env['API_URL'] ?? '');
    _authService = AuthService(_apiService);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final loginData = {
        'login': _usernameController.text,
        'password': _passwordController.text
      };

      try {
        await Provider.of<LoginProvider>(context, listen: false)
            .login(loginData);

        await Provider.of<CartProvider>(context, listen: false)
            .syncCartWithUserProfile();

        CustomSnackbar.show(context, 'Login Successsful!');

        Navigator.pop(context);
      } catch (error) {
        if (error == "Your account is not activated. Please contact support.") {
          Navigator.popAndPushNamed(
              context, AppRoutes.accountUnderVerification);
        } else {
          showErrorDialog(context, 'Login Error!', error.toString());
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final successMessage =
        ModalRoute.of(context)?.settings.arguments as String?;

    if (successMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(successMessage)),
        );
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Image.asset(
                  'assets/images/gona_market_logo_white.png',
                  height: 100,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onError,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        'Login',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 43,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: Column(
                          children: [
                            PrimaryTextInput(
                              labelText: 'Email or Phone Number...',
                              controller: _usernameController,
                              keyboardType: TextInputType.text,
                            ),
                            const SizedBox(height: 30),
                            PrimaryTextInput(
                              labelText: 'Password...',
                              controller: _passwordController,
                              obscureText: true,
                              suffixIcon: Icon(
                                color: Theme.of(context).primaryColor,
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Forgot Password? ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(),
                                ),
                                Text(
                                  'Recover',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 50),
                            PrimaryButton(
                                text: _isLoading ? 'Login in...' : "Login",
                                onPressed: () =>
                                    _isLoading ? null : _submitLogin()),
                            const SizedBox(height: 50),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'New here? ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.popAndPushNamed(
                                      context, AppRoutes.register),
                                  child: Text(
                                    'Register',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
