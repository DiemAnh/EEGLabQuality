import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class DeviceButton extends StatelessWidget {
  const DeviceButton({super.key, required this.onPressed, required this.icon, required this.color});
  final IconData icon;
  final Function onPressed;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){
        onPressed();
        }, 
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.all(16),
        minimumSize: const Size(40, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25)
        )
      ),
      child: Icon(icon,color: Colors.black)
      );
  }
}