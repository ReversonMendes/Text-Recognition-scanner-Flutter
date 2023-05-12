import 'package:capture_prime/model/campos.dart';

import '../model/documento.dart';

List<Campos> boletoCampos = [
  Campos(tipo: camposTipo.CPFCNPJ, title: 'CPF/CNPJ'),
  Campos(tipo: camposTipo.DATA, title: 'Data Vencimento'),
  Campos(tipo: camposTipo.COMBO, title: 'Tipo movimentação'),
];
List<Campos> nfCampos = [
  Campos(tipo: camposTipo.CPFCNPJ, title: 'CNPJ'),
  Campos(tipo: camposTipo.DATA, title: 'Data Emissão'),
];
List<Campos> cnhCampos = [
  Campos(tipo: camposTipo.TEXTO, title: 'CPF'),
  Campos(tipo: camposTipo.DATA, title: 'Data Validade'),
];
List<Campos> irCampos = [
  Campos(tipo: camposTipo.CPFCNPJ, title: 'CPF/CNPJ'),
  Campos(tipo: camposTipo.ANO, title: 'Ano exercicio'),
];
List<Documento> staticDoc = [
  Documento(
      tipo: DocTipo.BOLETO,
      title: "Boletos",
      image: "assets/images/avatar_1.png",
      active: true,
      campos: boletoCampos),
  Documento(
    tipo: DocTipo.NF,
    title: "Notas Fiscais",
    image: "assets/images/avatar_2.png",
    active: true,
    campos: nfCampos,
  ),
  Documento(
    tipo: DocTipo.CNH,
    title: "CNH",
    image: "assets/images/avatar_3.png",
    active: true,
    campos: cnhCampos,
  ),
  Documento(
    tipo: DocTipo.IR,
    title: "Imposto de Renda",
    image: "assets/images/avatar_4.png",
    active: true,
    campos: irCampos,
  ),
];
