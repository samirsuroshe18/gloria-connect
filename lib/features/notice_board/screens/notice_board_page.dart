import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/notice_board/bloc/notice_board_bloc.dart';
import 'package:gloria_connect/features/notice_board/models/notice_board_model.dart';
import 'package:gloria_connect/utils/staggered_list_animation.dart';
import 'package:lottie/lottie.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class NoticeBoardPage extends StatefulWidget {
  const NoticeBoardPage({super.key});
  @override
  State<NoticeBoardPage> createState() => _NoticeBoardPageState();
}

class _NoticeBoardPageState extends State<NoticeBoardPage> {
  List<NoticeBoardModel> data = [];
  bool _isLoading = false;
  bool _isError = false;
  String _filterCategory = 'all';
  final List<String> _categories = ['all', 'important', 'event', 'maintenance', 'general'];
  final TextEditingController _searchController = TextEditingController();
  List<NoticeBoardModel> _filteredData = [];

  @override
  void initState() {
    super.initState();
    context.read<NoticeBoardBloc>().add(NoticeBoardGetAllNotices());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterNotices() {
    setState(() {
      _filteredData = data.where((notice) {
        // Filter by category if not "All"
        bool categoryMatch = _filterCategory == 'all' || 
                            notice.category == _filterCategory;
        
        // Filter by search text
        bool searchMatch = _searchController.text.isEmpty || 
                          notice.title!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                          notice.description!.toLowerCase().contains(_searchController.text.toLowerCase());
        
        return categoryMatch && searchMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Update filtered data when main data changes
    if (_filteredData.isEmpty && data.isNotEmpty) {
      _filteredData = List.from(data);
    }
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0.2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white70), // Darker color
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Notice Board',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70),
            onPressed: _onRefresh,
            tooltip: 'Refresh Notices',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white70),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
            tooltip: 'Filter Notices',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _filterNotices(),
              decoration: InputDecoration(
                hintText: 'Search notices...',
                hintStyle: const TextStyle(
                  color: Colors.white60
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ),
      ),
      body: BlocConsumer<NoticeBoardBloc, NoticeBoardState>(
        listener: (context, state) {
          if (state is NoticeBoardGetAllNoticesLoading) {
            _isLoading = true;
            _isError = false;
          }
          if (state is NoticeBoardGetAllNoticesSuccess) {
            setState(() {
              data = state.response;
              _filteredData = List.from(data);
              _isLoading = false;
              _isError = false;
            });
          }
          if (state is NoticeBoardGetAllNoticesFailure) {
            setState(() {
              data = [];
              _filteredData = [];
              _isLoading = false;
              _isError = true;
            });
          }
        },
        builder: (context, state) {
          if (_filteredData.isNotEmpty && _isLoading == false) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              color: const Color(0xFF3498DB),
              child: AnimationLimiter(
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _filteredData.length,
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (BuildContext context, int index) {
                    return StaggeredListAnimation(index: index, child: _buildNoticeCard(_filteredData[index]));
                  },
                ),
              ),
            );
          } else if (_isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/animations/loader.json',
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Loading notices...',
                    style: TextStyle(
                      color: Color(0xFF7F8C8D),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          } else if (data.isEmpty && _isError == true) {
            return _buildErrorState();
          } else {
            return _buildEmptyState();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newNotice = await Navigator.pushNamed(
            context,
            '/create-notice-board-screen',
          );

          if (newNotice is NoticeBoardModel) {
            setState(() {
              data.add(newNotice);
              _filteredData = List.from(data);
            });
          }
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white70),
      ),
    );
  }

  Widget _buildNoticeCard(NoticeBoardModel notice) {

    // Function to get category icon
    IconData getCategoryIcon(String category) {
      switch (category.toLowerCase()) {
        case 'important':
          return Icons.priority_high;
        case 'event':
          return Icons.event;
        case 'maintenance':
          return Icons.build;
        default:
          return Icons.notifications;
      }
    }

    return Card(
      color: Colors.black.withOpacity(0.2),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context, 
            '/notice-board-details-screen',
            arguments: notice,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category label
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    getCategoryIcon(notice.category ?? 'event'),
                    color: Colors.white70,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    notice.category ?? 'Not available',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    DateFormat('MMM dd, yyyy').format(notice.createdAt ?? DateTime.now()),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            // Notice content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notice.title ?? 'No title',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notice.description ?? 'No description',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white60,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Footer
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: const Icon(
                          Icons.person,
                          size: 18,
                          color: Color(0xFF7F8C8D),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        notice.publishedBy?.userName ?? "Unknown",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Read more',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: const Color(0xFF3498DB),
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
                "No Notices Available",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "There are no announcements at this time",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF7F8C8D),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _onRefresh,
                icon: const Icon(Icons.refresh),
                label: const Text("Refresh"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3498DB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: const Color(0xFF3498DB),
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
                "Oops! Something went wrong",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "We couldn't load the notices. Please try again.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF7F8C8D),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _onRefresh,
                icon: const Icon(Icons.refresh),
                label: const Text("Try Again"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3498DB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.deepPurple,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Notices',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categories.map((category) {
                      return ChoiceChip(
                        backgroundColor: Colors.purple.withOpacity(0.5),
                        label: Text(category),
                        selected: _filterCategory == category,
                        onSelected: (selected) {
                          setState(() {
                            _filterCategory = category;
                          });
                          _filterNotices();
                        },
                        selectedColor: Colors.purple.withOpacity(0.5),
                        labelStyle: TextStyle(
                          color: _filterCategory == category
                              ? Colors.white
                              : const Color(0xFF7F8C8D),
                          fontWeight: _filterCategory == category
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _filterCategory = 'All';
                            _searchController.clear();
                          });
                          _filterNotices();
                          Navigator.pop(context);
                        },
                        child: const Text('Reset Filters', style: TextStyle(color: Colors.white70),),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          _filterNotices();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.withOpacity(0.5),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onRefresh() async {
    context.read<NoticeBoardBloc>().add(NoticeBoardGetAllNotices());
  }
}