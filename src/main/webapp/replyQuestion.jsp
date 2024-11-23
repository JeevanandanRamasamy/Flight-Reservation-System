
<%@ page import="java.sql.*" %>

<% 
// Retrieve the question ID from the form
int questionId = Integer.parseInt(request.getParameter("questionId"));
int csRepId = (int)session.getAttribute("idNum");
String replyField = request.getParameter("replyField");
Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation_system", "root", "your_password");

try {
    Class.forName("com.mysql.jdbc.Driver");
    Statement st = con.createStatement();
	Statement st2 = con.createStatement();
    ResultSet rs = st.executeQuery("SELECT * FROM replies WHERE id=" + questionId);
    if(rs.next()){
    	%>
        <br>Sorry, someone already replied!<br/>
        <a href='questions.jsp'>Return to Questions</a>
    <%
   }
    else{
		String insert = "INSERT INTO replies(id,field,csrepid) VALUES('" + questionId + "','" + replyField  + "','" + csRepId + "');";
		st2.executeUpdate(insert);
		response.sendRedirect("questions.jsp");

    }
} catch (Exception e) {
    e.printStackTrace(); 
}
con.close();

// Redirect back to the questions page
%>