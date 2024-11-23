<%@ page import="java.sql.*" %>
<%
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation_system", "root", "your_password");

        String dataType = request.getParameter("type");
        String id = request.getParameter("id");

        if (dataType != null && id != null) {
            String deleteQuery = "";
            PreparedStatement pstmt = null;

            switch (dataType) {
                case "flight":
                	pstmt = con.prepareStatement("DELETE FROM Flight WHERE num = ?");
                    break;
                case "aircraft":
                	pstmt = con.prepareStatement("DELETE FROM Aircraft WHERE registration = ?");
                    break;
                case "airport":
                	pstmt = con.prepareStatement("DELETE FROM Airport WHERE id = ?");
                    break;
            }

            pstmt.setString(1, id);
            pstmt.executeUpdate();
            pstmt.close();
        }

        con.close();
        response.sendRedirect(request.getHeader("Referer"));
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect(request.getHeader("Referer") + "?error=Error: " + e.getMessage());
    }
%>