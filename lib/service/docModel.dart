class DoctorModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String phone;
  final bool isVerified;
  final String countryOfOrigin;
  final String idUrl;
  final String profilePicUrl;
  final String regNo;
  final String speciality;
  final bool homeVisitBySlot;
  final bool homeVisitImmediate;
  final bool clinicAppointment;
  final bool videoConsultancy;
  final String clinicName;
  final String clinicAddress;
  final int homeVisitBySlotFee;
  final int homeVisitImmediateFee;
  final int clinicAppointmentFee;
  final int videoConsultancyFee;
  final DateTime updatedOn;
  final DateTime createdOn;

  DoctorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.isVerified,
    required this.countryOfOrigin,
    required this.idUrl,
    required this.profilePicUrl,
    required this.regNo,
    required this.speciality,
    required this.homeVisitBySlot,
    required this.homeVisitImmediate,
    required this.clinicAppointment,
    required this.videoConsultancy,
    required this.clinicName,
    required this.clinicAddress,
    required this.homeVisitBySlotFee,
    required this.homeVisitImmediateFee,
    required this.clinicAppointmentFee,
    required this.videoConsultancyFee,
    required this.updatedOn,
    required this.createdOn,
  });

  // Empty constructor
  DoctorModel.empty()
      : id = '',
        name = '',
        email = '',
        password = '',
        phone = '',
        isVerified = false,
        countryOfOrigin = '',
        idUrl = '',
        profilePicUrl = '',
        regNo = '',
        speciality = '',
        homeVisitBySlot = false,
        homeVisitImmediate = false,
        clinicAppointment = false,
        videoConsultancy = false,
        clinicName = '',
        clinicAddress = '',
        homeVisitBySlotFee = 0,
        homeVisitImmediateFee = 0,
        clinicAppointmentFee = 0,
        videoConsultancyFee = 0,
        updatedOn = DateTime.now(),
        createdOn = DateTime.now();

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      isVerified: json['isVerfied'],
      countryOfOrigin: json['counrtyOfOrigin'],
      idUrl: json['idUrl'],
      profilePicUrl: json['profilePicUrl'],
      regNo: json['regNo'],
      speciality: json['speciality'],
      homeVisitBySlot: json['homeVistBySlot'],
      homeVisitImmediate: json['homeVisitImmediate'],
      clinicAppointment: json['clinicAppointment'],
      videoConsultancy: json['videoConsultancy'],
      clinicName: json['clinicName'],
      clinicAddress: json['clinicAddress'],
      homeVisitBySlotFee: json['homeVistBySlotFee'],
      homeVisitImmediateFee: json['homeVisitImmediateFee'],
      clinicAppointmentFee: json['clinicAppointmentFee'],
      videoConsultancyFee: json['videoConsultancyFee'],
      updatedOn: DateTime.parse(json['updatedOn']),
      createdOn: DateTime.parse(json['createdOn']),
    );
  }

  DoctorModel updateField({
    String? name,
    String? email,
    String? phone,
    String? password,
    bool? isVerified,
    String? countryOfOrigin,
    String? idUrl,
    String? profilePicUrl,
    String? regNo,
    String? speciality,
    bool? homeVisitBySlot,
    bool? homeVisitImmediate,
    bool? clinicAppointment,
    bool? videoConsultancy,
    String? clinicName,
    String? clinicAddress,
    int? homeVisitBySlotFee,
    int? homeVisitImmediateFee,
    int? clinicAppointmentFee,
    int? videoConsultancyFee,
    DateTime? updatedOn,
    DateTime? createdOn,
  }) {
    return DoctorModel(
      id: this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      isVerified: isVerified ?? this.isVerified,
      countryOfOrigin: countryOfOrigin ?? this.countryOfOrigin,
      idUrl: idUrl ?? this.idUrl,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      regNo: regNo ?? this.regNo,
      speciality: speciality ?? this.speciality,
      homeVisitBySlot: homeVisitBySlot ?? this.homeVisitBySlot,
      homeVisitImmediate: homeVisitImmediate ?? this.homeVisitImmediate,
      clinicAppointment: clinicAppointment ?? this.clinicAppointment,
      videoConsultancy: videoConsultancy ?? this.videoConsultancy,
      clinicName: clinicName ?? this.clinicName,
      clinicAddress: clinicAddress ?? this.clinicAddress,
      homeVisitBySlotFee: homeVisitBySlotFee ?? this.homeVisitBySlotFee,
      homeVisitImmediateFee:
          homeVisitImmediateFee ?? this.homeVisitImmediateFee,
      clinicAppointmentFee: clinicAppointmentFee ?? this.clinicAppointmentFee,
      videoConsultancyFee: videoConsultancyFee ?? this.videoConsultancyFee,
      updatedOn: updatedOn ?? this.updatedOn,
      createdOn: createdOn ?? this.createdOn,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'isVerfied': isVerified,
      'counrtyOfOrigin': countryOfOrigin,
      'idUrl': idUrl,
      'profilePicUrl': profilePicUrl,
      'regNo': regNo,
      'speciality': speciality,
      'homeVistBySlot': homeVisitBySlot,
      'homeVisitImmediate': homeVisitImmediate,
      'clinicAppointment': clinicAppointment,
      'videoConsultancy': videoConsultancy,
      'clinicName': clinicName,
      'clinicAddress': clinicAddress,
      'homeVistBySlotFee': homeVisitBySlotFee,
      'homeVisitImmediateFee': homeVisitImmediateFee,
      'clinicAppointmentFee': clinicAppointmentFee,
      'videoConsultancyFee': videoConsultancyFee,
      'updatedOn': updatedOn.toIso8601String(),
      'createdOn': createdOn.toIso8601String(),
    };
  }
}
