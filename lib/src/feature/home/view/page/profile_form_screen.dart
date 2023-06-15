import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../auth/repository/user_model.dart';
import '../../../auth/repository/user_provider.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../widget/image_input.dart';

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({Key? key}) : super(key: key);

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

  static const List<String> _genderOptions = [
    'Masculino',
    'Feminino',
    'Não-binário',
    'Outro',
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

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');
    return isValidUrl && endsWithFile;
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
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final user = arg as User;
        _formData['image'] = user.image ?? '';
        _formData['name'] = user.name ?? '';
        _formData['socialName'] = user.socialName ?? '';
        _formData['email'] = user.email ?? '';
        _formData['age'] = user.age ?? 0;
        _formData['bio'] = user.bio ?? '';
        _formData['cpf'] = user.cpf ?? '';
        _formData['gender'] = user.gender ?? '';
        _formData['phoneNumber'] = user.phoneNumber ?? '';

        if (user.image.toString().toLowerCase().startsWith('https://')) {
          _isImageUrl = true;
          _imageUrlController.text = user.image!;
        } else {
          _isImageUrl = false;
          _pickedImage = user.image != '' ? File(user.image!) : null;
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
    }

    _formKey.currentState?.save();

    setState(() => _isLoading = true);
    try {
      User user = User();
      await Provider.of<UserProvider>(
        context,
        listen: false,
      ).saveUserInfo(user);
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro!'),
          content: const Text('Ocorreu um erro para salvar o produto.'),
          actions: [
            TextButton(
              child: const Text('Ok'),
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

  String? _validateAge(String? value) {
    if (value != null && value != '0') {
      final age = int.tryParse(value);
      if (age == null || age < 0 || age > 120) {
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
            onPressed: _changeTypeImage,
            icon: _isImageUrl
                ? const Icon(Icons.camera_alt)
                : const Icon(Icons.link),
          ),
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.outline,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
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
                              text: 'Url da Imagem',
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
                                  return 'Informe uma Url válida!';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                              height: 100,
                              width: 100,
                              margin: const EdgeInsets.only(
                                top: 10,
                                left: 10,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.outline,
                                  width: 1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: ClipOval(
                                child: _imageUrlController.text.isEmpty
                                    ? const Center(
                                        child: Text(
                                          'Informe a Url',
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : Image.network(_imageUrlController.text),
                              )),
                        ],
                      ),
                    const Divider(),
                    CustomTextField(
                      text: 'Name',
                      controller: _nameController,
                      initialValue: _formData['name']?.toString(),
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
                      onSaved: (name) => _formData['name'] = name ?? '',
                    ),
                    const Divider(),
                    CustomTextField(
                      text: 'Social Name',
                      controller: _socialNameController,
                      initialValue: _formData['socialName']?.toString(),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (value.trim().length < 3) {
                            return 'Social name precisa ter no mínimo 10 letras.';
                          }
                        }
                        return null;
                      },
                      onSaved: (name) => _formData['socialName'] = name ?? '',
                    ),
                    const Divider(),
                    CustomTextField(
                      text: 'E-mail',
                      controller: _emailController,
                      initialValue: _formData['email']?.toString(),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'O e-mail é obrigatório';
                        }
                        return null;
                      },
                      onSaved: (email) => _formData['email'] = email ?? '',
                    ),
                    const Divider(),
                    CustomTextField(
                      text: 'Number',
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
                      text: 'Age',
                      controller: _ageController,
                      initialValue: _formData['age']?.toString(),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: _validateAge,
                      onSaved: (age) =>
                          _formData['age'] = double.parse(age ?? '0'),
                    ),
                    const Divider(),
                    CustomTextField(
                      text: 'Bio',
                      controller: _bioController,
                      initialValue: _formData['bio']?.toString(),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      validator: _validateBio,
                      onSaved: (bio) => _formData['bio'] = bio ?? '',
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
                        ),
                      ),
                    ),
                    const Divider(),
                    CustomTextField(
                      text: 'CPF',
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
                  ],
                ),
              ),
            ),
    );
  }
}
