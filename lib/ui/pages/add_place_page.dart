import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/location_input_widget.dart';
import '../view_models/place_view_model.dart';
import '../../utils/utilities/navigation_utils.dart';
import '../../data/models/entities/place.dart';
import '../../utils/utilities/app_utils.dart';
import '../widgets/take_picture_widget.dart';
import '../resources/app_strings.dart';

class AddPlacePage extends StatefulWidget {
  @override
  _AddPlacePageState createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  final _form = GlobalKey<FormState>();
  final _place = Place();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.title_add_place),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildContent(),
        _buildButton(),
      ],
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            children: [
              _buildTitleField(),
              SizedBox(height: 16),
              TakePictureWidget(_onPictureTaken),
              SizedBox(height: 16),
              LocationInputWidget(_onLocationPicked),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: AppStrings.input_field_title,
      ),
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value?.isEmpty ?? false) {
          // Returning a value means there's an error
          return AppStrings.validation_required;
        }
        // Returning null means input is correct
        return null;
      },
      onSaved: (value) {
        _place.title = value?.trim() ?? '';
      },
    );
  }

  Widget _buildButton() {
    return Container(
      height: 48,
      child: RaisedButton.icon(
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        icon: const Icon(
          Icons.done,
          color: Colors.white,
        ),
        label: Text(AppStrings.submit.toUpperCase()),
        elevation: 0,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () => _submit(),
      ),
    );
  }

  void _onPictureTaken(File? file) {
    _place.image = file;
  }

  void _onLocationPicked(PlaceLocation placeLocation) {
    _place.location = placeLocation;
  }

  Future<void> _submit() async {
    // Execute validator for form fields
    bool isValid = _form.currentState?.validate() ?? false;
    if (isValid) {
      // Execute onSaved for form fields
      _form.currentState?.save();

      // Hide keyboard
      AppUtils.removeCurrentFocus(context);

      final viewModel = Provider.of<PlaceViewModel>(context, listen: false);
      final added = await viewModel.addPlace(_place);
      if (added) {
        NavigationUtils.pop(context);
      }
    }
  }
}
