import 'package:book_store/constant.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class NewLoadingIndicator extends StatelessWidget {
  const NewLoadingIndicator({super.key});


  @override
  Widget build(BuildContext context) {
    return const LoadingIndicator(
      indicatorType: Indicator.ballClipRotateMultiple,
      pathBackgroundColor: mainGreenColor,
      strokeWidth: 4,
    );
  }
}