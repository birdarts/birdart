import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

// Partially modified based on following url, originally distributed under Apache 2.0,
// original authors listed in repository commit history.
// https://github.com/mohesu/barcode_scanner

class QrCodeDialog extends StatelessWidget {
  const QrCodeDialog(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: QrImageView(
          data: text,
        ),
      ),
    );
  }
}

class QrScanDialog extends StatelessWidget {
  QrScanDialog({super.key, required this.onScan, this.validator});

  final void Function(String) onScan;
  final bool Function(String value)? validator;

  final controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: AiBarcodeScanner(
                controller: controller,
                onScan: (String value) {
                  debugPrint(value);
                },
                validator: validator,
                onDetect: (BarcodeCapture barcodeCapture) {
                  debugPrint(barcodeCapture.toString());
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  color: Theme.of(context).primaryColor,
                  tooltip: "Switch Camera",
                  onPressed: () => controller.switchCamera(),
                  icon: ValueListenableBuilder<CameraFacing>(
                    valueListenable: controller.cameraFacingState,
                    builder: (context, state, child) {
                      switch (state) {
                        case CameraFacing.front:
                          return const Icon(Icons.camera_front);
                        case CameraFacing.back:
                          return const Icon(Icons.camera_rear);
                      }
                    },
                  ),
                ),
                IconButton(
                  tooltip: "Torch",
                  onPressed: () => controller.toggleTorch(),
                  icon: ValueListenableBuilder<TorchState>(
                    valueListenable: controller.torchState,
                    builder: (context, state, child) {
                      switch (state) {
                        case TorchState.off:
                          return const Icon(
                            Icons.flash_off,
                            color: Colors.grey,
                          );
                        case TorchState.on:
                          return const Icon(
                            Icons.flash_on,
                            color: Colors.orange,
                          );
                      }
                    },
                  ),
                ),
                IconButton(
                  tooltip: "From Picture",
                  onPressed: () async {
                    final List<AssetEntity>? result =
                        await AssetPicker.pickAssets(
                      context,
                      pickerConfig: const AssetPickerConfig(
                        maxAssets: 1,
                        requestType: RequestType.image,
                        textDelegate: AssetPickerTextDelegate(),
                      ),
                    );
                    if (result != null && result.isNotEmpty) {
                      String? path = (await result.first.file)?.path;
                      if (path != null) {
                        controller.analyzeImage(path);
                      }
                    }
                  },
                  icon: const Icon(
                    Icons.image,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
