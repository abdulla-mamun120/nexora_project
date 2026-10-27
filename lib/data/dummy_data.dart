import '../models/notice.dart';
import '../models/service_contact.dart';
import '../models/place.dart';

// All dummy data in one place (will come from Firebase later)

const List<Notice> dummyNotices = [
  Notice(
    title: 'Scheduled water supply maintenance',
    description: 'Water supply will be limited on Road 7-10 during maintenance.',
    details:
        'Water supply will be limited on Road 7-10 from 9 AM to 2 PM due to pipeline maintenance. Please store enough water in advance.',
    category: 'Utilities',
    date: '08 Oct',
  ),
  Notice(
    title: 'Free community health screening',
    description: 'Saturday at the community center. Registration opens at 9:00 AM.',
    details:
        'A free health screening will be held on Saturday at the community center. Registration opens at 9:00 AM. Please bring your ID card.',
    category: 'Events',
    date: '07 Oct',
  ),
  Notice(
    title: 'Neighborhood cleanup drive',
    description: 'Meet beside the lake entrance at 7:30 AM.',
    details:
        'Residents are invited to join the cleanup drive. Meet beside the lake entrance at 7:30 AM. Gloves and bags will be provided.',
    category: 'Events',
    date: '05 Oct',
  ),
  Notice(
    title: 'Severe weather advisory',
    description: 'Avoid unnecessary travel during heavy rainfall.',
    details:
        'Heavy rainfall is expected for the next two days. Please avoid unnecessary travel and stay away from low-lying areas.',
    category: 'Emergency',
    date: '02 Oct',
    isPinned: true,
  ),
  Notice(
    title: 'Road closure near main market',
    description: 'Road repair work will continue for three days.',
    details:
        'The road near the main market will be closed for repair work for three days. Please use the alternative road beside the school.',
    category: 'Important',
    date: '04 Oct',
  ),
  Notice(
    title: 'Electricity load shedding schedule',
    description: 'New schedule starts from next week.',
    details:
        'A new electricity schedule starts from next week. Power may be off for one hour in the afternoon in some areas.',
    category: 'Utilities',
    date: '03 Oct',
  ),
];

const List<ServiceContact> dummyServices = [
  ServiceContact(
    name: 'Karim Uddin',
    category: 'Electrician',
    area: 'Road 3, Block A',
    phone: '01700-000001',
    experience: '8 years experience',
  ),
  ServiceContact(
    name: 'Rahim Mia',
    category: 'Plumber',
    area: 'Road 5, Block B',
    phone: '01700-000002',
    experience: '6 years experience',
  ),
  ServiceContact(
    name: 'Jamal Hossain',
    category: 'Mechanic',
    area: 'Main Market',
    phone: '01700-000003',
    experience: '10 years experience',
  ),
  ServiceContact(
    name: 'Nusrat Jahan',
    category: 'Tutor',
    area: 'Road 7, Block C',
    phone: '01700-000004',
    experience: 'Math and Science, Class 6-10',
  ),
  ServiceContact(
    name: 'Salam Sheikh',
    category: 'Electrician',
    area: 'Road 9, Block D',
    phone: '01700-000005',
    experience: '5 years experience',
  ),
  ServiceContact(
    name: 'Faruk Ahmed',
    category: 'Plumber',
    area: 'Road 2, Block A',
    phone: '01700-000006',
    experience: '12 years experience',
  ),
];

const List<Place> dummyPlaces = [
  Place(
    name: 'Community Health Center',
    category: 'Hospital',
    address: 'Road 4, Block A',
    openingHours: 'Open 24 hours',
    phone: '01800-000001',
  ),
  Place(
    name: 'City Care Clinic',
    category: 'Hospital',
    address: 'Main Road, Near Market',
    openingHours: '8:00 AM - 10:00 PM',
    phone: '01800-000002',
  ),
  Place(
    name: 'Model High School',
    category: 'School',
    address: 'Road 6, Block B',
    openingHours: '8:00 AM - 3:00 PM',
    phone: '01800-000003',
  ),
  Place(
    name: 'Central Mosque',
    category: 'Mosque',
    address: 'Road 2, Block A',
    openingHours: 'Open for all prayers',
    phone: '01800-000004',
  ),
  Place(
    name: 'Green Valley Mosque',
    category: 'Mosque',
    address: 'Road 8, Block C',
    openingHours: 'Open for all prayers',
    phone: '01800-000005',
  ),
  Place(
    name: 'Main Bazar',
    category: 'Market',
    address: 'Main Road',
    openingHours: '9:00 AM - 10:00 PM',
    phone: '01800-000006',
  ),
  Place(
    name: 'Lake View Park',
    category: 'Park',
    address: 'Beside the lake entrance',
    openingHours: '6:00 AM - 9:00 PM',
    phone: '01800-000007',
  ),
];