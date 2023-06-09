import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../auth/repository/user_provider.dart';
import '../widget/custom_text_field.dart';
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

  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();

  static const List<String> _genderOptions = [
    'Masculino',
    'Feminino',
    'Não-binário',
    'Outro',
  ];
  String _selectedGender = '';
  bool _showOtherGenderInput = false;
  final TextEditingController _otherGenderController = TextEditingController();

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

  @override
  void dispose() {
    _formData.clear();
    _phoneNumberController.dispose();
    _cpfController.dispose();
    super.dispose();
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
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.user;
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

  String? _validatePhoneNumber(String? value) {
    if (value != null && value.isNotEmpty) {
      final phoneNumberRegex = RegExp(r'^\(\d{2}\)\d{4,5}-\d{4}$');
      if (!phoneNumberRegex.hasMatch(value)) {
        return 'Por favor, insira um número de telefone válido (formato: (XX)XXXXX-XXXX).';
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
                labelText: 'Age',
                controller: _ageController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: _validateAge,
                onSaved: (value) {
                  _formData['age'] = value!;
                },
              ),
              const Divider(),
              CustomTextField(
                labelText: 'Bio',
                controller: _bioController,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                textInputAction: TextInputAction.next,
                validator: _validateBio,
                onSaved: (value) {
                  _formData['bio'] = value!;
                },
              ),
              const Divider(),
              CustomTextField(
                labelText: 'CPF',
                controller: _cpfController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: _validateCpf,
                onSaved: (value) {
                  _formData['cpf'] = value!;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  MaskTextInputFormatter(mask: '###.###.###-##'),
                ],
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
                    )),
              ),
              const Divider(),
              CustomTextField(
                labelText: 'Name',
                controller: _nameController,
                keyboardType: TextInputType.number,
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
                onSaved: (value) {
                  _formData['name'] = value!;
                },
              ),
              const Divider(),
              CustomTextField(
                labelText: 'E-mail',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O e-mail é obrigatório';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData['email'] = value!;
                },
              ),
              const Divider(),
              CustomTextField(
                labelText: 'Number',
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                validator: _validatePhoneNumber,
                onSaved: (value) {
                  _formData['phoneNumber'] = value!;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  MaskTextInputFormatter(mask: '(##) #####-####'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
