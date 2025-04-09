import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wardrope_app/Config.dart';
import 'package:wardrope_app/Starter/first.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late SharedPreferences prefs;
  String _name = "User";
  String _gender = 'Male';
  String _height = "0.0";
  String _weight = "0.0";

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? 'User';
      _gender = prefs.getString('gender') ?? 'Male';
      _height = prefs.getString('height') ?? "0.0";
      _weight = prefs.getString('weight') ?? "0.0";
    });
  }

  Future<void> _updateProfileData() async {
    await prefs.setString('name', _name);
    await prefs.setString('gender', _gender);
    await prefs.setString('height', _height);
    await prefs.setString('weight', _weight);
  }

  void _showEditDialog(String attribute, String value, Function(String) onChange) {
    TextEditingController _controller = TextEditingController(text: value);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $attribute'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Enter new $attribute'),
            onChanged: (val) => onChange(val),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  onChange(_controller.text);
                });
                _updateProfileData();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    await prefs.clear();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => FirstPage()));
  }

  Widget _buildInfoRow(String label, String value, IconData icon, Function() onEdit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: Config.secondaryColor),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                '$label: $value',
                style: TextStyle(
                  fontSize: 18,
                  color: Config.textColor,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Config.accentColor),
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String profileImage = _gender == 'Male' ? 'assets/profile/male.png' : 'assets/profile/female.png';

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page',style: TextStyle(color: Colors.white),),
        backgroundColor: Color.fromARGB(255, 43, 42, 42) ,
        actions: [
          IconButton(
            icon: Icon(Icons.logout,color: Colors.white,),
            onPressed: _logout,
          ),
        ],
      ),
      body: Container(
        color: Color.fromARGB(255, 43, 42, 42) ,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(profileImage),
                ),
              ),
              SizedBox(height: 20),
              _buildInfoRow('Name', _name, Icons.person, () => _showEditDialog('Name', _name, (val) => _name = val)),
              _buildInfoRow('Gender', _gender, Icons.wc, () => _showEditDialog('Gender', _gender, (val) => _gender = val)),
              _buildInfoRow('Height', '$_height cm', Icons.height, () => _showEditDialog('Height', _height, (val) => _height = val)),
              _buildInfoRow('Weight', '$_weight kg', Icons.line_weight, () => _showEditDialog('Weight', _weight, (val) => _weight = val)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text('Logout', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
