import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/features/resident_profile/bloc/resident_profile_bloc.dart';
import 'package:gloria_connect/utils/staggered_list_animation.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../resident_profile/models/member.dart';

class ApartmentMembersScreen extends StatefulWidget {
  const ApartmentMembersScreen({super.key,});

  @override
  State<ApartmentMembersScreen> createState() => _ApartmentMembersScreenState();
}

class _ApartmentMembersScreenState extends State<ApartmentMembersScreen> {
  List<Member> data = [];
  bool _isLoading = false;
  bool _isError = false;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  Future<void> _initialize() async {
    if(!mounted) return;
    context.read<ResidentProfileBloc>().add(GetApartmentMembers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Apartment Members',
          ),
          backgroundColor: Colors.black.withOpacity(0.2),
        ),
      body: BlocConsumer<ResidentProfileBloc, ResidentProfileState>(
        listener: (context, state){
          if (state is GetApartmentMembersLoading) {
            _isLoading = true;
            _isError = false;
          }
          if (state is GetApartmentMembersSuccess) {
            _isLoading = false;
            _isError = false;
            data = state.response;
          }
          if (state is GetApartmentMembersFailure) {
            _isLoading = false;
            _isError = true;
            data = [];
          }
        },
        builder: (context, state){
          if(data.isNotEmpty && _isLoading == false) {
            return RefreshIndicator(
              onRefresh: _onRefresh,  // Method to refresh user data
              child: AnimationLimiter(
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: data.length,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  itemBuilder: (context, index) {
                    final member = data[index];
                    return StaggeredListAnimation(index: index, child: Card(
                      color: Colors.black.withOpacity(0.2),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(member.user?.profile ?? ""),
                        ),
                        title: Text(
                          member.user?.userName ?? "NA",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(member.user?.phoneNo ?? ""),
                        trailing: IconButton(
                          icon: const Icon(Icons.call),
                          onPressed: () {
                            _makePhoneCall(member.user?.phoneNo ?? "");
                          },
                        ),
                      ),
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
          } else if (data.isEmpty && _isError == true) {
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
                        "There is no apartment members",
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
      )
    );
  }

  Future<void> _onRefresh() async {
    context.read<ResidentProfileBloc>().add(GetApartmentMembers());
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
