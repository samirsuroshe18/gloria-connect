import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/common_widgets/data_not_found_widget.dart';
import 'package:gloria_connect/features/my_visitors/bloc/my_visitors_bloc.dart';
import 'package:gloria_connect/features/my_visitors/widgets/visitor_current_card.dart';
import 'package:gloria_connect/common_widgets/staggered_list_animation.dart';

import '../../guard_waiting/models/entry.dart';

class CurrentVisitorsScreen extends StatefulWidget {
  const CurrentVisitorsScreen({super.key});

  @override
  State<CurrentVisitorsScreen> createState() => _CurrentVisitorsScreenState();
}

class _CurrentVisitorsScreenState extends State<CurrentVisitorsScreen>
    with AutomaticKeepAliveClientMixin {
  List<VisitorEntries> data = [];
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;

  @override
  void initState() {
    super.initState();
    context.read<MyVisitorsBloc>().add(GetCurrentEntries());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: BlocConsumer<MyVisitorsBloc, MyVisitorsState>(
      listener: (context, state) {
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
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: data.length,
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (BuildContext context, int index) {
                  return StaggeredListAnimation(index: index, child: VisitorCurrentCard(data: data[index]));
                },
              ),
            ),
          );
        } else if (_isLoading) {
          return const CustomLoader();
        } else if (data.isEmpty && _isError == true && statusCode == 401) {
          return BuildErrorState(onRefresh: _onRefresh);
        } else {
          return DataNotFoundWidget(onRefresh: _onRefresh, infoMessage: 'There are no current visitors',);
        }
      },
    ));
  }

  Future<void> _onRefresh() async {
    context.read<MyVisitorsBloc>().add(GetCurrentEntries());
  }

  @override
  bool get wantKeepAlive => true;
}
