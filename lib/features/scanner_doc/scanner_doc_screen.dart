import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:capture_prime/features/login/login_screen.dart';
import 'package:capture_prime/model/template.dart';
import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/icons.dart';
import '../../model/login.dart';
import '../../model/tipos_documentos_user.dart';
import '../../services/documentos_service.dart';
import '../../styles/colors.dart';
import '../upload/upload_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  bool _isPermissionGranted = false;

  late final Future<void> _future;
  CameraController? _cameraController;

  final TemplatesService templatesService = TemplatesService();

  final Random r = Random();

  String nomeUsuario = '';

  late List<Template> templates = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.threeBounce;
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.light;
    EasyLoading.instance.indicatorColor = Colors.lightBlueAccent;
    _future = _requestCameraPermission();
    _requestUser();
    _requestTemplatesUser();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    //textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return Stack(
          children: [
            if (_isPermissionGranted)
              FutureBuilder<List<CameraDescription>>(
                future: availableCameras(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _initCameraController(snapshot.data!);

                    return Center();
                  } else {
                    return const LinearProgressIndicator();
                  }
                },
              ),
            Scaffold(
              appBar: AppBar(
                toolbarHeight: 70,
                title: const SizedBox(
                  child: Icon(Icons.cloud_done, size: 60, color: blueColor),
                ),
                backgroundColor: Colors.grey.shade50,
                elevation: 0,
                actions: [
                  Container(
                    padding: EdgeInsets.zero,
                    height: 58,
                    width: 58,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 1.0,
                            offset: Offset(-0.2,1.0),
                            spreadRadius: -1.0)
                      ],
                    ),
                    child: Center(
                      child: SizedBox.fromSize(
                        size: Size(56, 56),
                        child: ClipOval(
                          child: Material(
                            elevation: 50,
                            shadowColor: Colors.black,
                            color: Colors.grey.shade100,
                            child: InkWell(
                              splashColor: Colors.black,
                              onTap: () {
                                _deslogar();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Icon(Icons.logout), // <-- Icon
                                  Text("Sair"), // <-- Text
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              backgroundColor: _isPermissionGranted ? Colors.transparent : null,
              body: _isPermissionGranted
                  ? Column(
                      children: <Widget>[
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TweenAnimationBuilder<double>(
                                duration: const Duration(seconds: 1),
                                tween: Tween(begin: 0, end: 1),
                                builder: (_, value, __) => Opacity(
                                  opacity: value,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.only(top: 20)),
                                      Text(
                                        "Olá, $nomeUsuario",
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.85),
                                            fontSize: 23,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 6),
                                      const Text(
                                        "Escolha qual documento deseja escanear.",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // ),
                          //)
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: GridView.count(
                              crossAxisCount: 2,
                              children:
                                  List.generate(templates.length, (index) {
                                final docItem = templates[index];
                                return GestureDetector(
                                  onTap: () async {
                                    _scanImage(docItem);
                                    setState(() {});
                                  },
                                  child: Container(
                                    child: Card(
                                      elevation: 4.0,
                                      color: gray,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          randomIcon(index),
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 20)),
                                          Text(
                                            docItem.nome_tipo,
                                            style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        )
                      ],
                    )
                  : Center(
                      child: Container(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: const Text(
                          '',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }

  Future<void> _requestUser() async {
    final user = await SessionManager().get('user');
    nomeUsuario = user['nome_usuario'];
  }

  Icon randomIcon(int i) => Icon(
        i <= iconData.length ? iconData[i] : iconData[iconData.length],
        color: Color((r.nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
        size: 40,
      );

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    // Select the first rear camera.
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    await _cameraController!.setFlashMode(FlashMode.off);

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _requestTemplatesUser() async {

    try {
    EasyLoading.show(status: 'loading...');
      TipoDocumentoUser? documentosUser = await templatesService.getAll();
      if (documentosUser != null) {
        templates = documentosUser.templates;
        Future.delayed(const Duration(seconds: 1)).then((value) {
          EasyLoading.dismiss();
        });
      } else {
        await  EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred when scanning text'),
          ),
        );
      }
    } catch (e) {
      await  EasyLoading.dismiss();
      return;
    }
    setState(() {});
  }

  Future<void> _scanImage(Template doc) async {
    if (_cameraController == null) return;

    final navigator = Navigator.of(context);

    File? scannedImage;

    try {
      var androidLabelsConfigs = {
        ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Avançar",
        ScannerLabelsConfig.ANDROID_SAVE_BUTTON_LABEL: "Salvar",
        ScannerLabelsConfig.ANDROID_ROTATE_LEFT_LABEL: "Virar esquerda",
        ScannerLabelsConfig.ANDROID_ROTATE_RIGHT_LABEL: "Virar direita",
        ScannerLabelsConfig.ANDROID_ORIGINAL_LABEL: "Original",
        ScannerLabelsConfig.ANDROID_BMW_LABEL: "B & W",
        ScannerLabelsConfig.PICKER_GALLERY_LABEL: "Galeria",
        ScannerLabelsConfig.PDF_GALLERY_ADD_IMAGE_LABEL: "Tirar foto",
        ScannerLabelsConfig.PDF_GALLERY_EMPTY_MESSAGE:
            "Nenhuma imagem foi escaneada!",
        ScannerLabelsConfig.PDF_GALLERY_DONE_LABEL: "Pronto",
      };

      var image = await DocumentScannerFlutter.launchForPdf(context,
          labelsConfig: androidLabelsConfigs);
      if (image != null) {
        setState(() {
          scannedImage = image;
        });
        // final inputImage = InputImage.fromFile(scannedImage!);
        // final recognizedText = await textRecognizer.processImage(inputImage);

        await navigator.push(
          MaterialPageRoute(
            builder: (BuildContext context) =>
                UploadScreen(documento: doc, imagem: scannedImage!),
            //DynamicTextFieldView()
          ),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred when scanning text'),
        ),
      );
    }
  }

  Future<void> _deslogar() async {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancelar", style: TextStyle(color: Colors.redAccent),),
      onPressed: () => Navigator.pop(context),
    );
    Widget continueButton = TextButton(
      child: const Text("Sair", style: TextStyle(color: Colors.greenAccent),),
      onPressed: () async {
        await SessionManager().remove('user');
        setState(() {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
            return LoginScreen();
          }), (r){
            return false;
          });
          //Navigator.popAndPushNamed(context, '/');
        });
      },
    );

    final alert = AlertDialog(
      title: const Text("Capture Prime"),
      icon: const Icon(Icons.cloud_done, color: blueColor),
      content: const Text(
          'Poxa, quer mesmo sair? \npara voltar será necessário logar novamente.',
           style: TextStyle(fontSize: 15, color: Colors.black45),
      ),
      actions: [cancelButton, continueButton],
    );
    await showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    );
  }
}
