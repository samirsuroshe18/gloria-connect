import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:gloria_connect/features/guard_waiting/bloc/guard_waiting_bloc.dart';
import 'package:gloria_connect/features/guard_waiting/widgets/apartment_list.dart';
import 'package:gloria_connect/features/guard_waiting/widgets/company_row.dart';
import 'package:gloria_connect/features/guard_waiting/widgets/delivery_header.dart';
import 'package:gloria_connect/features/guard_waiting/widgets/entry_action_button.dart';
import 'package:gloria_connect/features/guard_waiting/widgets/entry_type_tag.dart';
import 'package:gloria_connect/features/guard_waiting/widgets/flat_row.dart';
import 'package:gloria_connect/common_widgets/staggered_list_animation.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';

import '../models/entry.dart';

class ViewResidentApproval extends StatefulWidget {
  final VisitorEntries? data;
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
                CustomSnackBar.show(context: context, message: state.response['message'], type: SnackBarType.success);
                context.read<GuardWaitingBloc>().add(WaitingGetEntries());
                Navigator.pop(context);
              }
            }
            if (state is WaitingAllowEntryFailure) {
              CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
              _isLoadingAllow = false;
            }
            if (state is WaitingDenyEntryLoading) {
              _isLoadingDeny = true;
            }
            if (state is WaitingDenyEntrySuccess) {
              _isLoadingDeny = false;
              if (mounted) {
                CustomSnackBar.show(context: context, message: state.response['message'], type: SnackBarType.success);
                context.read<GuardWaitingBloc>().add(WaitingGetEntries());
                Navigator.pop(context);
              }
            }
            if (state is WaitingDenyEntryFailure) {
              CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
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
                    child: AnimationLimiter(
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: widget.data?.societyDetails?.societyApartments?.length ?? 0,
                        itemBuilder: (context, index) {
                          return StaggeredListAnimation(
                              index: index, child: FlatRow(
                              data: widget.data?.societyDetails!.societyApartments![index],
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Swapped Action buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      children: [
                        EntryActionButton(
                          onPressed: _denyEntryPressed,
                          isLoading: _isLoadingDeny,
                          label: 'DENY ENTRY',
                          backgroundColor: Colors.red,
                        ),
                        const SizedBox(width: 16),
                        EntryActionButton(
                          onPressed: _allowEntryPressed,
                          isLoading: _isLoadingAllow,
                          label: 'ALLOW ENTRY',
                          backgroundColor: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
    );
  }

  void _allowEntryPressed() {
    context.read<GuardWaitingBloc>().add(WaitingAllowEntry(id: widget.data!.id!));
  }

  void _denyEntryPressed() {
    context.read<GuardWaitingBloc>().add(WaitingDenyEntry(id: widget.data!.id!));
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
            CustomCachedNetworkImage(
              imageUrl: widget.data?.profileImg,
              size: 90,
              isCircular: true,
              borderWidth: 2,
              errorImage: Icons.person,
              onTap: ()=> CustomFullScreenImageViewer.show(
                context,
                widget.data?.profileImg
              ),
            ),
            const SizedBox(width: 16),
            _buildDeliveryInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DeliveryHeader(
            title: widget.data?.name ?? 'NA',
            onClose: () => Navigator.of(context).pop(),
          ),
          EntryTypeTag(entryType: widget.data!.entryType ?? ''),
          const SizedBox(height: 12),
          if (widget.data!.entryType != 'guest')
            CompanyRow(
              entryType: widget.data!.entryType ?? '',
              serviceLogo: widget.data?.serviceLogo,
              companyLogo: widget.data?.companyLogo,
              serviceName: widget.data?.serviceName,
              companyName: widget.data?.companyName,
            ),
          const SizedBox(height: 8),
          ApartmentList(
            apartments: widget.data!.societyDetails?.societyApartments
                ?.map((e) => e.apartment!)
                .toList() ?? [],
          ),
        ],
      ),
    );
  }
}
