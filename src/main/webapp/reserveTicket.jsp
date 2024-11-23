<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" import="java.util.Date"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Flight Reservation</title>
</head>
<body>
	<%
	String user_name = request.getParameter("username");
	int ticketNum = Integer.parseInt(request.getParameter("ticketNum"));
	String ticket_class = request.getParameter("class");

	try {
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation_system", "root", "your_password");

		PreparedStatement userStmt = con.prepareStatement("SELECT id FROM Users WHERE username = ?");
		userStmt.setString(1, user_name);
		ResultSet user = userStmt.executeQuery();
		Statement flightStmt = con.createStatement();
		ResultSet flights = flightStmt.executeQuery(
		"SELECT * FROM Flight f JOIN Ticket_Flight tf ON tf.flight_num = f.num WHERE tf.ticket_num = " + ticketNum);

		while (flights.next()) {
			Statement countStmt = con.createStatement();
			ResultSet count = countStmt.executeQuery("SELECT COUNT(*) count FROM Cust_Ticket ct JOIN Ticket_Flight tf"
			+ " ON ct.ticket_num = tf.ticket_num WHERE tf.ticket_num = " + ticketNum + " AND tf.flight_num = "
			+ flights.getInt("num"));
			Statement seatsStmt = con.createStatement();
			ResultSet seats = seatsStmt.executeQuery(
			"SELECT a.seats seats FROM Aircraft a JOIN Flight f ON f.registration = a.registration WHERE f.num = "
					+ flights.getInt("num"));

			if (count.next() && seats.next() && (seats.getInt("seats") <= count.getInt("count"))) {
				user.next();
		PreparedStatement pstmt = con
				.prepareStatement("INSERT INTO Waiting_list (flight_num, airline_id, cust_id) VALUES (?, ?, ?)");
		pstmt.setInt(1, flights.getInt("num"));
		pstmt.setString(2, flights.getString("airline_id"));
		pstmt.setInt(3, user.getInt("id"));
		pstmt.executeUpdate();
			}
		}
		
		if (user.next()) {
			Date currentDate = new Date();
			Timestamp time = new Timestamp(currentDate.getTime());

			PreparedStatement update = con.prepareStatement(
			"INSERT INTO Cust_Ticket (ticket_num, cust_id, class, time_purchased) VALUES (?, ?, ?, ?)");
			update.setInt(1, ticketNum);
			update.setInt(2, user.getInt("id"));
			update.setString(3, ticket_class);
			update.setTimestamp(4, time);
			update.executeUpdate();
			response.sendRedirect(request.getHeader("Referer"));
		} else {
			out.println("Invalid arguments");
		}
		con.close();
	} catch (Exception e) {
		e.printStackTrace();
		response.sendRedirect(request.getHeader("Referer") + "?error=Error: " + e.getMessage());
	}
	%>
</body>
</html>
