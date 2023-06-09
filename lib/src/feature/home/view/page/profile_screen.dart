import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/utils/app_routes.dart';
import '../../../auth/repository/user_model.dart';
import '../../../auth/repository/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final User? user = userProvider.user;

    final String? name =
        user!.socialName!.isEmpty ? user.name : user.socialName;
    final String? image = user.image!.isEmpty
        ? 'lib/assets/images/profile_image.png'
        : user.image;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage(image!),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Bem vindo(a) $name',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            user.email ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.profileForm);
            },
            child: const Text('Editar Perfil'),
          ),
        ],
      ),
    );
  }
}
