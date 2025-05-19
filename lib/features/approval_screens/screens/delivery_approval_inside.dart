import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:gloria_connect/features/approval_screens/widgets/circular_action_button.dart';
import 'package:gloria_connect/features/guard_entry/bloc/guard_entry_bloc.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
import 'package:gloria_connect/utils/phone_utils.dart';

import '../../guard_waiting/models/entry.dart';
import '../../my_visitors/bloc/my_visitors_bloc.dart';

class DeliveryApprovalInside extends StatefulWidget {
  final VisitorEntries? payload;
  const DeliveryApprovalInside({super.key, this.payload});

  @override
  State<DeliveryApprovalInside> createState() => _DeliveryApprovalInsideState();
}

class _DeliveryApprovalInsideState extends State<DeliveryApprovalInside> {
  bool _isLoadingAllow = false;
  bool _isLoadingDeny = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<GuardEntryBloc, GuardEntryState>(
          listener: (context, state) {
            if (state is ApproveDeliveryEntryLoading) {
              _isLoadingAllow = true;
            }
            if (state is ApproveDeliveryEntrySuccess) {
              _isLoadingAllow = false;
              CustomSnackBar.show(context: context, message: state.response['message'], type: SnackBarType.success);
              context.read<MyVisitorsBloc>().add(GetServiceRequest());
              Navigator.of(context).pop();
            }
            if (state is ApproveDeliveryEntryFailure) {
              _isLoadingAllow = false;
              CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
            }
            if (state is RejectDeliveryEntryLoading) {
              _isLoadingDeny = true;
            }
            if (state is RejectDeliveryEntrySuccess) {
              _isLoadingDeny = false;
              CustomSnackBar.show(context: context, message: state.response['message'], type: SnackBarType.success);
              context.read<MyVisitorsBloc>().add(GetServiceRequest());
              Navigator.of(context).pop();
            }
            if (state is RejectDeliveryEntryFailure) {
              _isLoadingDeny = false;
              CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
            }
          },
          builder: (context, state) {
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
                          '${widget.payload?.societyDetails?.societyGates!.toUpperCase()}, ${widget.payload?.societyDetails?.societyName!.toUpperCase()}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
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
                              color: Colors.white.withValues(alpha: 0.2),
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
                                _buildTopIcon(),
                                const SizedBox(height: 16.0),
                                // Text
                                _buildText(),
                                const SizedBox(height: 16.0),
                                // Delivery Person Info
                                _buildDeliveryPersonInfo(),
                              ],
                            ),
                          ),
                          // Action buttons
                          _buildActionButton(),
                        ],
                      ),
                      const Spacer(),
                      // Company Logo at the bottom
                      _buildBottomLogo(),
                    ],
                  ),
                ),
                // Cancel Icon at the top-right corner
                Positioned(
                  top: 40.0,
                  right: 16.0,
                  child: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.white70, size: 32.0),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            );
          },
        ),
    );
  }

  Widget _buildTopIcon(){
    return CircleAvatar(
      radius: 32,
      backgroundImage: widget.payload?.entryType == 'delivery'
          ? const AssetImage('assets/images/delivery/other.png')
          : widget.payload?.entryType == 'cab'
          ? const AssetImage('assets/images/cab/others.png')
          : widget.payload?.entryType == 'guest'
          ? const AssetImage('assets/images/guest/single_guest.png')
          : const AssetImage('assets/images/other/more_options.png'),
      onBackgroundImageError: (_, __) => const AssetImage('assets/images/profile.png'),
    );
  }

  Widget _buildText(){
    return Text(
      widget.payload?.entryType == 'delivery'
          ? "You’ve got a Delivery at the ${widget.payload?.societyDetails?.societyGates!}"
          : widget.payload?.entryType == 'cab'
          ? "Your cab is at the ${widget.payload?.societyDetails?.societyGates!} Ready for pickup!"
          : widget.payload?.entryType == 'guest'
          ? "Your Guest has arrived at the ${widget.payload?.societyDetails?.societyGates!}"
          : "The service provider is at the ${widget.payload?.societyDetails?.societyGates!}",
      style: const TextStyle(
          fontSize: 24.0,
          color: Colors.white70
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDeliveryPersonInfo(){
    return Row(
      children: [
        CustomCachedNetworkImage(
          imageUrl: widget.payload?.profileImg,
          size: 80,
          isCircular: true,
          borderWidth: 3,
          onTap: ()=> CustomFullScreenImageViewer.show(context, widget.payload?.profileImg),
        ),
        const SizedBox(width: 16.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.payload?.name ?? 'NA',
              style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70
              ),
            ),
            const SizedBox(height: 4.0),
            if (widget.payload?.entryType != 'guest')
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: widget.payload?.entryType == 'delivery' || widget.payload?.entryType == 'cab'
                        ? AssetImage(widget.payload?.companyLogo ?? 'assets/images/other/more_option.png')
                        : AssetImage(widget.payload?.serviceLogo ?? 'assets/images/other/more_option.png'),
                    onBackgroundImageError: (_, __) => const AssetImage('assets/images/profile.png'),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    widget.payload?.entryType == 'delivery' || widget.payload?.entryType == 'cab'
                        ? widget.payload?.companyName ?? 'NA'
                        : widget.payload?.serviceName ?? 'NA',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
          ],
        ),
        const Spacer(),
        IconButton(
            icon: const Icon(
              Icons.phone,
              color: Colors.white70,
              size: 30,
            ),
            onPressed: ()=> PhoneUtils.makePhoneCall(context, widget.payload?.mobNumber ?? '')),
      ],
    );
  }

  Widget _buildActionButton(){
    return Positioned(
      bottom: -60,
      left: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircularActionButton(
            onTap: () {
              context.read<GuardEntryBloc>().add(
                RejectDeliveryEntry(id: widget.payload!.id!),
              );
            },
            isLoading: _isLoadingDeny,
            icon: Icons.cancel,
            gradientColors: const [Colors.redAccent, Colors.red],
            label: "Deny Entry",
            shadowColor: Colors.red,
          ),
          const SizedBox(width: 120),
          CircularActionButton(
            onTap: () {
              context.read<GuardEntryBloc>().add(
                ApproveDeliveryEntry(id: widget.payload!.id!),
              );
            },
            isLoading: _isLoadingAllow,
            icon: Icons.check,
            gradientColors: const [Colors.greenAccent, Colors.green],
            label: "Allow Entry",
            shadowColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomLogo(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipOval(
        child: Image.asset(
          'assets/app_logo/app_logo.png',
          height: 60,
          width: 60,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
