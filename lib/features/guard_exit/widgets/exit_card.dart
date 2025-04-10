import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/guard_exit/bloc/guard_exit_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import '../../guard_waiting/models/entry.dart';

class ExitCard extends StatelessWidget {
  final VisitorEntries data;
  final String type;

  const ExitCard({super.key, required this.data, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showDetailsSheet(context),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 16),
                  _buildMainContent(),
                  const SizedBox(height: 16),
                  _buildFooter(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Hero(
          tag: 'profile_${data.id}',
          child: GestureDetector(
            onTap: () => _showImageDialog(data.profileImg, context),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _getStatusColor(),
                  width: 2,
                ),
                image: DecorationImage(
                  image: _getProfileImage(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.name ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70
                ),
              ),
              const SizedBox(height: 4),
              _buildStatusChip(),
            ],
          ),
        ),
        _buildTimeWidget(),
      ],
    );
  }

  Widget _buildMainContent() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildInfoTile(
            Icons.location_on_outlined,
            'Location',
            _getApartmentDetails(),
          ),
          if (data.vehicleDetails?.vehicleNumber != null)
            _buildInfoTile(
              Icons.directions_car_outlined,
              'Vehicle',
              data.vehicleDetails!.vehicleNumber!,
            ),
          _buildInfoTile(
            Icons.meeting_room_outlined,
            'Entry Gate',
            data.gateName ?? 'Main Gate',
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // TextButton.icon(
        //   icon: const Icon(Icons.info_outline, size: 20),
        //   label: const Text('Details'),
        //   onPressed: () => _showDetailsSheet(context),
        //   style: TextButton.styleFrom(
        //     foregroundColor: Colors.grey[700],
        //   ),
        // ),
        ElevatedButton.icon(
          icon: const Icon(Icons.exit_to_app, size: 20),
          label: const Text('CHECK OUT'),
          onPressed: () => _showOutConfirmationDialog(context, data, type),
          style: ElevatedButton.styleFrom(
            backgroundColor: _getStatusColor(),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        (data.entryType ?? data.profileType ?? 'Visitor').toUpperCase(),
        style: TextStyle(
          color: _getStatusColor(),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTimeWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          DateFormat('hh:mm a').format(data.entryTime ?? DateTime.now()),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Text(
          'Checked In',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.white70),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (data.entryType ?? data.profileType) {
      case 'service':
        return Colors.orange;
      case 'delivery':
        return Colors.green;
      case 'guest':
        return Colors.blue;
      case 'cab':
        return Colors.purple;
      default:
        return Colors.teal;
    }
  }

  // Keeping existing helper methods with slight modifications
  ImageProvider _getProfileImage() {
    if (data.profileImg != null && data.allowedBy == null) {
      return NetworkImage(data.profileImg!);
    } else if (data.entryType == 'service') {
      return NetworkImage(data.profileImg!);
    } else if (data.profileType != null && data.profileImg != null) {
      return NetworkImage(data.profileImg!);
    } else {
      return AssetImage(data.profileImg!);
    }
  }

  String _getApartmentDetails() {
    if (data.profileType != null && data.apartment == null) {
      return data.societyName!;
    } else if (data.allowedBy != null && data.entryType == 'service') {
      return data.gatepassAptDetails?.societyApartments?.map((item) => item.apartment ?? '').toList().join(', ') ?? 'N/A';
    } else if (data.allowedBy != null) {
      return data.apartment!;
    } else {
      return data.societyDetails!.societyApartments!.map((item) => item.apartment as String).toList().join(', ');
    }
  }

  void _showDetailsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: controller,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Add detailed information widgets here
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOutConfirmationDialog(BuildContext context, VisitorEntries data, String type) {
    bool isLoading = false;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        return Dialog(
          backgroundColor: const Color(0xff8ecae6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: BlocConsumer<GuardExitBloc, GuardExitState>(
            listener: (context, state) {
              if (state is ExitEntryLoading) {
                isLoading = true;
              }
              if (state is ExitEntrySuccess) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.response['message']),
                  backgroundColor: Colors.green,
                ));
                Navigator.of(context).pop();
                isLoading = false;
                _refresh(context);
              }
              if (state is ExitEntryFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ));
                isLoading = false;
              }
            },
            builder: (context, state) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Checkout',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: _getProfileImage(),
                            radius: 40,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.name!,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                                ),
                                const SizedBox(height: 4.0),
                                _buildTag(data.entryType ?? data.profileType!),
                                const SizedBox(height: 8.0),
                                _buildInfoRow(Icons.two_wheeler, data.vehicleDetails?.vehicleNumber ?? 'NA'),
                                const SizedBox(height: 4.0),
                                _buildInfoRow(Icons.access_time, DateFormat('hh:mm a').format(data.entryTime ?? DateTime.now())),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            String? isPreApproved = data.approvedBy != null && data.entryType != null ? data.entryType : data.profileType;
                            context.read<GuardExitBloc>().add(ExitEntry(id: data.id!, entryType: isPreApproved != null ? 'preapproved' : 'delivery'));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade400, // Softer green for minimal look
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : const Text(
                            'Confirm Exit',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return Transform.scale(
          scale: animation1.value,
          child: Opacity(
            opacity: animation1.value,
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String info) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black54), // Softer grey for icons
        const SizedBox(width: 4.0),
        Text(info.isEmpty ? "NA" : info, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blueAccent.shade100, // Subtle blue color
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black54, fontSize: 14,),
      ),
    );
  }

  void _refresh(BuildContext context){
    switch(type){
      case 'all' :
        context.read<GuardExitBloc>().add(ExitGetAllowedEntries());
        context.read<GuardExitBloc>().add(ExitGetCabEntries());
        context.read<GuardExitBloc>().add(ExitGetDeliveryEntries());
        context.read<GuardExitBloc>().add(ExitGetGuestEntries());
        context.read<GuardExitBloc>().add(ExitGetServiceEntries());
      case 'cab' :
        context.read<GuardExitBloc>().add(ExitGetCabEntries());
        context.read<GuardExitBloc>().add(ExitGetAllowedEntries());
      case 'delivery' :
        context.read<GuardExitBloc>().add(ExitGetDeliveryEntries());
        context.read<GuardExitBloc>().add(ExitGetAllowedEntries());
      case 'guest' :
        context.read<GuardExitBloc>().add(ExitGetGuestEntries());
        context.read<GuardExitBloc>().add(ExitGetAllowedEntries());
      case 'service' :
        context.read<GuardExitBloc>().add(ExitGetServiceEntries());
        context.read<GuardExitBloc>().add(ExitGetAllowedEntries());
      default:
        return;
    }
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
                  color: Colors.white, // White background for the image container
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Fit to image size
                    children: [
                      imageUrl!.contains("assets")
                          ? Image.asset(imageUrl,
                        height: MediaQuery.of(context).size.height * 0.5, // Constrain the height
                        width: double.infinity, // Expand to the width of the dialog
                        fit: BoxFit.contain, // Contain image within the space, maintaining aspect ratio
                      )
                          : Image.network(
                        imageUrl,
                        height: MediaQuery.of(context).size.height * 0.5, // Constrain the height
                        width: double.infinity, // Expand to the width of the dialog
                        fit: BoxFit.contain, // Contain image within the space, maintaining aspect ratio
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
