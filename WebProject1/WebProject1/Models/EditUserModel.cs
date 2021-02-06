using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebProject1.Models
{
    public class EditUserModel
    {
        public string Description { get; set; }
        public string ProfessionName { get; set; }
        public string Sex { get; set; }
        public string Hobby { get; set; }
        public int UserID { get; set; }
    }
}