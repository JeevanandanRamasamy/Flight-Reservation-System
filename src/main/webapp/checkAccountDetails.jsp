<%@ page import="java.sql.*"%>
<%
String action = request.getParameter("action");
String username = request.getParameter("username");
String pwd = request.getParameter("password");
session.setAttribute("username", username);

Class.forName("com.mysql.jdbc.Driver");
Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation_system", "root", "your_password");
Statement st = con.createStatement();
ResultSet rs, rsIdNum;
try{
	int idNum = -1;
	if ("login".equals(action)) {
		//Check if user exists
		rsIdNum = st.executeQuery("SELECT id FROM Users WHERE username = '" + username + "' AND password = '" + pwd + "';");
		if (rsIdNum.next()) {
			session.setAttribute("user", username);
			idNum = rsIdNum.getInt(1);
		}
		else{
			out.println("Incorrect Login, <a href='login.jsp'>try again</a>");
			return;
		}
		//Check Admin
		rs = st.executeQuery("SELECT * FROM Users WHERE id=" + idNum + " AND permission = 'admin';");
		if (rs.next()) {
			session.setAttribute("admin", username);
			session.setAttribute("idNum", idNum);
			response.sendRedirect("admin.jsp");
		} else {
		//Check cs rep
			rs = st.executeQuery("SELECT * FROM Users WHERE id=" + idNum + " AND permission = 'cust_rep';");
			if (rs.next()) {
				session.setAttribute("cust_rep", username);
				session.setAttribute("idNum", idNum);
				response.sendRedirect("cust_rep.jsp");
		//User is normal
			} else {
				//session.setAttribute("user", userid);
				session.setAttribute("idNum", idNum);
				response.sendRedirect("user_main.jsp");
			}
			
		}
	} else if ("register".equals(action)) {
		String fname = request.getParameter("fname");
		String lname = request.getParameter("lname");
		rs = st.executeQuery("SELECT * FROM users WHERE username='" + username + "'");
		if (rs.next()) {
			out.println("User already exists, <a href='login.jsp'>try again</a>");
		} else {
			PreparedStatement pstmt = con.prepareStatement(
					"INSERT INTO Users (username, password, fname, lname, permission) VALUES (?, ?, ?, ?, ?)");
			pstmt.setString(1, username);
			pstmt.setString(2, pwd);
			pstmt.setString(3, fname);
			pstmt.setString(4, lname);
			pstmt.setString(5, "customer");
			pstmt.executeUpdate();
			out.println("Registration successful! <a href='login.jsp'>Log in</a>");
		}
	}
} catch (Exception ex) {
	out.print(ex);
	out.print("Insert failed :()");
}
%>