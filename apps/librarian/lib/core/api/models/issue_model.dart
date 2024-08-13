class Issue {
  final IssueType type;
  final String title;
  final String okTitle;
  final String? explanation;
  final String? okExplanation;
  final String? instructions;
  final String? graphicUrl;

  const Issue({
    required this.title,
    required this.okTitle,
    this.explanation,
    this.okExplanation,
    this.instructions,
    this.graphicUrl,
    required this.type,
  });

  factory Issue.fromCode(String code) {
    return _reasonMap[code]!;
  }

  static final _reasonMap = <String, Issue>{
    'duesNotPaid': duesNotPaidIssue,
    'overdueLoan': overdueLoanIssue,
    'suspended': suspendedIssue,
    'needsLiabilityWaiver': needsLiabilityWaiverIssue,
  };
}

const duesNotPaidIssue = Issue(
  title: "Dues Not Paid",
  okTitle: "Dues Paid",
  explanation: "Annual dues must be paid before borrowing.",
  okExplanation: "Annual dues have been paid.",
  instructions:
      "The borrower can pay their dues from the library's website or by scanning the QR code.",
  graphicUrl: "qr_givebutter.png",
  type: IssueType.duesNotPaid,
);

const overdueLoanIssue = Issue(
  title: "Overdue Loan",
  okTitle: "No Overdue Loans",
  explanation: "All overdue items must be returned before borrowing again.",
  okExplanation: "All loans have been returned.",
  type: IssueType.overdueLoan,
);

const needsLiabilityWaiverIssue = Issue(
  title: "Needs Liability Waiver",
  okTitle: "Liability Waiver Signed",
  explanation:
      "A liability waiver must be signed before checking anything out.",
  okExplanation: "Liability waived!",
  type: IssueType.needsLiabilityWaiver,
);

const suspendedIssue = Issue(
  title: "Suspended",
  okTitle: "In Good Standing",
  explanation: "This person is no longer a member of the library.",
  okExplanation: "This member is in good standing.",
  type: IssueType.suspended,
);

enum IssueType {
  duesNotPaid,
  overdueLoan,
  suspended,
  needsLiabilityWaiver,
}
