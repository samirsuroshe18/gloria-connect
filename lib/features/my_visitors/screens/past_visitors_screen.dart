import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/features/my_visitors/widgets/vistor_past_card.dart';
import 'package:gloria_connect/utils/staggered_list_animation.dart';
import 'package:lottie/lottie.dart';

import '../../guard_waiting/models/entry.dart';
import '../bloc/my_visitors_bloc.dart';

class PastVisitorsScreen extends StatefulWidget {
  const PastVisitorsScreen({super.key});

  @override
  State<PastVisitorsScreen> createState() => _PastVisitorsScreenState();
}

class _PastVisitorsScreenState extends State<PastVisitorsScreen>
    with AutomaticKeepAliveClientMixin {
  List<Entry> data = [];
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;

  @override
  void initState() {
    super.initState();
    context.read<MyVisitorsBloc>().add(GetPastEntries());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: BlocConsumer<MyVisitorsBloc, MyVisitorsState>(
      listener: (context, state) {
        if (state is GetPastEntriesLoading) {
          _isLoading = true;
          _isError = false;
        }
        if (state is GetPastEntriesSuccess) {
          data = state.response;
          _isLoading = false;
          _isError = false;
        }
        if (state is GetPastEntriesFailure) {
          data = [];
          _isLoading = false;
          _isError = true;
          statusCode= state.status;
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
                  return StaggeredListAnimation(index: index, child: VisitorPastCard(data: data[index]));
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
                      "There is no past visitors",
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
    context.read<MyVisitorsBloc>().add(GetPastEntries());
  }

  @override
  bool get wantKeepAlive => true;
}
