<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" import="java.util.Date"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Ticket</title>
</head>
<body>
	<h2>Flight Search</h2>
	<%
	try {
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation_system", "root", "your_password");
	
	String username = request.getParameter("username");
	String ticketString = request.getParameter("ticketNum");
	if (ticketString != null) {
		int ticketNum = Integer.parseInt(ticketString);
		out.println("Editing ticket " + ticketNum + " for " + username);
			
		PreparedStatement userStmt = con.prepareStatement("SELECT id FROM Users WHERE username = ?");
		userStmt.setString(1, username);
		ResultSet user = userStmt.executeQuery();
		user.next();
		int userId = user.getInt("id");
		Statement ticketStmt = con.createStatement();
		ResultSet ticket = ticketStmt.executeQuery("SELECT * FROM Cust_Ticket WHERE cust_id = " + userId + " AND ticket_num = " + ticketNum);
		ticket.next();
		String selectedClass = ticket.getString("class");
		String[] classes = {"Economy", "Business", "First Class"};
		%>
		<form method="POST" action="editTicket.jsp">
			<input type="hidden" name="userId" value="<%= userId %>">
			<label for="newTicket">Change Ticket number:</label>
			<input type="text" name="newTicketNum" placeholder="Ticket Number" value="<%= ticketNum %>"> <br>
			<input type="hidden" name="oldTicketNum" value="<%= ticketNum %>">
			<label for="newClass">Change Ticket Class:</label>
			<select id="newClass" name="newClass">
				<option value="<%=selectedClass%>"><%=selectedClass%></option>
				<% for (String c : classes) {
						if (!c.equals(selectedClass)) {%>
							<option value="<%=c%>"><%=c%></option>
				<% 		}
					} %>
			</select> <br>
			<input type="submit" name="submit" value="Submit">
		</form>
	<% 	} else {
			int userId = Integer.parseInt(request.getParameter("userId"));
			int newTicketNum = Integer.parseInt(request.getParameter("newTicketNum"));
			int oldTicketNum = Integer.parseInt(request.getParameter("oldTicketNum"));
			String newClass = request.getParameter("newClass");
			Date currentDate = new Date();
			Timestamp time = new Timestamp(currentDate.getTime());
			
			PreparedStatement updateStmt = con.prepareStatement(
					"UPDATE Cust_Ticket SET ticket_num = ?, class = ?, time_purchased = ? WHERE ticket_num = ? AND cust_id = ?");
			updateStmt.setInt(1, newTicketNum);
			updateStmt.setString(2, newClass);
			updateStmt.setTimestamp(3, time);
			updateStmt.setInt(4, oldTicketNum);
			updateStmt.setInt(5, userId);
			updateStmt.executeUpdate();
			response.sendRedirect("reservation.jsp");
		}
	} catch (Exception e) {
		out.println("Exception: " + e.getMessage());
	} %>
</body>
</html>
	