<%@ page import="java.sql.*" import="java.time.LocalDate" import="java.time.LocalTime" %>
<%
    String dtype = request.getParameter("type");

    Connection con = null;
    PreparedStatement pstmt = null;
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation_system", "root", "your_password");
        
        if (dtype.equals("flight")) {
            int flightNumber = Integer.parseInt(request.getParameter("flightNumber"));
            String type = request.getParameter("flighttype");
            String registration = request.getParameter("registration");
            String airlineID = request.getParameter("airlineID");
            String depAirportID = request.getParameter("depAirportID");
            LocalDate depDate = LocalDate.parse(request.getParameter("depDate"));
            LocalTime depTime = LocalTime.parse(request.getParameter("depTime"));
            String arrAirportID = request.getParameter("arrAirportID");
            LocalDate arrDate = LocalDate.parse(request.getParameter("arrDate"));
            LocalTime arrTime = LocalTime.parse(request.getParameter("arrTime"));
            double price = Double.parseDouble(request.getParameter("price"));

            pstmt = con.prepareStatement("INSERT INTO Flight " +
                    "(num, flight_type, registration, airline_id, dep_airport_id, dep_date, dep_time, " +
                    "arr_airport_id, arr_date, arr_time, price) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            
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
        }
        else if (dtype.equals("aircraft")) {
            String registration = request.getParameter("registration");
            int seats = Integer.parseInt(request.getParameter("seats"));
            String airlineID = request.getParameter("airlineID");

            pstmt = con.prepareStatement("INSERT INTO Aircraft (registration, seats, airline_id) VALUES (?, ?, ?)");
            pstmt.setString(1, registration);
            pstmt.setInt(2, seats);
            pstmt.setString(3, airlineID);
        }
        else if (dtype.equals("airport")) {
            String airportID = request.getParameter("airportID");
            pstmt = con.prepareStatement("INSERT INTO Airport (airport_id) VALUES (?)");
            pstmt.setString(1, airportID);
    	    Statement st = con.createStatement();
    		st.executeUpdate("INSERT INTO Airport (id) VALUES ('" + airportID + "');");
        }
        pstmt.executeUpdate();
        response.sendRedirect(request.getHeader("Referer"));
    } catch (Exception e) {
    	out.println(e.getMessage());
        response.sendRedirect(request.getHeader("Referer") + "?error=Error: " + e.getMessage());
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (con != null) con.close();
        } catch (SQLException e) { }
    }
%>