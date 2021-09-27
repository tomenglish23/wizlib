using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WizLib_DataAccess.Data;
using WizLib_Model.Models;

namespace WizLib.Controllers
{
    public class CategoryController : Controller
    {
        private readonly ApplicationDbContext _db;

        public CategoryController(ApplicationDbContext db)
        {
            _db = db;
        }

        public IActionResult Index()
        {
            List<Category> objList = _db.Categories.ToList();
            return View(objList);
        }

        public IActionResult Upsert(int? id)
        {
            Category obj = new Category();
            if (id == null)
            {
                return View(obj);
            }
            // edit
            obj = _db.Categories.FirstOrDefault(u => u.Category_Id == id);
            if (obj == null)
            {
                return NotFound();
            }
            return View(obj);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Upsert(Category obj)
        {
            if (ModelState.IsValid)
            {
                if (obj.Category_Id == 0)
                {
                    // create
                    //_db.Add(obj); This works, too
                    _db.Categories.Add(obj);
                }
                else
                {
                    //update
                    //_db.Categories.Update(obj);      // Same as: PM> add-migration
                    _db.Update(obj);
                }
                _db.SaveChanges();                     // Same as: PM> update-database
                return RedirectToAction(nameof(Index));
            }
            return View(obj);
        }

        public IActionResult Delete(int id)
        {
            var objFromDb = _db.Categories.FirstOrDefault(u => u.Category_Id == id);
            _db.Categories.Remove(objFromDb);
            _db.SaveChanges();
            return RedirectToAction(nameof(Index));
        }

        //public IActionResult CreateMultiple2()
        //{
        //    for (int i = 1; i <= 2; i++)
        //    {
        //        _db.Categories.Add(new Category { Name = Guid.NewGuid().ToString() });
        //    }
        //    _db.SaveChanges();
        //    return RedirectToAction(nameof(Index));
        //}

        //public IActionResult CreateMultiple5()
        //{
        //    for (int i = 1; i <= 5; i++)
        //    {
        //        _db.Categories.Add(new Category { Name = Guid.NewGuid().ToString() });
        //    }
        //    _db.SaveChanges();
        //    return RedirectToAction(nameof(Index));
        //}

        // Create

        public IActionResult CreateMultiple2()
        {
            CreateMultiple(2);
            return RedirectToAction(nameof(Index));
        }

        public IActionResult CreateMultiple5()
        {
            CreateMultiple(5);
            return RedirectToAction(nameof(Index));
        }

        private void CreateMultiple(int itemCt)
        {
            List<Category> catList = new List<Category>();
            for (int i = 1; i <= itemCt; i++)
            {
                catList.Add(new Category { Name = Guid.NewGuid().ToString() });
            }
            _db.Categories.AddRange(catList);
            _db.SaveChanges();
        }

        // Delete

        public IActionResult RemoveMultiple2()
        {
            RemoveMultiple(2);
            return RedirectToAction(nameof(Index));
        }

        public IActionResult RemoveMultiple5()
        {
            RemoveMultiple(5);
            return RedirectToAction(nameof(Index));
        }

        private void RemoveMultiple(int itemCt)
        {
            IEnumerable<Category> catList = _db.Categories.OrderByDescending(u => u.Category_Id).Take(itemCt).ToList();

            _db.Categories.RemoveRange(catList);
            _db.SaveChanges();
        }


    }
}
