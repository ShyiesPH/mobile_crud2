import 'package:flutter/material.dart';
import '../repositories/contact_repository.dart';
import '../models/contact.dart';

class ContactFormWidget extends StatefulWidget {
  final Contact? contact;
  const ContactFormWidget({super.key, this.contact});

  @override
  State<ContactFormWidget> createState() => _ContactFormWidgetState();
}

class _ContactFormWidgetState extends State<ContactFormWidget> {
  final _formKey = GlobalKey<FormState>();
  String name = "", email = "", phone = "", address = "";

  @override
  void initState() {
    super.initState();
    name = widget.contact?.name ?? '';
    email = widget.contact?.email ?? '';
    phone = widget.contact?.phone ?? '';
    address = widget.contact?.address ?? '';
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final contact = Contact(
        id: widget.contact?.id,
        name: name,
        email: email,
        phone: phone,
        address: address,
      );

      if (widget.contact == null) {
        await ContactRepository.addContact(contact);
      } else {
        await ContactRepository.updateContact(contact);
      }

      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            TextFormField(
              initialValue: name,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              onSaved: (v) => name = v ?? '',
            ), // TextFormField
            TextFormField(
              initialValue: email,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              onSaved: (v) => email = v ?? '',
            ), // TextFormField
            TextFormField(
              initialValue: phone,
              decoration: const InputDecoration(labelText: 'Phone'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              onSaved: (v) => phone = v ?? '',
            ), // TextFormField
            TextFormField(
              initialValue: address,
              decoration: const InputDecoration(labelText: 'Address'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              onSaved: (v) => address = v ?? '',
            ), // TextFormField
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ), // TextButton
                ElevatedButton(
                  onPressed: _save,
                  child: const Text('Save'),
                ), // ElevatedButton
              ],
            ), // Row
          ],
        ), // Column
      ), // Form
    ); // SingleChildScrollView
  }
}
