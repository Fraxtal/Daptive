# CodeDaptive (E Learning Platform)

  An application that streamline learning C# for eager learners.

  ---

## 📂 Project Structure
```
Daptive/
├── views/              # ASPX pages
│   ├── Admin/          # Admin dashboard and management
│   ├── authentication/ # Login and registration
│   ├── learner/        # Student interface
│   └── lecturer/       # Instructor interface
├── styles/             # CSS stylesheets
├── scripts/            # JavaScript files
├── data/               # Database files (MDF)
└── resources/          # Images and assets
```

---

## ⚙️ Requirements
- .NET Framework 4.8.1
- Visual Studio 2017 or later
- IIS Express
- SQL Server LocalDB

---

## 🏗️ Build Instructions
1. Clone the repository
2. Open `Daptive.sln` in Visual Studio
3. Restore NuGet packages
4. Update the database connection string in `Web.config`
5. Build the solution (Ctrl+Shift+B)
6. Run the application (F5)

---

## 📦 Dependencies
- BCrypt.Net-Next 4.1.0
- System.Buffers 4.6.1
- System.Memory 4.6.3
- System.Numerics.Vectors 4.6.1
- System.Runtime.CompilerServices.Unsafe 6.1.2

---

## 👥 Contributors

This project was developed through collaboration by the following team members:

[Nicholas Pang Tze Shen](https://github.com/Fraxtal) 

[Ng Wei Hao](https://github.com/02-is-02) 

[Teoh Kai Chen](https://github.com/KingstonTeoh) 

[Tan Anh Kang](https://github.com/Okaniiiii18520) 

---

## 📝 Notes
- Default login page: `Login.aspx`
- Forms authentication timeout: 30 minutes
- Database: SQL Server LocalDB with MDF file attachment

---
