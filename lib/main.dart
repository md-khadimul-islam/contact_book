
import 'package:flutter/material.dart';
import 'models/contact.dart';
import 'helpers/database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    databaseHelper.initDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Contact Book App'),
        ),
        body: ContactListWidget(databaseHelper: databaseHelper),
      ),
    );
  }
}

class ContactListWidget extends StatefulWidget {
  final DatabaseHelper databaseHelper;

  ContactListWidget({required this.databaseHelper});

  @override
  _ContactListWidgetState createState() => _ContactListWidgetState();
}

class _ContactListWidgetState extends State<ContactListWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    refreshContactList();
  }

  void refreshContactList() async {
    final List<Contact> contactList = await widget.databaseHelper.getContacts();
    setState(() {
      contacts = contactList;
    });
  }

  void addContact() async {
    final newContact = Contact(
      name: nameController.text,
      phoneNumber: phoneNumberController.text,
    );

    await widget.databaseHelper.insertContact(newContact);
    refreshContactList();

    nameController.clear();
    phoneNumberController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 4.0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
              ),
              const SizedBox(height: 20.0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 4.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: phoneNumberController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
              ),
              const SizedBox(height: 30,),
              ElevatedButton(
                onPressed: addContact,
                child: const Text('Add Contact'),
              ),
            ],
          ),
        ),
       Expanded(
         child: ListView.builder(
           itemCount: contacts.length,
           itemBuilder: (context, index) {
             final contact = contacts[index];
             return ListTile(
               title: Text(contact.name),
               subtitle: Text(contact.phoneNumber),
             );
           },
         ),
       ),
      ],
    );
  }
}
