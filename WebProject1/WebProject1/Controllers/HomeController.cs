using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebProject1.Models;

namespace WebProject1.Controllers
{
    public class HomeController : Controller
    {

        SocialNetworkEntities7 db = new SocialNetworkEntities7();

        public ActionResult Start()
        {

            return View();
        }
        [HttpPost]
        public ActionResult HomePage(PostModel model)
        {

            return View();
        }

        public ActionResult HomePage()
        {

            // var myQuery = db.User.Where(s => s.UserID > 0).Select(s => s);


            var model = GetPosts();

            return View(model);
        }
        [HttpPost]
        public ActionResult HomePage(User model)
        {
            if (Session != null)
            {

                return View(model);
            }


            return View();
        }


        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
        [HttpPost]
        public ActionResult SignUp(User model)
        {


            User user1 = new User()
            {
                FirstName = model.FirstName,
                LastName = model.LastName,
                Email = model.Email,
                Password = model.Password,
                DateJoined = DateTime.Today,
            };



            db.User.Add(user1);

            db.SaveChanges();

            int latestUserId = user1.UserID;

            Session.Add("Name", user1.FirstName + " " + user1.LastName);
            Session.Add("ID", user1.UserID);

            return RedirectToAction("HomePage", "Home", new { user1 });
        }

        public ActionResult SignUp()
        {
            ViewBag.Message = "Your signup page.";



            return View();
        }

        public ActionResult LogIn()
        {
            ViewBag.Message = "Your login page.";

            return View();
        }

        [HttpPost]
        public ActionResult LogIn(User model)
        {

            var user1 = db.User.FirstOrDefault(x => x.Email == model.Email && x.Password == model.Password);

            if (user1 != null)
            {
                // return Redirect("~/Home/HomePage");
                Session.Add("Name", user1.FirstName + " " + user1.LastName);
                Session.Add("ID", user1.UserID);
                return RedirectToAction("HomePage", "Home", new { user1 });
            }
            else
            {
                ViewBag.LoginError = "Incorrect Credentials";
            }

            return View();

        }

        public ActionResult GetUserPage(int userid)
        {

            var userviewed = db.User.FirstOrDefault(s => s.UserID == userid);

            //int index = user.IndexOf(user.Single(s => s.Post.User.UserID == user[1].Post.UserID));

            //return RedirectToAction("UserPage","Home",  userviewed );
            return View("UserPage", userviewed);
        }

        public ActionResult UserPage(User user)
        {



            return View(user);
        }

        [HttpPost]
        public ActionResult CreatePost(CreatePostModel postModel)
        {
            var user = db.User.FirstOrDefault(s => s.UserID == postModel.UserId);
            if (user == null) throw new Exception("User not found");
            var post = new Post()
            {
                Text = postModel.Text,
                DatePosted = DateTime.Now,
                User = user
            };

            var createdPost = db.Post.Add(post);
            db.SaveChanges();

            var postsModel = GetPosts();

            return View("HomePage", postsModel);
        }

        public ActionResult GetEdituser(int userid)
        {
            var model = new EditUserModel();
            var userviewed = db.User.FirstOrDefault(s => s.UserID == userid);

            model.Description = userviewed?.ProfileDescription?.Description;

            model.ProfessionName = userviewed?.Profession?.ProfessionName;

            model.Sex = userviewed?.Sex;
            model.UserID = userviewed.UserID;
            model.Hobby = userviewed.Hobby?.HobbyName;

            return View("EditUser", model);
        }

        [HttpPost]
        public ActionResult EditUser(EditUserModel model)
        {

            User user = db.User.Where(s => s.UserID == model.UserID).FirstOrDefault();

            if (user.ProfileDescription == null)
            {
                user.ProfileDescription = new ProfileDescription()
                {
                    Description = model.Description,
                    User = user
                };
            }
            else
            {
                user.ProfileDescription.Description = model.Description;
            }

            if (user.Profession == null)
            {
                user.Profession = new Profession()
                {
                    ProfessionName = model.ProfessionName,
                    User = user
                };
            }
            else
            {
                user.Profession.ProfessionName = model.ProfessionName;
            }
            if (user.Hobby == null)
            {
                user.Hobby = new Hobby()
                {
                    HobbyName = model.Hobby,
                    User = user,
                };
            }
            else
            {
                user.Hobby.HobbyName = model.Hobby;

            }

            user.Sex = !string.IsNullOrEmpty(model.Sex) ? model.Sex : user.Sex;

            db.SaveChanges();


            return View("UserPage", user);
        }



        public ActionResult SearchUser()
        {

            return View();
        }

        [HttpPost]
        public ActionResult SearchUser(string name)
        {



            return View();
        }

        public ActionResult CreateComment(CreateCommentModel commentModel)
        {

            var user = db.User.AsNoTracking().FirstOrDefault(s => s.UserID == commentModel.UserID);
            if (user == null) throw new Exception("User not found");

            var post = db.Post.AsNoTracking().FirstOrDefault(s => s.PostID == commentModel.PostID);
            if (post == null) throw new Exception("Post not found");

            var comment = new Comment()
            {
                User = user,
                Post = post,
                Text = commentModel.PostCommentText,
                DateCommented = DateTime.Now,
                PostID = post.PostID,
                UserCommentedID = user.UserID
            };

            //db.Comment.Add(comment);
            db.Comment.Attach(comment);
            db.SaveChanges();

            return View("HomePage", GetPosts());
        }

        public ActionResult Like()
        {

            return View();
        }

        private List<UserPostCommentViewModel> GetPosts()
        {
            List<UserPostCommentViewModel> model = new List<UserPostCommentViewModel>();

            var postList = db.Post.ToList();

            foreach (var item in postList)
            {
                var commentList = new List<CommentModel>();
                foreach (var comment in item.Comment)
                {
                    commentList.Add(new CommentModel()
                    {
                        CommentID = comment.CommentID,
                        UserCommentedName = comment.User.FirstName + " " + comment.User.LastName,
                        UserCommentedID = comment.UserCommentedID,
                        CommentText = comment.Text,
                        PostID = comment.PostID,
                        DateCommented = comment.DateCommented,
                    });
                }
                model.Add(new UserPostCommentViewModel()
                {

                    Post = new PostModel()
                    {
                        Comment = commentList,

                        User = new UserModel()
                        {
                            UserID = item.UserID,
                            FirstName = item.User.FirstName,
                            LastName = item.User.LastName,
                            Name = item.User.FirstName + " " + item.User.LastName,
                            ProfilePictureURL = item.User.PictureURL,

                        },

                        PostID = item.PostID,
                        PostText = item.Text,
                        DatePosted = item.DatePosted,
                        Likes = item.Likes,
                        UserID = item.UserID,
                        UserPostedName = item.User.FirstName + " " + item.User.LastName,
                    },

                });

            }
            return model;
        }


    }
}