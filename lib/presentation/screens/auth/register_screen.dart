import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gona_market_app/core/utils/show_error_dialog.dart';
import 'package:gona_market_app/core/widgets/button.dart';
import 'package:gona_market_app/core/widgets/dropdown.dart';
import 'package:gona_market_app/core/widgets/text_inputs.dart';
import 'package:gona_market_app/data/services/api_service.dart';
import 'package:gona_market_app/data/services/registration_service.dart';
import 'package:gona_market_app/logic/providers/lga_provider.dart';
import 'package:gona_market_app/logic/providers/states_provider.dart';
import 'package:gona_market_app/presentation/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late Dio _dio;
  late ApiService _apiService;
  late RegistrationService _registrationService;

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late final bool _obscurePassword = true;
  late bool _tAndCAgreed = false;

  var selectedState;
  var selectedLGA;
  bool _isLoading = false;
  List<Map<String, dynamic>> localGovernments = [];

  // String? _firstnameError;
  // String? _lastnameError;
  // String? _emailError;
  // String? _phoneNumberError;
  // String? _newPasswordError;
  // String? _confirmPasswordError;
  // String? _stateError;
  // String? _lgaError;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    _apiService = ApiService(_dio, baseUrl: dotenv.env['API_URL'] ?? '');
    _registrationService = RegistrationService(_apiService);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StatesProvider>(context, listen: false).fetchStates();
    });
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void fetchLocalGovernments(String stateId) async {
    final lgaProvider = Provider.of<LGAProvider>(context, listen: false);
    await lgaProvider.fetchLGAByIdAndField(stateId);

    setState(() {
      localGovernments = lgaProvider.lgas;
      selectedLGA = null;
    });
  }

  void _submitRegistration() async {
    if (_formKey.currentState!.validate()) {
      if (!_tAndCAgreed) {
        showErrorDialog(context, 'Agreement Required!',
            'You must agree to the terms and conditions!');
        return;
      }

      setState(() {
        _isLoading = true;
      });
      final registrationData = {
        'first_name': _firstnameController.text,
        'last_name': _lastnameController.text,
        'email': _emailController.text,
        'phone_number': _phoneNumberController.text,
        'state_id': selectedState,
        'lga_id': selectedLGA,
        'password': _newPasswordController.text,
        'password_confirmation': _confirmPasswordController.text,
        'registration_platform': 'mobile_app',
      };

      try {
        final response =
            await _registrationService.registerUser(registrationData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          Navigator.popAndPushNamed(
              context, AppRoutes.accountUnderVerification);
        } else {
          if (kDebugMode) {
            print('register try catch error: $response');
          }
          showErrorDialog(context, 'Registration Error!',
              'Registration failed. Please try again.');
        }
      } catch (error) {
        showErrorDialog(context, 'Registration Error!', 'Error: $error.');
        if (kDebugMode) {
          print('register try catch error: $error');
        }
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final statesProvider = Provider.of<StatesProvider>(context);

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
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        'Register',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 43,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: Column(
                          children: [
                            PrimaryTextInput(
                              labelText: 'First name...',
                              controller: _firstnameController,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter first name!';
                                }
                                return null;
                              },
                            ),
                            PrimaryTextInput(
                              labelText: 'Last name...',
                              controller: _lastnameController,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter last name!';
                                }
                                return null;
                              },
                            ),
                            PrimaryTextInput(
                              labelText: 'Email address...',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter email address!';
                                }
                                return null;
                              },
                            ),
                            PrimaryTextInput(
                              labelText: 'Phone number...',
                              controller: _phoneNumberController,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter phone number!';
                                }
                                return null;
                              },
                            ),
                            PrimaryDropdown<String>(
                              value: selectedState,
                              items: statesProvider.states
                                  .map((state) => state['state'].toString())
                                  .toList(),
                              hintText: 'State of Residence',
                              onChanged: (value) {
                                setState(() {
                                  if (value == null) {
                                    selectedState = null;
                                    selectedLGA = null;
                                    localGovernments = [];
                                  } else {
                                    final selectedStateObj =
                                        statesProvider.states.firstWhere(
                                            (state) => state['state'] == value);
                                    selectedState = selectedStateObj['id'];
                                    fetchLocalGovernments(selectedState);
                                  }
                                });
                              },
                              validator: (value) =>
                                  validateDropdown(value, 'state'),
                            ),
                            if (selectedState != null &&
                                localGovernments.isNotEmpty)
                              PrimaryDropdown<String>(
                                value: selectedLGA,
                                items: localGovernments
                                    .map((lga) => lga['lga'].toString())
                                    .toList(),
                                hintText: 'Local Government Area',
                                onChanged: (value) {
                                  setState(() {
                                    final selectedLGAObj =
                                        localGovernments.firstWhere(
                                            (lga) => lga['lga'] == value);
                                    selectedLGA = selectedLGAObj['id'];
                                  });
                                },
                                validator: (value) =>
                                    validateDropdown(value, 'LGA'),
                              ),
                            PrimaryTextInput(
                              labelText: 'New Password...',
                              controller: _newPasswordController,
                              obscureText: _obscurePassword,
                            suffixIcon: Icon(
                              color: Theme.of(context).primaryColor,
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter new password!';
                                }
                                return null;
                              },
                            ),
                            PrimaryTextInput(
                              labelText: 'Confirm Password...',
                              controller: _confirmPasswordController,
                              obscureText: _obscurePassword,
                              suffixIcon: Icon(
                              color: Theme.of(context).primaryColor,
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm password!';
                                }
                                if (_newPasswordController.text !=
                                    _confirmPasswordController.text) {
                                  return 'Passwords do not match!';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Checkbox(
                                  value: _tAndCAgreed,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _tAndCAgreed = value ?? false;
                                    });
                                  },
                                ),
                                const Expanded(
                                  child: Text(
                                    'I agree to the terms and conditions',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            PrimaryButton(
                              text: _isLoading ? 'Submitting...' : 'Register',
                              onPressed:
                                  _isLoading ? () {} : _submitRegistration,
                            ),
                            const SizedBox(height: 50),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an Account? ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.popAndPushNamed(
                                      context, AppRoutes.login),
                                  child: Text(
                                    'Login',
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
                            ),
                            const SizedBox(height: 50),
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

  String? validateDropdown(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please select a $fieldName';
    }
    return null;
  }
}
