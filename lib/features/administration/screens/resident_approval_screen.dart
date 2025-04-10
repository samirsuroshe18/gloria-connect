import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/utils/staggered_list_animation.dart';
import 'package:lottie/lottie.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:gloria_connect/features/administration/widgets/verification_request_card.dart';
import 'package:url_launcher/url_launcher.dart';

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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.response['message']!),
                  backgroundColor: Colors.green,
                ),
              );
              setState(() {
                isLoadingList[cardIndex!][button!] = false;
                context.read<AdministrationBloc>().add(AdminGetPendingResidentReq());
              });
            }
            if (state is AdminVerifyResidentFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
              setState(() {
                isLoadingList[cardIndex!][button!] = false;
              });
            }
          }
        },
        builder: (context, state) {
          if (data.isNotEmpty && _isLoading == false) {
            return RefreshIndicator(
              onRefresh: _refreshUserData,
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
                      onCall: () => onCall(data[index]),
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
            return Center(
              child: Lottie.asset(
                'assets/animations/loader.json',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            );
          } else if (data.isEmpty && _isError == true && statusCode == 401) {
            return RefreshIndicator(
              onRefresh: _refreshUserData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height - 200,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animations/error.json',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Something went wrong!",
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: _refreshUserData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height - 200,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animations/no_data.json',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "There are no resident request",
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _refreshUserData() async {
    context.read<AdministrationBloc>().add(AdminGetPendingResidentReq());
  }

  Future<void> onCall(ResidentRequestsModel data) async {
    final Uri url = Uri(
      scheme: 'tel',
      path: data.user?.phoneNo,
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not connect $url';
    }
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
