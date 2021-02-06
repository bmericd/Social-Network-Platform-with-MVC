using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace WebProject1.Models
{
    public class UserPostCommentViewModel
    {
        public PostModel Post { get; set; }

     
    }

    public class UserModel
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public int UserID { get; set; }
        public string ProfilePictureURL { get; set; }
        public string Name { get; set; }
        public string ProfileDescription { get; set; }
        public string Hobby { get; set; }


    }

    public class PostModel
    {

        public PostModel()
        {         
            Comment = new List<CommentModel>();
        }

        public UserModel User { get; set; }
        public List<CommentModel> Comment { get; set; }

        public int PostID { get; set; }
        public string PostText { get; set; }
        public int Likes { get; set; }
        public DateTime? DatePosted { get; set; }
        public int UserID { get; set; }
        public string PostPictureURL { get; set; }
        public string UserPostedName { get; set; }

    }

    public class CommentModel
    {
        public int CommentID { get; set; }
        public int PostID { get; set; }
        public string UserCommentedName { get; set; }
        public int UserCommentedID { get; set; }
        public DateTime? DateCommented { get; set; }
        public string CommentText { get; set; }


    }
}