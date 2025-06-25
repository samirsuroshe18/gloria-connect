import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/config/theme/app_colors.dart';
import 'package:gloria_connect/features/auth/bloc/auth_bloc.dart';
import 'package:gloria_connect/features/setting/bloc/setting_bloc.dart';
import 'package:gloria_connect/features/setting/models/complaint_model.dart';
import 'package:gloria_connect/features/setting/widgets/build_detail_item.dart';
import 'package:gloria_connect/features/setting/widgets/build_message_bubble.dart';
import 'package:gloria_connect/features/setting/widgets/pending_bottom_section.dart';
import 'package:gloria_connect/features/setting/widgets/resolved_bottom_section.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:gloria_connect/features/administration/models/technician_model.dart';

class ResidentComplaintDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const ResidentComplaintDetailsScreen({super.key, required this.data});

  @override
  State<ResidentComplaintDetailsScreen> createState() => _ResidentComplaintDetailsScreenState();
}

class _ResidentComplaintDetailsScreenState extends State<ResidentComplaintDetailsScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool isResolved = false;
  final ScrollController _scrollController = ScrollController();
  List<Response>? messages = [];
  Complaint? complaintModel;
  late String userId;
  bool _isLoading = false;
  bool _isActionLoading = false;
  bool _isMessageLoading = false;
  int? statusCode;
  String complaintId = "...";
  DateTime? complaintDate;
  Technician? _assignedTechnician;

  // Mock work done data
  final String workDonePhoto = '';
  final String workDoneDescription = 'Technician fixed the issue and replaced the faulty part. The complaint is now resolved.';

  @override
  void initState() {
    super.initState();
    final complaintBloc = context.read<AuthBloc>();
    final currentState = complaintBloc.state;
    if (currentState is AuthGetUserSuccess) {
      userId = currentState.response.id!;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
          _buildAssignedTechnicianInfo(),
          if(complaintModel?.assignStatus == 'assigned')
            _buildResolutionStatus(),
          if(complaintModel?.resolution?.status == 'approved')
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pushNamed(context, '/work-approval-screen', arguments: {'userRole':'resident', 'complaint': complaintModel});
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

  Widget _buildResolutionStatus(){
    final statusData = _getStatusDetails(complaintModel?.resolution?.status);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusData.color.withValues(alpha: 0.1),
          child: Icon(statusData.icon, color: statusData.color),
        ),
        title: Text(
          statusData.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: statusData.color,
          ),
        ),
        subtitle: Text(
          statusData.message,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  _StatusDetails _getStatusDetails(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return _StatusDetails(
          title: 'Approved',
          message: 'The resolution has been approved by the administrator.',
          icon: Icons.check_circle_outline,
          color: Colors.green,
        );
      case 'rejected':
        return _StatusDetails(
          title: 'Rejected',
          message: 'The resolution was rejected and needs rework.',
          icon: Icons.cancel_outlined,
          color: Colors.red,
        );
      case 'under_review':
        return _StatusDetails(
          title: 'Under Review',
          message: 'The resolution is currently being reviewed by the administrator.',
          icon: Icons.sync_problem,
          color: Colors.orange,
        );
      case 'pending':
      default:
        return _StatusDetails(
          title: 'Pending',
          message: 'The resolution is pending admin review.',
          icon: Icons.hourglass_top,
          color: Colors.grey,
        );
    }
  }

  Widget _buildAssignedTechnicianInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Assigned to:',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          if (complaintModel?.assignStatus == 'assigned')
            Row(
              children: [
                CustomCachedNetworkImage(
                  isCircular: true,
                  size: 40,
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
                        complaintModel?.technicianId?.userName ?? 'Not assigned',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        complaintModel?.technicianId?.role ?? 'Role not specified',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            const Text(
              'No technician assigned yet',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
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

class _StatusDetails {
  final String title;
  final String message;
  final IconData icon;
  final Color color;

  _StatusDetails({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
  });
}