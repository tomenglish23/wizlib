using Microsoft.EntityFrameworkCore.Migrations;

namespace WizLib_DataAccess.Migrations
{
    public partial class addDropBooksFKsConstraints : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            //migrationBuilder.Sql("IF(OBJECT_ID('dbo.FK_Books_BookDetails_BookDetail_Id', 'F') IS NOT NULL)"
            //                   + "BEGIN"
            //                   + "    ALTER TABLE[dbo].[Books] DROP CONSTRAINT FK_Books_BookDetails_BookDetail_Id"
            //                   + "END");


            //migrationBuilder.Sql("IF(OBJECT_ID('dbo.FK_Books_Publishers_Publisher_Id', 'F') IS NOT NULL)"
            //                   + "BEGIN"
            //                   + "    ALTER TABLE[dbo].[Books] DROP CONSTRAINT FK_Books_Publishers_Publisher_Id"
            //                   + "END");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
        }
    }
}
