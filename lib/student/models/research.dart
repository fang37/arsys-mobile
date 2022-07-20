import 'package:arsys/faculty/models/faculty.dart';
import 'package:arsys/student/models/defense_approval.dart';
import 'package:arsys/student/models/milestone.dart';
import 'package:arsys/student/models/proposal_review.dart';
import 'package:arsys/student/models/spv.dart';
import 'package:arsys/student/models/student.dart';
import 'package:arsys/student/models/supervisor_score.dart';
import 'package:arsys/student/models/turnitin.dart';
import 'package:get/get.dart';

class Research {
  int? id;
  int? researchType;
  String? researchName; // dict
  String? researchCode;
  String? title;
  String? abstract;
  int? researchMilestone;
  int? status;
  String? approvalDate;
  String? researchId;

  bool siasPro = false;
  bool siasProPre = false;
  bool siasFinal = false;
  bool siasFinalPre = false;

  Student? student;
  List<Faculty>? supervisor = <Faculty>[];
  List<SPV>? spv = <SPV>[];
  Milestone? milestone;
  List<DefenseApproval>? defenseApproval = <DefenseApproval>[];
  List<ProposalReview>? proposalReview = <ProposalReview>[];
  Turnitin? turnitinPre;

  // var supervise;

  var information = "".obs;

  Research({
    this.id,
    this.researchType,
    this.researchName,
    this.researchCode,
    this.title,
    this.abstract,
    this.researchMilestone,
    this.status,
    this.approvalDate,
    this.researchId,
    this.supervisor,
    this.milestone,
    this.defenseApproval,
    // this.supervise
  });

  Research.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    researchType = json['research_type'] ?? -1;
    researchName = getResearchName(json['research_type'] ?? -1);
    researchCode = json['research_code'] ?? "";
    title = json['title'] ?? "";
    abstract = json['abstract'] ?? "";
    researchMilestone = json['research_milestone'] ?? -1;
    status = json['status'] ?? -1;
    approvalDate = json['approval_date'] ?? "";
    if (json['student'] != null) {
      student = Student.fromJson(json['student']);
    }
    if (json['milestone'] != null) {
      milestone = Milestone.fromJson(json['milestone']);
    }
    for (var item in json['supervisor'] ?? []) {
      supervisor!.add(Faculty.fromJson(item['faculty']));
    }
    for (var item in json['supervisor'] ?? []) {
      spv!.add(SPV.fromJson(item));
    }
    // print(supervisor![0].id);

    for (var item in json['defense_approval'] ?? []) {
      defenseApproval!.add(DefenseApproval.fromJson(item));
    }

    for (var item in json['proposal_review'] ?? []) {
      proposalReview!.add(ProposalReview.fromJson(item));
    }
    siasPro = siasStatusAssigner(json['s_i_a_s_pro']);
    siasProPre = siasStatusAssigner(json['s_i_a_s_pro_pre']);
    siasFinal = siasStatusAssigner(json['s_i_a_s_final']);
    siasFinalPre = siasStatusAssigner(json['s_i_a_s_final_pre']);

    turnitinPre = turnitinAssigner(json['turnitin_predefense']);
    updateInformation();
    // supervise = json['supervise'];
  }

  Research.listFromJson(Map<String, dynamic> json) {
    id = json['id'];
    researchType = json['research_type'] ?? -1;
    researchName = getResearchName(json['research_type'] ?? -1);
    researchCode = json['research_code'];
    title = json['title'];
    abstract = json['abstract'];
    researchMilestone = json['research_milestone'] ?? -1;
    status = json['status'] ?? -1;
    approvalDate = json['approval_date'];
    milestone = Milestone.fromJson(json['milestone']);
    // supervise = json['supervise'];
  }

  Research.supervisionFromJson(Map<String, dynamic> json) {
    id = json['id'];
    researchType = json['research_type'] ?? -1;
    researchName = getResearchName(json['research_type'] ?? -1);
    researchCode = json['research_code'];
    title = json['title'];
    abstract = json['abstract'];
    researchMilestone = json['research_milestone'] ?? -1;
    status = json['status'] ?? -1;
    approvalDate = json['approval_date'];
    milestone = Milestone.fromJson(json['milestone']);
    student = Student.fromJson(json['student']);
    for (var item in json['supervisor']) {
      supervisor!.add(Faculty.fromJson(item['faculty']));
    }
    for (var item in json['defense_approval']) {
      defenseApproval!.add(DefenseApproval.fromJson(item));
    }
  }

  String getResearchName(int type) {
    switch (type) {
      case 1:
        {
          return 'SKRIPSI';
        }
      case 2:
        {
          return 'Tugas Akhir';
        }
      case 3:
        {
          return 'Praktik Industri';
        }
      case 4:
        {
          return 'Seminar Teknik Elektro';
        }
      case 5:
        {
          return 'TESIS';
        }
      case 6:
        {
          return 'DISERTASI';
        }
      default:
        {
          return '-';
        }
    }
  }

  String getSupervisorCode() {
    String code = "-";
    for (Faculty sv in supervisor!) {
      if (code == "-") {
        code = sv.code!;
      } else {
        code = code + " - " + sv.code!;
      }
    }
    return code;
  }

  bool isSupervisor(int facultyId) {
    for (Faculty faculty in supervisor!) {
      if (faculty.id == facultyId) {
        return true;
      }
    }
    return false;
  }

  int? getSupervisorScore(int facultyId) {
    for (SPV item in spv!) {
      if (item.supervisorId == facultyId) {
        if (item.supervisorScore?.first.mark != -1) {
          return item.supervisorScore?.first.mark;
        }
      }
    }
    return null;
  }

  SPV? getSPV(int facultyId) {
    for (SPV item in spv!) {
      if (item.supervisorId == facultyId) {
        return item;
      }
    }
    return null;
  }

  void updateInformation() {
    information.value = milestone?.description ?? "";
    if (milestone?.sequence == 4) {
      // Proposal sudah approved di arsys
      if (siasPro) {
        // Proposal approved di SIAS
        information.value =
            "Checking research proposal in SIAS has been done. Now, you can proceed to the next step.";
      } else {
        // Proposal belum approved di SIAS
        if (!siasProPre) {
          // Proposal belum di submit ke SIAS
          information.value =
              "Submit your research proposal at SIAS, and hit the SUBMIT button if you done.\nYou could not proceed to the next stage if you have not confirmed, and please submitted it no later than two weeks.";
        } else {
          // Proposal menunggu pengecekan oleh admin ke SIAS
          information.value = "Waiting admin approval based on SIAS";
        }
      }
    }
    if (milestone?.sequence == 6) {
      if (turnitinPre?.approval == false) {
        information.value =
            "${milestone?.message} please fullfil the other requirements on arsys-website";
      }
    }
    if (milestone?.sequence == 8) {
      information.value =
          "Pre defense has been scheduled, please contact your supervisors and examiners for confirmation";
    }
  }

  bool siasStatusAssigner(var sias) {
    if (sias == null || sias == "") {
      return false;
    } else {
      return true;
    }
  }

  Turnitin turnitinAssigner(var turnitin) {
    if (turnitin == null) {
      return Turnitin.nullJson();
    } else {
      return Turnitin.fromJson(turnitin);
    }
  }

  SubmissionType getSubmissionType() {
    if (milestone?.sequence == 4 && siasProPre == false && siasPro == false) {
      // SIAS Proposal
      return SubmissionType.siasPro;
    } else if (milestone?.sequence == 4 && siasPro == true) {
      // Pre Defense Propose
      return SubmissionType.defense;
    } else if (milestone?.sequence == 6 && turnitinPre?.id == -1) {
      // Request Turnitin Invitation
      return SubmissionType.turnitin;
    } else if (milestone?.sequence == 9) {
      // Defense Report
      return SubmissionType.defenseReport;
    } else if (milestone?.sequence == 10 && milestone!.proposeButton) {
      // Final Defense Propose
      return SubmissionType.finalDefense;
    } else {
      return SubmissionType.none;
    }
  }

  getSubmissionButton() {
    if (milestone?.sequence == 4 && siasProPre == false && siasPro == false) {
      // SIAS Proposal
      return true;
    } else if (milestone?.sequence == 4 && siasPro == true) {
      // Pre Defense
      return true;
    } else if (milestone?.sequence == 6 && turnitinPre?.id == -1) {
      // Request Turnitin Invitation
      return true;
    } else if (milestone?.sequence == 9) {
      // Report of Defense
      return true;
    } else {
      return false;
    }
  }

  String getSubmissionTitle() {
    if (getSubmissionType() == SubmissionType.siasPro) {
      // SIAS Proposal
      return "SIAS Proposal";
    } else if (getSubmissionType() == SubmissionType.defense) {
      return "Pre Defense";
    } else if (getSubmissionType() == SubmissionType.turnitin) {
      return "Turnitin";
    } else if (getSubmissionType() == SubmissionType.defenseReport) {
      // Report of Defense
      return "Report of Defense";
    } else if (getSubmissionType() == SubmissionType.finalDefense) {
      // Report of Defense
      return "Final Defense";
    } else {
      return "You have no submission for now";
    }
  }

  String getSubmissionDescription() {
    if (getSubmissionType() == SubmissionType.siasPro) {
      return "Only hit the SUBMIT button when you're finished uploading the research propsal at SIAS";
    } else if (getSubmissionType() == SubmissionType.defense) {
      return "Hit the propose button to proceed the next step";
    } else if (getSubmissionType() == SubmissionType.turnitin) {
      return "Get Turnitin score by the invitation and Pass Turnitin similarity < 25% \nMake sure that your email address is valid. Hence, please check the email address in your profile before applying the Turnitin invitation. Please refer to the nearest defense schedule for the deadline of Turnitin submission";
    } else if (getSubmissionType() == SubmissionType.defenseReport) {
      return "You should write the report of defense to continue the milestone";
    } else if (getSubmissionType() == SubmissionType.finalDefense) {
      return "Hit the propose button to proceed the next step";
    } else {
      return '';
    }
  }

  EventType getEventType() {
    if (milestone?.sequence == 6 &&
        turnitinPre!.score! <= 25 &&
        turnitinPre?.approval == true) {
      // Apply Pre Defense Event
      return EventType.preDefense;
    } else if (milestone?.sequence == 7 ||
        milestone?.sequence == 8 ||
        milestone?.sequence == 9) {
      // Open Event Page for see the schedule and details of event
      return EventType.schedule;
    } else if (milestone?.sequence == 12) {
      // Apply Final Defense Event
      return EventType.finalDefense;
    } else if (milestone?.sequence == 13 ||
        milestone?.sequence == 14 ||
        milestone?.sequence == 15) {
      // Open Event Page for see the schedule and details of event
      return EventType.schedule;
    } else {
      return EventType.none;
    }
  }

  bool getEventButton() {
    if (getEventType() == EventType.preDefense) {
      // Apply Pre Defense Event
      return true;
    } else if (milestone?.sequence == 12) {
      // Apply Final Defense Event
      return true;
    } else
      return false;
  }

  bool getEventScheduleButton() {
    if (milestone?.sequence == 7 ||
        milestone?.sequence == 8 ||
        milestone?.sequence == 9) {
      return true;
    } else {
      return false;
    }
  }
}

enum SubmissionType {
  none,
  siasPro,
  defense,
  turnitin,
  preDefenseEvent,
  defenseReport,
  finalDefense
}

enum EventType { none, preDefense, finalDefense, schedule }


//  "research": [
//         {
//             "id": 555,
//             "academic_year_id": null,
//             "research_type": 2,
//             "student_id": 399,
//             "research_code": "TA-1701089-2",
//             "title": "RANCANG BANGUN PURWARUPA SISTEM TELEMETRI DETEKSI DINI PADA BENCANA KEKERINGAN",
//             "abstract": "Penelitian ini bertujuan untuk merancang sebuah sistem implementasi dari telemetri yaitu sistem peringatan dini kekeringan dimana mampu untuk memberikan data pengukuran secara realtime melalui notifikasi TelegramPenelitian ini memiliki tujuan untuk mengawasi dua indikator bencana kekeringan, yaitu curah hujan dan kelembaban tanah sebagai sebuah sistem untuk mendeteksi secara dini adanya bencana kekeringan. Pengawasan ini menggunakan Sistem Telemetri dimana pengukuran indikator dilakukan secara jarak jauh menggunakan dua Platform yaitu ANTARES serta Telegram. Sensor soil moisture digunakan untuk mengukur kadar kelembaban tanah dan rain gauge digunakan untuk mengukur tingkat curah hujan, dimana semuanya diatur oleh ESP32 sebagai pengolah data dan mengirimkan data melalui koneksi WiFi ke Platform yang telah dipilih. Hasil penelitian ini adalah suatu perangkat yang dapat mengukur kadar kelembaban tanah dan curah hujan serta memberikan laporan dalam bentuk notifikasi ke Telegram dan data mentah dalam sebuah website. Hasil purwarupa ini menampilkan pembacaan sensor-sensor serta pengiriman datanya dalam rentang 6 jam",
//             "research_milestone": 20,
//             "status": 1,
//             "approval_date": "2021-05-17 08:19:31",
//             "remark": null,
//             "file": null,
//             "created_at": "2021-03-24T21:44:07.000000Z",
//             "updated_at": "2022-01-12T09:24:32.000000Z",
//             "research_id": null,
//             "username": null,
//             "milestone": {
//                 "id": 32,
//                 "milestone": "Graduated",
//                 "milestone_model": "defense",
//                 "propose_button": null,
//                 "phase": "Graduated",
//                 "sequence": 20,
//                 "status": null,
//                 "description": "Final-defense has completed",
//                 "message": null,
//                 "created_at": null,
//                 "updated_at": null
//             },
//             "supervise": [],
//             "supervisor": [
//                 {
//                     "id": 23,
//                     "research_id": 555,
//                     "supervisor_id": 15,
//                     "bypass": 1,
//                     "created_at": "2021-07-15T18:11:29.000000Z",
//                     "updated_at": "2021-07-15T18:11:29.000000Z",
//                     "faculty": {
//                         "id": 15,
//                         "user_id": 185,
//                         "sso_username": "197208262005011001",
//                         "code": "AHS",
//                         "upi_code": "2410",
//                         "nip": "197208262005011001",
//                         "old_nip": null,
//                         "front_title": null,
//                         "rear_title": "MT.",
//                         "first_name": "Agus Heri Setya",
//                         "last_name": "Budi",
//                         "duty_id": null,
//                         "specialization_id": 3,
//                         "program_id": null,
//                         "phone": null,
//                         "email": null,
//                         "created_at": "2021-03-22T09:34:26.000000Z",
//                         "updated_at": "2021-10-16T13:44:31.000000Z"
//                     }
//                 },
//                 {
//                     "id": 24,
//                     "research_id": 555,
//                     "supervisor_id": 19,
//                     "bypass": 1,
//                     "created_at": "2021-07-22T19:34:44.000000Z",
//                     "updated_at": "2021-07-22T19:34:44.000000Z",
//                     "faculty": {
//                         "id": 19,
//                         "user_id": 144,
//                         "sso_username": "130809446",
//                         "code": "MKH",
//                         "upi_code": "0535",
//                         "nip": "195311101980021001",
//                         "old_nip": null,
//                         "front_title": "Prof. Dr. H.",
//                         "rear_title": "M.Pd.",
//                         "first_name": "Mukhidin",
//                         "last_name": "",
//                         "duty_id": null,
//                         "specialization_id": null,
//                         "program_id": null,
//                         "phone": null,
//                         "email": null,
//                         "created_at": "2021-03-22T09:34:26.000000Z",
//                         "updated_at": "2021-04-08T00:24:07.000000Z"
//                     }
//                 }
//             ],
//             "defense_approval": [
//                 {
//                     "id": 201,
//                     "research_id": 555,
//                     "defense_model": {
//                         "id": 1,
//                         "code": "PRE",
//                         "description": "Pre defense",
//                         "created_at": "2021-03-26T00:48:21.000000Z",
//                         "updated_at": "2021-03-26T00:48:24.000000Z"
//                     },
//                     "approver_id": 15,
//                     "approver_role": 1,
//                     "decision": 1,
//                     "approval_date": "2021-07-19 03:58:07",
//                     "created_at": "2021-07-19T10:58:07.000000Z",
//                     "updated_at": "2021-07-19T10:58:07.000000Z",
//                     "faculty": {
//                         "id": 15,
//                         "user_id": 185,
//                         "sso_username": "197208262005011001",
//                         "code": "AHS",
//                         "upi_code": "2410",
//                         "nip": "197208262005011001",
//                         "old_nip": null,
//                         "front_title": null,
//                         "rear_title": "MT.",
//                         "first_name": "Agus Heri Setya",
//                         "last_name": "Budi",
//                         "duty_id": null,
//                         "specialization_id": 3,
//                         "program_id": null,
//                         "phone": null,
//                         "email": null,
//                         "created_at": "2021-03-22T09:34:26.000000Z",
//                         "updated_at": "2021-10-16T13:44:31.000000Z"
//                     }
//                 },
//                 {
//                     "id": 202,
//                     "research_id": 555,
//                     "defense_model": {
//                         "id": 1,
//                         "code": "PRE",
//                         "description": "Pre defense",
//                         "created_at": "2021-03-26T00:48:21.000000Z",
//                         "updated_at": "2021-03-26T00:48:24.000000Z"
//                     },
//                     "approver_id": 19,
//                     "approver_role": 1,
//                     "decision": 1,
//                     "approval_date": "2021-07-19 03:26:15",
//                     "created_at": "2021-07-19T10:26:15.000000Z",
//                     "updated_at": "2021-07-19T10:26:15.000000Z",
//                     "faculty": {
//                         "id": 19,
//                         "user_id": 144,
//                         "sso_username": "130809446",
//                         "code": "MKH",
//                         "upi_code": "0535",
//                         "nip": "195311101980021001",
//                         "old_nip": null,
//                         "front_title": "Prof. Dr. H.",
//                         "rear_title": "M.Pd.",
//                         "first_name": "Mukhidin",
//                         "last_name": "",
//                         "duty_id": null,
//                         "specialization_id": null,
//                         "program_id": null,
//                         "phone": null,
//                         "email": null,
//                         "created_at": "2021-03-22T09:34:26.000000Z",
//                         "updated_at": "2021-04-08T00:24:07.000000Z"
//                     }
//                 },
//             ]
//         }
//     ]
