namespace LoanAmortFunctions
{
    public struct AmortData
    {
        public string PayDateNo { get; set; }
        public string Balance { get; set; }
        public string InterestPaid { get; set; }
        public string PrincipalPaid { get; set; }
        public string Payment { get; set; }

        public AmortData(string dueDate, string totalPaid, string interestPaid, string principalPaid, string remainingBalance) : this()
        {
            PayDateNo = dueDate;
            Payment = totalPaid;
            InterestPaid = interestPaid;
            PrincipalPaid = principalPaid;
            Balance = remainingBalance;
        }
    }
}