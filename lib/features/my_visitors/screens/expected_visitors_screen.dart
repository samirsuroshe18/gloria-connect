import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/invite_visitors/models/pre_approved_banner.dart';
import 'package:gloria_connect/features/my_visitors/bloc/my_visitors_bloc.dart';
import 'package:gloria_connect/features/my_visitors/widgets/visitor_expected_card.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

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
              child: ListView.builder(
                itemCount: data.length,
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (BuildContext context, int index) {
                  return VisitorExpectedCard(
                    userName: data[index].name!,
                    // date: DateFormat('dd MMM, yyyy')
                    //     .format(data[index].checkInCodeStartDate!).toString(),
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
                        "There is no expected visitors",
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
      ),
    );
  }

  Future<void> _onRefresh() async {
    context.read<MyVisitorsBloc>().add(GetExpectedEntries());
  }

  @override
  bool get wantKeepAlive => true;
}
