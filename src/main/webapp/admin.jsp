<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Admin</title>
</head>
<body>

<h1>Admin</h1>

<h2>Add, Edit, and Delete</h2>
<form method="post" action="adminAction.jsp">
    <label for="action">Select Action:</label>
    <select name="action" id="action" onchange="toggleFields()">
        <option value="addUser" selected>Add User</option>
        <option value="editUser">Edit User</option>
        <option value="deleteUser">Delete User</option>
    </select>

    <div id="textFields" style="overflow-y: scroll; max-height: 100px;">
        <label for="username">Username:</label>
        <input type="text" name="username" id="username"><br>

        <label for="password">Password:</label>
        <input type="text" name="password" id="password"><br>

        <label for="fname">First Name:</label>
        <input type="text" name="fname" id="fname"><br>

        <label for="lname">Last Name:</label>
        <input type="text" name="lname" id="lname"><br>
    </div>

    <div id="dropdownField" style="display: none;">
	    <label for="selectedUser">Select User:</label>
	    <select name="selectedUser" id="selectedUser">
	        <%
	            ApplicationDB db = new ApplicationDB();
	            Connection connection = db.getConnection();
	
	            Statement statement = null;
	            ResultSet resultSet = null;
	
	            try {
	                String query = "SELECT id, username FROM Users";
	                statement = connection.createStatement();
	                resultSet = statement.executeQuery(query);
	
	                while (resultSet.next()) {
	                    int userId = resultSet.getInt("id");
	                    String username = resultSet.getString("username");
	                    out.println("<option value=\"" + userId + "\">" + username + "</option>");
	                }
	
	            } catch (Exception e) {
	                e.printStackTrace();
	            } finally {
	                resultSet.close();
	                statement.close();
	                connection.close();
	            }
	        %>
	    </select><br>
	</div>

    <div id="checkboxField" style="display: none;">
        <label for="checkbox">Customer Representative:</label>
        <input type="checkbox" name="checkbox" id="checkbox"><br>
    </div>

    <input type="submit" value="Submit">
</form>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        toggleFields();
    });

    function toggleFields() {
        var selectedAction = document.getElementById("action").value;
        var textFields = document.getElementById("textFields");
        var dropdownField = document.getElementById("dropdownField");
        var checkboxField = document.getElementById("checkboxField");

        textFields.style.display = "none";
        dropdownField.style.display = "none";
        checkboxField.style.display = "none";

        if (selectedAction === "addUser") {
            textFields.style.display = "block";
            checkboxField.style.display = "block";
        } else if (selectedAction === "editUser") {
            dropdownField.style.display = "block";
        } else if (selectedAction === "deleteUser") {
        	dropdownField.style.display = "block";
        }
    }
</script>


<h2>Sales Report</h2>
<form method="post" action="adminAction.jsp">
    <label for="month">Select Month:</label>
    <select name="month" id="month">
        <option value="January">January</option>
        <option value="February">February</option>
        <option value="March">March</option>
        <option value="April">April</option>
        <option value="May">May</option>
        <option value="June">June</option>
        <option value="July">July</option>
        <option value="August">August</option>
        <option value="September">September</option>
        <option value="October">October</option>
        <option value="November">November</option>
        <option value="December">December</option>
    </select>
    <input type="submit" value="submit">
</form>

<h2>List of Reservations</h2>
<form method="post" action="adminAction.jsp">
    <label for="listType">Select List Type:</label>
    <select name="listType" id="listType">
        <option value="byFlightNumber">By Flight Number</option>
        <option value="byCustomerName">By Customer Name</option>
    </select>
    <input type="submit" value="submit">
</form>

<h2>Revenue Summary</h2>
<form method="post" action="adminAction.jsp">
    <label for="summaryType">Select Summary Type:</label>
    <select name="summaryType" id="summaryType">
        <option value="byFlight">By Flight</option>
        <option value="byAirline">By Airline</option>
        <option value="byCustomer">By Customer</option>
    </select>
    <input type="submit" value="submit">
</form>

<h2>Most Total Revenue</h2>
<form method="post" action="adminAction.jsp">
    <input type="hidden" name="action" value="mostTotalRevenue">
    <input type="submit" value="Submit">
</form>

<h2>Most Active Flights</h2>
<form method="post" action="adminAction.jsp">
    <input type="hidden" name="action" value="mostActiveFlights">
    <input type="submit" value="submit">
</form>

</body>
</html>