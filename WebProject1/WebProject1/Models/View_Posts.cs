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
    
    public partial class View_Posts
    {
        public string ProfilePicture { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public int PostID { get; set; }
        public int UserID { get; set; }
        public string Text_of_Post { get; set; }
        public string PictureURL { get; set; }
        public string User_Posted { get; set; }
        public int Likes { get; set; }
        public int CommentID { get; set; }
        public string Text_of_Comment { get; set; }
        public string User_Commented { get; set; }
        public int UsercommentedID { get; set; }
        public Nullable<System.DateTime> DatePosted { get; set; }
        public Nullable<System.DateTime> DateCommented { get; set; }
    }
}
