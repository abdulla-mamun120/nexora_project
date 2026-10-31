import 'app_language.dart';

// All app texts: key -> English and Bangla
const Map<String, Map<String, String>> _strings = {
  'nav_home': {'en': 'Home', 'bn': 'হোম'},
  'nav_notices': {'en': 'Notices', 'bn': 'নোটিশ'},
  'nav_services': {'en': 'Services', 'bn': 'সেবা'},
  'nav_area_guide': {'en': 'Area Guide', 'bn': 'এলাকা গাইড'},
  'nav_profile': {'en': 'Profile', 'bn': 'প্রোফাইল'},
    // ----- Home -----
  'home_greeting': {'en': 'Good morning', 'bn': 'সুপ্রভাত'},
  'home_search_hint': {
    'en': 'Search notices, services or places',
    'bn': 'নোটিশ, সেবা বা জায়গা খুঁজুন',
  },
  'home_quick_help': {
    'en': 'Community quick help',
    'bn': 'কমিউনিটি দ্রুত সহায়তা',
  },
  'home_emergency_title': {
    'en': 'Get help quickly when\nevery second counts',
    'bn': 'প্রতিটি সেকেন্ড মূল্যবান,\nদ্রুত সাহায্য নিন',
  },
  'home_emergency_btn': {
    'en': 'Emergency contacts',
    'bn': 'জরুরি নম্বর',
  },
  'home_quick_services': {'en': 'Quick services', 'bn': 'দ্রুত সেবা'},
  'svc_electrician': {'en': 'Electrician', 'bn': 'ইলেকট্রিশিয়ান'},
  'svc_plumber': {'en': 'Plumber', 'bn': 'প্লাম্বার'},
  'svc_hospital': {'en': 'Hospital', 'bn': 'হাসপাতাল'},
  'svc_report': {'en': 'Report', 'bn': 'অভিযোগ'},
  'home_latest_notices': {'en': 'Latest notices', 'bn': 'সর্বশেষ নোটিশ'},
  'home_view_all': {'en': 'View all', 'bn': 'সব দেখুন'},
  'tag_important': {'en': 'Important', 'bn': 'গুরুত্বপূর্ণ'},
  'tag_general': {'en': 'General', 'bn': 'সাধারণ'},
  'home_notice1_title': {
    'en': 'Scheduled water supply maintenance',
    'bn': 'নির্ধারিত পানি সরবরাহ রক্ষণাবেক্ষণ',
  },
  'home_notice1_sub': {
    'en': 'Water supply will be off from 9 AM to 2 PM.',
    'bn': 'সকাল ৯টা থেকে দুপুর ২টা পর্যন্ত পানি সরবরাহ বন্ধ থাকবে।',
  },
  'home_notice2_title': {
    'en': 'Community meeting on Friday',
    'bn': 'শুক্রবার কমিউনিটি সভা',
  },
  'home_notice2_sub': {
    'en': 'All residents are invited to the area meeting.',
    'bn': 'এলাকার সব বাসিন্দাকে সভায় আমন্ত্রণ জানানো হচ্ছে।',
  },
    // ----- Notices -----
  'notices_title': {'en': 'Notice Board', 'bn': 'নোটিশ বোর্ড'},
  'notices_search': {'en': 'Search notices', 'bn': 'নোটিশ খুঁজুন'},
  'notices_empty': {
    'en': 'No notices found',
    'bn': 'কোনো নোটিশ পাওয়া যায়নি',
  },
  'listen_notice': {'en': 'Listen to this notice', 'bn': 'নোটিশটি শুনুন'},

  // ----- Services -----
  'services_title': {'en': 'Local Services', 'bn': 'স্থানীয় সেবা'},
  'services_search': {
    'en': 'Search by name, service or area',
    'bn': 'নাম, সেবা বা এলাকা দিয়ে খুঁজুন',
  },
  'services_empty': {
    'en': 'No services found',
    'bn': 'কোনো সেবা পাওয়া যায়নি',
  },

  // ----- Area Guide -----
  'guide_title': {'en': 'Area Guide', 'bn': 'এলাকা গাইড'},
  'guide_search': {
    'en': 'Search by name, type or address',
    'bn': 'নাম, ধরন বা ঠিকানা দিয়ে খুঁজুন',
  },
  'guide_empty': {
    'en': 'No places found',
    'bn': 'কোনো জায়গা পাওয়া যায়নি',
  },
  'view_on_map': {'en': 'View on map', 'bn': 'মানচিত্রে দেখুন'},

  // ----- Category names (shown on chips and tags) -----
  'cat_All': {'en': 'All', 'bn': 'সব'},
  'cat_Important': {'en': 'Important', 'bn': 'গুরুত্বপূর্ণ'},
  'cat_Events': {'en': 'Events', 'bn': 'অনুষ্ঠান'},
  'cat_Utilities': {'en': 'Utilities', 'bn': 'ইউটিলিটি'},
  'cat_Emergency': {'en': 'Emergency', 'bn': 'জরুরি'},
  'cat_Electrician': {'en': 'Electrician', 'bn': 'ইলেকট্রিশিয়ান'},
  'cat_Plumber': {'en': 'Plumber', 'bn': 'প্লাম্বার'},
  'cat_Mechanic': {'en': 'Mechanic', 'bn': 'মেকানিক'},
  'cat_Tutor': {'en': 'Tutor', 'bn': 'টিউটর'},
  'cat_Hospital': {'en': 'Hospital', 'bn': 'হাসপাতাল'},
  'cat_School': {'en': 'School', 'bn': 'স্কুল'},
  'cat_Mosque': {'en': 'Mosque', 'bn': 'মসজিদ'},
  'cat_Market': {'en': 'Market', 'bn': 'বাজার'},
  'cat_Park': {'en': 'Park', 'bn': 'পার্ক'},
    // ----- Emergency -----
  'emg_title': {'en': 'Emergency Contacts', 'bn': 'জরুরি নম্বর'},
  'emg_danger': {'en': 'In immediate danger?', 'bn': 'এখনই বিপদে আছেন?'},
  'emg_danger_sub': {
    'en': 'Call the national emergency number right now.',
    'bn': 'এখনই জাতীয় জরুরি নম্বরে কল করুন।',
  },
  'emg_call_999': {'en': 'Call 999', 'bn': '৯৯৯ এ কল করুন'},
  'emg_important': {'en': 'Important numbers', 'bn': 'গুরুত্বপূর্ণ নম্বর'},
  'emg_empty': {'en': 'No numbers found', 'bn': 'কোনো নম্বর পাওয়া যায়নি'},

  // ----- Profile -----
  'profile_title': {'en': 'Profile', 'bn': 'প্রোফাইল'},
  'badge_verified': {'en': 'Verified resident', 'bn': 'যাচাইকৃত বাসিন্দা'},
  'badge_pending': {'en': 'Verification pending', 'bn': 'যাচাই চলছে'},
  'badge_not_verified': {'en': 'Not verified', 'bn': 'যাচাই হয়নি'},
  'verify_sub_verified': {
    'en': 'You can report problems',
    'bn': 'আপনি অভিযোগ জানাতে পারবেন',
  },
  'verify_sub_pending': {
    'en': 'Waiting for admin approval',
    'bn': 'অ্যাডমিনের অনুমোদনের অপেক্ষায়',
  },
  'verify_sub_none': {
    'en': 'Get verified to report problems',
    'bn': 'অভিযোগ জানাতে যাচাই করিয়ে নিন',
  },
  'lbl_phone': {'en': 'Phone', 'bn': 'ফোন'},
  'lbl_area': {'en': 'Area', 'bn': 'এলাকা'},
  'lbl_email': {'en': 'Email', 'bn': 'ইমেইল'},
  'menu_verification': {'en': 'Verification', 'bn': 'যাচাইকরণ'},
  'menu_edit_profile': {'en': 'Edit Profile', 'bn': 'প্রোফাইল সম্পাদনা'},
  'menu_edit_sub': {
    'en': 'Change your name and phone',
    'bn': 'নাম ও ফোন নম্বর বদলান',
  },
  'menu_language': {'en': 'Language', 'bn': 'ভাষা'},
  'menu_about': {'en': 'About Nexora', 'bn': 'Nexora সম্পর্কে'},
  'menu_admin': {'en': 'Admin Panel', 'bn': 'অ্যাডমিন প্যানেল'},
  'menu_admin_sub': {
    'en': 'Verify users, reports, notices',
    'bn': 'ব্যবহারকারী যাচাই, অভিযোগ ও নোটিশ',
  },
  'about_text': {
    'en':
        'A digital community service platform for people living in the same area.',
    'bn': 'একই এলাকার মানুষের জন্য একটি ডিজিটাল কমিউনিটি সেবা প্ল্যাটফর্ম।',
  },
  'lbl_full_name': {'en': 'Full Name', 'bn': 'পূর্ণ নাম'},
  'lbl_phone_number': {'en': 'Phone Number', 'bn': 'ফোন নম্বর'},
  'save': {'en': 'Save', 'bn': 'সংরক্ষণ করুন'},
  'profile_updated': {'en': 'Profile updated', 'bn': 'প্রোফাইল আপডেট হয়েছে'},
  'choose_language': {'en': 'Choose language', 'bn': 'ভাষা বেছে নিন'},
  'logout': {'en': 'Logout', 'bn': 'লগআউট'},
  'logout_confirm': {
    'en': 'Are you sure you want to logout?',
    'bn': 'আপনি কি লগআউট করতে চান?',
  },
  'cancel': {'en': 'Cancel', 'bn': 'বাতিল'},
    // ----- Report: categories and priorities -----
  'cat_Road': {'en': 'Road', 'bn': 'রাস্তা'},
  'cat_Water': {'en': 'Water', 'bn': 'পানি'},
  'cat_Electricity': {'en': 'Electricity', 'bn': 'বিদ্যুৎ'},
  'cat_Garbage': {'en': 'Garbage', 'bn': 'ময়লা'},
  'cat_Safety': {'en': 'Safety', 'bn': 'নিরাপত্তা'},
  'cat_Other': {'en': 'Other', 'bn': 'অন্যান্য'},
  'cat_Normal': {'en': 'Normal', 'bn': 'সাধারণ'},
  'cat_Urgent': {'en': 'Urgent', 'bn': 'অতি জরুরি'},

  // ----- Report: page -----
  'rep_appbar': {'en': 'Report a Problem', 'bn': 'সমস্যা জানান'},
  'rep_header_title': {
    'en': 'Help improve your area',
    'bn': 'এলাকার উন্নতিতে সাহায্য করুন',
  },
  'rep_header_sub': {
    'en': 'Report local problems to the admin',
    'bn': 'স্থানীয় সমস্যা অ্যাডমিনকে জানান',
  },

  // ----- Report: locked view -----
  'rep_locked_title': {
    'en': 'Verification required',
    'bn': 'যাচাইকরণ প্রয়োজন',
  },
  'rep_locked_text': {
    'en':
        'To stop false and spam reports, only verified residents of this area can report problems.',
    'bn':
        'ভুয়া ও স্প্যাম অভিযোগ ঠেকাতে শুধু যাচাইকৃত বাসিন্দারা সমস্যা জানাতে পারবেন।',
  },
  'rep_how_verified': {
    'en': 'How to get verified',
    'bn': 'কীভাবে যাচাই হবেন',
  },
  'rep_step1': {
    'en': 'Send your house number, block and phone number',
    'bn': 'বাড়ির নম্বর, ব্লক ও ফোন নম্বর পাঠান',
  },
  'rep_step2': {
    'en': 'The admin checks your details',
    'bn': 'অ্যাডমিন আপনার তথ্য মিলিয়ে দেখবেন',
  },
  'rep_step3': {
    'en': 'You get the Verified badge and can report',
    'bn': 'আপনি যাচাইকৃত ব্যাজ পাবেন ও অভিযোগ জানাতে পারবেন',
  },
  'rep_request_btn': {
    'en': 'Request Verification',
    'bn': 'যাচাইয়ের অনুরোধ করুন',
  },

  // ----- Report: verification request sheet -----
  'rep_sheet_sub': {
    'en': 'The admin will check these details.',
    'bn': 'অ্যাডমিন এই তথ্যগুলো মিলিয়ে দেখবেন।',
  },
  'rep_house': {'en': 'House / Holding No.', 'bn': 'বাড়ি / হোল্ডিং নম্বর'},
  'rep_block': {'en': 'Road / Block', 'bn': 'রোড / ব্লক'},
  'rep_err_house': {
    'en': 'Please enter your house number',
    'bn': 'বাড়ির নম্বর লিখুন',
  },
  'rep_err_block': {
    'en': 'Please enter your road or block',
    'bn': 'রোড বা ব্লক লিখুন',
  },
  'rep_err_phone': {
    'en': 'Phone number must be at least 11 digits',
    'bn': 'ফোন নম্বর কমপক্ষে ১১ অঙ্কের হতে হবে',
  },
  'rep_send_request': {'en': 'Send Request', 'bn': 'অনুরোধ পাঠান'},
  'rep_request_sent': {
    'en': 'Verification request sent',
    'bn': 'যাচাইয়ের অনুরোধ পাঠানো হয়েছে',
  },

  // ----- Report: pending view -----
  'rep_pending_title': {
    'en': 'Verification pending',
    'bn': 'যাচাই চলছে',
  },
  'rep_pending_text': {
    'en':
        'The admin is checking your details. You can report problems as soon as you are approved.',
    'bn':
        'অ্যাডমিন আপনার তথ্য যাচাই করছেন। অনুমোদন পেলেই আপনি সমস্যা জানাতে পারবেন।',
  },

  // ----- Report: form -----
  'rep_problem_title': {'en': 'Problem title', 'bn': 'সমস্যার শিরোনাম'},
  'rep_err_title': {'en': 'Please enter a title', 'bn': 'শিরোনাম লিখুন'},
  'rep_err_title_short': {
    'en': 'Title is too short',
    'bn': 'শিরোনাম খুব ছোট',
  },
  'rep_what_kind': {
    'en': 'What kind of problem?',
    'bn': 'কী ধরনের সমস্যা?',
  },
  'rep_err_category': {
    'en': 'Please select a category',
    'bn': 'একটি ধরন বেছে নিন',
  },
  'rep_how_urgent': {'en': 'How urgent is it?', 'bn': 'কতটা জরুরি?'},
  'rep_location': {'en': 'Location (optional)', 'bn': 'অবস্থান (ঐচ্ছিক)'},
  'rep_describe': {'en': 'Describe the problem', 'bn': 'সমস্যাটি বর্ণনা করুন'},
  'rep_err_desc': {
    'en': 'Please describe the problem',
    'bn': 'সমস্যার বর্ণনা লিখুন',
  },
  'rep_err_desc_short': {
    'en': 'Please write at least 10 characters',
    'bn': 'কমপক্ষে ১০ অক্ষর লিখুন',
  },
  'rep_add_photo': {'en': 'Add a photo (optional)', 'bn': 'ছবি যোগ করুন (ঐচ্ছিক)'},
  'rep_photo_later': {
    'en': 'Photo upload will be added later',
    'bn': 'ছবি আপলোড পরে যোগ হবে',
  },
  'rep_submit': {'en': 'Submit Report', 'bn': 'অভিযোগ জমা দিন'},
  'rep_submit_fail': {
    'en': 'Could not submit. Are you verified?',
    'bn': 'জমা দেওয়া যায়নি। আপনি কি যাচাইকৃত?',
  },
  'rep_done_title': {'en': 'Report submitted', 'bn': 'অভিযোগ জমা হয়েছে'},
  'rep_done_text': {
    'en': 'Status: Under review\nThe admin will check your report.',
    'bn': 'অবস্থা: যাচাই চলছে\nঅ্যাডমিন আপনার অভিযোগ দেখবেন।',
  },
  'ok': {'en': 'OK', 'bn': 'ঠিক আছে'},
};

// Returns the text of the current language
String t(String key) {
  final lang = AppLanguage.isBangla ? 'bn' : 'en';
  return _strings[key]?[lang] ?? _strings[key]?['en'] ?? key;
}
// Translates a category name (e.g. 'Plumber'). Unknown names stay as they are.
String tCat(String category) {
  final key = 'cat_$category';
  if (_strings.containsKey(key)) return t(key);
  return category;
}