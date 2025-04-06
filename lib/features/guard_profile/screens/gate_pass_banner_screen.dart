import 'package:flutter/material.dart';
import 'package:gloria_connect/features/guard_profile/models/GatePassBanner.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

class GatePassBannerScreen extends StatefulWidget {
  final GatePassBanner? data;
  const GatePassBannerScreen({super.key, this.data});

  @override
  State<GatePassBannerScreen> createState() => _GatePassBannerScreenState();
}

class _GatePassBannerScreenState extends State<GatePassBannerScreen> {
  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> _shareScreenshot() async {
    // Capture the widget as an image
    final image = await screenshotController.capture();
    if (image != null) {
      // Save the captured image to a temporary directory
      final directory = await getTemporaryDirectory();
      final imagePath = File('${directory.path}/otp_banner.png');
      await imagePath.writeAsBytes(image);

      // Share the image using share_plus
      await Share.shareXFiles(
        [XFile(imagePath.path)],
        text: 'Here is your Gate pass OTP!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screenshot(
        controller: screenshotController,
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height, // Fullscreen height
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      spreadRadius: 6,
                      blurRadius: 15,
                      offset: const Offset(0, 10), // Stronger shadow for depth
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Close button
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          // Navigator.popUntil(context, (route) => route.settings.name == '/guard-home');
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Share Invite Text
                    Text(
                      'Share Invite',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 8.0,
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    // White inner card with shadows for 3D effect
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 10,
                            offset: const Offset(0, 6), // Adjusted for depth
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Invitation text
                          Text(
                            'Hello,',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      '${widget.data?.approvedBy?.userName!} ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const TextSpan(
                                  text: 'has been granted access to ',
                                ),
                                TextSpan(
                                  text:
                                      '${widget.data?.gatepassAptDetails!.societyApartments!.map((item) => item.apartment as String).toList().join(', ') ?? 'NA'}, ${widget.data?.gatepassAptDetails?.societyName ?? 'NA'}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Valid Upto heading, current date, and time
                          const Row(
                            children: [
                              Text(
                                'Valid Upto:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 16, color: Colors.black),
                              const SizedBox(width: 8),
                              Text(
                                // Dynamic current date
                                DateFormat('dd MMM, yyyy').format(
                                    widget.data!.checkInCodeExpiryDate!),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const Spacer(),
                              // Circular logo with stronger 3D effect
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3), // Shadow color
                                      blurRadius: 30, // How blurry the shadow is
                                      spreadRadius: 0.1, // Shadow position (x, y)
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/app_logo.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  size: 16, color: Colors.black),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat('hh:mm a')
                                    .format(widget.data!.checkInCodeExpiry!),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 30),
                          // Passcode text with slight shadow for effect
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  'YOUR PASSCODE',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.data!.checkInCode!,
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 8.0,
                                        color: Colors.black.withOpacity(0.2),
                                        offset: const Offset(3, 3),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Instruction text
                    const Text(
                      'Please share this passcode to the security at the gate for hassle-free entry',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 120),
                    // Share button with gradient and 3D shadow effect
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.shade300,
                            Colors.orange.shade700
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 6,
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _shareScreenshot,
                        icon: const Icon(Icons.share, color: Colors.white),
                        label: const Text(
                          'Share',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.transparent, // Use gradient for button
                          padding: const EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 120.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 0, // Set elevation to zero
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
