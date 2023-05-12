import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class ComboBox extends StatefulWidget {
  final List<String> listOption;
  final TextEditingController comboController;
  final String descrCampo;

  const ComboBox(
      {super.key,
      required this.listOption,
      required this.comboController,
      required this.descrCampo});

  @override
  State<ComboBox> createState() => _ComboBoxState();
}

class _ComboBoxState extends State<ComboBox> {
  String dropdownValue = '';

  late List<String> listOption;
  late TextEditingController comboController;
  late String descrCampo;

  @override
  void initState() {
    listOption = widget.listOption;
    comboController = widget.comboController;
    dropdownValue = listOption.first;
    descrCampo = widget.descrCampo;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Text(
                descrCampo,
                style: TextStyle(
                    fontSize: 15, color: Colors.black.withOpacity(0.7)),
              )
      ),
      Padding(
        padding: EdgeInsets.only(top: 10),
        child: DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_downward,
              textDirection: TextDirection.rtl),
          elevation: 16,
          style: const TextStyle(color: Colors.black54),
          underline: Container(
            height: 2,
            color: Colors.black54,
          ),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              comboController.value = TextEditingValue(text: value!);
              dropdownValue = value!;
            });
          },
          items: listOption.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    ]);
  }
}
