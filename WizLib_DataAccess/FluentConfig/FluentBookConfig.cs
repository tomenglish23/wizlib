﻿using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WizLib_Model.Models;

namespace WizLib_DataAccess.FluentConfig
{
    public class FluentBookConfig : IEntityTypeConfiguration<Fluent_Book>
    {
        public void Configure(EntityTypeBuilder<Fluent_Book> modelBuilder)
        {
            // Name of Table

            //Book
            modelBuilder.HasKey(b => b.Book_Id);
            modelBuilder.Property(b => b.ISBN).IsRequired().HasMaxLength(15);
            modelBuilder.Property(b => b.Title).IsRequired();
            modelBuilder.Property(b => b.Price).IsRequired();

            // Relations

            //one to one Book to BookDetail
            modelBuilder
                .HasOne(b => b.Fluent_BookDetail)
                .WithOne(b => b.Fluent_Book).HasForeignKey<Fluent_Book>("BookDetail_Id");
            //one to many publisher to Book
            modelBuilder
                .HasOne(b => b.Fluent_Publisher)
                .WithMany(b => b.Fluent_Book).HasForeignKey(b => b.Publisher_Id);
        }
    }
}
