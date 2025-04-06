import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/setting/bloc/setting_bloc.dart';
import 'package:gloria_connect/features/setting/models/complaint_model.dart';
import 'package:intl/intl.dart';

import '../../auth/bloc/auth_bloc.dart';

class ComplaintDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? data;

  const ComplaintDetailsScreen({super.key, this.data});

  @override
  State<ComplaintDetailsScreen> createState() => _ComplaintDetailsScreenState();
}

class _ComplaintDetailsScreenState extends State<ComplaintDetailsScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool isResolved = false;
  final ScrollController _scrollController = ScrollController();
  List<Response>? messages = [];
  late ComplaintModel complaintModel;
  late String userId;

  @override
  void initState() {
    super.initState();
    final complaintBloc = context.read<AuthBloc>();
    final currentState = complaintBloc.state;
    if(currentState is AuthGetUserSuccess){
      userId = currentState.response.id!;
    }
    complaintModel = widget.data?['data'] != null
        ? widget.data!['data']  // Ensure proper conversion
        : ComplaintModel.fromJson(widget.data!);

    // messages = widget.data?['data'].toJson()['responses'];
    messages = complaintModel.responses;


    // isResolved = widget.data?['data']?.status != 'pending';
    isResolved = complaintModel.status != 'pending';
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      context.read<SettingBloc>().add(SettingAddResponse(
          id: complaintModel.complaintId!,
          message: _messageController.text));
      _messageController.clear();
    }
  }

  void _onIsResolved() {
    context
        .read<SettingBloc>()
        .add(SettingResolve(id: complaintModel.complaintId!));
  }

  void _onReopen() {
    context
        .read<SettingBloc>()
        .add(SettingReopen(id: complaintModel.complaintId!));
  }

  Future<void> _onRefreshResponse() async {
    context
        .read<SettingBloc>()
        .add(SettingGetResponse(id: complaintModel.complaintId!));
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
              'Complaint #${complaintModel.complaintId}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              DateFormat('MMMM d, yyyy')
                  .format(complaintModel.date ?? DateTime.now()),
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
          return RefreshIndicator(
            onRefresh: _onRefreshResponse,
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
                            (context, index) => _buildMessageBubble(
                              messages![index].toJson(),
                              widget.data,
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
        InkWell(
          onTap: () {
            if (complaintModel.imageUrl != null &&
                complaintModel.imageUrl is String) {
              _showImageDialog(complaintModel.imageUrl!);
            }
          },
          borderRadius: BorderRadius.circular(24), // To match the image shape
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
              complaintModel.imageUrl!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.report_problem_outlined,
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                complaintModel.category ?? 'NA',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                complaintModel.subCategory ?? 'NA',
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

void _showImageDialog(String imageUrl) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.black.withOpacity(0.8), // Dark background like WhatsApp
        child: GestureDetector(
          onTap: () => Navigator.pop(context), // Close when tapped
          child: InteractiveViewer(
            panEnabled: true, // Allow panning
            minScale: 0.5,
            maxScale: 3.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      );
    },
  );
}

  Widget _buildDetailContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailItem(
            icon: Icons.location_on_outlined,
            title: 'Location',
            content: complaintModel.area ?? 'NA',
          ),
          const SizedBox(height: 16),
          _buildDetailItem(
            icon: Icons.description_outlined,
            title: 'Description',
            content: complaintModel.description ?? 'NA',
          ),
          const SizedBox(height: 16),
          _buildDetailItem(
            icon: Icons.message_outlined,
            title: 'Responses',
            content: '${messages?.length} messages',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.white70),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(
      Map<String, dynamic> message, Map<String, dynamic>? data) {
    // complaintModel.responses?[0].id
    final isMe = userId == message['responseBy']['_id'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) _buildAvatar(message['responseBy']),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? Theme.of(context).primaryColor : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message['responseBy']['userName'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isMe ? Colors.white : Colors.black87,
                          fontSize: 13,
                        ),
                      ),
                      if (message['responseBy']['role'] == 'admin')
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isMe
                                ? Colors.white.withOpacity(0.2)
                                : Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Admin',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isMe
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message['message'],
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM d, h:mm a').format(
                      DateTime.parse(message['date']),
                    ),
                    style: TextStyle(
                      fontSize: 11,
                      color:
                          isMe ? Colors.white.withOpacity(0.7) : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isMe) _buildAvatar(message['responseBy']),
        ],
      ),
    );
  }

  Widget _buildAvatar(Map<String, dynamic> user) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
      backgroundImage: user['profile'] != null && user['profile'].isNotEmpty
          ? NetworkImage(user['profile'])
          : null,
      child: (user['profile'] == null || user['profile'].isEmpty)
          ? Text(
              user['userName'][0].toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            )
          : null,
    );
  }

  Widget _buildBottomSection() {
    if (isResolved) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: OutlinedButton.icon(
          onPressed: _onReopen,
          icon: const Icon(Icons.refresh, color: Colors.white70,),
          label: const Text('Reopen Complaint', style: TextStyle(color: Colors.white70),),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            minimumSize: const Size(double.infinity, 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _messageController,
            decoration: InputDecoration(
              hintText: 'Type your message...',
              hintStyle: const TextStyle(color: Colors.white60),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.black.withOpacity(0.2),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.white70,
                ),
                onPressed: _sendMessage,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _onIsResolved,
            icon: const Icon(Icons.check_circle_outline, color: Colors.white70,),
            label: const Text('Mark as Resolved',style: TextStyle(color: Colors.white70),),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              minimumSize: const Size(double.infinity, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.deepPurple.withOpacity(0.5)
            ),
          ),
        ],
      ),
    );
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

    if (state is SettingGetResponseSuccess) {
      messages = state.response.toJson()['responses'];
      isResolved = state.response.status == 'resolved';
      complaintModel = state.response;
    }

    if (state is SettingGetResponseFailure) {
      _showErrorSnackBar(state.message);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[700],
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
