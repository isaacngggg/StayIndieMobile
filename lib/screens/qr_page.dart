import 'package:flutter/widgets.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/screens/archive/content_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:stay_indie/screens/archive/MainProfilePage.dart';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stay_indie/screens/profile/profile_page.dart';

class QrPage extends StatefulWidget {
  const QrPage({super.key});
  static const String id = '/qr_page';

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  // @protected
  // late QrImage qrImage;
  // @override
  // void initState() {
  //   super.initState();

  //   final qrCode = QrCode(
  //     8,
  //     QrErrorCorrectLevel.H,
  //   )..addData(currentUserId);

  //   qrImage = QrImage(qrCode);
  // }

  @override
  var profileId;
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(80.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: PrettyQrView.data(
                data: currentUserId,
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MobileScanner(
                        fit: BoxFit.contain,
                        onDetect: (capture) {
                          final List<Barcode> barcodes = capture.barcodes;
                          debugPrint('Barcode found! ${barcodes[0].rawValue}');
                          try {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                    profileId: barcodes[0].rawValue!),
                              ),
                            );
                          } catch (e) {
                            print('Error: $e');
                          }
                        }),
                  ),
                );
              },
              child: Text(
                'Scan QR Code',
              ),
              style: kSmallPrimaryButtonStyle,
            ),
          ],
        ),
      ),
    );
  }
}