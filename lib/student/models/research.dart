import 'package:arsys/faculty/model/faculty.dart';
import 'package:arsys/student/models/defense_approval.dart';
import 'package:arsys/student/models/milestone.dart';
import 'package:arsys/student/models/proposal_review.dart';

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

  List<Faculty>? supervisor = <Faculty>[];
  Milestone? milestone;
  List<DefenseApproval>? defenseApproval = <DefenseApproval>[];
  List<ProposalReview>? proposalReview = <ProposalReview>[];
  // var supervise;

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
    researchCode = json['research_code'];
    title = json['title'];
    abstract = json['abstract'];
    researchMilestone = json['research_milestone'] ?? -1;
    status = json['status'] ?? -1;
    approvalDate = json['approval_date'];
    milestone = Milestone.fromJson(json['milestone']);
    for (var item in json['supervisor']) {
      supervisor!.add(Faculty.fromJson(item['faculty']));
    }
    for (var item in json['defense_approval']) {
      defenseApproval!.add(DefenseApproval.fromJson(item));
    }
    for (var item in json['proposal_review']) {
      proposalReview!.add(ProposalReview.fromJson(item));
    }
    siasPro = siasStatusAssigner(json['s_i_a_s_pro']);
    siasProPre = siasStatusAssigner(json['s_i_a_s_pro_pre']);
    siasFinal = siasStatusAssigner(json['s_i_a_s_final']);
    siasFinalPre = siasStatusAssigner(json['s_i_a_s_final_pre']);
    // supervise = json['supervise'];
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

  String getInformation() {
    String message = milestone!.description ?? "";
    if (milestone?.sequence == 4) {
      // Proposal sudah approved di arsys
      if (siasPro) {
        // Proposal approved di SIAS
        message =
            "Checking research proposal in SIAS has been done. Now, you can proceed to the next step.";
      } else {
        // Proposal belum approved di SIAS
        if (!siasProPre) {
          // Proposal belum di submit ke SIAS
          message =
              "Submit your research proposal at SIAS, and hit the SUBMIT button if you done.\nYou could not proceed to the next stage if you have not confirmed, and please submitted it no later than two weeks.";
        } else {
          // Proposal menunggu pengecekan oleh admin ke SIAS
          message = "Waiting admin approval based on SIAS";
        }
      }
    }
    return message;
  }

  bool siasStatusAssigner(var sias) {
    if (sias == null || sias == "") {
      return false;
    } else {
      return true;
    }
  }
}


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