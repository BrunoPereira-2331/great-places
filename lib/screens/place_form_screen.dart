import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:great_places/widgets/location_input.dart';
import 'package:provider/provider.dart';

import '../widgets/image_input.dart';

class PlaceFormScreen extends StatefulWidget {
  const PlaceFormScreen({Key? key}) : super(key: key);

  @override
  State<PlaceFormScreen> createState() => _PlaceFormScreenState();
}

class _PlaceFormScreenState extends State<PlaceFormScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  LatLng? _pickedPosition;
  final _formKey = GlobalKey<FormState>();

  void _submitForm() {
    if (!_isvalidForm()) {
      return;
    }

    Provider.of<GreatPlaces>(context, listen: false).addPlace(
      _titleController.text,
      _selectedImage!,
      _pickedPosition!,
    );
    Navigator.of(context).pop();
  }

  void _selectImage(File selectedImage) {
    setState(() {
      _selectedImage = selectedImage;
    });
  }

  void _selectPosition(LatLng pickedPosition) {
    setState(() {
      _pickedPosition = pickedPosition;
    });
  }

  bool _isvalidForm() {
    return _formKey.currentState!.validate() && _titleController.text.isNotEmpty && _pickedPosition != null && _selectedImage != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("New Place"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      onEditingComplete: () =>
                          _isvalidForm() ? _submitForm() : null,
                      validator: (text) {
                        return text == null || text.isEmpty
                          ? "Required field"
                          : null;
                      },
                      decoration: const InputDecoration(
                        labelText: "Title",
                      ),
                    ),
                    const SizedBox(height: 10),
                    ImageInput(
                      onSelectImage: _selectImage,
                    ),
                    const SizedBox(height: 10),
                    LocationInput(
                      onSelectPosition: _selectPosition,
                    ),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Add"),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black),
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.secondary),
                elevation: MaterialStateProperty.all(0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            onPressed: () => _isvalidForm() ? _submitForm() : () {},
          )
        ],
      ),
    );
  }
}
