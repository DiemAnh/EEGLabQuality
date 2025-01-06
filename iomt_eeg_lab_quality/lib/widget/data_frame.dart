import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../themes/text_styles.dart';

class DataFrame extends StatelessWidget {
  const DataFrame({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.date,
  });
  
  final IconData icon;
  final String title;
  final String subTitle;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 120,
      margin: const EdgeInsets.only(left: 32, right: 0, top: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(156, 237, 254, 1),
            Color.fromRGBO(221, 197, 253, 1)
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 50),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subTitle,
                style: TextStyles.t20M.copyWith(fontWeight: FontWeight.normal),
              ),
              Text(
                title,
                style: TextStyles.t32M.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                date,
                style: TextStyles.t16R.copyWith(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
