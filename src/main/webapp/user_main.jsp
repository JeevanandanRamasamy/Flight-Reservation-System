<%
    if ((session.getAttribute("user") == null)) {
    %>
        You are not logged in<br/>
        <a href="login.jsp">Please Login</a>
    <%} 
    else {
        %>
        Welcome <%=session.getAttribute("user")%>
        <a href='logout.jsp'>Log out</a>
        <a href='reservation.jsp'>View available reservations</a>
        <a href='account.jsp'>View your account</a>
        <a href='questions.jsp'>View message boards</a>
    <%
	}
%>