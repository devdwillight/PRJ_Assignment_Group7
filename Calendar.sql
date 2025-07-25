﻿--create database Calendar;

use Calendar

CREATE TABLE Users (
    id_user INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(255) NOT NULL,
    password NVARCHAR(255) NOT NULL,
    first_name NVARCHAR(255) default null,
    last_name NVARCHAR(255)default null,
    birthday DATE default null,
    email NVARCHAR(255) unique NOT NULL,
    phone NVARCHAR(20) default null,
    gender NVARCHAR(10) default null,
    active BIT default null,
	is_admin bit default 0,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME default null,
	avatar nvarchar(255) default null
);

CREATE TABLE tokenForgetPassword (
    id int IDENTITY(1,1) PRIMARY KEY,
    token VARCHAR(255) NOT NULL,
    expiryTime DATETIME NOT NULL,
	isUsed bit NOT NULL,
	userId int NOT NULL,
	FOREIGN KEY (userId) REFERENCES [Users](id_user)
);

select * from User_Course

CREATE TABLE Course (
    id_course INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
	category VARCHAR(255),
    price FLOAT NOT NULL,
    duration VARCHAR(255),
    description nvarchar(max),
    frequency VARCHAR(255),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME,
	imageUrl VARCHAR (3000)
);
ALTER TABLE Course ALTER COLUMN price FLOAT NOT NULL;

CREATE TABLE User_Course (
    id_enroll INT IDENTITY(1,1) PRIMARY KEY,
    id_user INT NOT NULL,
    id_course INT NOT NULL,
    enroll_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_user) REFERENCES Users(id_user),
    FOREIGN KEY (id_course) REFERENCES Course(id_course),
    UNIQUE (id_user, id_course) -- đảm bảo 1 user chỉ học 1 course 1 lần
);
ALTER TABLE Course
DROP COLUMN TotalAmount;
CREATE TABLE Orders (
    id_order INT IDENTITY(1,1) PRIMARY KEY,
    id_user INT NOT NULL,
    status nvarchar(255 )DEFAULT 'Processing' CHECK (Status IN ('Processing', 'Completed', 'Failed')),
	payment_method nvarchar(255) NOT NULL,
	payment_time datetime NOT NULL,
	TotalAmount FLOAT NOT NULL DEFAULT 0.00,	
    FOREIGN KEY (id_user) REFERENCES Users(id_user),
);

select * from Task
 ALTER TABLE Task ADD  position INT; --mới thêm
 select * from Orders
CREATE TABLE Calendar (
    id_calendar INT IDENTITY(1,1) PRIMARY KEY,
    id_user INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    color VARCHAR(50) default 'Blue',
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME,
    FOREIGN KEY (id_user) REFERENCES Users(id_user)
);
ALTER TABLE Course
DROP CONSTRAINT DF__Course__TotalAmo__44CA3770; -- Thay thế bằng tên ràng buộc thực tế của bạn

CREATE TABLE UserEvents (
    id_event INT IDENTITY(1,1) PRIMARY KEY,
    id_calendar INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    Start_Date DATETIME,
	Due_Date Datetime,
    description VARCHAR(max),
    location VARCHAR(255),
	is_all_day BIT DEFAULT 0,
	is_recurring BIT DEFAULT 0,
	recurrence_rule VARCHAR(255), -- VD: "FREQ=DAILY;INTERVAL=1;COUNT=5"
	color VARCHAR(50) default N'Blue',
	remind_method bit default 0, --vd: "0 by notification - 1 by email"
	remind_before INT DEFAULT 30,
	remind_unit VARCHAR(10) DEFAULT 'minutes' CHECK (remind_unit IN ('minutes', 'hours', 'days', 'weeks')),
    updated_at DATETIME,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_calendar) REFERENCES Calendar(id_calendar)
);

CREATE TABLE Task (
    id_task INT IDENTITY(1,1) PRIMARY KEY,
    id_user INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    color VARCHAR(50) default N'Blue',
	 position INT, --mới thêm
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME,
    FOREIGN KEY (id_user) REFERENCES Users(id_user)
);
CREATE TABLE To_Do (
    id_todo INT IDENTITY(1,1) PRIMARY KEY,
    id_task INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    due_date DATETIME NOT NULL,
	is_all_day BIT DEFAULT 0,
	is_recurring BIT DEFAULT 0,
	recurrence_rule VARCHAR(255), -- VD: "FREQ=DAILY;INTERVAL=1;COUNT=5"
    is_completed BIT,
	created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME,
    FOREIGN KEY (id_task) REFERENCES Task(id_task)
);
select * from Users
select * from Users
select * from UserEvents

INSERT INTO Users (username, password, first_name, last_name, birthday, email, phone, gender, active, is_admin)
VALUES
('tuan','123','admin','admin','2000-1-1','nguyenhuuminhtuan20111@gmail.com','1234567890','Male',1,1),
('john_doe', 'hashed_pwd1', 'John', 'Doe', '1990-01-01', 'john@example.com', '1234567890', 'Male', 1, 0),
('jane_smith', 'hashed_pwd2', 'Jane', 'Smith', '1992-02-02', 'jane@example.com', '0987654321', 'Female', 1, 1),
('alice_johnson', 'hashed_pwd3', 'Alice', 'Johnson', '1988-03-15', 'alice.johnson@email.com', '5551234567', 'Female', 1, 0),
('bob_williams', 'hashed_pwd4', 'Bob', 'Williams', '1985-07-22', 'bob.williams@email.com', '5559876543', 'Male', 1, 0),
('carol_brown', 'hashed_pwd5', 'Carol', 'Brown', '1993-11-08', 'carol.brown@email.com', '5552468135', 'Female', 1, 1),
('david_jones', 'hashed_pwd6', 'David', 'Jones', '1991-05-12', 'david.jones@email.com', '5558642097', 'Male', 1, 0),
('emma_garcia', 'hashed_pwd7', 'Emma', 'Garcia', '1989-09-30', 'emma.garcia@email.com', '5553692581', 'Female', 1, 0),
('frank_miller', 'hashed_pwd8', 'Frank', 'Miller', '1987-12-03', 'frank.miller@email.com', '5557418529', 'Male', 1, 0),
('grace_davis', 'hashed_pwd9', 'Grace', 'Davis', '1994-04-18', 'grace.davis@email.com', '5551597534', 'Female', 1, 0),
('henry_rodriguez', 'hashed_pwd10', 'Henry', 'Rodriguez', '1986-08-25', 'henry.rodriguez@email.com', '5558520963', 'Male', 1, 1),
('isabel_martinez', 'hashed_pwd11', 'Isabel', 'Martinez', '1992-01-07', 'isabel.martinez@email.com', '5554826173', 'Female', 1, 0),
('jack_hernandez', 'hashed_pwd12', 'Jack', 'Hernandez', '1990-06-14', 'jack.hernandez@email.com', '5557359148', 'Male', 0, 0),
('kate_lopez', 'hashed_pwd13', 'Kate', 'Lopez', '1995-10-21', 'kate.lopez@email.com', '5553174829', 'Female', 1, 0),
('liam_gonzalez', 'hashed_pwd14', 'Liam', 'Gonzalez', '1988-02-28', 'liam.gonzalez@email.com', '5559630741', 'Male', 1, 0),
('mia_wilson', 'hashed_pwd15', 'Mia', 'Wilson', '1993-07-11', 'mia.wilson@email.com', '5556847295', 'Female', 1, 0),
('noah_anderson', 'hashed_pwd16', 'Noah', 'Anderson', '1987-11-19', 'noah.anderson@email.com', '5552951847', 'Male', 1, 0),
('olivia_thomas', 'hashed_pwd17', 'Olivia', 'Thomas', '1991-03-26', 'olivia.thomas@email.com', '5558174629', 'Female', 1, 1),
('paul_taylor', 'hashed_pwd18', 'Paul', 'Taylor', '1989-08-02', 'paul.taylor@email.com', '5553629517', 'Male', 1, 0),
('quinn_moore', 'hashed_pwd19', 'Quinn', 'Moore', '1994-12-09', 'quinn.moore@email.com', '5557416283', 'Non-binary', 1, 0),
('ruby_jackson', 'hashed_pwd20', 'Ruby', 'Jackson', '1986-04-16', 'ruby.jackson@email.com', '5551852739', 'Female', 1, 0),
('sam_martin', 'hashed_pwd21', 'Sam', 'Martin', '1992-09-23', 'sam.martin@email.com', '5596283741', 'Male', 0, 0),
('tina_lee', 'hashed_pwd22', 'Tina', 'Lee', '1990-01-30', 'tina.lee@email.com', '5554173629', 'Female', 1, 0),
('ulysses_perez', 'hashed_pwd23', 'Ulysses', 'Perez', '1988-06-06', 'ulysses.perez@email.com', '5558529631', 'Male', 1, 0),
('vera_thompson', 'hashed_pwd24', 'Vera', 'Thompson', '1995-10-13', 'vera.thompson@email.com', '5552963741', 'Female', 1, 0),
('wade_white', 'hashed_pwd25', 'Wade', 'White', '1987-02-20', 'wade.white@email.com', '5557418639', 'Male', 1, 1),
('xara_harris', 'hashed_pwd26', 'Xara', 'Harris', '1993-07-27', 'xara.harris@email.com', '5553851729', 'Female', 1, 0),
('yuki_clark', 'hashed_pwd27', 'Yuki', 'Clark', '1991-11-04', 'yuki.clark@email.com', '5556294817', 'Non-binary', 1, 0),
('zoe_lewis', 'hashed_pwd28', 'Zoe', 'Lewis', '1989-03-11', 'zoe.lewis@email.com', '5559517283', 'Female', 1, 0),
('aaron_robinson', 'hashed_pwd29', 'Aaron', 'Robinson', '1986-07-18', 'aaron.robinson@email.com', '5552748139', 'Male', 1, 0),
('bella_walker', 'hashed_pwd30', 'Bella', 'Walker', '1994-11-25', 'bella.walker@email.com', '5558361749', 'Female', 1, 0),
('carlos_hall', 'hashed_pwd31', 'Carlos', 'Hall', '1992-04-01', 'carlos.hall@email.com', '5554927183', 'Male', 0, 0),
('diana_allen', 'hashed_pwd32', 'Diana', 'Allen', '1988-08-08', 'diana.allen@email.com', '5557183629', 'Female', 1, 0),
('ethan_young', 'hashed_pwd33', 'Ethan', 'Young', '1990-12-15', 'ethan.young@email.com', '5553641829', 'Male', 1, 0),
('fiona_hernandez', 'hashed_pwd34', 'Fiona', 'Hernandez', '1987-05-22', 'fiona.hernandez@email.com', '5559274163', 'Female', 1, 1),
('gavin_king', 'hashed_pwd35', 'Gavin', 'King', '1995-09-29', 'gavin.king@email.com', '5552817439', 'Male', 1, 0),
('hanna_wright', 'hashed_pwd36', 'Hanna', 'Wright', '1993-01-05', 'hanna.wright@email.com', '5556394817', 'Female', 1, 0),
('ian_green', 'hashed_pwd37', 'Ian', 'Green', '1989-06-12', 'ian.green@email.com', '5554172839', 'Male', 1, 0),
('jess_adams', 'hashed_pwd38', 'Jess', 'Adams', '1991-10-19', 'jess.adams@email.com', '5558529174', 'Non-binary', 1, 0),
('kyle_baker', 'hashed_pwd39', 'Kyle', 'Baker', '1986-02-26', 'kyle.baker@email.com', '5553746291', 'Male', 1, 0),
('lily_nelson', 'hashed_pwd40', 'Lily', 'Nelson', '1994-07-03', 'lily.nelson@email.com', '5557851294', 'Female', 0, 0),
('mason_carter', 'hashed_pwd41', 'Mason', 'Carter', '1992-11-10', 'mason.carter@email.com', '5552948176', 'Male', 1, 0),
('nora_mitchell', 'hashed_pwd42', 'Nora', 'Mitchell', '1988-03-17', 'nora.mitchell@email.com', '5556271849', 'Female', 1, 0),
('oscar_perez', 'hashed_pwd43', 'Oscar', 'Perez', '1990-07-24', 'oscar.perez@email.com', '5554839627', 'Male', 1, 1),
('penny_roberts', 'hashed_pwd44', 'Penny', 'Roberts', '1987-11-30', 'penny.roberts@email.com', '5558174629', 'Female', 1, 0),
('quincy_turner', 'hashed_pwd45', 'Quincy', 'Turner', '1995-04-07', 'quincy.turner@email.com', '5553629481', 'Male', 1, 0),
('rosa_phillips', 'hashed_pwd46', 'Rosa', 'Phillips', '1993-08-14', 'rosa.phillips@email.com', '5557394816', 'Female', 1, 0),
('steve_campbell', 'hashed_pwd47', 'Steve', 'Campbell', '1989-12-21', 'steve.campbell@email.com', '5552617394', 'Male', 1, 0),
('tara_parker', 'hashed_pwd48', 'Tara', 'Parker', '1991-05-28', 'tara.parker@email.com', '5558462917', 'Female', 1, 0),
('uri_evans', 'hashed_pwd49', 'Uri', 'Evans', '1986-09-04', 'uri.evans@email.com', '5554928371', 'Male', 0, 0),
('violet_edwards', 'hashed_pwd50', 'Violet', 'Edwards', '1994-01-11', 'violet.edwards@email.com', '5557163849', 'Female', 1, 0),
('wyatt_collins', 'hashed_pwd51', 'Wyatt', 'Collins', '1992-06-18', 'wyatt.collins@email.com', '5553841729', 'Male', 1, 0),
('yasmin_stewart', 'hashed_pwd52', 'Yasmin', 'Stewart', '1988-10-25', 'yasmin.stewart@email.com', '5559274183', 'Female', 1, 1);
select * from Course
INSERT INTO Course (name, price, duration, description, frequency, category,imageUrl)
VALUES
('Mobile App Development', 249.99, '5 months', N'Create iOS and Android apps using React Native and Flutter.', 'Weekly', 'Technology', 'https://riseuplabs.com/wp-content/uploads/2021/07/mobile-application-development-guidelines-riseuplabs.jpg'),
('Digital Marketing Fundamentals', 149.99, '6 weeks', N'Master SEO, social media marketing, and Google Ads strategies.', 'Bi-weekly', 'Marketing', 'https://d2ds8yldqp7gxv.cloudfront.net/Blog+Explanatory+Images/Fundamentals+of+Digital+Marketing+1.webp'),
('Python Programming Bootcamp', 179.99, '8 weeks', N'Complete Python course from basics to advanced programming concepts.', 'Weekly', 'Programming', 'https://www.cdmi.in/courses@2x/python-training-institute.webp'),
('Graphic Design Essentials', 129.99, '10 weeks', N'Learn Adobe Creative Suite, typography, and design principles.', 'Weekly', 'Design','https://5.imimg.com/data5/SELLER/Default/2024/9/454403725/GP/XZ/HQ/16304956/graphic-design-essentials.png'),
('Project Management Professional', 399.99, '12 weeks', N'PMP certification preparation with real-world project scenarios.', 'Weekly', 'Business','https://www.myraacademy.com/wp-content/uploads/2022/05/PMP_PageHeader.jpg'),
('Photography Masterclass', 89.99, '4 weeks', N'Digital photography techniques, lighting, and post-processing skills.', 'Bi-weekly', 'Art','https://img.evbuc.com/https%3A%2F%2Fcdn.evbuc.com%2Fimages%2F1065018073%2F2759876212611%2F1%2Foriginal.20250702-113229?crop=focalpoint&fit=crop&w=600&auto=format%2Ccompress&q=75&sharp=10&fp-x=0.0359848484848&fp-y=0.421352291447&s=7d9bc3dcd806ee176d468940124b114e'),
('Financial Planning & Investment', 199.99, '8 weeks', N'Personal finance management, investment strategies, and retirement planning.', 'Weekly', 'Finance','https://investoplanning.com/wp-content/uploads/Frequently-Asked-Questions-What-are-Financial-Planning-Features-FAQ-Features-of-Financial-Planning.webp'),
('UI/UX Design Workshop', 219.99, '6 weeks', N'User interface and experience design using Figma and design thinking.', 'Weekly', 'Design','https://www.figma.com/community/resource/8d2d8ca7-82e1-4eba-8fb1-382ebfcaef36/thumbnail'),
('Cybersecurity Fundamentals', 279.99, '10 weeks', N'Network security, ethical hacking, and cybersecurity best practices.', 'Weekly', 'Technology','https://m.media-amazon.com/images/I/71Yh1DLCePL._UF350,350_QL50_.jpg'),
('Creative Writing Workshop', 99.99, '8 weeks', N'Develop storytelling skills, character development, and narrative techniques.', 'Bi-weekly', 'Writing','https://metapreponline.com/wp-content/uploads/2021/03/Creative-writing-Generic-WORKSHOP-1024x1024.png'),
('Machine Learning Basics', 349.99, '12 weeks', N'Introduction to ML algorithms, neural networks, and AI applications.', 'Weekly', 'Artificial Intelligence','https://www.worldeducation.net/Shared/Images/Product/Applied-Machine-Learning-Basics/1066248000121998133.png'),
('Foreign Language - Spanish', 119.99, '16 weeks', N'Conversational Spanish from beginner to intermediate level.', 'Bi-weekly', 'Language','https://3.files.edl.io/c2fa/20/03/16/195213-b81b8a50-bb81-4c99-9475-c68efe9b3cb5.jpg'),
('Business Analytics', 259.99, '9 weeks', N'Data visualization, statistical analysis, and business intelligence tools.', 'Weekly', 'Business','https://www.smartdatacollective.com/wp-content/uploads/2011/04/Business-Analytics.jpg'),
('Video Production & Editing', 169.99, '7 weeks', N'Video creation, editing techniques, and post-production workflows.', 'Weekly', 'Media','https://theceoviews.com/wp-content/uploads/2025/07/How-AI-is-Transforming-the-Video-Production-Industry-scaled.webp'),
('Public Speaking Mastery', 79.99, '5 weeks', N'Overcome speaking anxiety and deliver compelling presentations.', 'Weekly', 'Communication','https://i.ytimg.com/vi/jhFoRx7bjf4/maxresdefault.jpg'),
('E-commerce Business Setup', 189.99, '6 weeks', N'Build and launch successful online stores using Shopify and marketing.', 'Bi-weekly', 'Business','https://softprodigy.com/storage/2022/09/Follow-these-steps-to-start-your-e-commerce-business-startup.-01.jpg'),
('Artificial Intelligence Ethics', 149.99, '4 weeks', N'Explore AI ethics, bias in algorithms, and responsible AI development.', 'Weekly', 'Artificial Intelligence','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgZCqhEI6FV4PIterKU1LQcDgC3xaBRJZOhw&s'),
('Yoga Instructor Training', 499.99, '20 weeks', N'Comprehensive 200-hour yoga teacher certification program.', 'Bi-weekly', 'Health','https://embed-ssl.wistia.com/deliveries/f20818b8690eee8e18f606d5624ceb16.webp?image_crop_resized=960x766'),
('Blockchain & Cryptocurrency', 299.99, '8 weeks', N'Understanding blockchain technology, crypto trading, and DeFi basics.', 'Weekly', 'Technology','https://www.fahasa.com/blog/wp-content/uploads/2025/05/Screenshot-2025-05-25-084241-1.png'),
('Interior Design Principles', 139.99, '12 weeks', N'Space planning, color theory, and home decoration techniques.', 'Bi-weekly', 'Design','https://www.dsigndpo.com/blog/wp-content/uploads/2022/09/7-Principles-Of-Interior-Design.jpg');


UPDATE Course SET description = N'Master the complete workflow of creating high‑performance iOS and Android applications, from wireframing and state management to publishing on App Store and Google Play, while learning best practices for UI, performance tuning, and continuous integration.' 
WHERE name = 'Mobile App Development';

UPDATE Course SET description = N'Gain a rock‑solid foundation in digital marketing by exploring SEO, content strategy, social media advertising, Google Ads, and analytics. You will design campaigns, optimise conversion funnels, and measure ROI for real‑world business scenarios.' 
WHERE name = 'Digital Marketing Fundamentals';

UPDATE Course SET description = N'This intensive bootcamp takes you from Python basics to advanced topics such as object‑oriented programming, web scraping, database integration, and RESTful APIs. Finish by building and deploying a capstone project that showcases your new skills.' 
WHERE name = 'Python Programming Bootcamp';

UPDATE Course SET description = N'Learn the principles of compelling visual communication through hands‑on projects with Adobe Photoshop, Illustrator, and InDesign. Develop portfolios covering typography, layout, colour theory, branding, and social‑media graphics that meet professional standards.' 
WHERE name = 'Graphic Design Essentials';

UPDATE Course SET description = N'Prepare thoroughly for the PMP exam with structured lessons on project initiation, planning, execution, monitoring, and closure. Real‑world case studies and mock tests ensure you master PMBOK concepts and confidently lead complex projects.' 
WHERE name = 'Project Management Professional';

UPDATE Course SET description = N'Explore camera settings, composition, lighting, and storytelling techniques while shooting in diverse environments. Post‑production sessions using Lightroom and Photoshop help you transform raw images into stunning, portfolio‑ready photographs.' 
WHERE name = 'Photography Masterclass';

UPDATE Course SET description = N'Develop a personalised financial roadmap covering budgeting, risk management, diversified investing, and retirement planning. Interactive tools and market simulations teach you to analyse portfolios, reduce taxes, and achieve long‑term financial security.' 
WHERE name = 'Financial Planning & Investment';

UPDATE Course SET description = N'Practice design‑thinking methodologies while crafting intuitive interfaces in Figma. You will conduct user research, build wireframes, prototype high‑fidelity screens, and run usability tests to deliver delightful digital experiences.' 
WHERE name = 'UI/UX Design Workshop';

UPDATE Course SET description = N'Dive into cyber‑threat landscapes, encryption, firewalls, and ethical hacking techniques. Lab exercises on vulnerability assessment and incident response equip you to safeguard networks and prepare for industry certifications.' 
WHERE name = 'Cybersecurity Fundamentals';

UPDATE Course SET description = N'Unlock your creativity through guided exercises in character building, dialogue, pacing, and world‑building. You will critique peer work, refine drafts, and compile a polished short story or opening book chapter by course end.' 
WHERE name = 'Creative Writing Workshop';

UPDATE Course SET description = N'Build a solid grounding in supervised and unsupervised learning, neural networks, and model evaluation. Hands‑on notebooks in Python and TensorFlow guide you from data preprocessing to deploying predictive models in production.' 
WHERE name = 'Machine Learning Basics';

UPDATE Course SET description = N'Progress from everyday greetings to confident conversations about travel, culture, and current events. Multimedia lessons, interactive quizzes, and live speaking sessions ensure balanced development of listening, reading, writing, and pronunciation skills.' 
WHERE name = 'Foreign Language - Spanish';

UPDATE Course SET description = N'Use Excel, SQL, and Tableau to transform raw data into actionable business insights. Learn statistical methods, dashboard design, and storytelling with data to support strategic decision‑making across industries.' 
WHERE name = 'Business Analytics';

UPDATE Course SET description = N'Master every phase of video production, from pre‑production scripting and storyboarding to filming, colour grading, and sound design. Edit with Premiere Pro and DaVinci Resolve, delivering professional projects for YouTube or client work.' 
WHERE name = 'Video Production & Editing';

UPDATE Course SET description = N'Overcome stage fright through proven psychological techniques, vocal exercises, and structured rehearsal methods. Craft persuasive speeches, handle Q&A confidently, and discover your authentic speaking style for meetings or large audiences.' 
WHERE name = 'Public Speaking Mastery';

UPDATE Course SET description = N'Launch a profitable online store by selecting niche products, configuring Shopify, integrating payment gateways, and planning fulfilment. Learn traffic acquisition through SEO, email automation, and social‑media ads to scale revenue effectively.' 
WHERE name = 'E-commerce Business Setup';

UPDATE Course SET description = N'Examine ethical concerns in AI, including algorithmic bias, privacy, transparency, and governance. Case studies and debates help you formulate responsible AI policies and propose fairness‑aware solutions for real‑world applications.' 
WHERE name = 'Artificial Intelligence Ethics';

UPDATE Course SET description = N'Complete a 200‑hour yoga curriculum covering anatomy, asana alignment, pranayama, meditation, and class sequencing. Practical teaching labs build the confidence and pedagogy required to earn Yoga Alliance certification.' 
WHERE name = 'Yoga Instructor Training';

UPDATE Course SET description = N'Deepen your understanding of blockchain architecture, consensus mechanisms, smart contracts, and decentralised finance. Simulated trading labs teach wallet security, technical analysis, and risk management for cryptocurrency investments.' 
WHERE name = 'Blockchain & Cryptocurrency';

UPDATE Course SET description = N'Apply professional interior‑design principles to residential and commercial spaces, mastering colour palettes, lighting, furniture selection, and 3‑D visualisation tools. Final projects include a complete design proposal and mood boards.' 
WHERE name = 'Interior Design Principles';


INSERT INTO Orders (id_user, payment_method, payment_time, TotalAmount)
VALUES
(1,  'Credit Card', GETDATE(),100.5),
(2,  'PayPal', GETDATE(),100.5);

INSERT INTO Calendar (id_user, name, color)
VALUES
(1, 'Work Schedule', 'Blue'),
(1, 'Personal Events', 'Orange'),
(2, 'Family Calendar', 'Red'),
(2, 'Fitness Routine', 'Green'),
(3, 'Project Deadlines', 'Purple'),
(3, 'Social Events', 'Pink'),
(4, 'Work Meetings', 'Navy'),
(4, 'Travel Plans', 'Teal'),
(5, 'Study Schedule', 'Yellow'),
(5, 'Health Appointments', 'Lime'),
(6, 'Business Calendar', 'Maroon'),
(6, 'Hobby Time', 'Cyan'),
(7, 'Team Projects', 'Indigo'),
(7, 'Weekend Plans', 'Coral'),
(8, 'Client Meetings', 'Brown'),
(8, 'Personal Goals', 'Magenta'),
(9, 'School Events', 'Olive'),
(9, 'Family Time', 'Silver'),
(10, 'Work Shifts', 'Gold'),
(10, 'Entertainment', 'Lavender'),
(11, 'Marketing Tasks', 'Turquoise'),
(11, 'Volunteer Work', 'Beige'),
(12, 'Training Sessions', 'Crimson'),
(12, 'Social Media', 'Mint'),
(13, 'Development Work', 'Salmon'),
(13, 'Personal Projects', 'Khaki'),
(14, 'Sales Calendar', 'Plum'),
(14, 'Home Maintenance', 'Peach'),
(15, 'Research Tasks', 'Violet'),
(15, 'Cooking Schedule', 'Rose'),
(16, 'Freelance Work', 'Azure'),
(16, 'Gaming Sessions', 'Ivory'),
(17, 'Consulting Jobs', 'Tan'),
(17, 'Book Club', 'Amber'),
(18, 'Design Projects', 'Jade'),
(18, 'Music Practice', 'Ruby'),
(19, 'Content Creation', 'Emerald'),
(19, 'Pet Care', 'Chocolate'),
(20, 'Teaching Schedule', 'Burgundy'),
(20, 'Garden Planning', 'Mint Green'),
(21, 'Photography Gigs', 'Sky Blue'),
(21, 'Language Learning', 'Coral Pink'),
(22, 'Writing Deadlines', 'Forest Green'),
(22, 'Movie Nights', 'Deep Purple'),
(23, 'Coding Bootcamp', 'Electric Blue'),
(23, 'Meal Planning', 'Sunshine Yellow'),
(24, 'Art Classes', 'Hot Pink'),
(24, 'Investment Tracking', 'Dark Green'),
(25, 'Yoga Sessions', 'Soft Blue'),
(25, 'Reading List', 'Warm Orange');

INSERT INTO Calendar (id_user, name, color)
VALUES
(54, 'Work Schedule', 'Blue')

INSERT INTO UserEvents (
    id_calendar, name, Start_Date, Due_Date, description, location,
    is_all_day, is_recurring, color, remind_method, remind_before, remind_unit, created_at
)
VALUES
(51, N'Test Mail Event', DATEADD(minute, 8, GETDATE()), DATEADD(minute, 10, GETDATE()), N'Sự kiện test gửi mail reminder', 'Phòng Test', 0, 0, N'Blue', 1, 5, 'minutes', GETDATE());


INSERT INTO UserEvents (
    id_calendar, name, Start_Date, Due_Date, description, location,
    is_all_day, is_recurring, recurrence_rule, color, remind_method, remind_before, remind_unit, updated_at
)
VALUES
(1, 'Weekly Team Meeting', '2025-07-02 09:00:00', '2025-07-02 10:00:00', 'Regular team sync and project updates', 'Conference Room A', 0, 1, 'FREQ=WEEKLY;BYDAY=WE', 'Blue', 1, 15, 'minutes', '2025-07-01 14:30:00'),
(2, 'Dinner with Parents', '2025-07-05 18:30:00', '2025-07-05 21:00:00', 'Family dinner at home', 'Home', 0, 0, NULL, 'Orange', 0, 30, 'minutes', '2025-07-04 12:15:00'),
(3, 'Project Alpha Deadline', '2025-07-10 23:59:00', '2025-07-10 23:59:00', 'Final submission for Project Alpha', 'Office Building', 0, 0, NULL, 'Red', 1, 2, 'days', '2025-07-08 16:45:00'),
(4, 'Birthday Party - Sarah', '2025-07-12 14:00:00', '2025-07-12 18:00:00', 'Sarah''s 30th birthday celebration', 'Central Park', 0, 0, NULL, 'Pink', 0, 1, 'hours', '2025-07-11 10:20:00'),
(5, 'Morning Workout', '2025-07-01 06:00:00', '2025-07-01 07:00:00', 'Cardio and strength training', 'Fitness Center', 0, 1, 'FREQ=DAILY;INTERVAL=1', 'Green', 0, 10, 'minutes', '2025-06-30 20:00:00'),
(6, 'Book Club Meeting', '2025-07-08 19:00:00', '2025-07-08 21:00:00', 'Discussing "The Great Gatsby"', 'Community Library', 0, 1, 'FREQ=MONTHLY;BYMONTHDAY=8', 'Purple', 1, 2, 'hours', '2025-07-06 11:30:00'),
(7, 'Client Presentation', '2025-07-15 14:00:00', '2025-07-15 15:30:00', 'Q2 performance review with client', 'Client Office Downtown', 0, 0, NULL, 'Navy', 1, 45, 'minutes', '2025-07-14 09:15:00'),
(8, 'Flight to Tokyo', '2025-07-20 08:45:00', '2025-07-20 22:30:00', 'Business trip to Tokyo office', 'Airport Terminal 2', 0, 0, NULL, 'Teal', 0, 3, 'hours', '2025-07-18 14:20:00'),
(9, 'Midterm Exam - Biology', '2025-07-25 10:00:00', '2025-07-25 12:00:00', 'Chapter 1-8 coverage', 'University Hall Room 203', 0, 0, NULL, 'Yellow', 1, 1, 'days', '2025-07-23 18:45:00'),
(10, 'Doctor Appointment', '2025-07-07 11:30:00', '2025-07-07 12:00:00', 'Annual physical checkup', 'Medical Center', 0, 0, NULL, 'Lime', 0, 30, 'minutes', '2025-07-05 15:10:00'),
(11, 'Marketing Campaign Launch', '2025-07-18 00:00:00', '2025-07-18 23:59:00', 'Summer campaign goes live', 'Multiple Locations', 1, 0, NULL, 'Maroon', 1, 1, 'weeks', '2025-07-11 13:25:00'),
(12, 'Guitar Lesson', '2025-07-03 16:00:00', '2025-07-03 17:00:00', 'Working on fingerpicking techniques', 'Music Studio', 0, 1, 'FREQ=WEEKLY;BYDAY=TH', 'Cyan', 0, 20, 'minutes', '2025-07-02 19:30:00'),
(13, 'Code Review Session', '2025-07-14 13:00:00', '2025-07-14 14:30:00', 'Review pull requests for sprint', 'Development Lab', 0, 1, 'FREQ=WEEKLY;BYDAY=MO', 'Indigo', 1, 15, 'minutes', '2025-07-13 08:45:00'),
(14, 'Weekend Hiking Trip', '2025-07-19 06:00:00', '2025-07-20 18:00:00', 'Mountain trail hiking adventure', 'Blue Ridge Mountains', 1, 0, NULL, 'Coral', 0, 12, 'hours', '2025-07-17 16:20:00'),
(15, 'Quarterly Business Review', '2025-07-30 09:00:00', '2025-07-30 17:00:00', 'Q2 results and Q3 planning', 'Corporate Headquarters', 1, 1, 'FREQ=MONTHLY;INTERVAL=3', 'Brown', 1, 2, 'days', '2025-07-28 11:15:00'),
(16, 'Meditation Session', '2025-07-04 07:00:00', '2025-07-04 07:30:00', 'Morning mindfulness practice', 'Home Garden', 0, 1, 'FREQ=DAILY', 'Magenta', 0, 5, 'minutes', '2025-07-03 22:10:00'),
(17, 'School Science Fair', '2025-07-22 10:00:00', '2025-07-22 16:00:00', 'Judging student projects', 'Elementary School Gym', 1, 0, NULL, 'Olive', 1, 1, 'days', '2025-07-21 14:35:00'),
(18, 'Family BBQ', '2025-07-26 12:00:00', '2025-07-26 20:00:00', 'Annual summer family gathering', 'Backyard', 1, 1, 'FREQ=YEARLY', 'Silver', 0, 2, 'hours', '2025-07-24 17:50:00'),
(19, 'Night Shift - Security', '2025-07-11 22:00:00', '2025-07-12 06:00:00', 'Building security patrol', 'Office Complex', 0, 1, 'FREQ=WEEKLY;BYDAY=FR,SA', 'Gold', 0, 1, 'hours', '2025-07-10 20:25:00'),
(20, 'Netflix Movie Marathon', '2025-07-13 19:00:00', '2025-07-13 23:00:00', 'Marvel movies night', 'Living Room', 0, 0, NULL, 'Lavender', 0, 0, 'minutes', '2025-07-13 10:30:00'),
(21, 'Social Media Content Planning', '2025-07-16 10:00:00', '2025-07-16 12:00:00', 'Plan next week''s posts', 'Home Office', 0, 1, 'FREQ=WEEKLY;BYDAY=TU', 'Turquoise', 1, 30, 'minutes', '2025-07-15 13:40:00'),
(22, 'Volunteer at Food Bank', '2025-07-17 14:00:00', '2025-07-17 18:00:00', 'Help distribute meals', 'Community Food Bank', 0, 1, 'FREQ=WEEKLY;BYDAY=WE', 'Beige', 0, 1, 'hours', '2025-07-16 09:55:00'),
(23, 'Personal Training Session', '2025-07-21 17:00:00', '2025-07-21 18:00:00', 'Upper body strength training', 'Local Gym', 0, 1, 'FREQ=WEEKLY;BYDAY=MO,WE,FR', 'Crimson', 0, 15, 'minutes', '2025-07-20 21:15:00'),
(24, 'Instagram Live Session', '2025-07-23 20:00:00', '2025-07-23 21:00:00', 'Q&A with followers', 'Home Studio', 0, 1, 'FREQ=WEEKLY;BYDAY=TU', 'Mint', 1, 30, 'minutes', '2025-07-22 16:45:00'),
(25, 'Web Development Workshop', '2025-07-24 09:00:00', '2025-07-24 17:00:00', 'React and Node.js bootcamp', 'Tech Center', 1, 0, NULL, 'Salmon', 1, 1, 'days', '2025-07-22 12:20:00'),
(26, 'Home Renovation Planning', '2025-07-27 10:00:00', '2025-07-27 12:00:00', 'Kitchen remodel discussion', 'Home', 0, 0, NULL, 'Khaki', 0, 2, 'hours', '2025-07-26 18:30:00'),
(27, 'Sales Pitch - New Client', '2025-07-28 15:00:00', '2025-07-28 16:30:00', 'Present our services', 'Client Office', 0, 0, NULL, 'Plum', 1, 1, 'hours', '2025-07-27 11:45:00'),
(28, 'Garden Watering', '2025-07-02 06:30:00', '2025-07-02 07:00:00', 'Water vegetables and flowers', 'Backyard Garden', 0, 1, 'FREQ=DAILY', 'Peach', 0, 10, 'minutes', '2025-07-01 19:20:00'),
(29, 'Research Paper Deadline', '2025-07-31 23:59:00', '2025-07-31 23:59:00', 'Submit final draft to journal', 'University', 0, 0, NULL, 'Violet', 1, 3, 'days', '2025-07-28 15:10:00'),
(30, 'Cooking Class', '2025-07-06 18:00:00', '2025-07-06 21:00:00', 'Italian cuisine basics', 'Culinary School', 0, 1, 'FREQ=WEEKLY;BYDAY=SA', 'Rose', 0, 45, 'minutes', '2025-07-05 14:25:00'),
(31, 'Freelance Project Delivery', '2025-07-09 17:00:00', '2025-07-09 17:00:00', 'Website redesign completion', 'Client Location', 0, 0, NULL, 'Azure', 1, 2, 'hours', '2025-07-08 10:15:00'),
(32, 'Gaming Tournament', '2025-07-11 19:00:00', '2025-07-11 23:00:00', 'Online esports competition', 'Home', 0, 0, NULL, 'Ivory', 0, 30, 'minutes', '2025-07-10 16:40:00'),
(33, 'Business Consultation', '2025-07-29 11:00:00', '2025-07-29 13:00:00', 'Strategic planning session', 'Downtown Office', 0, 0, NULL, 'Tan', 1, 1, 'hours', '2025-07-28 09:30:00'),
(34, 'Reading Session', '2025-07-04 20:00:00', '2025-07-04 21:30:00', 'Finish current novel chapter', 'Library Corner', 0, 1, 'FREQ=DAILY', 'Amber', 0, 0, 'minutes', '2025-07-04 12:50:00'),
(35, 'Logo Design Review', '2025-07-12 10:00:00', '2025-07-12 11:30:00', 'Client feedback incorporation', 'Design Studio', 0, 0, NULL, 'Jade', 1, 30, 'minutes', '2025-07-11 15:20:00'),
(36, 'Piano Recital Practice', '2025-07-15 19:00:00', '2025-07-15 20:30:00', 'Prepare for upcoming recital', 'Music Room', 0, 1, 'FREQ=WEEKLY;BYDAY=MO,WE,FR', 'Ruby', 0, 20, 'minutes', '2025-07-14 21:10:00'),
(37, 'YouTube Video Upload', '2025-07-18 16:00:00', '2025-07-18 17:00:00', 'Edit and publish weekly vlog', 'Home Office', 0, 1, 'FREQ=WEEKLY;BYDAY=TH', 'Emerald', 1, 1, 'hours', '2025-07-17 13:35:00'),
(38, 'Vet Appointment - Max', '2025-07-25 14:30:00', '2025-07-25 15:00:00', 'Annual checkup for dog', 'Animal Hospital', 0, 0, NULL, 'Chocolate', 0, 2, 'hours', '2025-07-23 11:25:00'),
(39, 'Lecture - Modern History', '2025-07-08 10:00:00', '2025-07-08 11:30:00', 'World War II analysis', 'University Auditorium', 0, 1, 'FREQ=WEEKLY;BYDAY=TU,TH', 'Burgundy', 1, 15, 'minutes', '2025-07-07 17:40:00'),
(40, 'Plant Repotting Day', '2025-07-19 09:00:00', '2025-07-19 12:00:00', 'Repot indoor plants', 'Garden Shed', 0, 1, 'FREQ=MONTHLY;BYMONTHDAY=19', 'Mint Green', 0, 30, 'minutes', '2025-07-18 20:15:00'),
(41, 'Wedding Photography Gig', '2025-07-26 13:00:00', '2025-07-26 22:00:00', 'Capture ceremony and reception', 'Riverside Chapel', 1, 0, NULL, 'Sky Blue', 1, 2, 'hours', '2025-07-24 14:50:00'),
(42, 'Spanish Lesson', '2025-07-01 18:00:00', '2025-07-01 19:00:00', 'Conversational practice', 'Language Center', 0, 1, 'FREQ=WEEKLY;BYDAY=MO,WE', 'Coral Pink', 0, 25, 'minutes', '2025-06-30 16:30:00'),
(43, 'Article Submission', '2025-07-14 23:59:00', '2025-07-14 23:59:00', 'Tech blog post deadline', 'Home Office', 0, 0, NULL, 'Forest Green', 1, 6, 'hours', '2025-07-13 19:20:00'),
(44, 'Movie Night - Friends', '2025-07-05 20:00:00', '2025-07-05 23:00:00', 'Weekly movie with roommates', 'Living Room', 0, 1, 'FREQ=WEEKLY;BYDAY=FR', 'Deep Purple', 0, 1, 'hours', '2025-07-04 22:45:00'),
(45, 'Coding Bootcamp - Final Project', '2025-07-31 18:00:00', '2025-07-31 20:00:00', 'Present capstone project', 'Bootcamp Center', 0, 0, NULL, 'Electric Blue', 1, 1, 'days', '2025-07-30 10:25:00'),
(46, 'Meal Prep Sunday', '2025-07-06 10:00:00', '2025-07-06 14:00:00', 'Prepare meals for the week', 'Kitchen', 0, 1, 'FREQ=WEEKLY;BYDAY=SU', 'Sunshine Yellow', 0, 30, 'minutes', '2025-07-05 18:15:00'),
(47, 'Art Exhibition Opening', '2025-07-17 18:00:00', '2025-07-17 21:00:00', 'Local artists showcase', 'Downtown Gallery', 0, 0, NULL, 'Hot Pink', 1, 2, 'hours', '2025-07-16 12:40:00'),
(48, 'Portfolio Review', '2025-07-23 09:00:00', '2025-07-23 10:30:00', 'Quarterly investment check', 'Financial Advisor Office', 0, 1, 'FREQ=MONTHLY;INTERVAL=3', 'Dark Green', 1, 1, 'days', '2025-07-22 15:55:00'),
(49, 'Morning Yoga', '2025-07-02 07:30:00', '2025-07-02 08:30:00', 'Hatha yoga practice', 'Yoga Studio', 0, 1, 'FREQ=WEEKLY;BYDAY=TU,TH,SA', 'Soft Blue', 0, 15, 'minutes', '2025-07-01 21:30:00'),
(50, 'Book Review Due', '2025-07-16 23:59:00', '2025-07-16 23:59:00', 'Submit review for book club', 'Online', 0, 0, NULL, 'Warm Orange', 1, 2, 'days', '2025-07-14 13:20:00');

INSERT INTO Task (id_user, name, color)
VALUES
(1, 'Website Redesign', 'Blue'),
(1, 'Client Proposals', 'Green'),
(2, 'Grocery Shopping', 'Red'),
(2, 'Home Organization', 'Purple'),
(3, 'Marketing Campaign', 'Teal'),
(3, 'Social Media Content', 'Yellow'),
(4, 'Code Review Tasks', 'Navy'),
(4, 'Bug Fixes', 'Lime'),
(5, 'Study for Certification', 'Maroon'),
(5, 'Fitness Goals', 'Cyan'),
(6, 'Business Development', 'Indigo'),
(6, 'Networking Events', 'Coral'),
(7, 'Team Management', 'Brown'),
(7, 'Performance Reviews', 'Magenta'),
(8, 'Travel Planning', 'Olive'),
(8, 'Language Learning', 'Silver'),
(9, 'Research Projects', 'Gold'),
(9, 'Academic Writing', 'Lavender'),
(10, 'Health Appointments', 'Turquoise'),
(10, 'Personal Finance', 'Beige'),
(11, 'Content Creation', 'Crimson'),
(11, 'Brand Strategy', 'Mint'),
(12, 'Skill Development', 'Salmon'),
(12, 'Hobby Projects', 'Khaki'),
(13, 'Software Development', 'Plum'),
(13, 'Testing Tasks', 'Peach'),
(14, 'Sales Activities', 'Violet'),
(14, 'Customer Follow-ups', 'Rose'),
(15, 'Data Analysis', 'Azure'),
(15, 'Report Generation', 'Ivory'),
(16, 'Creative Writing', 'Tan'),
(16, 'Photography Projects', 'Amber'),
(17, 'Consulting Work', 'Jade'),
(17, 'Workshop Preparation', 'Ruby'),
(18, 'Design Tasks', 'Emerald'),
(18, 'Portfolio Updates', 'Chocolate'),
(19, 'Video Production', 'Burgundy'),
(19, 'Equipment Maintenance', 'Mint Green'),
(20, 'Lesson Planning', 'Sky Blue'),
(20, 'Student Assessments', 'Coral Pink'),
(21, 'Event Photography', 'Forest Green'),
(21, 'Photo Editing', 'Deep Purple'),
(22, 'Editorial Tasks', 'Electric Blue'),
(22, 'Book Reviews', 'Sunshine Yellow'),
(23, 'Learning Objectives', 'Hot Pink'),
(23, 'Meal Preparation', 'Dark Green'),
(24, 'Art Commissions', 'Soft Blue'),
(24, 'Investment Research', 'Warm Orange'),
(25, 'Wellness Routine', 'Light Purple'),
(25, 'Reading Schedule', 'Bright Red'),
(26, 'Home Improvement', 'Deep Teal'),
(26, 'Garden Projects', 'Lemon Yellow');

INSERT INTO To_Do (id_task, title, description, due_date, is_all_day, is_recurring, recurrence_rule, is_completed)
VALUES
(1, 'Create wireframes', 'Design initial wireframes for homepage', '2025-07-05 14:00:00', 0, 0, NULL, 0),
(1, 'Review color scheme', 'Finalize brand colors for new design', '2025-07-08 16:30:00', 0, 0, NULL, 1),
(2, 'Draft proposal for Tech Corp', 'Prepare comprehensive service proposal', '2025-07-10 17:00:00', 0, 0, NULL, 0),
(2, 'Follow up with ABC Company', 'Send follow-up email after meeting', '2025-07-03 10:00:00', 0, 0, NULL, 1),
(3, 'Buy fresh vegetables', 'Tomatoes, lettuce, carrots, onions', '2025-07-02 19:00:00', 0, 1, 'FREQ=WEEKLY;BYDAY=TU', 0),
(3, 'Stock cleaning supplies', 'All-purpose cleaner, paper towels, detergent', '2025-07-04 20:00:00', 0, 0, NULL, 0),
(4, 'Organize bedroom closet', 'Sort clothes and donate unused items', '2025-07-06 00:00:00', 1, 0, NULL, 0),
(4, 'Deep clean kitchen', 'Clean appliances and organize cabinets', '2025-07-09 00:00:00', 1, 0, NULL, 0),
(5, 'Design Instagram posts', 'Create 5 posts for product launch', '2025-07-07 15:00:00', 0, 0, NULL, 1),
(5, 'Analyze competitor campaigns', 'Research top 3 competitors strategies', '2025-07-12 12:00:00', 0, 0, NULL, 0),
(6, 'Write blog post', 'Tips for effective social media engagement', '2025-07-11 13:30:00', 0, 0, NULL, 0),
(6, 'Schedule weekly posts', 'Plan and schedule next week content', '2025-07-04 11:00:00', 0, 1, 'FREQ=WEEKLY;BYDAY=TH', 1),
(7, 'Review pull request #247', 'Check authentication module changes', '2025-07-03 09:00:00', 0, 0, NULL, 1),
(7, 'Update documentation', 'Add API endpoint documentation', '2025-07-08 14:00:00', 0, 0, NULL, 0),
(8, 'Fix login bug', 'Resolve session timeout issue', '2025-07-05 11:30:00', 0, 0, NULL, 0),
(8, 'Optimize database queries', 'Improve performance for user search', '2025-07-15 16:00:00', 0, 0, NULL, 0),
(9, 'Complete AWS certification', 'Finish remaining practice tests', '2025-07-20 00:00:00', 1, 0, NULL, 0),
(9, 'Read Chapter 5-8', 'Cloud architecture patterns', '2025-07-13 22:00:00', 0, 0, NULL, 1),
(10, 'Morning jog', 'Run 3 miles in the park', '2025-07-02 07:00:00', 0, 1, 'FREQ=DAILY;BYDAY=MO,WE,FR', 1),
(10, 'Gym workout', 'Upper body strength training', '2025-07-04 18:00:00', 0, 1, 'FREQ=WEEKLY;BYDAY=TU,TH', 0),
(11, 'Contact potential partners', 'Reach out to 5 strategic partners', '2025-07-14 10:00:00', 0, 0, NULL, 0),
(11, 'Update business plan', 'Revise Q3 growth projections', '2025-07-18 17:00:00', 0, 0, NULL, 0),
(12, 'Attend tech meetup', 'Local JavaScript developers meetup', '2025-07-16 19:00:00', 0, 0, NULL, 0),
(12, 'Connect on LinkedIn', 'Follow up with meetup contacts', '2025-07-17 09:00:00', 0, 0, NULL, 0),
(13, 'One-on-one with Sarah', 'Discuss career development goals', '2025-07-09 14:00:00', 0, 0, NULL, 1),
(13, 'Prepare team presentation', 'Q2 results and Q3 objectives', '2025-07-11 16:00:00', 0, 0, NULL, 0),
(14, 'Complete John''s review', 'Annual performance evaluation', '2025-07-22 15:00:00', 0, 0, NULL, 0),
(14, 'Schedule team building', 'Plan monthly team activity', '2025-07-25 12:00:00', 0, 0, NULL, 0),
(15, 'Book flight tickets', 'Business trip to San Francisco', '2025-07-06 23:59:00', 0, 0, NULL, 1),
(15, 'Research hotels', 'Find accommodation near conference venue', '2025-07-07 20:00:00', 0, 0, NULL, 0),
(16, 'Practice Spanish vocabulary', 'Review 50 new words', '2025-07-03 20:30:00', 0, 1, 'FREQ=DAILY', 1),
(16, 'Complete lesson 12', 'Grammar exercises and conversation', '2025-07-10 21:00:00', 0, 0, NULL, 0),
(17, 'Literature review', 'Find 10 relevant academic papers', '2025-07-19 00:00:00', 1, 0, NULL, 0),
(17, 'Data collection', 'Survey 100 participants', '2025-07-28 00:00:00', 1, 0, NULL, 0),
(18, 'Draft introduction', 'Write thesis introduction chapter', '2025-07-24 23:59:00', 0, 0, NULL, 0),
(18, 'Format bibliography', 'APA style reference formatting', '2025-07-26 17:00:00', 0, 0, NULL, 0),
(19, 'Schedule dentist appointment', 'Six-month cleaning and checkup', '2025-07-08 00:00:00', 1, 0, NULL, 1),
(19, 'Refill prescriptions', 'Order monthly medications', '2025-07-15 18:00:00', 0, 1, 'FREQ=MONTHLY;BYMONTHDAY=15', 0),
(20, 'Review investment portfolio', 'Check Q2 performance', '2025-07-21 11:00:00', 0, 1, 'FREQ=MONTHLY;INTERVAL=3', 0),
(20, 'Update budget spreadsheet', 'Add June expenses', '2025-07-05 19:00:00', 0, 1, 'FREQ=MONTHLY;BYMONTHDAY=5', 1),
(21, 'Write product review', '500-word review for tech blog', '2025-07-12 20:00:00', 0, 0, NULL, 0),
(21, 'Edit video content', 'Final cut for YouTube channel', '2025-07-17 22:00:00', 0, 0, NULL, 0),
(22, 'Develop brand guidelines', 'Create comprehensive style guide', '2025-07-30 00:00:00', 1, 0, NULL, 0),
(22, 'Client brand workshop', 'Facilitate brand discovery session', '2025-07-23 14:30:00', 0, 0, NULL, 0),
(23, 'Learn React Hooks', 'Complete online tutorial series', '2025-07-27 00:00:00', 1, 0, NULL, 0),
(23, 'Build practice project', 'Create to-do app with new skills', '2025-07-31 23:59:00', 0, 0, NULL, 0),
(24, 'Finish oil painting', 'Complete landscape commission', '2025-07-14 00:00:00', 1, 0, NULL, 1),
(24, 'Organize art supplies', 'Clean and inventory studio materials', '2025-07-16 15:00:00', 0, 0, NULL, 0),
(25, 'Set up development environment', 'Configure IDE and dependencies', '2025-07-04 13:00:00', 0, 0, NULL, 1),
(25, 'Code authentication module', 'Implement user login system', '2025-07-18 16:30:00', 0, 0, NULL, 0);


select * from User_Course
INSERT INTO User_Course (id_user, id_course)
VALUES
(1, 1),
(2, 1)

