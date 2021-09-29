﻿using Microsoft.AspNetCore.Mvc;
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
        }

        public IActionResult Index()
        {
            //List<Book> objList = _db.Books.ToList();
            List<Book> objList = _db.Books.Include(u => u.Publisher).ToList();
            //foreach(var obj in objList)
            //{
            //    // Least efficiient
            //    //obj.Publisher = _db.Publishers.FirstOrDefault(u => u.Publisher_Id == obj.Publisher_Id);

            //    // Explicit Loading: More efficient
            //    _db.Entry(obj).Reference(u => u.Publisher).Load(); // Loads all the publishers.
            //}
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
            //if (ModelState.IsValid)  // tmetmetme - He removed this for now. (S6.510
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

        public IActionResult Details(int? id)
        {
            BookVM obj = new BookVM();

            if (id == null)
            {
                return View(obj);
            }
            // edit
            obj.Book = _db.Books.Include(u => u.BookDetail).FirstOrDefault(u => u.Book_Id == id);

            // If .Include is at the end, it works on the complete entity rather than in the DB:
            //obj.Book = _db.Books.Include(u => u.BookDetail).FirstOrDefault(u => u.Book_Id == id);

            //obj.Book = _db.Books.FirstOrDefault(u => u.Book_Id == id);
            //obj.Book.BookDetail = _db.BookDetails.FirstOrDefault(u => u.BookDetail_Id == obj.Book.BookDetail_Id);

            if (obj == null)
            {
                return NotFound();
            }
            return View(obj);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Details(BookVM obj)
        {
            //if (ModelState.IsValid)  // tmetmetme - He removed this for now. (S6.510
            //{
            if (obj.Book.BookDetail.BookDetail_Id == 0)
            {
                // create
                _db.BookDetails.Add(obj.Book.BookDetail);
                _db.SaveChanges();

                var BookFromDb = _db.Books.FirstOrDefault(u => u.Book_Id == obj.Book.Book_Id);
                BookFromDb.BookDetail_Id = obj.Book.BookDetail.BookDetail_Id;
                _db.SaveChanges();
            }
            else
            {
                //update
                _db.BookDetails.Update(obj.Book.BookDetail);
                _db.SaveChanges();
            }

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

        public IActionResult PlayGround()
        {
            var bookTemp = _db.Books.FirstOrDefault();
            bookTemp.Price = 100;

            var bookCollection = _db.Books;
            double totalPrice = 0;

            foreach (var book in bookCollection)
            {
                totalPrice += book.Price;
            }

            var bookList = _db.Books.ToList();
            foreach (var book in bookList)
            {
                totalPrice += book.Price;
            }

            var bookCollection2 = _db.Books;
            var bookCount1 = bookCollection2.Count();

            var bookCount2 = _db.Books.Count();


            IEnumerable<Book> BookList1 = _db.Books;
            var filteredBook1 = BookList1.Where(b => b.Price > 60).ToList();

            IQueryable<Book> BookList2 = _db.Books;
            var filteredBook2 = BookList2.Where(b => b.Price > 60).ToList();


            // S6.60: UPdating Entity Manually
            var category = _db.Categories.FirstOrDefault();
            _db.Entry(category).State = EntityState.Modified;
            _db.SaveChanges();


            // Updating related data (S6.59)
            // Book_Id 5 BookDetail_Id 4
            // Book_Id 7 BookDetail_Id 3

            var bookTemp1 = _db.Books.Include(b => b.BookDetail).FirstOrDefault(b => b.Book_Id == 5);
            bookTemp1.BookDetail.NumberOfChapters = 5555;
            _db.Books.Update(bookTemp1);
            _db.SaveChanges();

            var bookTemp2 = _db.Books.Include(b => b.BookDetail).FirstOrDefault(b => b.Book_Id == 5);
            bookTemp2.BookDetail.Weight = 3333;
            _db.Books.Attach(bookTemp1);
            _db.SaveChanges();


            return RedirectToAction(nameof(Index));
        }
    }
}
