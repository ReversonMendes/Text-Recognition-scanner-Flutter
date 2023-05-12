import 'dart:io';

import 'package:capture_prime/features/widgets/combo_field.dart';
import 'package:capture_prime/features/widgets/date_field.dart';
import 'package:capture_prime/features/widgets/text_field.dart';
import 'package:capture_prime/features/widgets/upload_button.dart';
import 'package:capture_prime/model/upload_response.dart';
import 'package:capture_prime/services/upload_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../model/fields.dart';
import '../../model/template.dart';
import '../../model/template_fields.dart';
import '../../services/documentos_service.dart';
import '../../styles/colors.dart';

class UploadScreen extends StatefulWidget {
  final Template documento;
  final File imagem;

  const UploadScreen(
      {super.key, required this.documento, required this.imagem});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final UploadService _uploadService = UploadService();
  final TemplatesService templatesService = TemplatesService();

  late Template documento = widget.documento;
  late File imagem = widget.imagem;
  //late TextRecognizer textRecognizer;

  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController accountController;
  late TextEditingController dateController;
  final List<TextEditingController> _controllers = [];
  final List<dynamic> _fields = [];

  final double _elementsOpacity = 1;

  @override
  void initState() {
    //textRecognizer = TextRecognizer();
    passwordController = TextEditingController();
    accountController = TextEditingController();
    emailController = TextEditingController();
    dateController = TextEditingController();

    _requestFieldsTemplate();
    super.initState();
  }

  @override
  void dispose() {
    imagem.delete();
    //textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Upload de Arquivo'),
        ),
        body: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(children: [
            Text(
              documento.nome_tipo,
              style:
                  TextStyle(fontSize: 30, color: Colors.black.withOpacity(0.7)),
            ),
            const SizedBox(height: 50),
            Expanded(child: _listView()),
            UploadButton(
              elementsOpacity: _elementsOpacity,
              onTap: () {
                setState(() {
                  print("UPLOAD");
                  _upload(context);
                });
              },
              onAnimatinoEnd: () async {
                await Future.delayed(Duration(milliseconds: 500));
                setState(() {
                  // loadingBallAppear = true;
                });
              },
            ),
          ]),
        ),
      );

  Widget _listView() {
    return ListView.builder(
      itemCount: _fields.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(5),
          child: _fields[index],
        );
      },
    );
  }

  Future<void> _createFields(List<Fields> listaCampos) async {
    // final inputImage = InputImage.fromFile(imagem);
    // final RecognizedText recognizedText =
    //     await textRecognizer.processImage(inputImage);

    // passwordController = TextEditingController();
    // accountController = TextEditingController(text: recognizedText.text);
    // emailController = TextEditingController();
    var field;
    //listaCampos.sort((a, b) => b.id_combo.compareTo(a.id_combo));


    for (var i = 0; i < listaCampos.length; i++) {
      final controller = TextEditingController();

      if (listaCampos[i].itenscombo.isNotEmpty) {
        //   List<String> option =
        //       listaCampos[i].itenscombo.map((i) => i.valoritem).toList();
        //   field = ComboBox(
        //     listOption: option,
        //     comboController: controller,
        //     descrCampo: listaCampos[i].desccampo,
        //   );

        late Map<String, Widget> itens = {};
        listaCampos[i]
            .itenscombo
            .forEach((item) => itens[item.valoritem] = Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(item.valoritem),
                ));

        field = Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Column(
            children: <Widget>[
              Text(listaCampos[i].desccampo),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: CupertinoSegmentedControl<String>(
                  unselectedColor: Colors.grey.shade50,
                  selectedColor: Colors.blue,
                  children: itens,
                  onValueChanged: (value) {
                    setState(() {
                      controller.value = TextEditingValue(text: value!);
                    });
                  },
                ),
              ),
            ],
          ),
        );
      } else {
        switch (listaCampos[i].tipocampo) {
          case 'VARCHAR':
            {
              field = CustomTextField(
                fade: _elementsOpacity == 0,
                textController: controller,
                title: listaCampos[i].desccampo,
                mask: listaCampos[i].masccampo,
                tamanho: int.parse(listaCampos[i].tamcampo),
              );
            }
            break;
          case 'DATE':
            {
              field = DateField(
                fadeDate: _elementsOpacity == 0,
                dateController: controller,
                title: listaCampos[i].desccampo,
              );
              //controller.value = TextEditingValue(text: _scanDate(recognizedText));
            }
            break;
          // case camposTipo.ANO:
          //   {
          //     field = DateField(
          //       fadeDate: _elementsOpacity == 0,
          //       dateController: controller,
          //       title: doc.campos[i].title,
          //     );
          //   }
          //   break;
          // case camposTipo.CPFCNPJ:
          //   {
          //     field = CpfCnpjField(
          //       fadeDate: _elementsOpacity == 0,
          //       cpfCnpjController: controller,
          //       title: doc.campos[i].title,
          //     );
          //     //controller.value = TextEditingValue(text: _scanCPFOrCNPJNumber(recognizedText));
          //   }
          //   break;
          // case camposTipo.COMBO:
          //   {
          //     field = DropdownButtonExample();
          //   }
          //   break;
        }
      }

      setState(() {
        _controllers.add(controller);
        _fields.add(field);
      });
    }

    //
    // setState(() {
    //   accountController.value = TextEditingValue(text: recognizedText.text);
    // });
  }

  Future<void> _upload(BuildContext context) async {
    try {
      //List<String> file = [imagem.path];
      List<String> params = [];

      for (final i in _controllers) {
        params.add(i.value.text);
      }

      UploadResponse? uploadResponse = await _uploadService.uploadArchive(
          documento.id_tipo, imagem.path, params);

      if (uploadResponse != null) {
        var text = uploadResponse.error
            ? 'Houve um erro ao enviar o arquivo!'
            : 'Upload realizado com sucesso!';

        final alert = AlertDialog(
          title: Text("Capture Prime"),
          icon: const Icon(Icons.cloud_done, color: blueColor),
          content: Text(text,
              style: TextStyle(
                  fontSize: 15, color: Colors.black.withOpacity(0.7))),
          actions: [
            TextButton(
              onPressed: () {
                var nav = Navigator.of(context);
                nav.pop();
                nav.pop();
              },
              child: Text("OK"),
            ),
          ],
        );
        // ignore: use_build_context_synchronously
        await showDialog(
          context: context,
          builder: (BuildContext context) => alert,
        );
      }

      setState(() {});
    } catch (e) {
      print('falha upload;');
    }
  }

  Future<void> _requestFieldsTemplate() async {
    TemplateFields? templateFields =
        await templatesService.getFields(documento.id_tipo);
    if (templateFields != null) {
      //campos = templateFields.fields;
      _createFields(templateFields.fields);
    }
  }

  // String _scanCPFOrCNPJNumber(RecognizedText recognizedText) {
  //   for (final i in recognizedText.blocks) {
  //     for (final line in i.lines) {
  //       for (final element in line.elements) {
  //         String text = element.text;
  //
  //         /// Checking whether the gotten text is a phone number or not.
  //         if (UtilBrasilFields.isCPFValido(text)) {
  //           debugPrint('Yes, this is a phone number');
  //
  //           /// Converting text into phone number
  //           //String phoneNumber = _extractPhoneNumber(text);
  //           String phoneNumber = text;
  //           return phoneNumber;
  //         }
  //       }
  //     }
  //   }
  //   return '';
  // }

  // String _scanDate(RecognizedText recognizedText) {
  //   for (final i in recognizedText.blocks) {
  //     for (final line in i.lines) {
  //       for (final element in line.elements) {
  //         String text = element.text;
  //
  //         /// Checking whether the gotten text is a phone number or not.
  //         if (_isDate(text)) {
  //           debugPrint('Yes, this is a phone number');
  //
  //           /// Converting text into phone number
  //           //String phoneNumber = _extractPhoneNumber(text);
  //           String phoneNumber = text;
  //           return phoneNumber;
  //         }
  //       }
  //     }
  //   }
  //   return '';
  // }

  // bool _isDate(value) {
  //   final components = value.split("/");
  //   if (components.length == 3) {
  //     final day = int.tryParse(components[0]);
  //     final month = int.tryParse(components[1]);
  //     final year = int.tryParse(components[2]);
  //     if (day != null && month != null && year != null) {
  //       final date = DateTime(year, month, day);
  //       if (date.year == year && date.month == month && date.day == day) {
  //         return true;
  //       } else {
  //         return false;
  //       }
  //     }
  //   }
  //   return false;
  // }
}
