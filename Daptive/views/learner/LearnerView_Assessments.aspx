<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LearnerView_Assessments.aspx.cs" Inherits="Daptive.views.LearnerView_Assessments" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="stylesheet" href="~/styles/authentication/login.css" runat="server"/>
    <link rel="stylesheet" href="~/styles/learner/assessment.css" runat="server"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <ul class="nav-bar">
                <li><a href="LearnerView_Assessments.aspx">Home</a></li>
                <li><a href="LearnerView_Courses.aspx">Courses</a></li>
                <li><a href="LearnerView_Assessments.aspx">Assessments</a></li>
                <li><a href="LearnerView_Assessments.aspx">Profile</a></li>
            </ul>
            <ul class="filter-list">
                <li><a href="LearnerView_Assessments.aspx">Submitted</a></li>
                <li><a href="LearnerView_Assessments.aspx">Assessment 2</a></li>
                <li><a href="LearnerView_Assessments.aspx">Assessment 3</a></li>
            </ul>
        </div>
    </form>
</body>
</html>
