<%@ page import="java.sql.*" import="java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<head>
<title>Account Information</title>
</head>
<body>
	<%
	if (session.getAttribute("user") == null) {
	%>
	You are not logged in
	<br>
	<a href="login.jsp">Please Login</a>
	<%
	} else {
	try {
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation_system", "root", "your_password");
		Statement ticketStmt1 = con.createStatement();
		Statement ticketStmt2 = con.createStatement();
		Statement prevFlights = con.createStatement();
		Statement futureFlights = con.createStatement();
		//	
		Statement waitingStmt = con.createStatement();
		Statement findTicketsStmt = con.createStatement();
		Statement countStmt = con.createStatement();
		Statement seatsStmt = con.createStatement();
		Statement flightStmt = con.createStatement();
		//
		ResultSet prevTickets = ticketStmt1.executeQuery(
		"SELECT DISTINCT t.num, fare, booking_fee, class FROM Flight f JOIN Ticket_Flight tf ON tf.flight_num = f.num"
				+ " AND tf.airline_id = f.airline_id JOIN Ticket t ON t.num = tf.ticket_num JOIN Cust_Ticket ct"
				+ " ON ct.ticket_num = t.num JOIN Users u ON ct.cust_id = u.id WHERE u.id = "
				+ session.getAttribute("idNum") + " AND CONCAT(f.arr_date, ' ', f.arr_time) < NOW();");
		ResultSet futureTickets = ticketStmt2.executeQuery(
		"SELECT DISTINCT t.num, fare, booking_fee, class FROM Flight f JOIN Ticket_Flight tf ON tf.flight_num = f.num"
				+ " AND tf.airline_id = f.airline_id JOIN Ticket t ON t.num = tf.ticket_num JOIN Cust_Ticket ct"
				+ " ON ct.ticket_num = t.num JOIN Users u ON ct.cust_id = u.id WHERE u.id = "
				+ session.getAttribute("idNum") + " AND CONCAT(f.dep_date, ' ', f.dep_time) > NOW();");
		
		// select every flight user is waiting for
		ResultSet waitingList = waitingStmt.executeQuery("SELECT * from Waiting_List WHERE cust_id =" + session.getAttribute("idNum") + ";");
		try{ 
			while(waitingList.next()){
				//find the ticket(s) that flight is under
				int flightNum = waitingList.getInt("flight_num");
				String airlineId = waitingList.getString("airline_id");
				ResultSet waitingTickets = findTicketsStmt.executeQuery("SELECT num FROM ticket t JOIN ticket_flight ft ON t.num=ft.ticket_num WHERE ft.flight_num = " + flightNum + " LIMIT 1;");
				waitingTickets.next();
				int ticketNum = waitingTickets.getInt("num");
				
				//find all flights under that ticket
				ResultSet flights = flightStmt.executeQuery(
						"SELECT * FROM Flight f JOIN Ticket_Flight tf ON tf.flight_num = f.num WHERE tf.ticket_num = " + ticketNum);
				
				//find how many seats are taken under each flight customer is waiting for
				while(flights.next()){
					ResultSet count = countStmt.executeQuery("SELECT COUNT(*) count FROM Cust_Ticket ct JOIN Ticket_Flight tf"
							+ " ON ct.ticket_num = tf.ticket_num WHERE tf.ticket_num = " + ticketNum + " AND tf.flight_num = "
							+ flightNum);
						
					ResultSet seats = seatsStmt.executeQuery(
					"SELECT a.seats seats FROM Aircraft a JOIN Flight f ON f.registration = a.registration WHERE f.num = "
							+ flights.getInt("num"));
					
						if (count.next() && seats.next() && (seats.getInt("seats") > count.getInt("count"))) {
							out.println("<b>Flight " + flights.getInt("num") + " has a vacancy!" + "<a href='reservation.jsp'> Reserve Now</a> </b>");
						}
						else{
							// can delete, for error checking
								//out.println("<p>test " + flightNum + " " + airlineId + " " + ticketNum + " " + seats.getInt("seats") + " " + count.getInt("count") + "</p>");
								
								
							}
					
				}
						
				}
		}
		catch(Exception e){
			e.printStackTrace();
			response.sendRedirect(request.getHeader("Referer") + "?error=Error: " + e.getMessage());
		
		}
		
	%>
	<h2>Account Information</h2>

	<h3>Past Flight Reservations</h3>
	<table border="1">
		<thead>
			<tr>
				<th>Ticket Number</th>
				<th>Flight Number</th>
				<th>Type</th>
				<th>Aircraft ID</th>
				<th>Airline</th>
				<th>Departure Airport</th>
				<th>Departure Date</th>
				<th>Departure Time</th>
				<th>Destination Airport</th>
				<th>Destination Date</th>
				<th>Destination Time</th>
				<th>Price</th>
				<th>Class</th>
			</tr>
		</thead>
		<tbody>
			<%
			while (prevTickets.next()) {
				int ticketNum1 = Integer.parseInt(prevTickets.getString("t.num"));
				int ticketPrice1 = Integer.parseInt(prevTickets.getString("fare"))
				+ Integer.parseInt(prevTickets.getString("booking_fee"));
				String ticketClass1 = prevTickets.getString("class");
				ResultSet rs1 = prevFlights.executeQuery("SELECT * FROM Flight f JOIN Ticket_Flight tf ON tf.flight_num = f.num "
				+ "AND tf.airline_id = f.airline_id JOIN Ticket t ON t.num = tf.ticket_num WHERE t.num = " + ticketNum1
				+ " AND CONCAT(f.arr_date, ' ', f.arr_time) < NOW();");

				ArrayList<String> flightNum1 = new ArrayList<String>();
				ArrayList<String> flightType1 = new ArrayList<String>();
				ArrayList<String> aircraftId1 = new ArrayList<String>();
				ArrayList<String> airline1 = new ArrayList<String>();
				ArrayList<String> depAirport1 = new ArrayList<String>();
				ArrayList<String> depDate1 = new ArrayList<String>();
				ArrayList<String> depTime1 = new ArrayList<String>();
				ArrayList<String> arrAirport1 = new ArrayList<String>();
				ArrayList<String> arrDate1 = new ArrayList<String>();
				ArrayList<String> arrTime1 = new ArrayList<String>();
				while (rs1.next()) {
					flightNum1.add(rs1.getString("num"));
					flightType1.add(rs1.getString("flight_type"));
					aircraftId1.add(rs1.getString("registration"));
					airline1.add(rs1.getString("airline_id"));
					depAirport1.add(rs1.getString("dep_airport_id"));
					depDate1.add(rs1.getString("dep_date"));
					depTime1.add(rs1.getString("dep_time"));
					arrAirport1.add(rs1.getString("arr_airport_id"));
					arrDate1.add(rs1.getString("arr_date"));
					arrTime1.add(rs1.getString("arr_time"));
				}
			%>
			<tr>
				<td><%=ticketNum1%></td>
				<td>
					<%
					for (String fNum : flightNum1) {
					%> <%=fNum%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String fType : flightType1) {
					%> <%=fType%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String aId : aircraftId1) {
					%> <%=aId%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String a : airline1) {
					%> <%=a%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String dAir : depAirport1) {
					%> <%=dAir%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String dDate : depDate1) {
					%> <%=dDate%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String dTime : depTime1) {
					%> <%=dTime%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String aAir : arrAirport1) {
					%> <%=aAir%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String aDate : arrDate1) {
					%> <%=aDate%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String aTime : arrTime1) {
					%> <%=aTime%><br> <%
 }
 %>
				</td>
				<td><%=ticketPrice1%></td>
				<td><%=ticketClass1%></td>
				
			</tr>
			<%
			}
			%>
		</tbody>
	</table>

	<h3>Upcoming Flight Reservations</h3>
	<table border="1">
		<thead>
			<tr>
				<th>Ticket Number</th>
				<th>Flight Number</th>
				<th>Type</th>
				<th>Aircraft ID</th>
				<th>Airline</th>
				<th>Departure Airport</th>
				<th>Departure Date</th>
				<th>Departure Time</th>
				<th>Destination Airport</th>
				<th>Destination Date</th>
				<th>Destination Time</th>
				<th>Price</th>
				<th>Class</th>
				<th>Cancel</th>
			</tr>
		</thead>
		<tbody>
			<%
			while (futureTickets.next()) {
				int ticketNum2 = Integer.parseInt(futureTickets.getString("t.num"));
				int ticketPrice2 = Integer.parseInt(futureTickets.getString("fare"))
				+ Integer.parseInt(futureTickets.getString("booking_fee"));
				String ticketClass2 = futureTickets.getString("class");
				ResultSet rs2 = futureFlights.executeQuery("SELECT * FROM Flight f JOIN Ticket_Flight tf ON tf.flight_num = f.num "
				+ "AND tf.airline_id = f.airline_id JOIN Ticket t ON t.num = tf.ticket_num WHERE t.num = " + ticketNum2
				+ " AND CONCAT(f.dep_date, ' ', f.dep_time) > NOW();");

				ArrayList<String> flightNum2 = new ArrayList<String>();
				ArrayList<String> flightType2 = new ArrayList<String>();
				ArrayList<String> aircraftId2 = new ArrayList<String>();
				ArrayList<String> airline2 = new ArrayList<String>();
				ArrayList<String> depAirport2 = new ArrayList<String>();
				ArrayList<String> depDate2 = new ArrayList<String>();
				ArrayList<String> depTime2 = new ArrayList<String>();
				ArrayList<String> arrAirport2 = new ArrayList<String>();
				ArrayList<String> arrDate2 = new ArrayList<String>();
				ArrayList<String> arrTime2 = new ArrayList<String>();
				while (rs2.next()) {
					flightNum2.add(rs2.getString("num"));
					flightType2.add(rs2.getString("flight_type"));
					aircraftId2.add(rs2.getString("registration"));
					airline2.add(rs2.getString("airline_id"));
					depAirport2.add(rs2.getString("dep_airport_id"));
					depDate2.add(rs2.getString("dep_date"));
					depTime2.add(rs2.getString("dep_time"));
					arrAirport2.add(rs2.getString("arr_airport_id"));
					arrDate2.add(rs2.getString("arr_date"));
					arrTime2.add(rs2.getString("arr_time"));
				}
			%>
			<tr>
				<td><%=ticketNum2%></td>
				<td>
					<%
					for (String fNum : flightNum2) {
					%> <%=fNum%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String fType : flightType2) {
					%> <%=fType%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String aId : aircraftId2) {
					%> <%=aId%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String a : airline2) {
					%> <%=a%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String dAir : depAirport2) {
					%> <%=dAir%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String dDate : depDate2) {
					%> <%=dDate%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String dTime : depTime2) {
					%> <%=dTime%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String aAir : arrAirport2) {
					%> <%=aAir%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String aDate : arrDate2) {
					%> <%=aDate%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String aTime : arrTime2) {
					%> <%=aTime%><br> <%
 }
 %>
				</td>
				<td><%=ticketPrice2%></td>
				<td><%=ticketClass2%></td>
				<td>
				<% if (ticketClass2.equals("Business") || ticketClass2.equals("First Class")) { %>
					<button onclick="cancel(this.parentNode.parentNode)">Cancel</button>
				<% } %>
				</td>
			</tr>
			<%
			}
			%>
		</tbody>
	</table>
	<script>
		function cancel(row) {
			var form = document.createElement('form');
			form.method = 'post';
			form.action = 'cancelTicket.jsp';

			var dataUserInput = document.createElement('input');
			dataUserInput.type = 'hidden';
			dataUserInput.name = 'username';
    		dataUserInput.value = '<%=session.getAttribute("user")%>';
			
			var dataNumInput = document.createElement('input');
			dataNumInput.type = 'hidden';
			dataNumInput.name = 'ticketNum';
			dataNumInput.value = row.cells[0].innerText;

			form.appendChild(dataUserInput);
			form.appendChild(dataNumInput);
			document.body.appendChild(form);
			form.submit();
		}
	</script>
	<%
	con.close();
	} catch (Exception e) {
	out.println("Exception: " + e.getMessage());
	}
	}
	%>
</body>
</html>