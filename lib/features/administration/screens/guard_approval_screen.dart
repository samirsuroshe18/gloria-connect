import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/common_widgets/data_not_found_widget.dart';
import 'package:gloria_connect/features/administration/bloc/administration_bloc.dart';
import 'package:gloria_connect/features/administration/models/guard_requests_model.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
import 'package:gloria_connect/utils/phone_utils.dart';
import 'package:gloria_connect/common_widgets/staggered_list_animation.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:gloria_connect/features/administration/widgets/verification_request_card.dart';

class GuardApprovalScreen extends StatefulWidget {
  const GuardApprovalScreen({super.key});

  @override
  State<GuardApprovalScreen> createState() => _GuardApprovalScreenState();
}

class _GuardApprovalScreenState extends State<GuardApprovalScreen> {
  List<GuardRequestsModel> data = [];
  int? cardIndex;
  String? button;
  List<Map<String, bool>> isLoadingList = [];
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;

  @override
  void initState() {
    super.initState();
    context.read<AdministrationBloc>().add(AdminGetPendingGuardReq());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Guard Approval',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black.withValues(alpha: 0.2),
      ),
      body: BlocConsumer<AdministrationBloc, AdministrationState>(
        listener: (context, state) {
          if (state is AdminGetPendingGuardReqLoading) {
            setState(() {
              _isLoading = true;
              _isError = false;
            });
          }
          if (state is AdminGetPendingGuardReqSuccess) {
            setState(() {
              _isLoading = false;
              _isError = false;
              data = state.response;
              isLoadingList = List.generate(data.length, (index) => {
                  'approve': false, 'reject': false
                },
              );
            });
          }
          if (state is AdminGetPendingGuardReqFailure) {
            setState(() {
              _isLoading = false;
              _isError = true;
              data = [];
              statusCode = state.status;
            });
          }

          if (state is AdminVerifyGuardLoading) {
            setState(() {
              isLoadingList[cardIndex!][button!] = true;
            });
          }

          if (state is AdminVerifyGuardSuccess) {
            CustomSnackBar.show(context: context, message: state.response['message'], type: SnackBarType.success);
            setState(() {
              isLoadingList[cardIndex!][button!] = false;
            });
            context.read<AdministrationBloc>().add(AdminGetPendingGuardReq());
          }
          if (state is AdminVerifyGuardFailure) {
            CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
            setState(() {
              isLoadingList[cardIndex!][button!] = false;
            });
          }
        },
        builder: (context, state) {
          if (data.isNotEmpty && _isLoading == false) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: AnimationLimiter(
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return StaggeredListAnimation(index: index, child: VerificationRequestCard(
                      profileImageUrl: data[index].user?.profile ?? '',
                      userName: data[index].user?.userName ?? 'NA',
                      role: data[index].profileType ?? 'NA',
                      societyName: data[index].societyName ?? 'NA',
                      gateAssign: data[index].gateAssign ?? 'NA',
                      isLoadingApprove: isLoadingList[index]['approve']!,
                      isLoadingReject: isLoadingList[index]['reject']!,
                      date: data[index].createdAt != null
                          ? '${data[index].createdAt!.day}/${data[index].createdAt!.month}/${data[index].createdAt!.year}'
                          : 'NA',
                      tagColor: Colors.orange,
                      time: timeago.format(data[index].createdAt ?? DateTime.now()),
                      onApprove: () => onApprove(data[index], index),
                      onReject: () => onReject(data[index], index),
                      onCall: () => PhoneUtils.makePhoneCall(context, data[index].user?.phoneNo ?? ''),
                    ));
                  },
                ),
              ),
            );
          } else if (_isLoading) {
            return const CustomLoader();
          } else if (data.isEmpty && _isError == true && statusCode == 401) {
            return BuildErrorState(onRefresh: _onRefresh);
          } else {
            return DataNotFoundWidget(onRefresh: _onRefresh, infoMessage: 'There are no Guard request',);
          }
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    context.read<AdministrationBloc>().add(AdminGetPendingGuardReq());
  }

  void onApprove(GuardRequestsModel data, int index) {
    setState(() {
      cardIndex = index;
      button = 'approve';
    });
    context.read<AdministrationBloc>().add(AdminVerifyGuard(requestId: data.id!, user: data.user!.id!, guardStatus: 'approve'));
  }

  void onReject(GuardRequestsModel data, int index) {
    setState(() {
      cardIndex = index;
      button = 'reject';
    });
    context.read<AdministrationBloc>().add(AdminVerifyGuard(requestId: data.id!, user: data.user!.id!, guardStatus: 'rejected'));
  }
}
