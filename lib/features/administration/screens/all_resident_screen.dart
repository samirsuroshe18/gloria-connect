import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/features/administration/bloc/administration_bloc.dart';
import 'package:gloria_connect/features/administration/models/society_member.dart';
import 'package:gloria_connect/utils/staggered_list_animation.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';


class AllResidentScreen extends StatefulWidget {
  const AllResidentScreen({super.key,});

  @override
  State<AllResidentScreen> createState() => _AllResidentScreenState();
}

class _AllResidentScreenState extends State<AllResidentScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<SocietyMember> data = [];
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;
  bool _isLazyLoading = false;
  int _page = 1;
  final int _limit = 15;
  bool _hasMore = true;
  String _searchQuery = '';

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  Future<void> _initialize() async {
    if(!mounted) return;
    _fetchEntries();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMore && data.length>=_limit) {
        _isLazyLoading = true;
        _fetchEntries();
      }
    }
  }

  Future<void> _fetchEntries()async {
    final queryParams = {
      'page': _page.toString(),
      'limit': _limit.toString(),
    };

    if (_searchQuery.isNotEmpty) {
      queryParams['search'] = _searchQuery;
    }

    context.read<AdministrationBloc>().add(AdminGetSocietyMember(queryParams: queryParams));
  }

  Widget _buildSearchFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            hintText: 'Search by name, mobile, etc.',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _page = 1;
                  data.clear();
                });
                _fetchEntries();
              },
            )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.2)
        ),
        onSubmitted: (value) {
          setState(() {
            _searchQuery = value;
            _page = 1;
            data.clear();
          });
          _fetchEntries();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Society Members',
            style: TextStyle(color: Colors.white,),
          ),
          backgroundColor: Colors.black.withOpacity(0.2),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: _buildSearchFilterBar(),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: BlocConsumer<AdministrationBloc, AdministrationState>(
          listener: (context, state){
            if (state is AdminGetSocietyMemberLoading) {
              _isLoading = true;
              _isError = false;
            }
            if (state is AdminGetSocietyMemberSuccess) {
              if (_page == 1) {
                data.clear();
              }
              data.addAll(state.response.societyMembers as Iterable<SocietyMember>);
              _page++;
              _hasMore = state.response.pagination?.hasMore ?? false;
              _isLoading = false;
              _isLazyLoading = false;
              _isError = false;
            }
            if (state is AdminGetSocietyMemberFailure) {
              data = [];
              _isLoading = false;
              _isLazyLoading = false;
              _isError = true;
              statusCode= state.status;
              _hasMore = false;
            }
            if (state is AdminCreateAdminSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.response['message']!),
                  backgroundColor: Colors.green,
                ),
              );
            }
            if (state is AdminCreateAdminFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
            if (state is AdminRemoveResidentSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.response['message']!),
                  backgroundColor: Colors.green,
                ),
              );
            }
            if (state is AdminRemoveResidentFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state){
            if (data.isNotEmpty && _isLoading == false) {
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: AnimationLimiter(
                  child: _buildEntriesList(),
                ),
              );
            } else if (_isLazyLoading) {
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: AnimationLimiter(
                  child: _buildEntriesList(),
                ),
              );
            } else if (_isLoading && _isLazyLoading==false) {
              return Center(
                child: Lottie.asset(
                  'assets/animations/loader.json',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              );
            }else if (data.isEmpty && _isError == true && statusCode == 401) {
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
                          "There are no residents.",
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

  Widget _buildMembersCard(member){
    return Card(
      color: Colors.black.withOpacity(0.2),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: (member.user?.profile != null && member.user!.profile!.isNotEmpty)
              ? NetworkImage(member.user!.profile!)
              : const AssetImage('assets/images/profile.png') as ImageProvider,
        ),
        title: Text(
          member.user?.userName ?? "NA",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(member.user?.phoneNo ?? ""),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') {
              _deleteResident(member.user?.id ?? "");
            } else if (value == 'makeAdmin') {
              _makeAdmin(member.user?.email ?? "");
            }else if(value == 'call'){
              _makePhoneCall(member.user?.phoneNo ?? "");
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete Resident'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'makeAdmin',
              child: Row(
                children: [
                  Icon(Icons.person_add, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Make Admin'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'call',
              child: Row(
                children: [
                  Icon(Icons.call, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Call'),
                ],
              ),
            ),
          ],
          icon: const Icon(Icons.more_vert), // Three-dot icon
        ),
      ),
    );
  }

  Widget _buildEntriesList() {

    return ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: data.length + 1,
        itemBuilder: (context, index) {
          if (index < data.length) {
            return StaggeredListAnimation(index: index, child: _buildMembersCard(data[index]));
          } else {
            if (_hasMore) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: Text("No more data to load")),
              );
            }
          }
        }
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _makeAdmin(String email) async {
    if(!mounted) return;

    showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Promote User to Admin'),
          content: const Text('Are you sure you want to grant admin privileges to this user? Admins have elevated permissions to manage the system.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            BlocBuilder<AdministrationBloc, AdministrationState>(
              builder: (context, state) {
                if (state is AdminCreateAdminLoading) {
                  return const CircularProgressIndicator();
                } else if (state is AdminCreateAdminFailure) {
                  return TextButton(
                    child: const Text('Confirm'),
                    onPressed: () {
                      context.read<AdministrationBloc>().add(AdminCreateAdmin(email: email));
                    },
                  );
                }else if (state is AdminCreateAdminSuccess) {
                  onPressed(){
                    Navigator.of(context).pop();
                  }
                  return TextButton(
                    onPressed: onPressed(),
                    child: const Text('Confirm'),
                  );
                } else {
                  return TextButton(
                    child: const Text('Confirm'),
                    onPressed: () {
                      context.read<AdministrationBloc>().add(
                        AdminCreateAdmin(email: email),
                      );
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteResident(String id) async {
    if(!mounted) return;

    showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Resident', style: TextStyle(color: Colors.red)),
          content: const Text('Are you sure you want to delete this resident? This action cannot be undone and will remove all associated data.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            BlocBuilder<AdministrationBloc, AdministrationState>(
              builder: (context, state) {
                if (state is AdminRemoveResidentLoading) {
                  return const CircularProgressIndicator();
                } else if (state is AdminRemoveResidentFailure) {
                  return TextButton(
                    child: const Text('Delete', style: TextStyle(color: Colors.red),),
                    onPressed: () {
                      context.read<AdministrationBloc>().add(AdminRemoveResident(id: id));
                    },
                  );
                }else if (state is AdminRemoveResidentSuccess) {
                  onPressed(){
                    _page = 1;
                    context.read<AdministrationBloc>().add(AdminGetSocietyMember(queryParams: {
                      'page': _page.toString(),
                      'limit': _limit.toString(),
                    }));
                    Navigator.of(context).pop();
                  }
                  return TextButton(
                    onPressed: onPressed(),
                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                  );
                } else {
                  return TextButton(
                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      context.read<AdministrationBloc>().add(AdminRemoveResident(id: id));
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _onRefresh() async {
    if(_hasMore) {
      await _fetchEntries();
    }
  }
}
