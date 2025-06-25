import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/features/administration/bloc/administration_bloc.dart';
import 'package:gloria_connect/features/setting/bloc/setting_bloc.dart';
import 'package:gloria_connect/features/setting/models/complaint_model.dart';
import 'package:gloria_connect/features/setting/widgets/build_detail_item.dart';
import 'package:gloria_connect/features/setting/widgets/build_message_bubble.dart';
import 'package:gloria_connect/features/setting/widgets/pending_bottom_section.dart';
import 'package:gloria_connect/features/setting/widgets/resolved_bottom_section.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../../auth/bloc/auth_bloc.dart';
import 'package:gloria_connect/config/theme/app_colors.dart';
import 'package:gloria_connect/features/administration/models/technician_model.dart';

class AdminComplaintDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const AdminComplaintDetailsScreen({super.key, required this.data});

  @override
  State<AdminComplaintDetailsScreen> createState() => _AdminComplaintDetailsScreenState();
}

class _AdminComplaintDetailsScreenState extends State<AdminComplaintDetailsScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool isResolved = false;
  final ScrollController _scrollController = ScrollController();
  List<Response>? messages = [];
  Complaint? complaintModel;
  late String userId;
  bool _isLoading = false;
  bool _isSaveLoading = false;
  bool _isActionLoading = false;
  bool _isMessageLoading = false;
  int? statusCode;
  String complaintId = "...";
  DateTime? complaintDate;
  Technician? _assignedTechnician;
  String? resolutionStatus;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthGetUserSuccess) {
      userId = authState.response.id!;
    } else {
    }
    context.read<SettingBloc>().add(SettingGetResponse(id: widget.data['id']));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      context.read<SettingBloc>().add(
        SettingAddResponse(
          id: complaintModel!.complaintId!,
          message: _messageController.text,
        ),
      );
      _messageController.clear();
    }
  }

  void _onIsResolved() {
    context.read<SettingBloc>().add(SettingResolve(id: complaintModel!.complaintId!));
  }

  void _onReopen() {
    context.read<SettingBloc>().add(SettingReopen(id: complaintModel!.complaintId!));
  }

  Future<void> _onRefresh() async {
    context.read<SettingBloc>().add(SettingGetResponse(id: widget.data['id']));
  }

  void _navigateAndSelectTechnician() async {
    final selected = await Navigator.pushNamed(context, '/tech-selection-screen');
    if (selected != null && selected is Technician) {
      setState(() {
        _assignedTechnician = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.2),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Complaint #$complaintId',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              complaintDate != null
                  ? DateFormat('MMMM d, yyyy').format(complaintDate!)
                  : 'NA',
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white70),
          onPressed: () => Navigator.pop(context, complaintModel),
        ),
        actions: [
          _buildStatusChip(),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocConsumer<SettingBloc, SettingState>(
        listener: _blocListener,
        builder: (context, state) {
          return BlocConsumer<AdministrationBloc, AdministrationState>(
            listener: (context, state) {
              if (state is AssignTechnicianLoading) {
                _isSaveLoading = true;
              }
              if (state is AssignTechnicianSuccess) {
                _isSaveLoading = false;
                complaintModel = state.response;
                resolutionStatus = complaintModel?.resolution?.status ?? 'pending';
              }
              if (state is AssignTechnicianFailure) {
                _isSaveLoading = false;
                CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
              }
            },
            builder: (context, state) {
              if (complaintModel != null && _isLoading == false) {
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(child: _buildComplaintDetails()),
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) => BuildMessageBubble(
                              message: messages![index].toJson(),
                              userId: userId,
                            ),
                            childCount: messages?.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (_isLoading) {
                return const CustomLoader();
              } else {
                return BuildErrorState(onRefresh: _onRefresh);
              }
            }
          );
        },
      ),
      bottomNavigationBar: _buildBottomSection(),
    );
  }

  Widget _buildStatusChip() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isResolved ? Colors.green : Colors.orange,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isResolved ? Icons.check_circle : Icons.pending,
            size: 14,
            color: Colors.white70,
          ),
          const SizedBox(width: 4),
          Text(
            isResolved ? 'Resolved' : 'Pending',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintDetails() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailHeader(),
          const Divider(height: 1),
          _buildDetailContent(),
          const Divider(height: 1),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildDetailHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CustomCachedNetworkImage(
            size: 48,
            borderWidth: 2,
            errorImage: Icons.report_problem_outlined,
            isCircular: true,
            imageUrl: complaintModel?.imageUrl,
            onTap: ()=> CustomFullScreenImageViewer.show(
                context,
                complaintModel?.imageUrl,
                errorImage: Icons.report_problem_outlined
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  complaintModel?.category ?? 'NA',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  complaintModel?.subCategory ?? 'NA',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildDetailItem(
            icon: Icons.location_on_outlined,
            title: 'Location',
            content: complaintModel?.area ?? 'NA',
          ),
          const SizedBox(height: 12),
          BuildDetailItem(
            icon: Icons.notes,
            title: 'Description',
            content: complaintModel?.description ?? 'NA',
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAssignedTechnicianInfo(),
          const SizedBox(height: 10),
          if(resolutionStatus != 'pending')
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pushNamed(context, '/work-approval-screen', arguments: {'userRole':'admin', 'complaint': complaintModel});
              },
              icon: const Icon(Icons.visibility, size: 18),
              label: const Text('View'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryButtonColor,
                foregroundColor: AppColors.buttonTextColor,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAssignedTechnicianInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (complaintModel?.assignStatus == 'unassigned') ...[
          ElevatedButton.icon(
            onPressed: _navigateAndSelectTechnician,
            icon: const Icon(Icons.person_add, size: 18),
            label: const Text('Assign Technician'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryButtonColor,
              foregroundColor: AppColors.buttonTextColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          if (_assignedTechnician != null) ...[
            const Text(
              'Assigned to:',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                CustomCachedNetworkImage(
                  isCircular: true,
                  size: 20,
                  imageUrl: _assignedTechnician?.profile,
                  errorImage: Icons.person,
                  borderWidth: 1,
                  onTap: ()=> CustomFullScreenImageViewer.show(context, _assignedTechnician?.profile, errorImage: Icons.person),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _assignedTechnician?.userName ?? 'NA',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _assignedTechnician?.role ?? 'NA',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _isSaveLoading ? null : () {
                    context.read<AdministrationBloc>().add(
                      AssignTechnician(
                        complaintId: complaintModel!.id!,
                        technicianId: _assignedTechnician!.id!,
                      ),
                    );
                  },
                  icon: _isSaveLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : const Icon(Icons.save),
                  label: Text(_isSaveLoading ? 'Saving...' : 'Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryButtonColor,
                    foregroundColor: AppColors.buttonTextColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],

        if (complaintModel?.assignStatus == 'assigned') ...[
          const Text(
            'Assigned to:',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CustomCachedNetworkImage(
                isCircular: true,
                size: 20,
                imageUrl: complaintModel?.technicianId?.profile,
                errorImage: Icons.person,
                borderWidth: 1,
                onTap: ()=> CustomFullScreenImageViewer.show(context, _assignedTechnician?.profile, errorImage: Icons.person),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      complaintModel?.technicianId?.userName ?? 'NA',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      complaintModel?.technicianId?.role ?? 'NA',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if(complaintModel?.status != 'resolved')
          Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: _getStatusColorForText(complaintModel?.resolution?.status ?? 'pending'),
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _getStatusMessage(complaintModel?.resolution?.status ?? 'pending'),
                      style: TextStyle(
                        color: _getStatusColorForText(complaintModel?.resolution?.status ?? 'pending'),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }

  Color _getStatusColorForText(String status) {
    switch (status) {
      case 'approved':
        return Colors.green; // Success
      case 'rejected':
        return Colors.red; // Error or Rejected
      case 'under_review':
        return Colors.orange; // In Review
      case 'pending':
        return Colors.amber; // Waiting on action
      default:
        return Colors.grey; // Unknown or default
    }
  }

  String _getStatusMessage(String status) {
    switch (status) {
      case 'approved':
        return 'Complaint resolution approved. Awaiting resident action.';
      case 'rejected':
        return 'Rework requested. Awaiting technician action.';
      case 'under_review':
        return 'Complaint resolution pending review.';
      case 'pending':
        return 'Awaiting complaint resolution from technician.';
      default:
        return 'Awaiting complaint resolution from technician.';
    }
  }

  void _blocListener(BuildContext context, SettingState state) {
    if (state is SettingAddResponseLoading) {
      setState(() {
        _isMessageLoading = true;
      });
    }

    if (state is SettingAddResponseSuccess) {
      setState(() {
        _isMessageLoading = false;
      });
      if (state.response.responses!.isNotEmpty) {
        messages?.add(state.response.responses![state.response.responses!.length - 1]);
        complaintModel = state.response;

        // Scroll to bottom after adding new message
        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    }

    if (state is SettingAddResponseFailure) {
      setState(() {
        _isMessageLoading = false;
      });
      _showErrorSnackBar(state.message);
    }

    if (state is SettingResolveLoading) {
      setState(() {
        _isActionLoading = true;
      });
    }

    if (state is SettingResolveSuccess) {
      setState(() {
        isResolved = state.response.status == 'resolved';
        _isActionLoading = false;
      });
      complaintModel = state.response;
    }

    if (state is SettingResolveFailure) {
      setState(() {
        _isActionLoading = false;
      });
      _showErrorSnackBar(state.message);
    }

    if (state is SettingReopenLoading) {
      setState(() {
        _isActionLoading = true;
      });
    }

    if (state is SettingReopenSuccess) {
      setState(() {
        _isActionLoading = false;
        isResolved = state.response.status == 'resolved';
      });
      complaintModel = state.response;
    }

    if (state is SettingReopenFailure) {
      setState(() {
        _isActionLoading = false;
      });
      _showErrorSnackBar(state.message);
    }

    if (state is SettingGetResponseLoading) {
      _isLoading = true;
    }

    if (state is SettingGetResponseSuccess) {
      complaintModel = state.response;
      messages = complaintModel!.responses;
      isResolved = complaintModel!.status != 'pending';
      setState(() {
        complaintId = complaintModel!.complaintId!;
        complaintDate = complaintModel!.createdAt!;
      });
      _isLoading = false;
    }
    if (state is SettingGetResponseFailure) {
      complaintModel = null;
      _isLoading = false;
      statusCode = state.status;
      _showErrorSnackBar(state.message);
    }
  }

  Widget _buildBottomSection() {
    if (_isActionLoading) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: CustomLoader(),
      );
    }
    if (isResolved) {
      return ResolvedBottomSection(
        isActionLoading: _isActionLoading,
        onReopen: _onReopen,
      );
    } else {
      return PendingBottomSection(
        messageController: _messageController,
        sendMessage: _sendMessage,
        onIsResolved: _onIsResolved,
        isActionLoading: _isActionLoading,
        isLoading: _isMessageLoading,
      );
    }
  }

  void _showErrorSnackBar(String message) {
    CustomSnackBar.show(context: context, message: message, type: SnackBarType.error);
  }
}