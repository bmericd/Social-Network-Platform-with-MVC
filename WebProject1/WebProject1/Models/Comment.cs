//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace WebProject1.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class Comment
    {
        public int CommentID { get; set; }
        public string Text { get; set; }
        public Nullable<System.DateTime> DateCommented { get; set; }
        public int UserCommentedID { get; set; }
        public int PostID { get; set; }
    
        public virtual Post Post { get; set; }
        public virtual User User { get; set; }
    }
}