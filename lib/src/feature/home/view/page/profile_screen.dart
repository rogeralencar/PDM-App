import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

import '../../../auth/repository/user_model.dart';
import '../../../auth/repository/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  final User? user;
  final bool isYourProfile;

  const ProfileScreen({
    Key? key,
    this.isYourProfile = true,
    this.user,
  }) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  User? user;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    User? user;
    if (widget.isYourProfile) {
      user = userProvider.user;
    } else {
      user = widget.user;
    }

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
                        SizedBox(width: screenSize.width * 0.18),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            ClipOval(
                              child: SizedBox(
                                width: screenSize.width * 0.22,
                                height: screenSize.width * 0.22,
                                child: FadeInImage(
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
                            ),
                            if (widget.isYourProfile)
                              Positioned(
                                child: GestureDetector(
                                  onTap: () {
                                    Modular.to.pushNamed('profileForm',
                                        arguments: user);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          screenSize.width * 0.01),
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
                            if (widget.isYourProfile)
                              Text(
                                'hello'.i18n(),
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.045,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
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
                                'no_additional_information'.i18n(),
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
                                    'age'.i18n(),
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
                                    'gender'.i18n(),
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
                      'bio'.i18n(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontStyle: FontStyle.normal,
                        fontSize: screenSize.width * 0.08,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Text(
                      user.bio != '' ? user.bio! : 'bio_not_provided'.i18n(),
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
                      'contact_me'.i18n(),
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
                          '${'email'.i18n()} ${user.email}',
                          style: TextStyle(
                            fontSize: screenSize.width * 0.045,
                          ),
                        ),
                        if (user.phoneNumber != '')
                          Text(
                            '${'number'.i18n()} ${user.phoneNumber}',
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
