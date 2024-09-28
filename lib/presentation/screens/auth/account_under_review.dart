import 'package:flutter/material.dart';
import 'package:gona_market_app/core/widgets/button.dart';
import 'package:gona_market_app/presentation/routes/app_routes.dart';

class AccountUnderReview extends StatefulWidget {
  const AccountUnderReview({super.key});

  @override
  State<AccountUnderReview> createState() => _AccountUnderReviewState();
}

class _AccountUnderReviewState extends State<AccountUnderReview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 30),
              Image.asset(
                'assets/images/gona_market_logo_and_name_green.png',
                height: 200,
              ),
              const SizedBox(height: 50),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(
                      text:
                          'We are happy to have you join us, Your account in under review by our account validation officers, this will take no morethan ',
                    ),
                    const TextSpan(
                      text: '24-72 hours',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ' if that exceed kindly contact the customer care @ ',
                    ),
                    TextSpan(
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                      text: '08107100130',
                    ),
                    const TextSpan(
                      text: ' or ',
                    ),
                    TextSpan(
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                      text: 'support@gonamarket.app',
                    ),
                    const TextSpan(
                      text: ' for further clearity.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 50),
                child: PrimaryButton(
                  text: "Go Back Home",
                  onPressed: () =>
                      Navigator.popAndPushNamed(context, AppRoutes.home),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Want to Try? ',
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
                            )
            ],
          ),
        ),
      ),
    );
  }
}
