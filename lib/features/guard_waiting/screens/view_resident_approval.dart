import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/guard_waiting/bloc/guard_waiting_bloc.dart';
import 'package:gloria_connect/features/guard_waiting/widgets/flat_row.dart';

import '../models/entry.dart';

class ViewResidentApproval extends StatefulWidget {
  final Entry? data;
  const ViewResidentApproval({super.key, this.data});

  @override
  State<ViewResidentApproval> createState() => _ViewResidentApprovalState();
}

class _ViewResidentApprovalState extends State<ViewResidentApproval> {
  bool _isLoadingAllow = false;
  bool _isLoadingDeny = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'View Residents Approval',
            style: TextStyle(color: Colors.white70),
          ),
          backgroundColor: Colors.black.withOpacity(0.2),
        ),
        body: BlocConsumer<GuardWaitingBloc, GuardWaitingState>(
          listener: (context, state) {
            if (state is WaitingAllowEntryLoading) {
              _isLoadingAllow = true;
            }
            if (state is WaitingAllowEntrySuccess) {
              _isLoadingAllow = false;
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.response['message']),
                    backgroundColor: Colors.green,
                  ),
                );
                context.read<GuardWaitingBloc>().add(WaitingGetEntries());
                Navigator.pop(context);
              }
            }
            if (state is WaitingAllowEntryFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent));
              _isLoadingAllow = false;
            }
            if (state is WaitingDenyEntryLoading) {
              _isLoadingDeny = true;
            }
            if (state is WaitingDenyEntrySuccess) {
              _isLoadingDeny = false;
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.response['message']),
                    backgroundColor: Colors.green,
                  ),
                );
                context.read<GuardWaitingBloc>().add(WaitingGetEntries());
                Navigator.pop(context);
              }
            }
            if (state is WaitingDenyEntryFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent));
              _isLoadingDeny = false;
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  _buildDeliveryCard(),
                  const SizedBox(height: 20),

                  // Flats list arranged vertically with dividers only
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.data?.societyDetails?.societyApartments
                              ?.length ??
                          0,
                      itemBuilder: (context, index) {
                        return FlatRow(
                          data: widget
                              .data?.societyDetails!.societyApartments![index],
                        );
                      },
                    ),
                  ),

                  // Swapped Action buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _denyEntryPressed,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor:
                                  Colors.red, // Deny Entry button color
                            ),
                            child: Center(
                              child: _isLoadingDeny
                                  ? CircularProgressIndicator(
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              Colors.blueAccent),
                                      backgroundColor: Colors.grey[200],
                                      strokeWidth: 5.0,
                                    )
                                  : const Text('DENY ENTRY',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _allowEntryPressed,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor:
                                  Colors.green, // Allow Entry button color
                            ),
                            child: Center(
                              child: _isLoadingAllow
                                  ? CircularProgressIndicator(
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              Colors.blueAccent),
                                      backgroundColor: Colors.grey[200],
                                      strokeWidth: 5.0,
                                    )
                                  : const Text('ALLOW ENTRY',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }

  void _allowEntryPressed() {
    context
        .read<GuardWaitingBloc>()
        .add(WaitingAllowEntry(id: widget.data!.id!));
  }

  void _denyEntryPressed() {
    context
        .read<GuardWaitingBloc>()
        .add(WaitingDenyEntry(id: widget.data!.id!));
  }

  Widget _buildDeliveryCard() {
    return Card(
      color: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileImage(),
            const SizedBox(width: 16),
            _buildDeliveryInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white70, // Border color
          width: 2, // Border width
        ),
      ),
      child: CircleAvatar(
        backgroundImage: widget.data?.profileImg != null &&
                !widget.data!.profileImg!.contains('assets')
            ? NetworkImage(widget.data!.profileImg!)
            : AssetImage(widget.data!.profileImg!),
        radius: 45,
        child: GestureDetector(
          onTap: () {
            _showImageDialog(
                widget.data?.profileImg, context); // Open dialog on tap
          },
        ),
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDeliveryHeader(),
          _buildEntryTypeTag(),
          const SizedBox(height: 12),
          if (widget.data!.entryType != 'guest') _buildCompanyRow(),
          const SizedBox(height: 8),
          _buildApartmentList(),
        ],
      ),
    );
  }

  Widget _buildDeliveryHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.data?.name ?? 'NA',
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white70),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.cancel,
            size: 20,
            color: Colors.white70,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildEntryTypeTag() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      decoration: BoxDecoration(
        gradient:
            const LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        widget.data!.entryType.toString().toUpperCase(),
        style: const TextStyle(color: Colors.white70, fontSize: 16),
      ),
    );
  }

  Widget _buildCompanyRow() {
    return Row(
      children: [
        CircleAvatar(
            radius: 13,
            backgroundImage: AssetImage(widget.data!.entryType == 'other'
                ? widget.data?.serviceLogo ?? 'assets/images/profile.png'
                : widget.data!.companyLogo!)),
        const SizedBox(width: 5),
        Text(
            widget.data!.entryType == 'other'
                ? widget.data?.serviceName ?? "NA"
                : widget.data!.companyName!,
            style: const TextStyle(fontSize: 16, color: Colors.white70)),
      ],
    );
  }

  Widget _buildApartmentList() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
            padding: EdgeInsets.all(5.0),
            child: Icon(Icons.home, size: 20, color: Colors.white70)),
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.data!.societyDetails!.societyApartments!
                .map((e) => Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(e.apartment!,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.white70))))
                .toList(),
          ),
        ),
      ],
    );
  }

  void _showImageDialog(String? imageUrl, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allows dismissing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.transparent, // Transparent background
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  color:
                      Colors.white, // White background for the image container
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Fit to image size
                    children: [
                      imageUrl!.contains("assets")
                          ? Image.asset(
                              imageUrl,
                              height: MediaQuery.of(context).size.height *
                                  0.5, // Constrain the height
                              width: double
                                  .infinity, // Expand to the width of the dialog
                              fit: BoxFit
                                  .contain, // Contain image within the space, maintaining aspect ratio
                            )
                          : Image.network(
                              imageUrl,
                              height: MediaQuery.of(context).size.height *
                                  0.5, // Constrain the height
                              width: double
                                  .infinity, // Expand to the width of the dialog
                              fit: BoxFit
                                  .contain, // Contain image within the space, maintaining aspect ratio
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error, size: 100);
                              },
                            ),
                    ],
                  ),
                ),
              ),
              // Close button
              Positioned(
                top: 10,
                right: 10,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.6),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
