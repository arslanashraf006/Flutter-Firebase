import 'package:flutter/material.dart';

import '../utils/app_color.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  bool loading;
   RoundButton({Key? key,
    required this.title,
  required this.onTap,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.appDefaultColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: loading
              ? const CircularProgressIndicator(
            strokeWidth: 3,
            color: AppColors.whiteColor,
          )
              : Text(title,
          style: const TextStyle(
            color: AppColors.whiteColor,
          ),
          ),
        ),
      ),
    );
  }
}
