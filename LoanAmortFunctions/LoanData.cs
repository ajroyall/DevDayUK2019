using System;
using System.Collections.Generic;

namespace LoanAmortFunctions
{
    class LoanData
    {
        public IList<AmortData> AmortList { get; set; }
        public string TotalInterest { get; set; }

        public LoanData()
        {
            AmortList = new List<AmortData>();
        }
    }
}
