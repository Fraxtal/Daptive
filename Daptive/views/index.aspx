<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs"
Inherits="Daptive.views.index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
  <head runat="server">
    <title>Homepage</title>
    <link rel="stylesheet" href="../styles/style.css" />
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
      crossorigin="anonymous"
    />
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
  </head>
  <body>
    <form id="form1" runat="server">
      <div class="container">
          <nav
            class="navbar navbar-expand-lg bg-body-tertiary rounded"
            aria-label="Eleventh navbar example"
          >
            <div class="container-fluid">
              <i class="bi bi-book" style="font-size: 2rem; color: cornflowerblue;"></i>
              <button
                class="navbar-toggler"
                type="button"
                data-bs-toggle="collapse"   
                data-bs-target="#navbarsExample09"
                aria-controls="navbarsExample09"
                aria-expanded="false"
                aria-label="Toggle navigation"
              >
                <span class="navbar-toggler-icon"></span>
              </button>
              <div class="collapse navbar-collapse" id="navbarsExample09">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                  <li class="nav-item">
                    <a class="nav-link active" aria-current="page" href="#">Home</a>
                  </li>
                  <li class="nav-item"><a class="nav-link" href="#">Link</a></li>
                </ul>
              </div>
            </div>
          </nav>
          </div>
      <main>
        <h1>Our Dashboard</h1>
      </main>
    </form>
    <script
      src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"
      integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI"
      crossorigin="anonymous"
    ></script>
  </body>
</html>
