using System.Collections.Generic;

namespace LoanAmortFunctions
{
    public class LoanParameters
    {
        public int P { get; set; }
        public int T { get; set; }
        public decimal R { get; set; }
        public IList<string> Errors { get; }

        public LoanParameters()
        {
            Errors = new List<string>();
        }

        internal bool Validate()
        {
            Errors.Clear();

            if (P < 1)
                Errors.Add("Principal must be greater than 0");

            if (T < 1)
                Errors.Add("Term must be greater that 0 ");

            return Errors.Count == 0;
        }
    }
}