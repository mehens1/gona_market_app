import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gona_market_app/core/widgets/custom_snackbar.dart';
import 'package:gona_market_app/logic/providers/user_provider.dart';
import 'package:gona_market_app/presentation/routes/app_routes.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: screenWidth * 0.95,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.1),
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.9,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.1),
                    ),
                  ),
                  CircleAvatar(
                    radius: screenWidth * 0.2,
                    backgroundImage: NetworkImage(
                        user?.avatarUrl ?? 'https://via.placeholder.com/150'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Text(
                    user?.fullName ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '• Active status',
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Options List
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildListTile(context, Icons.edit, 'Edit Profile'),
                  _buildListTile(
                      context, Icons.location_on, 'Shopping Address'),
                  _buildListTile(context, Icons.store, 'My Store'),
                  _buildListTile(context, Icons.history, 'Order History'),
                  _buildListTile(context, Icons.credit_card, 'Cards'),
                  const SizedBox(height: 50),
                  Column(
                    children: [
                      GestureDetector(
                        child: Text(
                          'Logout',
                          style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        child: Text('Rate This App.', style: TextStyle(color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        if (title == 'My Store') {
          if (kDebugMode) {
             Navigator.pushNamed(context, AppRoutes.myStore);
          }
          return;
        }

        print("No selection");
        CustomSnackbar.show(context, '$title feature is yet to be implemented!');
      },
    );
  }
}
