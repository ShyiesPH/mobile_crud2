import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../repositories/contact_repository.dart';
import '../widgets/contact_form_widget.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Contact> contacts = [];

  Future<void> loadContacts() async {
    final contacts = await ContactRepository.getContacts();
    setState(() {
      this.contacts = contacts;
    });
  }

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  void _showContactFormDialog({Contact? contact}) async {
    final title = contact == null ? "Add Contact" : "Edit Contact";
    final result = await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: ContactFormWidget(contact: contact),
        ); // AlertDialog
      },
    );

    if (result != null) {
      await loadContacts();
    }
  }

  void _deleteContact(int id) async {
    await ContactRepository.deleteContact(id);
    await loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contacts")), // AppBar
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 185, 129, 237),
              Color.fromARGB(255, 229, 113, 159),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ), // LinearGradient
        ), // BoxDecoration
        child: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ), // RoundedRectangleBorder
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    contact.name[0],
                    style: const TextStyle(color: Colors.white),
                  ), // Text
                ), // CircleAvatar
                title: Text(
                  contact.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ), // Text
                subtitle: Text(contact.email),
                onTap: () {
                  _showContactFormDialog(contact: contact);
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // delete contact
                    _deleteContact(contact.id!);
                  },
                ), // IconButton
              ), // ListTile
            ); // Card
          },
        ),
      ), // ListView.builder
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showContactFormDialog();
        },
      ),
    ); // Scaffold
  }
}
