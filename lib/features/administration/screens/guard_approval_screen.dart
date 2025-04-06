import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/administration/bloc/administration_bloc.dart';
import 'package:gloria_connect/features/administration/models/guard_requests_model.dart';
import 'package:lottie/lottie.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:gloria_connect/features/administration/widgets/verification_request_card.dart';
import 'package:url_launcher/url_launcher.dart';

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
        backgroundColor: Colors.black.withOpacity(0.2),
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.response['message']!),
                backgroundColor: Colors.green,
              ),
            );
            setState(() {
              isLoadingList[cardIndex!][button!] = false;
            });
            context.read<AdministrationBloc>().add(AdminGetPendingGuardReq());
          }
          if (state is AdminVerifyGuardFailure) {
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
        },
        builder: (context, state) {
          if (data.isNotEmpty && _isLoading == false) {
            return RefreshIndicator(
              onRefresh: _refreshUserData,
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return VerificationRequestCard(
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
                    onCall: () => onCall(data[index]),
                  );
                },
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
                        "There are no Guard request",
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
    context.read<AdministrationBloc>().add(AdminGetPendingGuardReq());
  }

  Future<void> onCall(GuardRequestsModel data) async {
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
