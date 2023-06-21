import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/custom_text_field.dart';
import '../../repository/categories_data.dart';
import '../../repository/product.dart';
import '../../repository/product_list.dart';
import '../../../../common/utils/location_util.dart';
import '../widget/image_input.dart';
import '../widget/location_input.dart';
import 'category_selector_screen.dart';

class ProductsFormScreen extends StatefulWidget {
  final Product? product;
  const ProductsFormScreen({super.key, this.product});

  @override
  State<ProductsFormScreen> createState() => _ProductsFormScreenState();
}

class _ProductsFormScreenState extends State<ProductsFormScreen> {
  File? _pickedImage;

  final _imageUrlFocus = FocusNode();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _categoryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  bool _isLoading = false;
  bool _isImageUrl = false;

  @override
  void dispose() {
    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();

    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
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
      if (widget.product != null) {
        _formData['id'] = widget.product!.id;
        _formData['name'] = widget.product!.name;
        _formData['price'] = widget.product!.price;
        _formData['orders'] = widget.product!.orders;
        _formData['description'] = widget.product!.description;
        _formData['categories'] = widget.product!.categories;
        _formData['image'] = widget.product!.image;
        _formData['latitude'] = widget.product!.location.latitude;
        _formData['longitude'] = widget.product!.location.longitude;
        _formData['address'] = widget.product!.location.address!;

        if (_formData.isNotEmpty && _categoryController.text.isEmpty) {
          List<String>? categories = _formData['categories'] as List<String>?;
          _categoryController.text = categories!.join(',');
        }

        if (widget.product!.image
            .toString()
            .toLowerCase()
            .startsWith('https://')) {
          _isImageUrl = true;
          _imageUrlController.text = widget.product!.image;
        } else {
          _isImageUrl = false;
          _pickedImage = File(widget.product!.image);
        }
      }
    }
  }

  void _selectCategory() async {
    final selectedCategoriesNames =
        (_formData['categories'] as List<String>?)?.toList();

    final updatedCategories = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CategorySelectionScreen(
          selectedCategoriesNames: selectedCategoriesNames ?? [],
        ),
      ),
    );

    if (updatedCategories != null) {
      List<Category> selectedCategories = categoryList
          .where((category) => updatedCategories.contains(category.name))
          .toList();

      setState(() {
        _formData['categories'] =
            selectedCategories.map((category) => category.name).toList();
        _categoryController.text =
            _formatSelectedCategories(selectedCategories);

        if (selectedCategories.isEmpty) {
          _categoryController.text = '';
        }
      });
    }
  }

  String _formatSelectedCategories(List<Category> categories) {
    return categories.map((category) => category.name).join(',');
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

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid ||
        _formData['image'] == null ||
        _formData['address'] == null ||
        _formData['categories'] == null) {
      return;
    }

    if (_isImageUrl) {
      _formData['image'] = _imageUrlController.text;
    }

    _formKey.currentState?.save();

    setState(() => _isLoading = true);
    try {
      await Provider.of<ProductList>(
        context,
        listen: false,
      ).saveProduct(_formData, _isImageUrl);
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro!'),
          content: const Text('Ocorreu um erro para salvar o produto'),
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
                    const SizedBox(height: 20),
                    CustomTextField(
                      text: 'Name',
                      controller: _nameController,
                      initialValue: _formData['name']?.toString(),
                      textInputAction: TextInputAction.next,
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
                    const Divider(),
                    CustomTextField(
                      text: 'Preço',
                      controller: _priceController,
                      initialValue: _formData['price']?.toString(),
                      textInputAction: TextInputAction.next,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
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
                    const Divider(),
                    CustomTextField(
                      text: 'Descrição',
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
                    const Divider(),
                    TextField(
                      controller: _categoryController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Selected Categories',
                        hintText: 'Press the buttom below',
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
                          vertical: 16.0,
                          horizontal: 12.0,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _formData['categories'] = [];
                              _categoryController.clear();
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _selectCategory,
                      child: const Text('Select Category'),
                    ),
                    const Divider(),
                    if (!_isImageUrl)
                      ImageInput(
                        _selectImage,
                        _pickedImage,
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
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: _imageUrlController.text.isEmpty
                                    ? const Text('Informe a Url')
                                    : Image.network(_imageUrlController.text),
                              )),
                        ],
                      ),
                    const Divider(),
                    const SizedBox(height: 10),
                    LocationInput(_selectPosition, _formData),
                  ],
                ),
              ),
            ),
    );
  }
}
