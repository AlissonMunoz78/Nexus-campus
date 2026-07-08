import '../../domain/entities/emergency_contact.dart';
import '../datasources/emergency_contacts_datasource.dart';

class EmergencyContactsRepository {
  final EmergencyContactsDatasource datasource;

  const EmergencyContactsRepository(this.datasource);

  Future<List<EmergencyContact>> getContacts(String userId) async {
    return datasource.getContacts(userId);
  }

  Future<EmergencyContact> addContact({
    required String userId,
    required String name,
    required String phone,
    String? relationship,
  }) async {
    return datasource.addContact(
      userId: userId,
      name: name,
      phone: phone,
      relationship: relationship,
    );
  }

  Future<void> deleteContact(String contactId) async {
    return datasource.deleteContact(contactId);
  }
}
