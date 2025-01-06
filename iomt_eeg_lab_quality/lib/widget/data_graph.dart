import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../themes/app_colors.dart';


class DataGraphs extends StatelessWidget {
  const DataGraphs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 160,
      margin: const EdgeInsets.only(left:32,right:0,top:16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.purple,AppColors.primary500,]),
        borderRadius: BorderRadius.circular(20)
      ),
      child:(
        Row(
          children:[
            
          ]
        )
      )
    );
  }
}