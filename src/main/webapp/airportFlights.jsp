<%@ page import="java.sql.*" %>
<%
if (session.getAttribute("cust_rep") == null) {
%>
    You are not logged in<br/>
    <a href="login.jsp">Please Login</a>
<%
} else {
    String selectedAirport = request.getParameter("selectedAirport");

    if (selectedAirport != null && !selectedAirport.trim().isEmpty()) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation_system", "root", "your_password");
            PreparedStatement pstmt = con.prepareStatement("SELECT * FROM Flight WHERE dep_airport_id LIKE ? OR arr_airport_id LIKE ?");
            pstmt.setString(1, "%" + selectedAirport + "%");
            pstmt.setString(2, "%" + selectedAirport + "%");
            ResultSet rs = pstmt.executeQuery();
%>
            <!DOCTYPE html>
            <html>
            <head>
                <title>Flights for Airport: <%= selectedAirport %></title>
            </head>
            <body>
                <h2>Flights for Airport: <%= selectedAirport %></h2>
                <table border="1">
                    <thead>
                        <tr>
                            <th>Flight Number</th>
                            <th>Airline</th>
                            <th>Departure Airport</th>
                            <th>Departure Time</th>
                            <th>Arrival Airport</th>
                            <th>Arrival Time</th>
                        </tr>
                    </thead>
                    <tbody>
<%
                    while (rs.next()) {
                    	String dep_date = rs.getString("dep_date"), dep_time = rs.getString("dep_time");
                    	String arr_date = rs.getString("arr_date"), arr_time = rs.getString("arr_time");
%>
                        <tr>
                            <td><%= rs.getString("num") %></td>
                            <td><%= rs.getString("airline_id") %></td>
                            <td><%= rs.getString("dep_airport_id") %></td>
                            <td><%= dep_date + " " + dep_time %></td>
                            <td><%= rs.getString("arr_airport_id") %></td>
                            <td><%= arr_date + " " + arr_time %></td>
                        </tr>
<%
                    }
                    rs.close();
                    pstmt.close();
                    con.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
%>
                    </tbody>
                </table>
            </body>
            </html>
<%
}
%>