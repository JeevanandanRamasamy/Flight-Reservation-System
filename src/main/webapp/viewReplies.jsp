<%@ page import="java.sql.*" %>

	<% 
	String username = (String)session.getAttribute("user");
    if ((session.getAttribute("user") == null)) {
    %>
        You are not logged in<br/>
        <a href="login.jsp">Please Login</a>
    <%}
   
    
    else{%>
<!DOCTYPE html>
<html>
<head>
    <title>Replies</title>
        <a href='logout.jsp?username=${username}'>Log out</a>
        <a href='reservation.jsp?username=${username}'>View available reservations</a>
        <a href='account.jsp?username=${username}'>View your account</a>
        <a href='questions.jsp?username=${username}'>View message boards</a>
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
hide{
  display:none;
}
show{
  display:block;
}
</style>



</head>


<body>
<% 
	String qUsername = request.getParameter("qUsername");
	String qSubject = request.getParameter("qSubject");
	String qField = request.getParameter("qField");
	//display question and replies
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
	out.print("</tr>");
	out.print("<tr>");

	//make a column
	out.print("<td>");
	//Print out current bar name:
	//out.print(rs.getString("user"));
	out.print(qUsername);
	out.print("</td>");
	out.print("<td>");
	//Print out current beer name:
	out.print(qSubject);
	out.print("</td>");
	out.print("<td>");
	//Print out current price
	out.print(qField);
	out.print("</td>");	
	Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation_system", "root", "your_password");
            Statement stmt = con.createStatement();
            Statement stmt2 = con.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM Replies WHERE id =" + Integer.parseInt(request.getParameter("questionId")));
            //load all questions from database
           	while(rs.next()) {
                int csrepid = rs.getInt("csrepid");
                ResultSet rsCurrName = stmt2.executeQuery("SELECT username FROM Users WHERE id=" + csrepid + ";");
                rsCurrName.next();
                String currName = rsCurrName.getString("username");
                String userField = rs.getString("field");
				//make a row
				out.print("<table>");
				out.print("<tr>");
				//make a column
				out.print("<td>");
				out.print(currName);
				out.print("</td>");
				out.print("<td>");
				out.print(userField);
				out.print("</td>");
				out.print("</table>");	
				
            }
			//close the connection.
			%><a href='questions.jsp'>Return to Questions</a><%
			con.close();
    }
    %>

</body>
</html>
