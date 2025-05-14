import 'package:flutter/material.dart';

class CompanyRow extends StatelessWidget {
  final String entryType;
  final String? serviceLogo;
  final String? companyLogo;
  final String? serviceName;
  final String? companyName;

  const CompanyRow({
    super.key,
    required this.entryType,
    this.serviceLogo,
    this.companyLogo,
    this.serviceName,
    this.companyName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 13,
          backgroundImage: AssetImage(
            entryType == 'other'
                ? serviceLogo ?? 'assets/images/profile.png'
                : companyLogo ?? 'assets/images/profile.png',
          ),
        ),
        const SizedBox(width: 5),
        Text(
          entryType == 'other' ? serviceName ?? "NA" : companyName ?? "NA",
          style: const TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ],
    );
  }
}
