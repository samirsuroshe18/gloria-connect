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
