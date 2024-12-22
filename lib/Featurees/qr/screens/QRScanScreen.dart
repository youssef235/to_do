import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../todos/screens/TodoDetailScreen.dart';
import '../cubit/QRScanCubit.dart';
import '../cubit/QRScanState.dart';

class QRScanScreen extends StatefulWidget {
  final String token;

  QRScanScreen({required this.token});

  @override
  _QRScanScreenState createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  MobileScannerController scannerController = MobileScannerController();

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Scan QR Code"),
        actions: [
          IconButton(
            icon: Icon(Icons.flash_on),
            onPressed: () => scannerController.toggleTorch(),
          ),
        ],
      ),
      body: BlocListener<QRScanCubit, QRScanState>(
        listener: (context, state) {
          if (state is QRScanLoading) {
            showDialog(
              context: context,
              builder: (context) => Center(child: CircularProgressIndicator()),
            );
          }

          if (state is QRScanSuccess) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailsPage(task: state.task),
              ),
            );
          }

          if (state is QRScanError) {
            Navigator.pop(context);
            print(state.message);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),

            );
          }
        },
        child: MobileScanner(
          controller: scannerController,
          onDetect: (capture) async {
            final barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              if (barcode.rawValue != null) {
                print("Scanned Barcode: ${barcode.rawValue}");
                scannerController.stop();

                final qrScanCubit = context.read<QRScanCubit>();
                qrScanCubit.fetchTaskById(barcode.rawValue!);
                break;
              }
            }

          },
        ),
      ),
    );
  }
}
