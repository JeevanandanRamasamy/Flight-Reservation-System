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
    <title>Question/Answer</title>
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
    <h3>Have a question? Let one of our skilled Customer Service representatives help!</h3>
    <form method="POST" action="postQuestion.jsp">
        <input type="text" name="subject" placeholder="Subject"/> <br/>
        <input type="text" name="field" placeholder="Enter your question here"/> <br/>
        <input type="submit" name="action" value="Submit"/>
    </form>    
    	<h3>Current Questions</h3>
    
<% 
	//display questions on page load in a table
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
	Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation_system", "root", "your_password");
            Statement stmt = con.createStatement();
            Statement stmt2 = con.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM Questions");
        	//load all questions from database

           	while(rs.next()) {
                //int questionId = rs.getInt("id");
                int userId = rs.getInt("userid");
                ResultSet rsCurrName = stmt2.executeQuery("SELECT username FROM Users WHERE id=" + userId + ";");
                rsCurrName.next();
                int questionId = rs.getInt("id");
                String currName = rsCurrName.getString("username");
                String userSubject = rs.getString("subject");
                String userField = rs.getString("field");
				//make a row
				out.print("<tr>");
				//make a column
				out.print("<td>");
				out.print(currName);
				out.print("</td>");
				out.print("<td>");
				out.print(userSubject);
				out.print("</td>");
				out.print("<td>");
				out.print(userField);
				out.print("</td>");
 					%>		
					<td>
			            <form method="POST" action="viewReplies.jsp">
			                <input type="hidden" name="questionId" value="<%=questionId%>"/>
			               	<input type="hidden" name="qUsername" value="<%=currName%>"/>
			           		<input type="hidden" name="qSubject" value="<%=userSubject%>"/>	
			           		<input type="hidden" name="qField" value="<%=userField%>"/>			              		                
        					<input type="submit" name="action" value="View"/>
			            </form>
			        </td>			
				<% 
				if (session.getAttribute("cust_rep") != null) { %>
			        <td>
			            <form method="POST" action="replyQuestion.jsp">
			                <input type="hidden" name="questionId" value="<%=questionId%>"/>
			            	<input type="text" name="replyField" placeholder="Enter Reply"/>                	            	
        					<input type="submit" name="action" value="Submit"/>
			            </form>
			        </td>
				<%}
				out.print("</tr>");
            }
			out.print("</table>");

			//close the connection.
			con.close();
    %>
    <h3>Search Questions</h3>
    <form method="GET" action="searchedQuestions.jsp">
          <input type="text"  name = "searchValue" placeholder="Search Questions">
          <input type="submit" value="Submit"/>
    </form>

</body>
</html>

<%}%>
