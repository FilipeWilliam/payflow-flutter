import 'package:flutter/material.dart';
import 'package:payflow/modules/barcode_scanner/barcode_scanner_controller.dart';
import 'package:payflow/modules/barcode_scanner/barcode_scanner_status.dart';
import 'package:payflow/shared/themes/app_colors.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';
import 'package:payflow/shared/widgets/bottom_sheet/bottom_sheet_widget.dart';
import 'package:payflow/shared/widgets/set_label_buttons/set_label_buttons.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({Key? key}) : super(key: key);

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  final controller = BarcodeScannerController();

  @override
  void initState() {
    controller.getAvailableCameras();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      left: true,
      right: true,
      child: Stack(
        children: [
          ValueListenableBuilder<BarcodeScannerStatus>(
            valueListenable: controller.statusNotifier,
            builder: (_, status, __) {
              if (status.showCamera) {
                return Container(
                  child: status.cameraController!.buildPreview(),
                );
              } else {
                return Container();
              }
            },
          ),
          RotatedBox(
            quarterTurns: 1,
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: Colors.black,
                  leading: BackButton(
                    color: AppColors.background,
                  ),
                  title: Text(
                    'Escaneie o código de barras do boleto.',
                    style: TextStyles.buttonBackground,
                  ),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: SetLabelButtons(
                  primaryLabel: 'Inserir código do boleto',
                  primaryOnPressed: () {},
                  secondaryLabel: 'Adicionar da galeria',
                  secondaryOnPressed: () {},
                )),
          ),
          ValueListenableBuilder<BarcodeScannerStatus>(
            valueListenable: controller.statusNotifier,
            builder: (_, status, __) {
              if (status.hasError) {
                return BottomSheetWidget(
                  title: 'Não foi possível identificar um código de barras.',
                  subtitle:
                      'Tente escanear novamente ou digite o código do seu boleto.',
                  primaryLabel: 'Escanear novamente',
                  primaryOnPressed: () {},
                  secondaryLabel: 'Digitar código',
                  secondaryOnPressed: () {},
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
