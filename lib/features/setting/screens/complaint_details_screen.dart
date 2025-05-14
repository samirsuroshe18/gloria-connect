import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
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

class ComplaintDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const ComplaintDetailsScreen({super.key, required this.data});

  @override
  State<ComplaintDetailsScreen> createState() => _ComplaintDetailsScreenState();
}

class _ComplaintDetailsScreenState extends State<ComplaintDetailsScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool isResolved = false;
  final ScrollController _scrollController = ScrollController();
  List<Response>? messages = [];
  Complaint? complaintModel;
  late String userId;
  bool _isLoading = false;
  int? statusCode;
  String complaintId = "...";
  DateTime? complaintDate;

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
        backgroundColor: Colors.black.withOpacity(0.2),
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
              child: Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverToBoxAdapter(
                          child: _buildComplaintDetails(),
                        ),
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
                  ),
                  _buildBottomSection(),
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
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailHeader(),
          const Divider(height: 1),
          _buildDetailContent(),
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
          const SizedBox(height: 16),
          BuildDetailItem(
            icon: Icons.description_outlined,
            title: 'Description',
            content: complaintModel?.description ?? 'NA',
          ),
          const SizedBox(height: 16),
          BuildDetailItem(
            icon: Icons.message_outlined,
            title: 'Responses',
            content: '${messages?.length} messages',
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    if (isResolved) {
      return ResolvedBottomSection(onReopen: _onReopen);
    }

    return PendingBottomSection(messageController: _messageController, sendMessage: _sendMessage, onIsResolved: _onIsResolved);
  }

  void _blocListener(BuildContext context, SettingState state) {
    if (state is SettingAddResponseLoading) {}

    if (state is SettingAddResponseSuccess) {
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
      _showErrorSnackBar(state.message);
    }

    if (state is SettingResolveLoading) {
      // Show loading indicator if needed
    }

    if (state is SettingResolveSuccess) {
      setState(() {
        isResolved = state.response.status == 'resolved';
      });
      complaintModel = state.response;
    }

    if (state is SettingResolveFailure) {
      _showErrorSnackBar(state.message);
    }

    if (state is SettingReopenLoading) {
      // Show loading indicator if needed
    }

    if (state is SettingReopenSuccess) {
      setState(() {
        isResolved = state.response.status == 'resolved';
      });
      complaintModel = state.response;
    }

    if (state is SettingReopenFailure) {
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

  void _showErrorSnackBar(String message) {
    CustomSnackBar.show(context: context, message: message, type: SnackBarType.error);
  }
}
