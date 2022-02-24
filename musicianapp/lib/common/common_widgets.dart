import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {

  String label;
  CommonTextField({Key? key, required this.label,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField (
      decoration: InputDecoration(
          labelText: label,
      ),
    );
  }
}

class CommonButton extends StatelessWidget {

  String label;
  Function function;

  CommonButton({Key? key, required this.label, required this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){
        function;
      },
      child: Text(label),
    );
  }
}
