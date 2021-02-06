using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebProject1.Models
{
    public class AdminViewModel
    {
        public AdminViewModel()
        {
            Users = new List<UserModel>();
        }
        public List<UserModel> Users { get; set; }
    }

}