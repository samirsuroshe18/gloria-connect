import 'package:flutter/material.dart';
import 'package:gloria_connect/features/invite_visitors/models/pre_approved_banner.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

class OtpBanner extends StatefulWidget {
  final PreApprovedBanner? data;
  const OtpBanner({super.key, this.data});

  @override
  State<OtpBanner> createState() => _OtpBannerState();
}

class _OtpBannerState extends State<OtpBanner> {
  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> _shareScreenshot() async {
    final image = await screenshotController.capture();
    if (image != null) {
      final directory = await getTemporaryDirectory();
      final imagePath = File('${directory.path}/otp_banner.png');
      await imagePath.writeAsBytes(image);

      await Share.shareXFiles(
        [XFile(imagePath.path)],
        text: 'Here is your OTP invite!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 360;
    final bool isMediumScreen = screenSize.width < 600;

    // Calculate responsive sizes
    final double mainPadding = screenSize.width * 0.04;
    final double cardPadding = screenSize.width * 0.03;
    final double titleFontSize = isSmallScreen ? 20 : 24;
    final double normalFontSize = isSmallScreen ? 14 : (isMediumScreen ? 16 : 18);
    final double passcodeSize = isSmallScreen ? 32 : (isMediumScreen ? 36 : 40);
    final double logoSize = isSmallScreen ? 40 : 50;
    final double buttonWidth = screenSize.width * (isSmallScreen ? 0.6 : 0.8);

    return Scaffold(
      body: Screenshot(
        controller: screenshotController,
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(mainPadding),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(cardPadding),
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
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Share Invite',
                      style: TextStyle(
                        fontSize: titleFontSize,
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
                    SizedBox(height: screenSize.height * 0.04),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(cardPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello,',
                            style: TextStyle(
                              fontSize: normalFontSize,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: normalFontSize,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: '${widget.data?.approvedBy?.userName!} ',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const TextSpan(text: 'has invited you to '),
                                TextSpan(
                                  text: '${widget.data?.apartment}, ${widget.data?.societyName}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.02),
                          Row(
                            children: [
                              Text(
                                'Valid Upto:',
                                style: TextStyle(
                                  fontSize: normalFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16, color: Colors.black),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  DateFormat('dd MMM, yyyy').format(widget.data!.checkInCodeExpiryDate!),
                                  style: TextStyle(
                                    fontSize: normalFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                width: logoSize,
                                height: logoSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 6,
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
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
                              const Icon(Icons.access_time, size: 16, color: Colors.black),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat('hh:mm a').format(widget.data!.checkInCodeExpiry!),
                                style: TextStyle(
                                  fontSize: normalFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 30),
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  'YOUR PASSCODE',
                                  style: TextStyle(
                                    fontSize: normalFontSize * 0.75,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.data!.checkInCode!,
                                  style: TextStyle(
                                    fontSize: passcodeSize,
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
                    Text(
                      'Please share this passcode to the security at the gate for hassle-free entry',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: normalFontSize * 0.875,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.1),
                    Container(
                      width: buttonWidth,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orange.shade300, Colors.orange.shade700],
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
                        label: Text(
                          'Share',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: normalFontSize * 1.1,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.02,
                            horizontal: screenSize.width * 0.1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 0,
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