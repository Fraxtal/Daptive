using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeRunner
{
    [Serializable]
    public class ExecutionResult
    {
        public bool IsError { get; set; }
        public string ErrorMessage { get; set; }
        public string[] Outputs { get; set; }
    }
}
