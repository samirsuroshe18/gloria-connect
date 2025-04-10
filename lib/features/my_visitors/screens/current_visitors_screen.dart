import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/features/my_visitors/bloc/my_visitors_bloc.dart';
import 'package:gloria_connect/features/my_visitors/widgets/visitor_current_card.dart';
import 'package:gloria_connect/features/notice_board/models/notice_board_model.dart';
import 'package:gloria_connect/utils/notification_service.dart';
import 'package:gloria_connect/utils/staggered_list_animation.dart';
import 'package:lottie/lottie.dart';

import '../../guard_waiting/models/entry.dart';

class CurrentVisitorsScreen extends StatefulWidget {
  const CurrentVisitorsScreen({super.key});

  @override
  State<CurrentVisitorsScreen> createState() => _CurrentVisitorsScreenState();
}

class _CurrentVisitorsScreenState extends State<CurrentVisitorsScreen>
    with AutomaticKeepAliveClientMixin {
  ReceivedAction? initialAction;
  List<VisitorEntries> data = [];
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;

  void getInitialAction() async {
    initialAction = NotificationController.initialAction;
    if (mounted) {
      if (initialAction != null &&
          jsonDecode(initialAction!.payload!['data']!)['action'] == 'VERIFY_RESIDENT_PROFILE_TYPE') {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/resident-approval',
          (route) => route.isFirst,
        );
      } else if (initialAction != null &&
          jsonDecode(initialAction!.payload!['data']!)['action'] == 'VERIFY_GUARD_PROFILE_TYPE') {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/guard-approval',
          (route) => route.isFirst,
        );
      } else if (initialAction != null &&
          initialAction?.payload?['action'] == 'VERIFY_DELIVERY_ENTRY') {
        Navigator.pushNamedAndRemoveUntil(
            context, '/delivery-approval-screen', (route) => route.isFirst,
            arguments: initialAction?.payload);
      }else if (initialAction != null &&
          jsonDecode(initialAction!.payload!['data']!)['action'] == 'NOTIFY_NOTICE_CREATED') {
        Navigator.pushNamedAndRemoveUntil(
            context, '/notice-board-details-screen', (route) => route.isFirst,
            arguments: NoticeBoardModel.fromJson(jsonDecode(initialAction!.payload!['data']!)));
      }else if (initialAction != null &&
          jsonDecode(initialAction!.payload!['data']!)['action'] == 'NOTIFY_COMPLAINT_CREATED') {
        Navigator.pushNamedAndRemoveUntil(
            context, '/complaint-details-screen', (route) => route.isFirst,
            arguments: {'id': jsonDecode(initialAction!.payload!['data']!)['id']});
      }else if (initialAction != null &&
          jsonDecode(initialAction!.payload!['data']!)['action'] == 'NOTIFY_RESIDENT_REPLIED') {
        Navigator.pushNamedAndRemoveUntil(
            context, '/complaint-details-screen', (route) => route.isFirst,
            arguments: {'id': jsonDecode(initialAction!.payload!['data']!)['id']});
      }else if (initialAction != null &&
          jsonDecode(initialAction!.payload!['data']!)['action'] == 'NOTIFY_ADMIN_REPLIED') {
        Navigator.pushNamedAndRemoveUntil(
            context, '/complaint-details-screen', (route) => route.isFirst,
            arguments: {'id': jsonDecode(initialAction!.payload!['data']!)['id']});
      } else {
        context.read<MyVisitorsBloc>().add(GetServiceRequest());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<MyVisitorsBloc>().add(GetCurrentEntries());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getInitialAction();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: BlocConsumer<MyVisitorsBloc, MyVisitorsState>(
      listener: (context, state) {
        if (state is GetServiceRequestSuccess) {
          Navigator.pushNamed(context, '/delivery-approval-inside',
              arguments: state.response);
        }
        if (state is GetCurrentEntriesLoading) {
          _isLoading = true;
          _isError = false;
        }
        if (state is GetCurrentEntriesSuccess) {
          data = state.response;
          _isLoading = false;
          _isError = false;
        }
        if (state is GetCurrentEntriesFailure) {
          data = [];
          _isLoading = false;
          _isError = true;
          statusCode = state.status;
        }
      },
      builder: (context, state) {
        if (data.isNotEmpty && _isLoading == false) {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: AnimationLimiter(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: data.length,
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (BuildContext context, int index) {
                  return StaggeredListAnimation(index: index, child: VisitorCurrentCard(data: data[index]));
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
            onRefresh: _onRefresh,
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
            onRefresh: _onRefresh,
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
                      "There is no current visitors",
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
    ));
  }

  Future<void> _onRefresh() async {
    context.read<MyVisitorsBloc>().add(GetServiceRequest());
    context.read<MyVisitorsBloc>().add(GetCurrentEntries());
  }

  @override
  bool get wantKeepAlive => true;
}
