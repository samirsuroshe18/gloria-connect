import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/common_widgets/data_not_found_widget.dart';
import 'package:gloria_connect/features/guard_waiting/bloc/guard_waiting_bloc.dart';
import 'package:gloria_connect/features/guard_waiting/widgets/apartment_list.dart';
import 'package:gloria_connect/features/guard_waiting/widgets/company_row.dart';
import 'package:gloria_connect/features/guard_waiting/widgets/delivery_header.dart';
import 'package:gloria_connect/features/guard_waiting/widgets/entry_action_button.dart';
import 'package:gloria_connect/features/guard_waiting/widgets/entry_type_tag.dart';
import 'package:gloria_connect/features/guard_waiting/widgets/flat_row.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';

import '../models/entry.dart';

class ViewResidentApproval extends StatefulWidget {
  final VisitorEntries? data;
  const ViewResidentApproval({super.key, this.data});

  @override
  State<ViewResidentApproval> createState() => _ViewResidentApprovalState();
}

class _ViewResidentApprovalState extends State<ViewResidentApproval> {
  VisitorEntries? visitorEntryModel;
  bool _isLoading = false;
  bool _isLoadingAllow = false;
  bool _isLoadingDeny = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<GuardWaitingBloc>().add(WaitingGetEntry(id: widget.data!.id!));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    context.read<GuardWaitingBloc>().add(WaitingGetEntry(id: widget.data!.id!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Residents Approval',
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: Colors.black.withValues(alpha: 0.2),
      ),
      body: BlocConsumer<GuardWaitingBloc, GuardWaitingState>(
        listener: (context, state) {
          if (state is WaitingAllowEntryLoading) {
            _isLoadingAllow = true;
          }
          if (state is WaitingAllowEntrySuccess) {
            _isLoadingAllow = false;
            if (mounted) {
              CustomSnackBar.show(
                  context: context,
                  message: state.response['message'],
                  type: SnackBarType.success);
              context.read<GuardWaitingBloc>().add(WaitingGetEntries());
              Navigator.pop(context);
            }
          }
          if (state is WaitingAllowEntryFailure) {
            CustomSnackBar.show(
                context: context,
                message: state.message,
                type: SnackBarType.error);
            _isLoadingAllow = false;
          }
          if (state is WaitingDenyEntryLoading) {
            _isLoadingDeny = true;
          }
          if (state is WaitingDenyEntrySuccess) {
            _isLoadingDeny = false;
            if (mounted) {
              CustomSnackBar.show(
                  context: context,
                  message: state.response['message'],
                  type: SnackBarType.success);
              context.read<GuardWaitingBloc>().add(WaitingGetEntries());
              Navigator.pop(context);
            }
          }
          if (state is WaitingDenyEntryFailure) {
            CustomSnackBar.show(
                context: context,
                message: state.message,
                type: SnackBarType.error);
            _isLoadingDeny = false;
          }

          if (state is WaitingGetEntryLoading) {
            _isLoading = true;
          }
          if (state is WaitingGetEntrySuccess) {
            visitorEntryModel = state.response;
            _isLoading = false;
          }
          if (state is WaitingGetEntryFailure) {
            visitorEntryModel = null;
            _isLoading = false;
          }
        },
        builder: (context, state) {
          if (visitorEntryModel != null && _isLoading == false) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: _buildContentView(),
            );
          } else if (_isLoading) {
            return const CustomLoader();
          } else {
            return DataNotFoundWidget(
              onRefresh: _onRefresh,
              infoMessage: 'No data available',
            );
          }
        },
      ),
    );
  }

  Widget _buildContentView() {
    return Stack(
      children: [
        // Scrollable content area
        Padding(
          padding: const EdgeInsets.only(bottom: 80), // Add bottom padding for button space
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      _buildDeliveryCard(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              
              // Flats list
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                sliver: SliverAnimatedList(
                  initialItemCount: visitorEntryModel?.societyDetails
                          ?.societyApartments?.length ??
                      0,
                  itemBuilder: (context, index, animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: FadeTransition(
                        opacity: animation,
                        child: FlatRow(
                          data: visitorEntryModel?.societyDetails!
                              .societyApartments![index],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        
        // Fixed action buttons at bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
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
          ),
        ),
      ],
    );
  }

  void _allowEntryPressed() {
    context
        .read<GuardWaitingBloc>()
        .add(WaitingAllowEntry(id: visitorEntryModel!.id!));
  }

  void _denyEntryPressed() {
    context
        .read<GuardWaitingBloc>()
        .add(WaitingDenyEntry(id: visitorEntryModel!.id!));
  }

  Widget _buildDeliveryCard() {
    return Card(
      color: Colors.black.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCachedNetworkImage(
              imageUrl: visitorEntryModel?.profileImg,
              size: 90,
              isCircular: true,
              borderWidth: 2,
              errorImage: Icons.person,
              onTap: () => CustomFullScreenImageViewer.show(
                  context, visitorEntryModel?.profileImg),
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
            title: visitorEntryModel?.name ?? 'NA',
            onClose: () => Navigator.of(context).pop(),
          ),
          EntryTypeTag(entryType: visitorEntryModel!.entryType ?? ''),
          const SizedBox(height: 12),
          if (visitorEntryModel!.entryType != 'guest')
            CompanyRow(
              entryType: visitorEntryModel!.entryType ?? '',
              serviceLogo: visitorEntryModel?.serviceLogo,
              companyLogo: visitorEntryModel?.companyLogo,
              serviceName: visitorEntryModel?.serviceName,
              companyName: visitorEntryModel?.companyName,
            ),
          const SizedBox(height: 8),
          ApartmentList(
            apartments: visitorEntryModel!.societyDetails?.societyApartments
                    ?.map((e) => e.apartment!)
                    .toList() ??
                [],
          ),
        ],
      ),
    );
  }
}