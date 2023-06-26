import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../auth/repository/user_model.dart';
import '../../../auth/repository/user_provider.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../../../auth/view/widget/auth.dart';
import '../widget/image_input.dart';

class ProfileFormScreen extends StatefulWidget {
  final User user;
  const ProfileFormScreen({Key? key, required this.user}) : super(key: key);

  @override
  ProfileFormScreenState createState() => ProfileFormScreenState();
}

class ProfileFormScreenState extends State<ProfileFormScreen> {
  File? _pickedImage;

  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  final _nameController = TextEditingController();
  final _socialNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _ageController = TextEditingController();
  final _bioController = TextEditingController();
  final _cpfController = TextEditingController();
  final _otherGenderController = TextEditingController();

  String _selectedGender = '';
  bool _showOtherGenderInput = false;

  static final List<String> _genderOptions = [
    'male'.i18n(),
    'female'.i18n(),
    'non_binary'.i18n(),
    'other'.i18n(),
  ];

  bool _isLoading = false;
  bool _isImageUrl = false;

  void _selectImage(File pickedImage) {
    setState(() {
      _pickedImage = pickedImage;
      _formData['image'] = pickedImage;
    });
  }

  void _changeTypeImage() {
    setState(() {
      _isImageUrl = !_isImageUrl;
    });
  }

  @override
  void dispose() {
    super.dispose();

    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();

    _ageController.dispose();
    _bioController.dispose();
    _cpfController.dispose();
    _emailController.dispose();
    _imageUrlController.dispose();
    _nameController.dispose();
    _otherGenderController.dispose();
    _phoneNumberController.dispose();
    _socialNameController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  void updateImage() {
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      _formData['image'] = widget.user.image ?? '';
      _formData['name'] = widget.user.name ?? '';
      _formData['socialName'] = widget.user.socialName ?? '';
      _formData['email'] = widget.user.email ?? '';
      _formData['age'] = widget.user.age ?? 0;
      _formData['bio'] = widget.user.bio ?? '';
      _formData['cpf'] = widget.user.cpf ?? '';
      _formData['gender'] = widget.user.gender ?? '';
      _formData['phoneNumber'] = widget.user.phoneNumber ?? '';
      _formData['cep'] = widget.user.cep ?? '';
      _formData['city'] = widget.user.city ?? '';

      if (widget.user.image.toString().toLowerCase().startsWith('https://')) {
        _isImageUrl = true;
        _imageUrlController.text = widget.user.image!;
      } else {
        _isImageUrl = false;
        _pickedImage =
            widget.user.image != '' ? File(widget.user.image!) : null;
      }

      if (widget.user.gender != null && widget.user.gender!.isNotEmpty) {
        if (_genderOptions.contains(widget.user.gender)) {
          _selectedGender = widget.user.gender!;
        } else {
          _selectedGender = 'other'.i18n();
          _otherGenderController.text = widget.user.gender!;
        }
      }
    }
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    if (_isImageUrl) {
      _formData['image'] = _imageUrlController.text;
    } else {
      _formData['image'] = _pickedImage ?? '';
    }

    _formKey.currentState?.save();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    User? user = userProvider.user;

    setState(() => _isLoading = true);
    if (_selectedGender == 'other'.i18n()) {
      _formData['gender'] = _otherGenderController.text;
    } else {
      _formData['gender'] = _selectedGender;
    }
    try {
      user!.age = _formData['age'] as int;
      user.name = _formData['name'] as String;
      user.bio = _formData['bio'] as String;
      user.cpf = _formData['cpf'] as String;
      user.socialName = _formData['socialName'] as String;
      user.email = _formData['email'] as String;
      user.phoneNumber = _formData['phoneNumber'] as String;
      user.gender = _formData['gender'] as String;
      user.image = _formData['image'];

      await userProvider.saveUserInfo(user, isImageUrl: _isImageUrl);
      userProvider.setUser(user);
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('error_occurred'.i18n()),
          content: Text('error_saving_user'.i18n()),
          actions: [
            TextButton(
              child: Text('ok'.i18n()),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } finally {
      Navigator.of(context).pop();
      setState(() => _isLoading = false);
    }
  }

  void _handleGenderOptionChange(String? value) {
    if (_selectedGender == value) {
      setState(() {
        _selectedGender = '';
        _showOtherGenderInput = false;
        _otherGenderController.clear();
      });
    } else {
      setState(() {
        _selectedGender = value ?? '';
        if (value == 'other'.i18n()) {
          _showOtherGenderInput = true;
        } else {
          _showOtherGenderInput = false;
          _otherGenderController.clear();
        }
      });
    }
  }

  void _handleOtherGenderInputChange(String value) {
    setState(() {
      _selectedGender = 'other'.i18n();
      _showOtherGenderInput = true;
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('error_occurred'.i18n()),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('close'.i18n()),
          ),
        ],
      ),
    );
  }

  void _deleteUser() async {
    bool confirmDelete = await _showConfirmationDialog();
    if (confirmDelete == true) {
      await _performDeleteUser();
    }
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('delete_account'.i18n()),
          content: Text('are_you_sure'.i18n()),
          actions: [
            TextButton(
              child: Text('no'.i18n()),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('yes'.i18n()),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _performDeleteUser() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<UserProvider>(
        context,
        listen: false,
      ).deleteUser().then((value) => Provider.of<Auth>(
            context,
            listen: false,
          ).deleteUser());
    } catch (error) {
      _showErrorDialog('unexpected_error'.i18n());
    }
    setState(() => _isLoading = false);
  }

  bool isValidImageUrl(String url) {
    if (url.isNotEmpty) {
      bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
      bool endsWithFile = url.toLowerCase().endsWith('.png') ||
          url.toLowerCase().endsWith('.jpg') ||
          url.toLowerCase().endsWith('.jpeg');
      return isValidUrl && endsWithFile;
    } else {
      return true;
    }
  }

  bool isValidEmail(String email) {
    RegExp emailRegExp = RegExp(
        r'^[a-zA-Z0-9.!#$%&*+\=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$');
    return emailRegExp.hasMatch(email);
  }

  String? _validateAge(String? value) {
    if (value != null && value.isNotEmpty) {
      final age = double.tryParse(value);
      if (age == null || age.isNaN || age.isNegative || age.remainder(1) != 0) {
        return 'age_invalid'.i18n();
      } else if (age < 18) {
        return 'age_requirement'.i18n();
      }
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length != 15) {
        return 'phone_number_invalid'.i18n();
      }
    }
    return null;
  }

  String? _validateBio(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.trim().length < 10) {
        return 'bio_invalid'.i18n();
      }
    }
    return null;
  }

  String? _validateCpf(String? value) {
    if (value != null && value.isNotEmpty) {
      final cpfRegex = RegExp(r'^\d{3}\.\d{3}\.\d{3}-\d{2}$');
      if (!cpfRegex.hasMatch(value)) {
        return 'cpf_invalid'.i18n();
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile_form'.i18n()),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _changeTypeImage,
            icon: _isImageUrl
                ? const Icon(Icons.camera_alt)
                : const Icon(Icons.link),
          ),
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.outline,
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    if (!_isImageUrl)
                      ImageInput(
                        _selectImage,
                        _pickedImage,
                        isProfile: true,
                      ),
                    if (_isImageUrl)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: CustomTextField(
                              text: 'image_url'.i18n(),
                              focusNode: _imageUrlFocus,
                              controller: _imageUrlController,
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submitForm(),
                              onSaved: (imageUrl) =>
                                  _formData['imageUrl'] = imageUrl ?? '',
                              validator: (userImageUrl) {
                                final imageUrl = userImageUrl ?? '';

                                if (!isValidImageUrl(imageUrl)) {
                                  return 'url_invalid'.i18n();
                                }
                                return null;
                              },
                            ),
                          ),
                          Stack(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                margin: const EdgeInsets.only(
                                  top: 10,
                                  left: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    width: 1,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: ClipOval(
                                  child: _imageUrlController.text.isEmpty
                                      ? Center(
                                          child: Text(
                                            'no_url'.i18n(),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      : Image.network(_imageUrlController.text),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _formData['imageUrl'] = '';
                                      _imageUrlController.text = '';
                                    });
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    const Divider(),
                    CustomTextField(
                      text: 'name_field'.i18n(),
                      controller: _nameController,
                      initialValue: _formData['name']?.toString(),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'name_required'.i18n();
                        }
                        if (value.trim().length < 3) {
                          return 'name_invalid'.i18n();
                        }
                        return null;
                      },
                      onSaved: (name) => _formData['name'] = name ?? '',
                    ),
                    const Divider(),
                    CustomTextField(
                      text: 'social_name_field'.i18n(),
                      controller: _socialNameController,
                      initialValue: _formData['socialName']?.toString(),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (value.trim().length < 3) {
                            return 'social_name_invalid'.i18n();
                          }
                        }
                        return null;
                      },
                      onSaved: (name) => _formData['socialName'] = name ?? '',
                    ),
                    const Divider(),
                    CustomTextField(
                      text: 'email_field'.i18n(),
                      controller: _emailController,
                      initialValue: _formData['email']?.toString(),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'email_required'.i18n();
                        } else if (!isValidEmail(value)) {
                          return 'email_invalid'.i18n();
                        }
                        return null;
                      },
                      onSaved: (email) => _formData['email'] = email ?? '',
                    ),
                    const Divider(),
                    CustomTextField(
                      text: 'number_field'.i18n(),
                      controller: _phoneNumberController,
                      initialValue: _formData['phoneNumber']?.toString(),
                      keyboardType: TextInputType.phone,
                      validator: _validatePhoneNumber,
                      onSaved: (number) =>
                          _formData['phoneNumber'] = number ?? '',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        MaskTextInputFormatter(mask: '(##) #####-####'),
                      ],
                    ),
                    const Divider(),
                    CustomTextField(
                      text: 'age_field'.i18n(),
                      controller: _ageController,
                      initialValue: _formData['age'] == 0
                          ? ''
                          : _formData['age'].toString(),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: _validateAge,
                      onSaved: (age) => _formData['age'] =
                          int.tryParse(age ?? '0')?.round() ?? 0,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const Divider(),
                    CustomTextField(
                      text: 'bio_field'.i18n(),
                      controller: _bioController,
                      initialValue: _formData['bio']?.toString(),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      validator: _validateBio,
                      onSaved: (bio) => _formData['bio'] = bio ?? '',
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'gender'.i18n(),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const Divider(),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        for (final genderOption in _genderOptions)
                          SizedBox(
                            width: 150,
                            child: InkWell(
                              onDoubleTap: () =>
                                  _handleGenderOptionChange(genderOption),
                              child: Row(
                                children: [
                                  Radio<String>(
                                    value: genderOption,
                                    groupValue: _selectedGender,
                                    onChanged: _handleGenderOptionChange,
                                  ),
                                  Text(genderOption),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: SizedBox(
                        width: 200,
                        child: TextField(
                          controller: _otherGenderController,
                          enabled: _showOtherGenderInput,
                          decoration: InputDecoration(
                            labelText: 'enter_gender'.i18n(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 2.0,
                              ),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.tertiary,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 12.0),
                          ),
                          onChanged: _handleOtherGenderInputChange,
                        ),
                      ),
                    ),
                    const Divider(),
                    CustomTextField(
                      text: 'cpf_field'.i18n(),
                      controller: _cpfController,
                      initialValue: _formData['cpf']?.toString(),
                      keyboardType: TextInputType.number,
                      validator: _validateCpf,
                      onSaved: (cpf) => _formData['cpf'] = cpf ?? '',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        MaskTextInputFormatter(mask: '###.###.###-##'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _deleteUser,
                      icon: const Icon(Icons.delete),
                      label: Text('delete_account'.i18n()),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
    );
  }
}
