using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebProject1.Models;

namespace WebProject1.Controllers
{
    public class AdminController : Controller
    {

        SocialNetworkEntities7 db = new SocialNetworkEntities7();
        // GET: Admin
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult AdminPanel()
        {
            var users = db.User.ToList();
            if (users == null || users.Count == 0)
                throw new Exception("Users not found");

            var model = new AdminViewModel();
            foreach (var user in users)
            {
                model.Users.Add(new UserModel()
                {
                    FirstName = user.FirstName,
                    LastName = user.LastName,
                    UserID = user.UserID
                });
            }

            return View(model);
        }
        public ActionResult Delete(int userId)
        {
            var user = db.User.FirstOrDefault(s => s.UserID == userId);
            if(user == null)
                throw new Exception("User not found");

            db.User.Remove(user);
            db.SaveChanges();

            var users = db.User.ToList();
           

            var model = new AdminViewModel();
            foreach (var item in users)
            {
                model.Users.Add(new UserModel()
                {
                    FirstName = item.FirstName,
                    LastName = item.LastName,
                    UserID = item.UserID
                });
            }


            return View("AdminPanel", model);
        }
     
    }
}