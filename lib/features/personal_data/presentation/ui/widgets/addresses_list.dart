import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/features/personal_data/presentation/ui/widgets/addres_item_widget.dart';

class AddressesList extends StatelessWidget {
  const AddressesList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => AddresItemWidget(),
      separatorBuilder: (context, index) => 5.verticalSpace,
      itemCount: 2,
    );
  }
}
