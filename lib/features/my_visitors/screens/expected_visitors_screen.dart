import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/common_widgets/data_not_found_widget.dart';
import 'package:gloria_connect/features/invite_visitors/models/pre_approved_banner.dart';
import 'package:gloria_connect/features/my_visitors/bloc/my_visitors_bloc.dart';
import 'package:gloria_connect/features/my_visitors/widgets/visitor_expected_card.dart';
import 'package:gloria_connect/common_widgets/staggered_list_animation.dart';

class ExpectedVisitorsScreen extends StatefulWidget {
  const ExpectedVisitorsScreen({super.key});

  @override
  State<ExpectedVisitorsScreen> createState() => _ExpectedVisitorsScreenState();
}

class _ExpectedVisitorsScreenState extends State<ExpectedVisitorsScreen>
    with AutomaticKeepAliveClientMixin {
  List<PreApprovedBanner> data = [];
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;

  @override
  void initState() {
    super.initState();
    context.read<MyVisitorsBloc>().add(GetExpectedEntries());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocConsumer<MyVisitorsBloc, MyVisitorsState>(
        listener: (context, state) {
          if (state is GetExpectedEntriesLoading) {
            _isLoading = true;
            _isError = false;
          }
          if (state is GetExpectedEntriesSuccess) {
            data = state.response;
            _isLoading = false;
            _isError = false;
          }
          if (state is GetExpectedEntriesFailure) {
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
                  itemBuilder: (BuildContext context, int index) {
                    return StaggeredListAnimation(index: index, child: VisitorExpectedCard(
                      userName: data[index].name!,
                      date: data[index].checkInCodeStartDate!.toString(),
                      tag: data[index].entryType!,
                      companyLogo: data[index].companyLogo,
                      companyName: data[index].companyName,
                      serviceName: data[index].serviceName,
                      serviceLogo: data[index].serviceLogo,
                      tagColor: Colors.orange,
                      profileImageUrl:
                      data[index].profileImg ?? 'assets/images/profile.png',
                      data: data[index],
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
            return DataNotFoundWidget(onRefresh: _onRefresh, infoMessage: 'There are no expected visitors',);
          }
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    context.read<MyVisitorsBloc>().add(GetExpectedEntries());
  }

  @override
  bool get wantKeepAlive => true;
}
