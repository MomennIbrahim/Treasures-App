import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/widgets/app_text_form_field.dart';
import 'package:konoz/features/edit_profile/data/model/address_model.dart';

class PersonalInformationForm extends StatefulWidget {
  const PersonalInformationForm({super.key});

  @override
  State<PersonalInformationForm> createState() =>
      _PersonalInformationFormState();
}

class _PersonalInformationFormState extends State<PersonalInformationForm> {
  AddressModel? _selectedAddress;

  Future<void> _openAddressPicker() async {
    // context.push بيرجع Future<T?> بالظبط زي Navigator.push، والقيمة
    // بترجع من خلال context.pop(result) جوه AddressPickerScreen.
    final result = await context.push<AddressModel>(
      Routes.addressPicker,
      extra: _selectedAddress,
    );

    if (result != null) {
      setState(() => _selectedAddress = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextFormField(label: "Name", hint: "Momen Ibrahim"),
        16.verticalSpace,
        AppTextFormField(
          label: "Phone Number",
          hint: "01x xxxxxxxx",
          validator: (String? value) {
            return null;
          },
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          inputFormatters: [LengthLimitingTextInputFormatter(10)],
        ),
        16.verticalSpace,
        AppTextFormField(label: "Email", hint: "7M4wZ@example.com"),
        //16.verticalSpace,
        // AddressFieldTile(address: _selectedAddress, onTap: _openAddressPicker),
      ],
    );
  }
}
