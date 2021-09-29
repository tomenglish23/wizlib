using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WizLib_DataAccess.Data;
using WizLib_Model.Models;
using WizLib_Model.ViewModels;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;

namespace WizLib.Controllers
{
    public class BookController : Controller
    {
        private readonly ApplicationDbContext _db;

        public BookController(ApplicationDbContext db)
        {
            _db = db;

            //string sqlCmd;
            //sqlCmd = "IF(OBJECT_ID('dbo.FK_Books_BookDetails_BookDetail_Id', 'F') IS NOT NULL) "
            //            + "BEGIN "
            //            + "    ALTER TABLE[dbo].[Books] DROP CONSTRAINT FK_Books_BookDetails_BookDetail_Id "
            //            + "END";
            //_db.DropFK(db, sqlCmd);   // tmetmetme        

            //sqlCmd = "IF(OBJECT_ID('dbo.FK_Books_Publishers_Publisher_Id', 'F') IS NOT NULL) "
            //            + "BEGIN "
            //            + "    ALTER TABLE[dbo].[Books] DROP CONSTRAINT FK_Books_Publishers_Publisher_Id "
            //            + "END";
            //_db.DropFK(db, sqlCmd);   // tmetmetme        
        }

        public IActionResult Index()
        {
            List<Book> objList = _db.Books.ToList();
            return View(objList);
        }

        public IActionResult Upsert(int? id)
        {
            BookVM obj = new BookVM();
            obj.PublisherList = _db.Publishers.Select(i => new SelectListItem
            {
                Text = i.Name,
                Value = i.Publisher_Id.ToString()
            });
            if (id == null)
            {
                return View(obj);
            }
            // edit
            obj.Book = _db.Books.FirstOrDefault(u => u.Book_Id == id);
            if (obj == null)
            {
                return NotFound();
            }
            return View(obj);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Upsert(BookVM obj)
        {
            //if (ModelState.IsValid)
            //{
                if (obj.Book.Book_Id == 0)
                {
                    // create
                    _db.Books.Add(obj.Book);
                }
                else
                {
                    //update
                    _db.Books.Update(obj.Book);
                }
                _db.SaveChanges();                     // Same as: PM> update-database
                return RedirectToAction(nameof(Index));
            //}
            //return View(obj);
        }

        public IActionResult Delete(int id)
        {
            var objFromDb = _db.Books.FirstOrDefault(u => u.Book_Id == id);
            _db.Books.Remove(objFromDb);
            _db.SaveChanges();
            return RedirectToAction(nameof(Index));
        }
    }
}
