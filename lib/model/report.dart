class Report {
  String docId;
  String report;
  String photoMemoId;
  DateTime timestamp;
  List<dynamic> grantedPermission;

  static const REPORT = 'report';
  static const PHOTOMEMO_ID = 'photomemoid';
  static const TIMESTAMP = 'timestamp';
  static const GRANTED_PERMISSION = 'grantedPermission';

  Report({
    this.docId,
    this.report,
    this.photoMemoId,
    this.timestamp,
    this.grantedPermission,
  }) {
    this.grantedPermission ??= [];
  }

  Report.clone(Report r) {
    this.docId = r.docId;
    this.report = r.report;
    this.photoMemoId = r.photoMemoId;
    this.timestamp = r.timestamp;
    this.grantedPermission = [];
    this.grantedPermission.addAll(r.grantedPermission);
  }

  void assign(Report r) {
    this.docId = r.docId;
    this.report = r.report;
    this.photoMemoId = r.photoMemoId;
    this.timestamp = r.timestamp;
    this.grantedPermission = [];
    this.grantedPermission.addAll(r.grantedPermission);
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      REPORT: this.report,
      PHOTOMEMO_ID: this.photoMemoId,
      TIMESTAMP: this.timestamp,
      GRANTED_PERMISSION: this.grantedPermission,
    };
  }

  static Report deserialize(Map<String, dynamic> doc, String docId) {
    return Report(
      docId: docId,
      report: doc[REPORT],
      photoMemoId: doc[PHOTOMEMO_ID],
      timestamp: doc[TIMESTAMP] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(doc[TIMESTAMP].millisecondsSinceEpoch),
      grantedPermission: doc[GRANTED_PERMISSION],
    );
  }
}
