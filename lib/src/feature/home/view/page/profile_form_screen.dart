import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../auth/repository/user_model.dart';
import '../../../auth/repository/user_provider.dart';
import '../../../../common/components/custom_text_field.dart';
import '../widget/image_input.dart';

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({Key? key}) : super(key: key);

  @override
  ProfileFormScreenState createState() => ProfileFormScreenState();
}

class ProfileFormScreenState extends State<ProfileFormScreen> {
  File? _pickedImage;

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneNumberFocus = FocusNode();
  final _ageFocus = FocusNode();
  final _bioFocus = FocusNode();
  final _cpfFocus = FocusNode();
  final _otherGenderFocus = FocusNode();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _ageController = TextEditingController();
  final _bioController = TextEditingController();
  final _cpfController = TextEditingController();
  final _otherGenderController = TextEditingController();

  String _selectedGender = '';
  bool _showOtherGenderInput = false;

  late UserProvider userProvider;
  late User? user;

  static const List<String> _genderOptions = [
    'Masculino',
    'Feminino',
    'Não-binário',
    'Outro',
  ];
  @override
  void initState() {
    super.initState();

    _loadUser();
  }

  @override
  void dispose() {
    super.dispose();

    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneNumberFocus.dispose();
    _ageFocus.dispose();
    _bioFocus.dispose();
    _cpfFocus.dispose();
    _otherGenderFocus.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    _cpfController.dispose();
    _otherGenderController.dispose();
  }

  void _loadUser() {
    userProvider = Provider.of<UserProvider>(context);
    user = userProvider.user;

    if (user?.gender != '') {
      if (_genderOptions.contains(user?.gender)) {
        _selectedGender = user!.gender!;
      } else {
        _selectedGender = 'Outro';
        _otherGenderController.text = user!.gender!;
      }
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
        if (value == 'Outro') {
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
      _selectedGender = 'Outro';
      _showOtherGenderInput = true;
    });
  }

  void _selectImage(File pickedImage) {
    setState(() {
      _pickedImage = pickedImage;
      _formData['image'] = pickedImage;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      user!.name = _nameController.text;
      user!.email = _emailController.text;
      user!.phoneNumber = _phoneNumberController.text;
      user!.age = _ageController.text as int?;
      user!.bio = _bioController.text;
      user!.cpf = _cpfController.text;

      if (_selectedGender == 'Outro') {
        user!.gender = _otherGenderController.text;
      } else {
        user!.gender = _selectedGender;
      }
      await userProvider.saveUserInfo(user!);
    }
  }

  String? _validateAge(String? value) {
    if (value != null && value.isNotEmpty) {
      final age = int.tryParse(value);
      if (age == null || age <= 0 || age > 120) {
        return 'Por favor, insira uma idade válida.';
      }
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value != null && value.isNotEmpty) {
      final phoneNumberRegex = RegExp(r'^\(\d{2}\)\d{4,5}-\d{4}$');
      if (!phoneNumberRegex.hasMatch(value)) {
        return 'Por favor, insira um número de telefone válido (formato: (XX)XXXXX-XXXX).';
      }
    }
    return null;
  }

  String? _validateBio(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.trim().length < 10) {
        return 'Bio precisa ter no mínimo 10 letras.';
      }
    }
    return null;
  }

  String? _validateCpf(String? value) {
    if (value != null && value.isNotEmpty) {
      final cpfRegex = RegExp(r'^\d{3}\.\d{3}\.\d{3}-\d{2}$');
      if (!cpfRegex.hasMatch(value)) {
        return 'Por favor, insira um CPF válido (formato: XXX.XXX.XXX-XX).';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Form'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ImageInput(
                _pickedImage,
                _selectImage,
              ),
              const Divider(),
              CustomTextField(
                labelText: 'Name',
                focusNode: _nameFocus,
                controller: _nameController,
                initialValue: user?.name,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Nome é obrigatório.';
                  }
                  if (value.trim().length < 3) {
                    return 'Nome precisa ter no mínimo 3 letras.';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_emailFocus);
                },
              ),
              CustomTextField(
                labelText: 'E-mail',
                focusNode: _emailFocus,
                controller: _emailController,
                initialValue: user?.email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O e-mail é obrigatório';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_phoneNumberFocus);
                },
              ),
              const Divider(),
              CustomTextField(
                labelText: 'Number',
                focusNode: _phoneNumberFocus,
                controller: _phoneNumberController,
                initialValue: user?.phoneNumber ?? '',
                keyboardType: TextInputType.phone,
                validator: _validatePhoneNumber,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  MaskTextInputFormatter(mask: '(##) #####-####'),
                ],
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_ageFocus);
                },
              ),
              const Divider(),
              CustomTextField(
                labelText: 'Age',
                focusNode: _ageFocus,
                controller: _ageController,
                initialValue: user?.age.toString() ?? '',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: _validateAge,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_bioFocus);
                },
              ),
              const Divider(),
              CustomTextField(
                labelText: 'Bio',
                focusNode: _bioFocus,
                controller: _bioController,
                initialValue: user?.bio ?? '',
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.next,
                validator: _validateBio,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_cpfFocus);
                },
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Gender',
                  style: TextStyle(fontSize: 14),
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
                    focusNode: _otherGenderFocus,
                    controller: _otherGenderController,
                    enabled: _showOtherGenderInput,
                    decoration: InputDecoration(
                      labelText: 'Digite seu gênero',
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
              CustomTextField(
                labelText: 'CPF',
                focusNode: _cpfFocus,
                controller: _cpfController,
                keyboardType: TextInputType.number,
                validator: _validateCpf,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  MaskTextInputFormatter(mask: '###.###.###-##'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
