<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" import="java.util.Date"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Cancel Ticket</title>
</head>
<body>
	<%
	try {
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation_system", "root", "your_password");
		
		String username = request.getParameter("username");
		int ticketNum = Integer.parseInt(request.getParameter("ticketNum"));
			
		PreparedStatement userStmt = con.prepareStatement("SELECT id FROM Users WHERE username = ?");
		userStmt.setString(1, username);
		ResultSet user = userStmt.executeQuery();
		user.next();
		int userId = user.getInt("id");
		Statement ticketStmt = con.createStatement();
		ticketStmt.executeUpdate("DELETE FROM Cust_Ticket WHERE cust_id = " + userId + " AND ticket_num = " + ticketNum);
		response.sendRedirect(request.getHeader("Referer"));
	} catch (Exception e) {
		out.println("Exception: " + e.getMessage());
	} %>
</body>
</html>
	