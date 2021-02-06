using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebProject1.Models
{
    public class CreateCommentModel
    {
        public int PostID { get; set; }
        public string PostCommentText { get; set; }
        public int UserID { get; set; }
      
    }
}