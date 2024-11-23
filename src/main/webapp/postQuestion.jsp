<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

	<% 
    if ((session.getAttribute("user") == null)) {
    %>
        You are not logged in<br/>
        <a href="login.jsp">Please Login</a>
    <%}
    
    else{
	try {

		ApplicationDB db = new ApplicationDB();	
	    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation_system", "root", "your_password");
	    Statement st = con.createStatement();		
		int clientIdNum;
		String clientUserName = (String)session.getAttribute("user");
    	ResultSet rs = st.executeQuery("SELECT id FROM users WHERE username = '" + clientUserName + "';");
    	rs.next();
    	clientIdNum = rs.getInt(1);
		String subject = request.getParameter("subject");
		String field = request.getParameter("field");
    	String insert = "INSERT INTO questions(subject, field, userid) VALUES('" + subject + "','" + field  + "','" + clientIdNum + "');";
		st.executeUpdate(insert);
		con.close();

		out.print("Comment successfully posted!");
		 %><a href='questions.jsp'>Return to Questions</a><%
		
	} catch (Exception ex) {
		out.print(ex);
		out.print("Insert failed :()");
	}
}%>
</body>
</html>