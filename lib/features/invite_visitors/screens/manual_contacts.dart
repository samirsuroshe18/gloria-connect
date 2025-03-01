// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class ManualContacts extends StatefulWidget {
//   final Map<String, dynamic>? data;
//   final String? name;
//   final String? number;
//
//   const ManualContacts({
//     super.key,
//     this.name,
//     this.number,
//     this.data,
//   });
//
//   @override
//   State<ManualContacts> createState() => _ManualContactsState();
// }
//
// class _ManualContactsState extends State<ManualContacts> with AutomaticKeepAliveClientMixin {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController nameController;
//   late TextEditingController numberController;
//   late TextEditingController vehicleController;
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     nameController = TextEditingController(text: widget.name);
//     numberController = TextEditingController(text: widget.number);
//     vehicleController = TextEditingController();
//     print(widget.name);
//     print(widget.number);
//   }
//
//   @override
//   void dispose() {
//     nameController.dispose();
//     numberController.dispose();
//     vehicleController.dispose();
//     super.dispose();
//   }
//
//   void _onProceed() {
//     if (_formKey.currentState!.validate()) {
//       Navigator.pushNamed(context, '/invite-guest', arguments: {
//         'name': nameController.text,
//         'number': numberController.text,
//         'profileImg': _getProfileImage(),
//         'companyName': _getCompanyName(),
//         'companyLogo': _getCompanyLogo(),
//         'serviceName': _getServiceName(),
//         'serviceLogo': _getServiceLogo(),
//         'vehicleNo': vehicleController.text,
//         'profileType': widget.data?['profileType'],
//       });
//     }
//   }
//
//   String _getProfileImage() {
//     switch (widget.data?['profileType']) {
//       case 'guest':
//         return 'assets/images/guest/single_guest.png';
//       case 'delivery':
//         return 'assets/images/delivery/other.png';
//       case 'cab':
//         return 'assets/images/cab/others.png';
//       default:
//         return 'assets/images/other/more_options.png';
//     }
//   }
//
//   String? _getCompanyName() {
//     if (widget.data?['profileType'] == 'delivery' ||
//         widget.data?['profileType'] == 'cab') {
//       return widget.data!['companyName'];
//     }
//     return null;
//   }
//
//   String? _getCompanyLogo() {
//     if (widget.data?['profileType'] == 'delivery' ||
//         widget.data?['profileType'] == 'cab') {
//       return widget.data!['image'];
//     }
//     return null;
//   }
//
//   String? _getServiceName() {
//     return widget.data?['profileType'] == 'other'
//         ? widget.data!['companyName']
//         : null;
//   }
//
//   String? _getServiceLogo() {
//     return widget.data?['profileType'] == 'other'
//         ? widget.data!['image']
//         : null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Scaffold(
//       body: SafeArea(
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 _buildProfileHeader(),
//                 const SizedBox(height: 32),
//                 _buildInputFields(),
//                 const SizedBox(height: 32),
//                 _buildSubmitButton(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProfileHeader() {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 40,
//             backgroundColor: Colors.blue.withOpacity(0.1),
//             child: CircleAvatar(
//               radius: 38,
//               backgroundImage: AssetImage(
//                 widget.data?['image'] ?? 'assets/images/profile.png',
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             _getVisitorType(),
//             style: Theme.of(context).textTheme.titleMedium?.copyWith(
//               fontWeight: FontWeight.w600,
//               color: Colors.black87,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _getVisitorType() {
//     if (widget.data?['profileType'] == 'guest') return 'Guest';
//     return widget.data?['companyName'] ?? 'Visitor';
//   }
//
//   Widget _buildInputFields() {
//     return Column(
//       children: [
//         _buildTextField(
//           controller: nameController,
//           label: 'Full Name',
//           icon: Icons.person_outline,
//           validator: (value) {
//             if (value?.isEmpty ?? true) {
//               return 'Please enter visitor name';
//             }
//             return null;
//           },
//         ),
//         const SizedBox(height: 20),
//         _buildTextField(
//           controller: numberController,
//           label: 'Mobile Number',
//           icon: Icons.phone_outlined,
//           keyboardType: TextInputType.phone,
//           maxLength: 10,
//           validator: (value) {
//             if (value?.isEmpty ?? true) {
//               return 'Please enter mobile number';
//             }
//             if (value!.length != 10) {
//               return 'Please enter valid mobile number';
//             }
//             return null;
//           },
//         ),
//         const SizedBox(height: 20),
//         _buildTextField(
//           controller: vehicleController,
//           label: widget.data?['profileType'] != 'cab'
//               ? 'Vehicle Number (Optional)'
//               : 'Vehicle Number',
//           icon: Icons.directions_car_outlined,
//           maxLength: 4,
//           validator: (value) {
//             if (widget.data?['profileType'] == 'cab' &&
//                 (value?.length ?? 0) < 4) {
//               return 'Please enter vehicle number';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     TextInputType? keyboardType,
//     int? maxLength,
//     String? Function(String?)? validator,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         maxLength: maxLength,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon, color: Colors.blue),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           filled: true,
//           fillColor: Colors.white,
//           counterText: '',
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 16,
//           ),
//         ),
//         validator: validator,
//       ),
//     );
//   }
//
//   Widget _buildSubmitButton() {
//     return ElevatedButton(
//       onPressed: isLoading ? null : _onProceed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.blue,
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         elevation: 2,
//       ),
//       child: isLoading
//           ? const CircularProgressIndicator(color: Colors.white)
//           : const Text(
//         'Add Visitor',
//         style: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
//
//   @override
//   bool get wantKeepAlive => true;
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../auth/widgets/auth_btn.dart';
import '../../auth/widgets/text_form_field.dart';

class ManualContacts extends StatefulWidget {
  final Map<String, dynamic>? data;
  final String? name;
  final String? number;
  const ManualContacts({super.key, this.name, this.number, this.data});

  @override
  State<ManualContacts> createState() => _ManualContactsState();
}

class _ManualContactsState extends State<ManualContacts>
    with AutomaticKeepAliveClientMixin {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController vehicleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    vehicleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.name != null) {
      nameController.text = widget.name!;
    }
    if (widget.number != null) {
      numberController.text = widget.number!;
    }
  }

  void updateControllers() {
    if (widget.name != null) {
      nameController.text = widget.name!;
    }
    if (widget.number != null) {
      numberController.text = formatPhoneNumber(widget.number!);
    }
  }

  @override
  void didUpdateWidget(ManualContacts oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.name != widget.name || oldWidget.number != widget.number) {
      updateControllers();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(widget.data?['image'] ??
                              'assets/images/profile.png')),
                      // Image.asset(
                      //   widget.data?['image'],
                      //   height: 100,
                      //   width: 100,
                      //   fit: BoxFit.contain,
                      // ),
                      const SizedBox(height: 10),
                      Text(
                        widget.data?['profileType'] == 'guest'
                            ? 'Guest'
                            : widget.data?['profileType'] == 'other'
                            ? widget.data!['companyName']
                            : widget.data?['companyName'],
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                AuthTextField(
                  icon: const Icon(Icons.person),
                  hintText: 'Name',
                  controller: nameController,
                  errorMsg: 'Please enter your username',
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                AuthTextField(
                  icon: const Icon(Icons.phone),
                  inputLength: 10,
                  inputType: TextInputType.number,
                  hintText: 'Mobile number',
                  controller: numberController,
                  errorMsg: 'Please enter mobile number',
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: vehicleController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [LengthLimitingTextInputFormatter(4)],
                  decoration: InputDecoration(
                    hintText: widget.data?['profileType'] != 'cab'
                        ? 'Vehicle number (Optional)'
                        : 'Vehicle number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.blue.withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.local_taxi),
                  ),
                  validator: (value) {
                    if (widget.data?['profileType'] == 'cab' &&
                        value!.length < 4) {
                      return 'Please enter vehicle number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AuthBtn(
                  isLoading: false,
                  onPressed: _onProceed,
                  text: 'Proceed',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onProceed() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(context, '/invite-guest', arguments: {
        'name': nameController.text,
        'number': numberController.text,
        'profileImg': widget.data?['profileType'] == 'guest'
            ? 'assets/images/guest/single_guest.png'
            : widget.data?['profileType'] == 'delivery'
            ? 'assets/images/delivery/other.png'
            : widget.data?['profileType'] == 'cab'
            ? 'assets/images/cab/others.png'
            : 'assets/images/other/more_options.png',
        'companyName': widget.data?['profileType'] == 'delivery' ||
            widget.data?['profileType'] == 'cab'
            ? widget.data!['companyName']
            : null,
        'companyLogo': widget.data?['profileType'] == 'delivery' ||
            widget.data?['profileType'] == 'cab'
            ? widget.data!['image']
            : null,
        'serviceName': widget.data?['profileType'] == 'other'
            ? widget.data!['companyName']
            : null,
        'serviceLogo': widget.data?['profileType'] == 'other'
            ? widget.data!['image']
            : null,
        'vehicleNo': vehicleController.text,
        'profileType': widget.data?['profileType'],
      });
    }
  }

  String formatPhoneNumber(String phoneNumber) {
    String cleanedNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (cleanedNumber.length == 10) {
      return cleanedNumber;
    } else if (cleanedNumber.length > 10) {
      return cleanedNumber.substring(cleanedNumber.length - 10);
    }
    return '';
  }

  @override
  bool get wantKeepAlive => true;
}
