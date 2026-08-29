import 'package:cookie_repository/cookie_repository.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/components/naim_app_bar.dart';
import 'package:flutter_application_1/components/naim_footer.dart';
import 'package:flutter_application_1/screens/home/widgets/naim_drawer.dart';

class AdminCookieScreen extends StatefulWidget {
  const AdminCookieScreen({super.key});

  @override
  State<AdminCookieScreen> createState() => _AdminCookieScreenState();
}

class _AdminCookieScreenState extends State<AdminCookieScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredientsController = TextEditingController();

  final _priceController = TextEditingController();
  final _discountController = TextEditingController();

  final _caloriesController = TextEditingController();
  final _proteinsController = TextEditingController();
  final _fatController = TextEditingController();
  final _carbsController = TextEditingController();

  final _label1Controller = TextEditingController();
  final _label2Controller = TextEditingController();

  final _pictureController = TextEditingController();
  final _themeColorController =
      TextEditingController(text: '#000000');

  final _imageScaleController =
      TextEditingController(text: '1.0');

  bool _isSaving = false;

  final FirebaseCookieRepo _cookieRepo = FirebaseCookieRepo();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();

    _priceController.dispose();
    _discountController.dispose();

    _caloriesController.dispose();
    _proteinsController.dispose();
    _fatController.dispose();
    _carbsController.dispose();

    _label1Controller.dispose();
    _label2Controller.dispose();

    _pictureController.dispose();
    _themeColorController.dispose();
    _imageScaleController.dispose();

    super.dispose();
  }

  Future<void> _createCookie() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final cookie = Cookie(
        cookieId: '',
        picture: _pictureController.text.trim(),
        label1: _label1Controller.text.trim(),
        label2: _label2Controller.text.trim(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(
          _priceController.text.trim(),
        ),
        ingredients: _ingredientsController.text.trim(),
        discount: _discountController.text.trim().isEmpty
            ? 0
            : double.parse(
                _discountController.text.trim(),
              ),
        macros: Macros(
          calories: int.parse(
            _caloriesController.text.trim(),
          ),
          proteins: int.parse(
            _proteinsController.text.trim(),
          ),
          fat: int.parse(
            _fatController.text.trim(),
          ),
          carbs: int.parse(
            _carbsController.text.trim(),
          ),
        ),
        themeColor: _themeColorController.text.trim(),
        imageScale: double.parse(
          _imageScaleController.text.trim(),
        ),
      );

      await _cookieRepo.createCookie(cookie);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${cookie.name} has been added to Naim 🍪',
          ),
        ),
      );

      _clearForm();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not create cookie: $error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _ingredientsController.clear();

    _priceController.clear();
    _discountController.clear();

    _caloriesController.clear();
    _proteinsController.clear();
    _fatController.clear();
    _carbsController.clear();

    _label1Controller.clear();
    _label2Controller.clear();

    _pictureController.clear();

    _themeColorController.text = '#000000';
    _imageScaleController.text = '1.0';
  }

  String? _requiredText(
    String? value,
    String label,
  ) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $label';
    }

    return null;
  }

  String? _requiredDouble(
    String? value,
    String label,
  ) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $label';
    }

    if (double.tryParse(value.trim()) == null) {
      return 'Please enter a valid number';
    }

    return null;
  }

  String? _requiredInt(
    String? value,
    String label,
  ) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $label';
    }

    if (int.tryParse(value.trim()) == null) {
      return 'Please enter a whole number';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const NaimAppBar(),
      endDrawer: const NaimDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                24,
                20,
                40,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'COOKIE CREATOR',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Create a new cookie and publish it directly to Naim.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 32),

                    const _SectionTitle(
                      title: 'COOKIE',
                    ),

                    const SizedBox(height: 14),

                    _AdminField(
                      controller: _nameController,
                      label: 'NAME',
                      hint: 'Pistachio Rose',
                      validator: (value) =>
                          _requiredText(
                        value,
                        'a cookie name',
                      ),
                    ),

                    const SizedBox(height: 14),

                    _AdminField(
                      controller: _descriptionController,
                      label: 'DESCRIPTION',
                      hint:
                          'Describe the flavour, texture and experience...',
                      maxLines: 4,
                      validator: (value) =>
                          _requiredText(
                        value,
                        'a description',
                      ),
                    ),

                    const SizedBox(height: 14),

                    _AdminField(
                      controller: _ingredientsController,
                      label: 'INGREDIENTS',
                      hint:
                          'Almond flour, pistachio, vanilla...',
                      maxLines: 4,
                      validator: (value) =>
                          _requiredText(
                        value,
                        'ingredients',
                      ),
                    ),

                    const SizedBox(height: 30),

                    const _SectionTitle(
                      title: 'PRICING',
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: _AdminField(
                            controller: _priceController,
                            label: 'PRICE',
                            hint: '3.99',
                            keyboardType:
                                const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (value) =>
                                _requiredDouble(
                              value,
                              'a price',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _AdminField(
                            controller:
                                _discountController,
                            label: 'DISCOUNT PRICE',
                            hint: '2.99',
                            keyboardType:
                                const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    const _SectionTitle(
                      title: 'MACROS',
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: _AdminField(
                            controller:
                                _caloriesController,
                            label: 'CALORIES',
                            hint: '240',
                            keyboardType:
                                TextInputType.number,
                            validator: (value) =>
                                _requiredInt(
                              value,
                              'calories',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _AdminField(
                            controller:
                                _proteinsController,
                            label: 'PROTEIN',
                            hint: '8',
                            keyboardType:
                                TextInputType.number,
                            validator: (value) =>
                                _requiredInt(
                              value,
                              'protein',
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: _AdminField(
                            controller:
                                _fatController,
                            label: 'FAT',
                            hint: '18',
                            keyboardType:
                                TextInputType.number,
                            validator: (value) =>
                                _requiredInt(
                              value,
                              'fat',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _AdminField(
                            controller:
                                _carbsController,
                            label: 'CARBS',
                            hint: '14',
                            keyboardType:
                                TextInputType.number,
                            validator: (value) =>
                                _requiredInt(
                              value,
                              'carbs',
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    const _SectionTitle(
                      title: 'LABELS',
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: _AdminField(
                            controller:
                                _label1Controller,
                            label: 'LABEL 1',
                            hint: 'VEGAN',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _AdminField(
                            controller:
                                _label2Controller,
                            label: 'LABEL 2',
                            hint: 'HIGH PROTEIN',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    const _SectionTitle(
                      title: 'APPEARANCE',
                    ),

                    const SizedBox(height: 14),

                    _AdminField(
                      controller: _pictureController,
                      label: 'PICTURE URL',
                      hint:
                          'https://raw.githubusercontent.com/...',
                      validator: (value) =>
                          _requiredText(
                        value,
                        'a picture URL',
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: _AdminField(
                            controller:
                                _themeColorController,
                            label: 'THEME COLOR',
                            hint: '#000000',
                            validator: (value) =>
                                _requiredText(
                              value,
                              'a theme color',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _AdminField(
                            controller:
                                _imageScaleController,
                            label: 'IMAGE SCALE',
                            hint: '1.0',
                            keyboardType:
                                const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (value) =>
                                _requiredDouble(
                              value,
                              'an image scale',
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 34),

                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed:
                            _isSaving ? null : _createCookie,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              Colors.black54,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(18),
                          ),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'ADD COOKIE',
                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const NaimFooter(),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _AdminField extends StatelessWidget {
  const _AdminField({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;

  final TextInputType? keyboardType;
  final int maxLines;

  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            color: Colors.grey.shade600,
          ),
        ),

        const SizedBox(height: 7),

        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 17,
            ),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: Color(0xFF2D160E),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}