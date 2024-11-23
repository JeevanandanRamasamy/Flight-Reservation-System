<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<style>
table, th, td {
  border: 1px solid black;
  border-radius: 1px;
  width=100%;
  
}

button {
	  text-align: center;
	  width=100%;
}
</style>


<% 
if ((session.getAttribute("user") == null)) {
%>
    You are not logged in<br/>
    <a href="login.jsp">Please Login</a>
<%} 
else {
    %>
    <a href='logout.jsp'>Log out</a>
    <a href='reservation.jsp'>View available reservations</a>
    <a href='account.jsp'>View your account</a>
    <a href='questions.jsp'>View message boards</a>
<%
}
ApplicationDB db = new ApplicationDB();	
Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation_system", "root", "your_password");
Statement st = con.createStatement();
Statement stmt2 = con.createStatement();
int clientIdNum;
String clientUserName = (String)session.getAttribute("username");
String searchQuery = request.getParameter("searchValue");
ResultSet rs = st.executeQuery("SELECT * FROM questions WHERE SUBJECT LIKE '%" + searchQuery + "%' OR FIELD LIKE" + " '%" + searchQuery + "%';");

out.print("<table>");
//make a row
out.print("<tr>");
//make a column
out.print("<td>");
//print out column header
out.print("<b>User</b>");
out.print("</td>");
//make a column
out.print("<td>");
out.print("<b>Title</b>");
out.print("</td>");
//make a column
out.print("<td>");
out.print("<b>Subject</b>");
out.print("</td>");
out.print("<td>");
out.print("<b>View Replies</b>");
out.print("</td>");
if(session.getAttribute("cust_rep")!=null){
	out.print("<td>");
	out.print("<b>Reply</b>");
	out.print("</td>");	
}
out.print("</tr>");

while(rs.next()) {
				int userId = rs.getInt("userid");
                String subject = rs.getString("subject");
                String field = rs.getString("field");
                ResultSet rsName = stmt2.executeQuery("SELECT username FROM Users WHERE id=" + userId + ";");
                rsName.next();
                String currName = rsName.getString("username");
                String userSubject = rs.getString("subject");
                String userField = rs.getString("field");
                out.print("<tr>");
				out.print("<td>");
				out.print(currName);
				out.print("</td>");
				out.print("<td>");
				out.print(userSubject);
				out.print("</td>");
				out.print("<td>");
				out.print(userField);
				out.print("</td>");
				out.print("<td>");
				out.print("<button type=" + "button" + "action=" + "viewReplies.jsp" + "value=" + "View Replies/>");
				out.print("</td>");

            }
			out.print("</table>");
			%><a href='questions.jsp'>Return to Questions</a><%

			//close the connection.
			con.close();
%>