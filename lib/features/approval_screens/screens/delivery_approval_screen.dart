import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/guard_entry/bloc/guard_entry_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../my_visitors/bloc/my_visitors_bloc.dart';

class DeliveryApprovalScreen extends StatefulWidget {
  final Map<String, dynamic>? payload;
  const DeliveryApprovalScreen({super.key, this.payload});

  @override
  State<DeliveryApprovalScreen> createState() => _DeliveryApprovalScreenState();
}

class _DeliveryApprovalScreenState extends State<DeliveryApprovalScreen> {
  bool _isLoadingAllow = false;
  bool _isLoadingDeny = false;
  String? societyName;
  String? societyBlock;
  String? apartment;
  String? societyGate;

  @override
  void initState() {
    super.initState();
    String input = widget.payload?['societyDetails'];
    RegExp societyNameRegex = RegExp(r'societyName:\s*([^,]+)');
    RegExp societyApartmentsRegex = RegExp(r'societyApartments:\s*\[\{societyBlock:\s*([^,]+),\s*apartment:\s*([^\}]+)\}\]');
    RegExp societyGatesRegex = RegExp(r'societyGates:\s*([^\}]+)');

    societyName = societyNameRegex.firstMatch(input)?.group(1);
    societyBlock = societyApartmentsRegex.firstMatch(input)?.group(1);
    apartment = societyApartmentsRegex.firstMatch(input)?.group(2);
    societyGate = societyGatesRegex.firstMatch(input)?.group(1);
  }

  void _makePhoneCall() async {
    final Uri url = Uri(
      scheme: 'tel',
      path: widget.payload?['mobNumber'],
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not connect $url';
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blue.shade400,
      body: BlocConsumer<GuardEntryBloc, GuardEntryState>(
        listener: (context, state){
          if(state is ApproveDeliveryEntryLoading){
            _isLoadingAllow = true;
          }
          if(state is ApproveDeliveryEntrySuccess){
            _isLoadingAllow = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.response['message']),
                backgroundColor: Colors.green,
              ),
            );
            context.read<MyVisitorsBloc>().add(GetServiceRequest());
            Navigator.of(context).pop();
          }
          if(state is ApproveDeliveryEntryFailure){
            _isLoadingAllow = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          if(state is RejectDeliveryEntryLoading){
            _isLoadingDeny = true;
          }
          if(state is RejectDeliveryEntrySuccess){
            _isLoadingDeny = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.response['message']),
                backgroundColor: Colors.green,
              ),
            );
            context.read<MyVisitorsBloc>().add(GetServiceRequest());
            Navigator.of(context).pop();
          }
          if(state is RejectDeliveryEntryFailure){
            _isLoadingDeny = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state){
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Title Text
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0, bottom: 16.0),
                      child: Text(
                        "${societyGate?.toUpperCase()}, $societyName",
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Spacer(),
                    // Delivery Info Container
                    Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 320.0, // Increased height
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Top Icon
                              CircleAvatar(
                                radius: 32,
                                backgroundImage: widget.payload?['entryType'] == 'delivery'
                                    ? const AssetImage('assets/images/delivery/other.png')
                                    : widget.payload?['entryType'] == 'cab'
                                    ? const AssetImage('assets/images/cab/others.png')
                                    : widget.payload?['entryType'] == 'guest'
                                    ? const AssetImage('assets/images/guest/single_guest.png')
                                    : const AssetImage('assets/images/other/more_options.png'),
                                onBackgroundImageError: (_, __) => const AssetImage('assets/images/profile.png'),
                              ),

                              const SizedBox(height: 16.0),
                              Text(
                                widget.payload?['entryType'] == 'delivery'
                                    ? "You’ve got a Delivery at the $societyGate"
                                    : widget.payload?['entryType'] == 'cab'
                                    ? "Your cab is at the $societyGate Ready for pickup!"
                                    : widget.payload?['entryType'] == 'guest'
                                    ? "Your Guest has arrived at the $societyGate"
                                    : "The service provider is at the $societyGate",
                                style: const TextStyle(
                                  fontSize: 24.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16.0),
                              // Delivery Person Info
                              Row(
                                children: [
                                  // Profile container with increased height
                                  SizedBox(
                                    height: 100.0, // Increased height
                                    child: CircleAvatar(
                                      radius: 40.0, // Increased size of the image
                                      backgroundImage: widget.payload?['profileImg']!=null ? NetworkImage(widget.payload?['profileImg']) : const AssetImage('assets/images/profile.png'), // Asset image for profile
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.payload?['name'],
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),
                                      if(widget.payload?['entryType'] != 'guest')
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 16,
                                              backgroundImage: widget.payload?['entryType']=='delivery' || widget.payload?['entryType']=='cab'
                                                  ? AssetImage(widget.payload!['companyLogo']!)
                                                  : AssetImage(widget.payload?['serviceLogo'] ?? 'assets/images/other/more_option.png'),
                                              onBackgroundImageError: (_, __) => const AssetImage('assets/images/profile.png'),
                                            ),
                                            const SizedBox(width: 8.0),

                                            Text(
                                              widget.payload?['entryType']=='delivery' || widget.payload?['entryType']=='cab'
                                                  ? widget.payload!['companyName']!
                                                  : widget.payload?['serviceName'] ?? 'NA',
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.phone, color: Colors.green),
                                    onPressed: _makePhoneCall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: -60, // Adjusted for both button and text alignment
                          left: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  // Deny Entry Button with red background and white border
                                  InkWell(
                                    onTap : () {
                                      // Deny Entry Action
                                      context.read<GuardEntryBloc>().add(RejectDeliveryEntry(id: widget.payload?['id']));
                                    },
                                    child: Container(
                                      width: 70, // Adjust the size to fit the design
                                      height: 70,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 4), // White border
                                      ),
                                      child: _isLoadingDeny
                                          ? const CircularProgressIndicator()
                                          :  const CircleAvatar(
                                              radius: 35,
                                              backgroundColor: Colors.red, // Set background color to red
                                              child: IconButton(
                                                icon: Icon(Icons.cancel, color: Colors.white), // Set icon color to white
                                                onPressed: null,
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0), // Space between button and text
                                  const Text(
                                    "Deny Entry",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 120), // Adjust spacing as needed
                              Column(
                                children: [
                                  // Allow Entry Button with green background and white border
                                  InkWell(
                                    onTap: () {
                                      context.read<GuardEntryBloc>().add(ApproveDeliveryEntry(id: widget.payload?['id']));
                                    },
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 4), // White border
                                      ),
                                      child: _isLoadingAllow
                                         ? const CircularProgressIndicator()
                                         :  const CircleAvatar(
                                            radius: 35,
                                            backgroundColor: Colors.green, // Set background color to green
                                            child: IconButton(
                                              icon: Icon(Icons.check, color: Colors.white), // Set icon color to white
                                              onPressed: null,
                                            ),
                                          ),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0), // Space between button and text
                                  const Text(
                                    "Allow Entry",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(), // Spacer to push the logo to the bottom
                    // Company Logo at the bottom
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/app_logo/app_logo.png', // Path to your logo in assets
                          height: 60, // Adjust size as needed
                          width: 60, // Ensure the logo is displayed as a circle
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Cancel Icon at the top-right corner
              Positioned(
                top: 40.0,
                right: 16.0,
                child: IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.white, size: 32.0),
                  onPressed: () {
                    // SystemNavigator.pop();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        },
      )
    );
  }
}
