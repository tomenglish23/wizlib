IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [Categories] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(max) NULL,
    CONSTRAINT [PK_Categories] PRIMARY KEY ([Id])
);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210921222203_AddCategoryTableToDb', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [Genres] (
    [GenreId] int NOT NULL IDENTITY,
    [Name] nvarchar(max) NULL,
    CONSTRAINT [PK_Genres] PRIMARY KEY ([GenreId])
);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210921230735_AddGenreTableToDb', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

EXEC sp_rename N'[Genres].[Name]', N'GenreName', N'COLUMN';
GO

ALTER TABLE [Genres] ADD [DisplayOrder] int NOT NULL DEFAULT 0;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210924213820_changeNameToGenreNameinGenreTable', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

DECLARE @var0 sysname;
SELECT @var0 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Genres]') AND [c].[name] = N'DisplayOrder');
IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [Genres] DROP CONSTRAINT [' + @var0 + '];');
ALTER TABLE [Genres] DROP COLUMN [DisplayOrder];
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210924215020_removeDisplayOrderColFromGenresTable', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210924215519_temp1', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

DROP TABLE [Genres];
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210924215736_removeGenresTableFromDb', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [Genres] (
    [GenreId] int NOT NULL IDENTITY,
    [GenreName] nvarchar(max) NULL,
    CONSTRAINT [PK_Genres] PRIMARY KEY ([GenreId])
);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210925163539_ChangeTableAndColumnNamesOfGenreTb', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [Genres] DROP CONSTRAINT [PK_Genres];
GO

EXEC sp_rename N'[Genres]', N'tb_Genre';
GO

EXEC sp_rename N'[tb_Genre].[GenreName]', N'Name1', N'COLUMN';
GO

ALTER TABLE [tb_Genre] ADD CONSTRAINT [PK_tb_Genre] PRIMARY KEY ([GenreId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210925164121_temp', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

EXEC sp_rename N'[tb_Genre].[Name1]', N'Name', N'COLUMN';
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210925164157_temp2', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [Books] (
    [Book_Id] int NOT NULL IDENTITY,
    [Title] nvarchar(max) NOT NULL,
    [ISBN] nvarchar(max) NOT NULL,
    [Price] float NOT NULL,
    CONSTRAINT [PK_Books] PRIMARY KEY ([Book_Id])
);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210925165201_AddBookTableToDB', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

DECLARE @var1 sysname;
SELECT @var1 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Books]') AND [c].[name] = N'ISBN');
IF @var1 IS NOT NULL EXEC(N'ALTER TABLE [Books] DROP CONSTRAINT [' + @var1 + '];');
ALTER TABLE [Books] ALTER COLUMN [ISBN] nvarchar(15) NOT NULL;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210925165840_AddMaxLengthToISBNAndNotMappedToPriceRange', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210925170931_AddTablesAuthorAndPublisherToDB', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [Authors] (
    [Author_Id] int NOT NULL IDENTITY,
    [FirstName] nvarchar(max) NOT NULL,
    [LastName] nvarchar(max) NOT NULL,
    [BirthDate] datetime2 NOT NULL,
    [Location] nvarchar(max) NULL,
    CONSTRAINT [PK_Authors] PRIMARY KEY ([Author_Id])
);
GO

CREATE TABLE [Publishers] (
    [Publisher_Id] int NOT NULL IDENTITY,
    [Name] nvarchar(max) NOT NULL,
    [Location] nvarchar(max) NOT NULL,
    CONSTRAINT [PK_Publishers] PRIMARY KEY ([Publisher_Id])
);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210925171033_AddDbSetForAuthorAndPublisher', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

EXEC sp_rename N'[Categories].[Id]', N'Category_Id', N'COLUMN';
GO

ALTER TABLE [Books] ADD [Category_Id] int NOT NULL DEFAULT 0;
GO

CREATE INDEX [IX_Books_Category_Id] ON [Books] ([Category_Id]);
GO

ALTER TABLE [Books] ADD CONSTRAINT [FK_Books_Categories_Category_Id] FOREIGN KEY ([Category_Id]) REFERENCES [Categories] ([Category_Id]) ON DELETE CASCADE;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210925174219_AddFKToBook', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [Books] DROP CONSTRAINT [FK_Books_Categories_Category_Id];
GO

DROP TABLE [Categories];
GO

DROP INDEX [IX_Books_Category_Id] ON [Books];
GO

EXEC sp_rename N'[Books].[Category_Id]', N'BookDetail_Id', N'COLUMN';
GO

CREATE TABLE [BookDetails] (
    [BookDetail_Id] int NOT NULL IDENTITY,
    [NumberOfChapters] int NOT NULL,
    [NumberOfPages] int NOT NULL,
    [Weight] float NOT NULL,
    CONSTRAINT [PK_BookDetails] PRIMARY KEY ([BookDetail_Id])
);
GO

CREATE UNIQUE INDEX [IX_Books_BookDetail_Id] ON [Books] ([BookDetail_Id]);
GO

ALTER TABLE [Books] ADD CONSTRAINT [FK_Books_BookDetails_BookDetail_Id] FOREIGN KEY ([BookDetail_Id]) REFERENCES [BookDetails] ([BookDetail_Id]) ON DELETE CASCADE;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210925175141_Add1to1BookBookDetails', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [Books] ADD [Publisher_Id] int NOT NULL DEFAULT 0;
GO

CREATE INDEX [IX_Books_Publisher_Id] ON [Books] ([Publisher_Id]);
GO

ALTER TABLE [Books] ADD CONSTRAINT [FK_Books_Publishers_Publisher_Id] FOREIGN KEY ([Publisher_Id]) REFERENCES [Publishers] ([Publisher_Id]) ON DELETE CASCADE;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210925180522_AddOneToManyBookAndPublisherRelation', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [BookAuthors] (
    [Book_Id] int NOT NULL,
    [Author_Id] int NOT NULL,
    [Book_Id1] int NULL,
    [Author_Id1] int NULL,
    CONSTRAINT [PK_BookAuthors] PRIMARY KEY ([Author_Id], [Book_Id]),
    CONSTRAINT [FK_BookAuthors_Authors_Author_Id1] FOREIGN KEY ([Author_Id1]) REFERENCES [Authors] ([Author_Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_BookAuthors_Books_Book_Id1] FOREIGN KEY ([Book_Id1]) REFERENCES [Books] ([Book_Id]) ON DELETE NO ACTION
);
GO

CREATE INDEX [IX_BookAuthors_Author_Id1] ON [BookAuthors] ([Author_Id1]);
GO

CREATE INDEX [IX_BookAuthors_Book_Id1] ON [BookAuthors] ([Book_Id1]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210926012800_AddManyToManyBookAndAuthorRelationWithBookAuthor', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [BookAuthors] DROP CONSTRAINT [FK_BookAuthors_Authors_Author_Id1];
GO

ALTER TABLE [BookAuthors] DROP CONSTRAINT [FK_BookAuthors_Books_Book_Id1];
GO

DROP INDEX [IX_BookAuthors_Author_Id1] ON [BookAuthors];
GO

DROP INDEX [IX_BookAuthors_Book_Id1] ON [BookAuthors];
GO

DECLARE @var2 sysname;
SELECT @var2 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[BookAuthors]') AND [c].[name] = N'Author_Id1');
IF @var2 IS NOT NULL EXEC(N'ALTER TABLE [BookAuthors] DROP CONSTRAINT [' + @var2 + '];');
ALTER TABLE [BookAuthors] DROP COLUMN [Author_Id1];
GO

DECLARE @var3 sysname;
SELECT @var3 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[BookAuthors]') AND [c].[name] = N'Book_Id1');
IF @var3 IS NOT NULL EXEC(N'ALTER TABLE [BookAuthors] DROP CONSTRAINT [' + @var3 + '];');
ALTER TABLE [BookAuthors] DROP COLUMN [Book_Id1];
GO

CREATE INDEX [IX_BookAuthors_Book_Id] ON [BookAuthors] ([Book_Id]);
GO

ALTER TABLE [BookAuthors] ADD CONSTRAINT [FK_BookAuthors_Authors_Author_Id] FOREIGN KEY ([Author_Id]) REFERENCES [Authors] ([Author_Id]) ON DELETE CASCADE;
GO

ALTER TABLE [BookAuthors] ADD CONSTRAINT [FK_BookAuthors_Books_Book_Id] FOREIGN KEY ([Book_Id]) REFERENCES [Books] ([Book_Id]) ON DELETE CASCADE;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210926013354_AddForeignKeyAnnotationToBookAuthor', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

DECLARE @var4 sysname;
SELECT @var4 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Publishers]') AND [c].[name] = N'Name');
IF @var4 IS NOT NULL EXEC(N'ALTER TABLE [Publishers] DROP CONSTRAINT [' + @var4 + '];');
ALTER TABLE [Publishers] ALTER COLUMN [Name] nvarchar(max) NULL;
GO

DECLARE @var5 sysname;
SELECT @var5 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Publishers]') AND [c].[name] = N'Location');
IF @var5 IS NOT NULL EXEC(N'ALTER TABLE [Publishers] DROP CONSTRAINT [' + @var5 + '];');
ALTER TABLE [Publishers] ALTER COLUMN [Location] nvarchar(max) NULL;
GO

CREATE TABLE [Fluent_BookDetails] (
    [BookDetail_Id] int NOT NULL IDENTITY,
    [NumberOfChapters] int NOT NULL,
    [NumberOfPages] int NOT NULL,
    [Weight] float NOT NULL,
    CONSTRAINT [PK_Fluent_BookDetails] PRIMARY KEY ([BookDetail_Id])
);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210926171916_AddFluentBookDetailsToDb', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

DECLARE @var6 sysname;
SELECT @var6 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Publishers]') AND [c].[name] = N'Name');
IF @var6 IS NOT NULL EXEC(N'ALTER TABLE [Publishers] DROP CONSTRAINT [' + @var6 + '];');
ALTER TABLE [Publishers] ALTER COLUMN [Name] nvarchar(max) NOT NULL;
ALTER TABLE [Publishers] ADD DEFAULT N'' FOR [Name];
GO

DECLARE @var7 sysname;
SELECT @var7 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Publishers]') AND [c].[name] = N'Location');
IF @var7 IS NOT NULL EXEC(N'ALTER TABLE [Publishers] DROP CONSTRAINT [' + @var7 + '];');
ALTER TABLE [Publishers] ALTER COLUMN [Location] nvarchar(max) NOT NULL;
ALTER TABLE [Publishers] ADD DEFAULT N'' FOR [Location];
GO

CREATE TABLE [Fluent_Authors] (
    [Author_Id] int NOT NULL IDENTITY,
    [FirstName] nvarchar(max) NOT NULL,
    [LastName] nvarchar(max) NOT NULL,
    [BirthDate] datetime2 NOT NULL,
    [Location] nvarchar(max) NULL,
    CONSTRAINT [PK_Fluent_Authors] PRIMARY KEY ([Author_Id])
);
GO

CREATE TABLE [Fluent_Books] (
    [Book_Id] int NOT NULL IDENTITY,
    [Title] nvarchar(max) NOT NULL,
    [ISBN] nvarchar(15) NOT NULL,
    [Price] float NOT NULL,
    CONSTRAINT [PK_Fluent_Books] PRIMARY KEY ([Book_Id])
);
GO

CREATE TABLE [Fluent_Publishers] (
    [Publisher_Id] int NOT NULL IDENTITY,
    [Name] nvarchar(max) NOT NULL,
    [Location] nvarchar(max) NOT NULL,
    CONSTRAINT [PK_Fluent_Publishers] PRIMARY KEY ([Publisher_Id])
);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210926175354_FluentAPIModels', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [tbl_category] (
    [Category_Id] int NOT NULL IDENTITY,
    [CategoryName] nvarchar(max) NULL,
    CONSTRAINT [PK_tbl_category] PRIMARY KEY ([Category_Id])
);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210926175956_AddCategoryWithMixOfDataAnnotationAndFluent', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [Fluent_Books] ADD [BookDetail_Id] int NOT NULL DEFAULT 0;
GO

CREATE UNIQUE INDEX [IX_Fluent_Books_BookDetail_Id] ON [Fluent_Books] ([BookDetail_Id]);
GO

ALTER TABLE [Fluent_Books] ADD CONSTRAINT [FK_Fluent_Books_Fluent_BookDetails_BookDetail_Id] FOREIGN KEY ([BookDetail_Id]) REFERENCES [Fluent_BookDetails] ([BookDetail_Id]) ON DELETE CASCADE;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210926181203_addOneToOneFluentBookAndBookDetail', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [Fluent_Books] ADD [Publisher_Id] int NOT NULL DEFAULT 0;
GO

CREATE INDEX [IX_Fluent_Books_Publisher_Id] ON [Fluent_Books] ([Publisher_Id]);
GO

ALTER TABLE [Fluent_Books] ADD CONSTRAINT [FK_Fluent_Books_Fluent_Publishers_Publisher_Id] FOREIGN KEY ([Publisher_Id]) REFERENCES [Fluent_Publishers] ([Publisher_Id]) ON DELETE CASCADE;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210926181911_addOneToManyFluentBookAndPublisher', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [Fluent_BookAuthor] (
    [Book_Id] int NOT NULL,
    [Author_Id] int NOT NULL,
    [Fluent_AuthorAuthor_Id] int NULL,
    CONSTRAINT [PK_Fluent_BookAuthor] PRIMARY KEY ([Author_Id], [Book_Id]),
    CONSTRAINT [FK_Fluent_BookAuthor_Fluent_Authors_Fluent_AuthorAuthor_Id] FOREIGN KEY ([Fluent_AuthorAuthor_Id]) REFERENCES [Fluent_Authors] ([Author_Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_Fluent_BookAuthor_Fluent_Books_Author_Id] FOREIGN KEY ([Author_Id]) REFERENCES [Fluent_Books] ([Book_Id]) ON DELETE CASCADE
);
GO

CREATE INDEX [IX_Fluent_BookAuthor_Fluent_AuthorAuthor_Id] ON [Fluent_BookAuthor] ([Fluent_AuthorAuthor_Id]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210926184540_addManyToManyBookAndAuthor', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [Fluent_BookAuthor] DROP CONSTRAINT [FK_Fluent_BookAuthor_Fluent_Authors_Fluent_AuthorAuthor_Id];
GO

ALTER TABLE [Fluent_BookAuthor] DROP CONSTRAINT [FK_Fluent_BookAuthor_Fluent_Books_Author_Id];
GO

DROP INDEX [IX_Fluent_BookAuthor_Fluent_AuthorAuthor_Id] ON [Fluent_BookAuthor];
GO

DECLARE @var8 sysname;
SELECT @var8 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Fluent_BookAuthor]') AND [c].[name] = N'Fluent_AuthorAuthor_Id');
IF @var8 IS NOT NULL EXEC(N'ALTER TABLE [Fluent_BookAuthor] DROP CONSTRAINT [' + @var8 + '];');
ALTER TABLE [Fluent_BookAuthor] DROP COLUMN [Fluent_AuthorAuthor_Id];
GO

CREATE INDEX [IX_Fluent_BookAuthor_Book_Id] ON [Fluent_BookAuthor] ([Book_Id]);
GO

ALTER TABLE [Fluent_BookAuthor] ADD CONSTRAINT [FK_Fluent_BookAuthor_Fluent_Authors_Author_Id] FOREIGN KEY ([Author_Id]) REFERENCES [Fluent_Authors] ([Author_Id]) ON DELETE CASCADE;
GO

ALTER TABLE [Fluent_BookAuthor] ADD CONSTRAINT [FK_Fluent_BookAuthor_Fluent_Books_Book_Id] FOREIGN KEY ([Book_Id]) REFERENCES [Fluent_Books] ([Book_Id]) ON DELETE CASCADE;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210926184851_addManyToManyBookAndAuthorCorrection', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

INSERT INTO tbl_Category VALUES('Cat 1')
GO

INSERT INTO tbl_Category VALUES('Cat 2')
GO

INSERT INTO tbl_Category VALUES('Cat 3')
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210926195446_AddRawCategoryToTable', N'5.0.10');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210928163541_addDropBooksFKsConstraints', N'5.0.10');
GO

COMMIT;
GO

