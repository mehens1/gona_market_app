import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gona_market_app/core/widgets/button.dart';
import 'package:gona_market_app/core/widgets/dropdown.dart';
import 'package:gona_market_app/core/widgets/text_inputs.dart';
import 'package:gona_market_app/logic/providers/lga_provider.dart';
import 'package:gona_market_app/logic/providers/states_provider.dart';
import 'package:gona_market_app/presentation/routes/app_routes.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _tAndCAgreed = false;
  var selectedState;
  var selectedLGA;
  List<Map<String, dynamic>> localGovernments = [];

  String? _firstnameError;
  String? _lastnameError;
  String? _emailError;
  String? _phoneNumberError;
  String? _newPasswordError;
  String? _confirmPasswordError;
  String? _stateError;
  String? _lgaError;
  String? _agreementError;

  final FocusNode _firstNameFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    _firstNameFocus.addListener(() {
    if (_firstNameFocus.hasFocus) {
      print("First Name field has focus");
    } else {
      print("First Name field lost focus");
    }
  });

    _firstnameController.addListener(() {
      if (_firstnameError != null) {
        _firstnameError = null;
      }
    });

    _lastnameController.addListener(() {
      if (_lastnameError != null) {
        _lastnameError = null;
      }
    });

    _emailController.addListener(() {
      if (_emailError != null) {
        _emailError = null;
      }
    });

    _phoneNumberController.addListener(() {
      if (_phoneNumberError != null) {
        _phoneNumberError = null;
      }
    });

    _newPasswordController.addListener(() {
      if (_newPasswordError != null) {
        _newPasswordError = null;
      }
    });

    _confirmPasswordController.addListener(() {
      if (_confirmPasswordError != null) {
        _confirmPasswordError = null;
      }
    });
    
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

    _firstNameFocus.dispose();
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

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
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
                              focusNode: _firstNameFocus,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return _firstnameError ??= 'Please enter first name!';
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
                                  return _lastnameError ??= 'Please enter last name!';
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
                                  return _emailError ??= 'Please enter email address!';
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
                                  return _phoneNumberError ??= 'Please enter phone number!';
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

                                  if (kDebugMode) {
                                    print('state values is: $selectedState');
                                  }
                                });
                              },
                              validator: (value) =>
                                  validateDropdown(value, 'state'),
                            ),

                            selectedState == null || localGovernments.isEmpty
                                ? Container()
                                : PrimaryDropdown<String>(
                                    value: selectedLGA,
                                    items: localGovernments.map((lga) {
                                      return lga['lga'].toString();
                                    }).toList(),
                                    hintText: 'Local Government Area',
                                    onChanged: (value) {
                                      setState(() {
                                        final selectedLGAObj =
                                            localGovernments.firstWhere(
                                                (lga) => lga['lga'] == value);
                                        selectedLGA = selectedLGAObj['id'];
                                        if (kDebugMode) {
                                          print(
                                              'Selected LGA ID: $selectedLGA');
                                        }
                                      });
                                    },
                                    validator: (value) =>
                                        validateDropdown(value, 'LGA'),
                                  ),

                            PrimaryTextInput(
                              labelText: 'New Password...',
                              controller: _newPasswordController,
                              obscureText: _obscureNewPassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return _newPasswordError ??= 'Please enter password!';
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureNewPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureNewPassword = !_obscureNewPassword;
                                  });
                                },
                              ),
                            ),
                            PrimaryTextInput(
                              labelText: 'Confirm Password...',
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return _confirmPasswordError ??= 'Please confirm password!';
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                    value: _tAndCAgreed,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _tAndCAgreed = value!;
                                        if (kDebugMode) {
                                          print(
                                              'terms and condition value: $_tAndCAgreed');
                                        }
                                      });
                                    }),
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                      context, AppRoutes.termsAndCondition),
                                  child: Text(
                                    'Agree to terms and condition',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 50),
                            PrimaryButton(
                              text: "Register",
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  print('form validation perfect: ');
                                }
                              },
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already a member? ',
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
                            const SizedBox(height: 50)
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
}

String? validateDropdown(String? value, String? type) {
  if (value == null || value.isEmpty) {
    return 'Please select $type!';
  }
  return null;
}
