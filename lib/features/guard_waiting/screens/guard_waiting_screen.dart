import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/features/guard_waiting/bloc/guard_waiting_bloc.dart';
import 'package:gloria_connect/features/guard_waiting/widgets/entry_card.dart';
import 'package:gloria_connect/utils/staggered_list_animation.dart';
import 'package:lottie/lottie.dart';

import '../models/entry.dart';

class GuardWaitingScreen extends StatefulWidget {
  const GuardWaitingScreen({super.key});

  @override
  State<GuardWaitingScreen> createState() => _GuardWaitingScreenState();
}

class _GuardWaitingScreenState extends State<GuardWaitingScreen> {
  List<VisitorEntries> data = [];
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;

  @override
  void initState() {
    super.initState();
    context.read<GuardWaitingBloc>().add(WaitingGetEntries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Waiting for Approval',
            style: TextStyle(color: Colors.white70),
          ),
          backgroundColor: Colors.black.withOpacity(0.2),
        ),
        body: BlocConsumer<GuardWaitingBloc, GuardWaitingState>(
          listener: (context, state) {
            if (state is WaitingGetEntriesLoading) {
              _isLoading = true;
              _isError = false;
            }
            if (state is WaitingGetEntriesSuccess) {
              _isLoading = false;
              _isError = false;
              data = state.response;
            }
            if (state is WaitingGetEntriesFailure) {
              _isLoading = false;
              _isError = true;
              statusCode = state.status;
              data = [];
            }
          },
          builder: (context, state) {
            if (data.isNotEmpty && _isLoading == false) {
              return RefreshIndicator(
                onRefresh: _refresh,
                child: AnimationLimiter(
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: data.length,
                    padding: const EdgeInsets.all(8.0),
                    itemBuilder: (BuildContext context, int index) {
                      return StaggeredListAnimation(index: index, child: EntryCard(
                        data: data[index],
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
                onRefresh: _refresh,
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
                onRefresh: _refresh,
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
                          "There is no waiting entries",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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

  // Function to simulate refreshing data
  Future<void> _refresh() async {
    context.read<GuardWaitingBloc>().add(WaitingGetEntries());
  }
}
