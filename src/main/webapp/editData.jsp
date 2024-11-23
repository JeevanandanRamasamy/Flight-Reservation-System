<%@ page import="java.sql.*" import="java.time.LocalDate"
	import="java.time.LocalTime"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Flight Reservation</title>
</head>
<body>
	<%
	String dtype = request.getParameter("type");
	Connection con = null;
	PreparedStatement pstmt = null;

	try {
		Class.forName("com.mysql.jdbc.Driver");
		con = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation_system", "root", "your_password");

		if (dtype.equals("flight")) {
			int prevFNum = Integer.parseInt(request.getParameter("id1"));
			String prevAId = request.getParameter("id2");
			int flightNumber = Integer.parseInt(request.getParameter("updatedValue1"));
			String type = request.getParameter("updatedValue2");
			String registration = request.getParameter("updatedValue3");
			String airlineID = request.getParameter("updatedValue4");
			String depAirportID = request.getParameter("updatedValue5");
			LocalDate depDate = LocalDate.parse(request.getParameter("updatedValue6"));
			LocalTime depTime = LocalTime.parse(request.getParameter("updatedValue7"));
			String arrAirportID = request.getParameter("updatedValue8");
			LocalDate arrDate = LocalDate.parse(request.getParameter("updatedValue9"));
			LocalTime arrTime = LocalTime.parse(request.getParameter("updatedValue10"));
			double price = Double.parseDouble(request.getParameter("updatedValue11"));

			pstmt = con.prepareStatement("UPDATE Flight SET "
			+ "num = ?, flight_type = ?, registration = ?, airline_id = ?, dep_airport_id = ?, dep_date = ?, dep_time = ?, "
			+ "arr_airport_id = ?, arr_date = ?, arr_time = ?, price = ? WHERE num = ? AND airline_id = ?");
			pstmt.setInt(1, flightNumber);
			pstmt.setString(2, type);
			pstmt.setString(3, registration);
			pstmt.setString(4, airlineID);
			pstmt.setString(5, depAirportID);
			pstmt.setDate(6, java.sql.Date.valueOf(depDate));
			pstmt.setTime(7, java.sql.Time.valueOf(depTime));
			pstmt.setString(8, arrAirportID);
			pstmt.setDate(9, java.sql.Date.valueOf(arrDate));
			pstmt.setTime(10, java.sql.Time.valueOf(arrTime));
			pstmt.setDouble(11, price);
			pstmt.setInt(12, prevFNum);
			pstmt.setString(13, prevAId);
		} else if (dtype.equals("aircraft")) {
			String prevAId = request.getParameter("id1");
			String registration = request.getParameter("updatedValue1");
			int seats = Integer.parseInt(request.getParameter("updatedValue2"));
			String airlineID = request.getParameter("updatedValue3");

			pstmt = con.prepareStatement(
			"UPDATE Aircraft SET registration = ?, seats = ?, airline_id = ? WHERE registration = ?");
			pstmt.setString(1, registration);
			pstmt.setInt(2, seats);
			pstmt.setString(3, airlineID);
			pstmt.setString(4, prevAId);
		} else if (dtype.equals("airport")) {
			String prevAId = request.getParameter("id1");
			String airportID = request.getParameter("updatedValue1");
			pstmt = con.prepareStatement("UPDATE Airport SET id = ? WHERE id = ?");
			pstmt.setString(1, airportID);
			pstmt.setString(2, prevAId);
		}

		pstmt.executeUpdate();
		response.sendRedirect(request.getHeader("Referer"));
	} catch (Exception e) {
		response.sendRedirect(request.getHeader("Referer") + "?error=Error: " + e.getMessage());
	} finally {
		try {
			if (pstmt != null)
		pstmt.close();
			if (con != null)
		con.close();
		} catch (SQLException e) {
		}
	}
	%>
</body>
</html>