import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:gloria_connect/features/guard_exit/bloc/guard_exit_bloc.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
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
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
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
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        CustomCachedNetworkImage(
          isCircular: true,
          size: 64,
          imageUrl: data.profileImg,
          errorImage: Icons.person,
          borderWidth: 3,
          onTap: ()=> CustomFullScreenImageViewer.show(context, data.profileImg),
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
                CustomSnackBar.show(context: context, message: state.response['message'], type: SnackBarType.success);
                Navigator.of(context).pop();
                isLoading = false;
                _refresh(context);
              }
              if (state is ExitEntryFailure) {
                CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.success);
                CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
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
                          CustomCachedNetworkImage(
                            isCircular: true,
                            size: 80,
                            imageUrl: data.profileImg,
                            errorImage: Icons.person,
                            borderWidth: 2,
                            onTap: ()=> CustomFullScreenImageViewer.show(context, data.profileImg),
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
}