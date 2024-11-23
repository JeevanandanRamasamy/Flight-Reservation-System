<%@ page import="java.sql.*" %>
<%
if (session.getAttribute("cust_rep") == null) {
%>
    You are not logged in<br/>
    <a href="login.jsp">Please Login</a>
<%
} else {
    String flightID = request.getParameter("flightID");

    if (flightID != null && !flightID.trim().isEmpty()) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation_system", "root", "your_password");
            PreparedStatement pstmt = con.prepareStatement("SELECT u.id id, u.fname fname, u.lname lname FROM Users u " + 
            	"JOIN Waiting_list w ON w.cust_id = u.id WHERE w.flight_num = ?");
            pstmt.setInt(1, Integer.parseInt(flightID));
            ResultSet rs = pstmt.executeQuery();
%>
            <!DOCTYPE html>
            <html>
            <head>
                <title>Waiting List for Flight: <%= flightID %></title>
            </head>
            <body>
                <h2>Waiting List for Flight: <%= flightID %></h2>
                <table border="1">
                    <thead>
                        <tr>
                            <th>Customer ID</th>
                            <th>Customer Name</th>
                        </tr>
                    </thead>
                    <tbody>
<%
                    while (rs.next()) {
                        String fname = rs.getString("fname"), lname = rs.getString("lname");
%>
                        <tr>
                            <td><%= rs.getString("id") %></td>
                            <td><%= fname + " " + lname %></td>
                        </tr>
<%
                    }
                    rs.close();
                    pstmt.close();
                    con.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
%>
                    </tbody>
                </table>
            </body>
            </html>
<%
    }
}
%>