import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/common_widgets/data_not_found_widget.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
import 'package:gloria_connect/utils/phone_utils.dart';
import 'package:gloria_connect/common_widgets/staggered_list_animation.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:gloria_connect/features/administration/widgets/verification_request_card.dart';

import '../bloc/administration_bloc.dart';
import '../models/resident_requests_model.dart';

class ResidentApprovalScreen extends StatefulWidget {
  const ResidentApprovalScreen({super.key});

  @override
  State<ResidentApprovalScreen> createState() => _ResidentApprovalScreenState();
}

class _ResidentApprovalScreenState extends State<ResidentApprovalScreen> {
  List<ResidentRequestsModel> data = [];
  int? cardIndex;
  String? button;
  List<Map<String, bool>> isLoadingList = [];
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;

  @override
  void initState() {
    super.initState();
    context.read<AdministrationBloc>().add(AdminGetPendingResidentReq());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Resident Approval',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.withOpacity(0.2),
      ),
      body: BlocConsumer<AdministrationBloc, AdministrationState>(
        listener: (context, state) {
          if (state is AdminGetPendingResidentReqLoading) {
            setState(() {
              _isLoading = true;
              _isError = false;
            });
          }
          if (state is AdminGetPendingResidentReqSuccess) {
            setState(() {
              _isLoading = false;
              _isError = false;
              data = state.response;
              isLoadingList = List.generate(data.length, (index) => {
                'approve': false, 'reject': false
              },);
            });
          }
          if (state is AdminGetPendingResidentReqFailure) {
            setState(() {
              _isLoading = false;
              _isError = true;
              data = [];
              statusCode = state.status;
            });
          }

          // Ensure cardIndex and button are valid before using them
          if (cardIndex != null && button != null) {
            if (state is AdminVerifyResidentLoading) {
              setState(() {
                isLoadingList[cardIndex!][button!] = true;
              });
            }

            if (state is AdminVerifyResidentSuccess) {
              CustomSnackBar.show(context: context, message: state.response['message'], type: SnackBarType.success);
              setState(() {
                isLoadingList[cardIndex!][button!] = false;
                context.read<AdministrationBloc>().add(AdminGetPendingResidentReq());
              });
            }
            if (state is AdminVerifyResidentFailure) {
              CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
              setState(() {
                isLoadingList[cardIndex!][button!] = false;
              });
            }
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
                      profileImageUrl: data[index].user?.profile ?? '', // Access with index
                      userName: data[index].user!.userName!, // Access with index
                      role: data[index].profileType!, // Access with index
                      societyName: data[index].societyName!, // Access with index
                      blockName: data[index].societyBlock!, // Access with index
                      apartment: data[index].apartment!,
                      isLoadingApprove: isLoadingList[index]['approve'] ?? false,
                      isLoadingReject: isLoadingList[index]['reject'] ?? false,
                      date: '${data[index].createdAt!.day}/${data[index].createdAt!.month}/${data[index].createdAt!.year}',
                      tagColor: Colors.orange,
                      time: timeago.format(data[index].createdAt!),
                      onApprove: () => onApprove(data[index], index),
                      onReject: () => onReject(data[index], index),
                      onCall: () => PhoneUtils.makePhoneCall(context, data[index].user?.phoneNo ?? ''),
                      profileType: data[index].profileType,
                      ownership: data[index].ownership,
                      tenantAgreement: data[index].tenantAgreement,
                      ownershipDocument: data[index].ownershipDocument,
                      startDate: data[index].startDate,
                      endDate: data[index].endDate,
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
            return DataNotFoundWidget(onRefresh: _onRefresh, infoMessage: 'There are no resident request',);
          }
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    context.read<AdministrationBloc>().add(AdminGetPendingResidentReq());
  }

  void onApprove(ResidentRequestsModel data, int index) {
    cardIndex = index;
    button = 'approve';
    context.read<AdministrationBloc>().add(
      AdminVerifyResident(
        requestId: data.id!,
        user: data.user!.id!,
        residentStatus: 'approve',
      ),
    );
  }

  void onReject(ResidentRequestsModel data, int index) {
    cardIndex = index;
    button = 'reject';
    context.read<AdministrationBloc>().add(
      AdminVerifyResident(
        requestId: data.id!,
        user: data.user!.id!,
        residentStatus: 'rejected',
      ),
    );
  }
}