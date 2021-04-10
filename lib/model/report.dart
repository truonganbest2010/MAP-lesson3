class Report {
  String docId;
  String report;
  String photoMemoId;
  DateTime timestamp;

  static const REPORT = 'report';
  static const PHOTOMEMO_ID = 'photomemoid';
  static const TIMESTAMP = 'timestamp';

  Report({
    this.docId,
    this.report,
    this.photoMemoId,
    this.timestamp,
  });

  Report.clone(Report r) {
    this.docId = r.docId;
    this.report = r.report;
    this.photoMemoId = r.photoMemoId;
    this.timestamp = r.timestamp;
  }

  void assign(Report r) {
    this.docId = r.docId;
    this.report = r.report;
    this.photoMemoId = r.photoMemoId;
    this.timestamp = r.timestamp;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      REPORT: this.report,
      PHOTOMEMO_ID: this.photoMemoId,
      TIMESTAMP: this.timestamp,
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
    );
  }
}
