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
    
    public partial class User_Information_Admin
    {
        public int UserID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string Sex { get; set; }
        public string PictureURL { get; set; }
        public Nullable<System.DateTime> DateJoined { get; set; }
        public Nullable<System.DateTime> Birthday { get; set; }
        public string Description { get; set; }
        public Nullable<bool> PrivateEmail { get; set; }
        public Nullable<bool> PrivatePicture { get; set; }
        public Nullable<bool> PrivateSex { get; set; }
    }
}
