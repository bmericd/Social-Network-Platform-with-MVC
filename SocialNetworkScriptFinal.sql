USE [master]
GO
/****** Object:  Database [SocialNetwork]    Script Date: 1/6/2021 4:29:29 AM ******/
CREATE DATABASE [SocialNetwork]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SocialNetwork', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER2019\MSSQL\DATA\SocialNetwork.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'SocialNetwork_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER2019\MSSQL\DATA\SocialNetwork_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [SocialNetwork] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SocialNetwork].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SocialNetwork] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SocialNetwork] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SocialNetwork] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SocialNetwork] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SocialNetwork] SET ARITHABORT OFF 
GO
ALTER DATABASE [SocialNetwork] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SocialNetwork] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SocialNetwork] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SocialNetwork] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SocialNetwork] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SocialNetwork] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SocialNetwork] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SocialNetwork] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SocialNetwork] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SocialNetwork] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SocialNetwork] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SocialNetwork] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SocialNetwork] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SocialNetwork] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SocialNetwork] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SocialNetwork] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SocialNetwork] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SocialNetwork] SET RECOVERY FULL 
GO
ALTER DATABASE [SocialNetwork] SET  MULTI_USER 
GO
ALTER DATABASE [SocialNetwork] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SocialNetwork] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SocialNetwork] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SocialNetwork] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [SocialNetwork] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'SocialNetwork', N'ON'
GO
ALTER DATABASE [SocialNetwork] SET QUERY_STORE = OFF
GO
USE [SocialNetwork]
GO
/****** Object:  Schema [SocialN]    Script Date: 1/6/2021 4:29:30 AM ******/
CREATE SCHEMA [SocialN]
GO
/****** Object:  UserDefinedFunction [SocialN].[CreateShortName]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [SocialN].[CreateShortName](@UserID int)
RETURNS NVARCHAR(255)
AS BEGIN
	DECLARE @NickName NVARCHAR(255)

	SET @NickName = (SELECT SUBSTRING([User].[FirstName],1,1) AS Name FROM [User] WHERE [User].[UserID] = @UserID)
	SET @NickName = @NickName + '.' + (SELECT[User].[LastName] FROM [User] WHERE [User].[UserID] = @UserID)

	RETURN @NickName
END
GO
/****** Object:  UserDefinedFunction [SocialN].[GetSexAvarage]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [SocialN].[GetSexAvarage]()
RETURNS float
AS BEGIN
	DECLARE @FemaleNumber float
	DECLARE @MaleNumber float
	DECLARE @Percentage float
	SET @FemaleNumber =(SELECT COUNT([User].[UserID]) FROM [User] WHERE [User].[Sex] = 'Female')
	SET @MaleNumber =(SELECT COUNT([User].[UserID]) FROM [User] WHERE [User].[Sex] = 'Male')

	SET @Percentage = @MaleNumber + @MaleNumber / dbo.GetTotalUserNumber()
	RETURN @Percentage
END
GO
/****** Object:  UserDefinedFunction [SocialN].[GetSexAverage]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [SocialN].[GetSexAverage]()
RETURNS NVARCHAR(255)
AS BEGIN
	DECLARE @FemaleNumber float
	DECLARE @MaleNumber float
	DECLARE @Percentage float
	DECLARE @PercentageStr NVARCHAR(255)

	SET @FemaleNumber =(SELECT COUNT([User].[UserID]) FROM [User] WHERE [User].[Sex] = 'Female')
	SET @MaleNumber =(SELECT COUNT([User].[UserID]) FROM [User] WHERE [User].[Sex] = 'Male')

	IF @MaleNumber> @FemaleNumber
	BEGIN
		SET @Percentage = 100 * @MaleNumber / SocialN.GetTotalUserNumber()
	SET @PercentageStr= (SELECT CAST((@Percentage) AS NVARCHAR(255))) + ' Percent Male'
	RETURN @PercentageStr
	END
	ELSE
	BEGIN
		SET @Percentage = 100 * @FemaleNumber / SocialN.GetTotalUserNumber()
	SET @PercentageStr= (SELECT CAST((@Percentage) AS NVARCHAR(255))) + ' Percent Female'
	RETURN @PercentageStr
	END

	RETURN @PercentageStr

END
GO
/****** Object:  UserDefinedFunction [SocialN].[GetTotalUserNumber]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [SocialN].[GetTotalUserNumber]()
RETURNS int
AS BEGIN
	DECLARE @TotalUserNumber  int
	SET @TotalUserNumber =(SELECT COUNT([User].[UserID]) FROM [User])
	RETURN @TotalUserNumber
END
GO
/****** Object:  Table [SocialN].[User]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SocialN].[User](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](255) NOT NULL,
	[LastName] [nvarchar](255) NOT NULL,
	[Email] [nvarchar](255) NOT NULL,
	[Password] [nvarchar](255) NOT NULL,
	[Sex] [nvarchar](255) NULL,
	[PictureURL] [nvarchar](255) NULL,
	[DateJoined] [date] NULL,
	[Birthday] [date] NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [SocialN].[ProfileDescription]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SocialN].[ProfileDescription](
	[UserID] [int] NOT NULL,
	[Description] [nvarchar](255) NULL,
 CONSTRAINT [PK_ProfileDescription] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [SocialN].[PrivacySettings]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SocialN].[PrivacySettings](
	[UserID] [int] NOT NULL,
	[PrivateEmail] [bit] NOT NULL,
	[PrivateSex] [bit] NOT NULL,
	[PrivatePicture] [bit] NOT NULL,
 CONSTRAINT [PK_PrivacySettings] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [SocialN].[User Information Admin]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [SocialN].[User Information Admin]
AS
SELECT [User].*,[ProfileDescription].[Description], ps.[PrivateEmail],ps.PrivatePicture,ps.PrivateSex FROM [User] LEFT JOIN [ProfileDescription] ON [User].[UserID] = [ProfileDescription].[UserID]
LEFT JOIN [PrivacySettings] ps ON [User].[UserID] =ps.[UserID]
GO
/****** Object:  Table [SocialN].[Event]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SocialN].[Event](
	[EventID] [int] IDENTITY(1,1) NOT NULL,
	[EventName] [nvarchar](255) NOT NULL,
	[EventDescription] [nvarchar](255) NULL,
	[DateCreated] [date] NULL,
	[UserID] [int] NOT NULL,
	[Notify] [bit] NULL,
 CONSTRAINT [PK_Event] PRIMARY KEY CLUSTERED 
(
	[EventID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [SocialN].[View Events]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [SocialN].[View Events]
AS
SELECT [User].[FirstName] AS "Created By", [Event].[EventID],[Event].[EventName],[Event].[EventDescription],[Event].[DateCreated] FROM [Event] LEFT JOIN [User] ON [User].[UserID] = [Event].[UserID]
GO
/****** Object:  Table [SocialN].[Hobby]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SocialN].[Hobby](
	[UserID] [int] NOT NULL,
	[HobbyName] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_Hobby] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [SocialN].[View Hobby]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [SocialN].[View Hobby]
AS
SELECT [User].[FirstName]+' '+[User].[LastName]AS [Name],[Hobby].[HobbyName] FROM [User],[Hobby] WHERE [User].[UserID] = [Hobby].[UserID] 
GO
/****** Object:  Table [SocialN].[Profession]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SocialN].[Profession](
	[UserID] [int] NOT NULL,
	[ProfessionName] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_Profession] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [SocialN].[View Professions]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [SocialN].[View Professions]
AS
SELECT [User].[FirstName],[User].[LastName],[Profession].[ProfessionName] FROM [User],[Profession] WHERE [User].[UserID] = [Profession].[UserID]
GO
/****** Object:  Table [SocialN].[Message]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SocialN].[Message](
	[MessageID] [int] IDENTITY(1,1) NOT NULL,
	[MessageText] [nvarchar](255) NOT NULL,
	[FromID] [int] NOT NULL,
	[ToID] [int] NOT NULL,
 CONSTRAINT [PK_Message] PRIMARY KEY CLUSTERED 
(
	[MessageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [SocialN].[View Messages]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [SocialN].[View Messages]
AS
SELECT sender.[FirstName] +' '+ sender.[LastName]  AS [Message Sender], reciever.[FirstName] +' '+ reciever.[LastName] AS [Message Reciever], [Message].[MessageText] FROM [User] sender,[User] reciever,[Message] WHERE sender.[UserID] = [Message].[FromID] AND reciever.[UserID] = [Message].[ToID]
GO
/****** Object:  Table [SocialN].[Following]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SocialN].[Following](
	[UserID] [int] NOT NULL,
	[FollowingID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [SocialN].[View Following]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [SocialN].[View Following]
AS
SELECT [User].[FirstName]+' '+[User].[LastName] AS [User], follower.[FirstName]+' '+ follower.[LastName] AS [Follower]  FROM [User],[User] follower INNER JOIN [Following] ON follower.[UserID] = [Following].[FollowingID] WHERE [Following].[UserID] =[User].[UserID]
GO
/****** Object:  Table [SocialN].[Relationship]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SocialN].[Relationship](
	[UserID] [int] NOT NULL,
	[RelationshipWithID] [int] NOT NULL,
	[Relationship] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  View [SocialN].[View Relationships]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [SocialN].[View Relationships]
AS
SELECT [User].[FirstName]+' '+[User].[LastName] AS [User], relwith.[FirstName]+' '+ relwith.[LastName] AS [User2], [Relationship].[Relationship]  FROM [User],[User] relwith INNER JOIN [Relationship] ON relwith.[UserID] = [Relationship].[RelationshipWithID] WHERE [Relationship].[UserID] =[User].[UserID]
GO
/****** Object:  Table [SocialN].[Post]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SocialN].[Post](
	[PostID] [int] IDENTITY(1,1) NOT NULL,
	[Text] [nvarchar](255) NULL,
	[PictureURL] [nvarchar](255) NULL,
	[DatePosted] [date] NULL,
	[Likes] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[TagID] [nvarchar](255) NULL,
 CONSTRAINT [PK_Post] PRIMARY KEY CLUSTERED 
(
	[PostID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [SocialN].[Comment]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SocialN].[Comment](
	[CommentID] [int] IDENTITY(1,1) NOT NULL,
	[Text] [nvarchar](255) NOT NULL,
	[DateCommented] [datetime] NULL,
	[UserCommentedID] [int] NOT NULL,
	[PostID] [int] NOT NULL,
 CONSTRAINT [PK_Comment] PRIMARY KEY CLUSTERED 
(
	[CommentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [SocialN].[View Posts]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [SocialN].[View Posts]
AS
SELECT poster.[PictureURL] AS [ProfilePicture],poster.[FirstName] AS [FirstName],poster.[LastName] AS [LastName],[Post].[PostID],[Post].[UserID],[Post].[Text] AS [Text of Post],[Post].[PictureURL], poster.[FirstName]+' '+poster.[LastName] AS [User Posted], [Post].[Likes],[Comment].[CommentID],[Comment].[Text] AS [Text of Comment], [User].[FirstName]+' '+[User].[LastName] AS [User Commented],[Comment].[UsercommentedID],[Post].[DatePosted],[Comment].[DateCommented]
FROM [Post]
INNER JOIN [Comment]
ON [Comment].[PostID] = [Post].[PostID]
INNER JOIN [User]
ON [User].[UserID] = [Comment].[UserCommentedID]
INNER JOIN [User] poster
ON poster.[UserID] = [Post].[UserID]
GO
/****** Object:  View [SocialN].[CheckTodaysBirthdays]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [SocialN].[CheckTodaysBirthdays]
AS
SELECT [User].[FirstName] +' '+[User].[LastName] AS [Name] , MONTH([User].[Birthday]) AS [BirthMonth],DAY([User].[Birthday]) AS [Birthday] FROM [User] WHERE  MONTH([User].[Birthday]) = MONTH(GETDATE()) AND  DAY([User].[Birthday]) = DAY(GETDATE())
GO
/****** Object:  View [SocialN].[View Settings]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [SocialN].[View Settings]
AS
SELECT  [User].[FirstName] +' '+[User].[LastName] AS [Name],[PrivacySettings].[PrivateEmail],[PrivacySettings].[PrivateSex],[PrivacySettings].[PrivatePicture]  FROM [User] INNER JOIN [PrivacySettings] ON [User].[UserID] = [PrivacySettings].[UserID]
GO
ALTER TABLE [SocialN].[Event] ADD  CONSTRAINT [DF_Event_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
ALTER TABLE [SocialN].[Event] ADD  CONSTRAINT [DF_Event_notify]  DEFAULT ((0)) FOR [Notify]
GO
ALTER TABLE [SocialN].[Post] ADD  CONSTRAINT [DF_Post_DatePosted]  DEFAULT (getdate()) FOR [DatePosted]
GO
ALTER TABLE [SocialN].[Post] ADD  CONSTRAINT [DF_Post_Likes]  DEFAULT ((0)) FOR [Likes]
GO
ALTER TABLE [SocialN].[PrivacySettings] ADD  CONSTRAINT [DF_PrivacySettings_PrivateEmail]  DEFAULT ((0)) FOR [PrivateEmail]
GO
ALTER TABLE [SocialN].[PrivacySettings] ADD  CONSTRAINT [DF_PrivacySettings_PrivateSex]  DEFAULT ((0)) FOR [PrivateSex]
GO
ALTER TABLE [SocialN].[PrivacySettings] ADD  CONSTRAINT [DF_PrivacySettings_PrivatePicture]  DEFAULT ((0)) FOR [PrivatePicture]
GO
ALTER TABLE [SocialN].[User] ADD  CONSTRAINT [DF_User_DateJoined]  DEFAULT (getdate()) FOR [DateJoined]
GO
ALTER TABLE [SocialN].[Comment]  WITH CHECK ADD  CONSTRAINT [FK_Comment_Post] FOREIGN KEY([PostID])
REFERENCES [SocialN].[Post] ([PostID])
GO
ALTER TABLE [SocialN].[Comment] CHECK CONSTRAINT [FK_Comment_Post]
GO
ALTER TABLE [SocialN].[Comment]  WITH CHECK ADD  CONSTRAINT [FK_Comment_User] FOREIGN KEY([UserCommentedID])
REFERENCES [SocialN].[User] ([UserID])
GO
ALTER TABLE [SocialN].[Comment] CHECK CONSTRAINT [FK_Comment_User]
GO
ALTER TABLE [SocialN].[Event]  WITH CHECK ADD  CONSTRAINT [FK_Event_User] FOREIGN KEY([UserID])
REFERENCES [SocialN].[User] ([UserID])
GO
ALTER TABLE [SocialN].[Event] CHECK CONSTRAINT [FK_Event_User]
GO
ALTER TABLE [SocialN].[Following]  WITH CHECK ADD  CONSTRAINT [FK_Following_User] FOREIGN KEY([UserID])
REFERENCES [SocialN].[User] ([UserID])
GO
ALTER TABLE [SocialN].[Following] CHECK CONSTRAINT [FK_Following_User]
GO
ALTER TABLE [SocialN].[Following]  WITH CHECK ADD  CONSTRAINT [FK_Following_User1] FOREIGN KEY([FollowingID])
REFERENCES [SocialN].[User] ([UserID])
GO
ALTER TABLE [SocialN].[Following] CHECK CONSTRAINT [FK_Following_User1]
GO
ALTER TABLE [SocialN].[Hobby]  WITH CHECK ADD  CONSTRAINT [FK_Hobby_User] FOREIGN KEY([UserID])
REFERENCES [SocialN].[User] ([UserID])
GO
ALTER TABLE [SocialN].[Hobby] CHECK CONSTRAINT [FK_Hobby_User]
GO
ALTER TABLE [SocialN].[Message]  WITH CHECK ADD  CONSTRAINT [FK_Message_User] FOREIGN KEY([FromID])
REFERENCES [SocialN].[User] ([UserID])
GO
ALTER TABLE [SocialN].[Message] CHECK CONSTRAINT [FK_Message_User]
GO
ALTER TABLE [SocialN].[Message]  WITH CHECK ADD  CONSTRAINT [FK_Message_User1] FOREIGN KEY([ToID])
REFERENCES [SocialN].[User] ([UserID])
GO
ALTER TABLE [SocialN].[Message] CHECK CONSTRAINT [FK_Message_User1]
GO
ALTER TABLE [SocialN].[Post]  WITH CHECK ADD  CONSTRAINT [FK_Post_User] FOREIGN KEY([UserID])
REFERENCES [SocialN].[User] ([UserID])
GO
ALTER TABLE [SocialN].[Post] CHECK CONSTRAINT [FK_Post_User]
GO
ALTER TABLE [SocialN].[PrivacySettings]  WITH CHECK ADD  CONSTRAINT [FK_PrivacySettings_User1] FOREIGN KEY([UserID])
REFERENCES [SocialN].[User] ([UserID])
GO
ALTER TABLE [SocialN].[PrivacySettings] CHECK CONSTRAINT [FK_PrivacySettings_User1]
GO
ALTER TABLE [SocialN].[Profession]  WITH CHECK ADD  CONSTRAINT [FK_Profession_User1] FOREIGN KEY([UserID])
REFERENCES [SocialN].[User] ([UserID])
GO
ALTER TABLE [SocialN].[Profession] CHECK CONSTRAINT [FK_Profession_User1]
GO
ALTER TABLE [SocialN].[ProfileDescription]  WITH CHECK ADD  CONSTRAINT [FK_ProfileDescription_User1] FOREIGN KEY([UserID])
REFERENCES [SocialN].[User] ([UserID])
GO
ALTER TABLE [SocialN].[ProfileDescription] CHECK CONSTRAINT [FK_ProfileDescription_User1]
GO
ALTER TABLE [SocialN].[Relationship]  WITH CHECK ADD  CONSTRAINT [FK_Relationship_User1] FOREIGN KEY([UserID])
REFERENCES [SocialN].[User] ([UserID])
GO
ALTER TABLE [SocialN].[Relationship] CHECK CONSTRAINT [FK_Relationship_User1]
GO
/****** Object:  StoredProcedure [SocialN].[CreateEvent]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [SocialN].[CreateEvent] @UserID int,@EventName nvarchar(255),@EventDescription nvarchar(255),@Notify int
AS
INSERT INTO Event (UserID,EventName,EventDescription,DateCreated,Notify)
VALUES(@UserID,@EventName,@EventDescription,GETDATE(),@Notify)
GO
/****** Object:  StoredProcedure [SocialN].[CreateOrDeleteUser]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [SocialN].[CreateOrDeleteUser] @FirstName nvarchar(255), @LastName nvarchar(255), @Email nvarchar(255), @Password nvarchar(255),@CreateOrDelete bit
AS
IF @CreateOrDelete = 1
BEGIN
INSERT INTO [User](FirstName,LastName,Email,Password,DateJoined)
VALUES(@FirstName,@LastName,@Email,@Password,GETDATE())
END
ELSE
BEGIN
DELETE FROM [User] WHERE [User].[Email] = @Email AND [User].[Password] = @Password
END
GO
/****** Object:  StoredProcedure [SocialN].[GetFollowers]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [SocialN].[GetFollowers] @UserID int
AS
SELECT [User].[FirstName],[User].[LastName]
FROM [User]
INNER JOIN [Following]
ON [User].[UserID] = [Following].[FollowingID]
WHERE [Following].[UserID] = @UserID
GO
/****** Object:  StoredProcedure [SocialN].[GetPostAndComment]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [SocialN].[GetPostAndComment] @UserID int
AS
SELECT [Post].[PostID],[Post].[Text],[Post].[Likes],[Comment].[CommentID],[Comment].[Text]
FROM [Post]
INNER JOIN [Comment]
ON [Comment].[PostID] = [Post].[PostID]
WHERE [Post].[UserID] = @UserID
GO
/****** Object:  StoredProcedure [SocialN].[GetShortName]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [SocialN].[GetShortName]
AS
DECLARE @Counter int
DECLARE @Total NVARCHAR(255)
SET @Counter = 0
SET @Total = (SELECT SocialN.GetTotalUserNumber())

CREATE TABLE #Temporary(
ShortName NVARCHAR(255)
)

WHILE (@Counter < (SELECT MAX([UserId]) FROM SocialN.[User]))
BEGIN
	INSERT INTO [#Temporary](ShortName)
	VALUES(SocialN.CreateShortName(@Counter))
	SET @Counter = @Counter +1
END
SELECT * FROM [#Temporary]
GO
/****** Object:  StoredProcedure [SocialN].[GetUserInfo]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [SocialN].[GetUserInfo] @UserID int
AS
SELECT [User].[FirstName],[User].[LastName] ,IIF([PrivacySettings].[PrivateEmail] = 0 , [User].[Email] ,'Private' ) AS Email ,IIF([PrivacySettings].[PrivateSex] = 0 , [User].[Sex] ,'Private')AS Sex,IIF([PrivacySettings].[PrivatePicture] = 0 , [User].[PictureURL] ,'Private')AS PictureURL FROM [PrivacySettings],[User] WHERE [User].[UserID] = @UserID AND [PrivacySettings].[UserID] = @UserID
GO
/****** Object:  StoredProcedure [SocialN].[PrintSexAverage]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [SocialN].[PrintSexAverage]
AS
SELECT [User].[Sex],[User].[FirstName],[User].[LastName] FROM [User]
ORDER BY  [Sex]
SELECT SocialN.GetSexAverage() AS AvarageSex
GO
/****** Object:  StoredProcedure [SocialN].[SameProfession]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [SocialN].[SameProfession] @ProfessionName nvarchar(255)
AS
SELECT [User].[FirstName],[Profession].[ProfessionName] 
FROM [User],[Profession] 
WHERE [Profession].[UserID] = [User].[UserID] AND [Profession].[ProfessionName] = @ProfessionName
GO
/****** Object:  StoredProcedure [SocialN].[SendMessage]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [SocialN].[SendMessage] @FromID int, @ToID int, @Message nvarchar(255)
AS
INSERT INTO [Message](MessageText,FromID,ToID)
VALUES(@Message,@FromID,@ToID)
SELECT * FROM [Message] WHERE [Message].[MessageID] = SCOPE_IDENTITY();
GO
/****** Object:  StoredProcedure [SocialN].[SetUserHobby]    Script Date: 1/6/2021 4:29:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [SocialN].[SetUserHobby] @UserID int,@Hobby nvarchar(255)
AS
INSERT INTO Hobby (UserID,HobbyName)
VALUES (@UserID,@Hobby)
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "User (SocialN)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'SocialN', @level1type=N'VIEW',@level1name=N'CheckTodaysBirthdays'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'SocialN', @level1type=N'VIEW',@level1name=N'CheckTodaysBirthdays'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ProfileDescription (SocialN)"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 102
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ps"
            Begin Extent = 
               Top = 72
               Left = 38
               Bottom = 202
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "User (SocialN)"
            Begin Extent = 
               Top = 6
               Left = 454
               Bottom = 136
               Right = 624
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'SocialN', @level1type=N'VIEW',@level1name=N'User Information Admin'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'SocialN', @level1type=N'VIEW',@level1name=N'User Information Admin'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Event (SocialN)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 216
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "User (SocialN)"
            Begin Extent = 
               Top = 6
               Left = 254
               Bottom = 136
               Right = 424
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'SocialN', @level1type=N'VIEW',@level1name=N'View Events'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'SocialN', @level1type=N'VIEW',@level1name=N'View Events'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Following (SocialN)"
            Begin Extent = 
               Top = 72
               Left = 38
               Bottom = 168
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "User (SocialN)"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "follower"
            Begin Extent = 
               Top = 6
               Left = 454
               Bottom = 136
               Right = 624
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'SocialN', @level1type=N'VIEW',@level1name=N'View Following'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'SocialN', @level1type=N'VIEW',@level1name=N'View Following'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Hobby (SocialN)"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 102
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "User (SocialN)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'SocialN', @level1type=N'VIEW',@level1name=N'View Hobby'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'SocialN', @level1type=N'VIEW',@level1name=N'View Hobby'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Message (SocialN)"
            Begin Extent = 
               Top = 72
               Left = 38
               Bottom = 202
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "sender"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "reciever"
            Begin Extent = 
               Top = 6
               Left = 454
               Bottom = 136
               Right = 624
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'SocialN', @level1type=N'VIEW',@level1name=N'View Messages'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'SocialN', @level1type=N'VIEW',@level1name=N'View Messages'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Post (SocialN)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Comment (SocialN)"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 436
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "User (SocialN)"
            Begin Extent = 
               Top = 6
               Left = 474
               Bottom = 136
               Right = 644
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "poster"
            Begin Extent = 
               Top = 6
               Left = 682
               Bottom = 136
               Right = 852
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'SocialN', @level1type=N'VIEW',@level1name=N'View Posts'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'SocialN', @level1type=N'VIEW',@level1name=N'View Posts'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Profession (SocialN)"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 102
               Right = 422
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "User (SocialN)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'SocialN', @level1type=N'VIEW',@level1name=N'View Professions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'SocialN', @level1type=N'VIEW',@level1name=N'View Professions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Relationship (SocialN)"
            Begin Extent = 
               Top = 72
               Left = 38
               Bottom = 185
               Right = 228
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "User (SocialN)"
            Begin Extent = 
               Top = 6
               Left = 266
               Bottom = 136
               Right = 436
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "relwith"
            Begin Extent = 
               Top = 6
               Left = 474
               Bottom = 136
               Right = 644
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'SocialN', @level1type=N'VIEW',@level1name=N'View Relationships'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'SocialN', @level1type=N'VIEW',@level1name=N'View Relationships'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PrivacySettings (SocialN)"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "User (SocialN)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'SocialN', @level1type=N'VIEW',@level1name=N'View Settings'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'SocialN', @level1type=N'VIEW',@level1name=N'View Settings'
GO
USE [master]
GO
ALTER DATABASE [SocialNetwork] SET  READ_WRITE 
GO
