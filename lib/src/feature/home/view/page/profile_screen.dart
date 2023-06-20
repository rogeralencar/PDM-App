import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';

import '../../../auth/repository/user_model.dart';
import '../../../auth/repository/user_provider.dart';
import '../../../auth/view/widget/auth.dart';
import 'profile_form_screen.dart';

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
    bool startsWithHttp =
        user.image.toString().toLowerCase().startsWith('https://');
    final String? image = user.image!.isEmpty
        ? 'lib/assets/images/profile_image.png'
        : user.image;

    const ImageProvider placeholderImage =
        AssetImage('lib/assets/images/profile_image.png');
    final ImageProvider<Object> mainImage = startsWithHttp
        ? NetworkImage(image!) as ImageProvider<Object>
        : FileImage(File(image!));

    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Modular.to.pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Provider.of<Auth>(
                context,
                listen: false,
              ).logout();
              Modular.to.navigate('/auth/');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: screenSize.height * 0.32,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: screenSize.width * 0.1),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            ClipOval(
                              child: FadeInImage(
                                width: screenSize.width * 0.24,
                                height: screenSize.width * 0.24,
                                fit: BoxFit.cover,
                                placeholder: placeholderImage,
                                image: mainImage,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return CircleAvatar(
                                    backgroundImage: placeholderImage,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.outline,
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileFormScreen(user: user),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.all(screenSize.width * 0.01),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: screenSize.width * 0.045,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: screenSize.width * 0.05),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello',
                              style: TextStyle(
                                fontSize: screenSize.width * 0.045,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            Text(
                              name!,
                              style: TextStyle(
                                fontSize: screenSize.width * 0.055,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: screenSize.height * 0.025),
                    Card(
                      margin: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.2,
                        vertical: screenSize.height * 0.01,
                      ),
                      clipBehavior: Clip.antiAlias,
                      elevation: 5.0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.015,
                          vertical: screenSize.height * 0.025,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            if (user.age == 0 && user.gender == '')
                              Text(
                                "Sem informações adicionais",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: screenSize.width * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            if (user.age != 0)
                              Column(
                                children: <Widget>[
                                  Text(
                                    "Age",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontSize: screenSize.width * 0.05,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: screenSize.height * 0.01),
                                  Text(
                                    user.age.toString(),
                                    style: TextStyle(
                                      fontSize: screenSize.width * 0.045,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                ],
                              ),
                            if (user.gender != '')
                              Column(
                                children: <Widget>[
                                  Text(
                                    "Gender",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontSize: screenSize.width * 0.05,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: screenSize.height * 0.01),
                                  Text(
                                    user.gender!,
                                    style: TextStyle(
                                      fontSize: screenSize.width * 0.045,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            SizedBox(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenSize.height * 0.03,
                  horizontal: screenSize.width * 0.1,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      "Bio:",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontStyle: FontStyle.normal,
                        fontSize: screenSize.width * 0.08,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Text(
                      user.bio != '' ? user.bio! : 'Bio não fornecida',
                      style: TextStyle(
                        fontSize: screenSize.width * 0.05,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        letterSpacing: screenSize.width * 0.001,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: screenSize.height * 0.03,
                  left: screenSize.width * 0.1,
                  right: screenSize.width * 0.1,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      "Contact me:",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontStyle: FontStyle.normal,
                        fontSize: screenSize.width * 0.08,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Email: ${user.email}",
                          style: TextStyle(
                            fontSize: screenSize.width * 0.045,
                          ),
                        ),
                        if (user.phoneNumber != '')
                          Text(
                            "Número: ${user.phoneNumber}",
                            style: TextStyle(
                              fontSize: screenSize.width * 0.045,
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
