import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/custom_text_field.dart';
import '../../repository/product.dart';
import '../../repository/product_list.dart';
import '../../../../common/utils/location_util.dart';
import '../widget/image_input.dart';
import '../widget/location_input.dart';

class ProductsFormScreen extends StatefulWidget {
  const ProductsFormScreen({super.key});

  @override
  State<ProductsFormScreen> createState() => _ProductsFormScreenState();
}

class _ProductsFormScreenState extends State<ProductsFormScreen> {
  File? _pickedImage;

  final _nameFocus = FocusNode();
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  final bool _isLoading = false;
  bool _isImageUrl = false;

  @override
  void dispose() {
    _nameFocus.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['orders'] = product.orders;
        _formData['description'] = product.description;
        _formData['category'] = product.category;
        _formData['image'] = product.image;
        _formData['latitude'] = product.location.latitude;
        _formData['longitude'] = product.location.longitude;
        _formData['address'] = product.location.address!;

        if (product.image.toString().toLowerCase().startsWith('https://')) {
          _isImageUrl = true;
          _imageUrlController.text = product.image;
        } else {
          _isImageUrl = false;
          _pickedImage = File(product.image);
        }
      }
    }
  }

  void _selectImage(File pickedImage) {
    setState(() {
      _pickedImage = pickedImage;
      _formData['image'] = pickedImage;
    });
  }

  void _selectPosition(LatLng position) async {
    final address = await LocationUtil.getAddressFrom(position);
    setState(() {
      _formData['latitude'] = position.latitude;
      _formData['longitude'] = position.longitude;
      _formData['address'] = address;
    });
  }

  void _changeTypeImage() {
    setState(() {
      _isImageUrl = !_isImageUrl;
    });
  }

  void updateImage() {
    setState(() {});
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');
    return isValidUrl && endsWithFile;
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    if (_isImageUrl) {
      _formData['image'] = _imageUrlController.text;
    }

    _formKey.currentState?.save();

    Provider.of<ProductList>(
      context,
      listen: false,
    ).saveProduct(_formData, _isImageUrl);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário do Produto'),
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
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    CustomTextField(
                      labelText: 'Name',
                      controller: _nameController,
                      focusNode: _nameFocus,
                      initialValue: _formData['name']?.toString(),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocus);
                      },
                      onSaved: (name) => _formData['name'] = name ?? '',
                      validator: (userName) {
                        final name = userName ?? '';
                        if (name.trim().isEmpty) {
                          return 'Nome é obrigatório.';
                        }
                        if (name.trim().length < 3) {
                          return 'Nome precisa no mínimo de 3 letras.';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      labelText: 'Preço',
                      focusNode: _priceFocus,
                      controller: _priceController,
                      initialValue: _formData['price']?.toString(),
                      textInputAction: TextInputAction.next,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionFocus);
                      },
                      onSaved: (price) =>
                          _formData['price'] = double.parse(price ?? '0'),
                      validator: (userPrice) {
                        final priceString = userPrice ?? '';
                        final price = double.tryParse(priceString) ?? -1;

                        if (price <= 0) {
                          return 'Informe um preço válido.';
                        }

                        return null;
                      },
                    ),
                    CustomTextField(
                      labelText: 'Descrição',
                      focusNode: _descriptionFocus,
                      controller: _descriptionController,
                      initialValue: _formData['description']?.toString(),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      onSaved: (description) =>
                          _formData['description'] = description ?? '',
                      validator: (userDescription) {
                        final description = userDescription ?? '';

                        if (description.trim().isEmpty) {
                          return 'Descrição é obrigatória.';
                        }

                        if (description.trim().length < 10) {
                          return 'Descrição precisa no mínimo de 10 letras.';
                        }

                        return null;
                      },
                    ),
                    if (!_isImageUrl)
                      ImageInput(
                        _pickedImage,
                        _selectImage,
                      ),
                    if (_isImageUrl)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: CustomTextField(
                              labelText: 'Url da Imagem',
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
                              ),
                              alignment: Alignment.center,
                              child: _imageUrlController.text.isEmpty
                                  ? const Text('Informe a Url')
                                  : Image.network(_imageUrlController.text)),
                        ],
                      ),
                    const SizedBox(height: 10),
                    LocationInput(_selectPosition, _formData),
                  ],
                ),
              ),
            ),
    );
  }
}
