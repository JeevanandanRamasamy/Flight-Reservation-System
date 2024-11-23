<%@ page import="java.sql.*" import="java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Reservation Page</title>
</head>
<body>
	<%
	if (session.getAttribute("cust_rep") == null) {
	%>
	<h2>Flight Search</h2>
	<form method="POST" action="queryFlights.jsp">
		<input type="text" name="departure" placeholder="Departure Airport">&nbsp;
		<input type="text" name="destination" placeholder="Destination Airport"> <br> 
		<label for="action">What type of Trip?</label> 
		<select name="trip" required>
			<option value="oneway">One-Way</option>
			<option value="roundtrip">Round-Trip</option>
		</select> <br> <label for="date">Departure Date:</label> 
		<input type="date" name="departure date" placeholder="Departure Date"><br>
		<label for="date">Return Date (ignore if one-way):</label> 
		<input type="date" name="return date" placeholder="Return Date"> <br>
		<label for="action">Flexible Dates? (+/- 3 days)</label> 
		<select name="flexibility" id="action">
			<option value="isflexible">Yes</option>
			<option value="notflexible">No</option>
		</select> <br> <br> <label for="action">Sort Criteria?</label> 
		<select name="sort" required>
			<option value="dont sort">Don't Sort</option>
			<option value="sort price">Price</option>
			<!-- <option value="sort stops">Number of Stops</option>  -->
			<option value="sort airline">Airline</option>
			<option value="sort takeoff">Take-off Time</option>
			<option value="sort duration">Duration of Flight</option>
		</select> <br> <br> 
			<label for="action">Filter Flights? (Leave blank if not)</label><br> 
			<input type="number" id="price" name="filter price" placeholder="Filter by Price" min="0" max="1000" step="0.01"> <br>
			<input type="number" id="stops" name="filter stops" placeholder="Filter by Stops" min="0" max="5" step="1" size="100"> <br> 
			<input type="text" name="filter airline" maxlength="2" placeholder="Filter by Airline"> <br> 
			<label for="action">Filter Takeoff Time: </label>
			<input type="time" id="filter takeoff id" name="filter takeoff" step="1" pattern="([01]?[0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]"><br>
			<label for="action">Filter Landing Time: </label>
			<input type="time" id="filter landing id" name="filter landing" step="1" pattern="([01]?[0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]"><br>
		<br> <input type="submit" name="action" value="Submit">
	</form>

	<%
	}
	String searchDeparture = request.getParameter("departure");
	String searchDestination = request.getParameter("destination");
	try {
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation_system", "root", "your_password");
	Statement ticketStmt = con.createStatement();
	Statement userStmt = con.createStatement();
	Statement flightStmt = con.createStatement();
	ResultSet tickets = ticketStmt.executeQuery("SELECT * FROM Ticket");
	ResultSet users = userStmt.executeQuery("SELECT username FROM Users WHERE permission = 'Customer';");
	ArrayList<String> userList = new ArrayList<String>();
	while (users.next()) {
		userList.add(users.getString("username"));
	}
	%>
	<h2>Reserve Flights</h2>
	<%
	if (session.getAttribute("cust_rep") != null) {
	%>
	<label for="username">Select Customer:</label>
	<select id="customer1" name="username">
		<%
		for (String user : userList) {
			String username = user;
		%>
		<option value="<%=username%>"><%=username%></option>
		<%
		}
		%>
	</select>
	<%
	}
	%>
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
				<th>Reserve</th>
			</tr>
		</thead>
		<tbody>
			<%
			while (tickets.next()) {
				int ticketNum = Integer.parseInt(tickets.getString("num"));
				int ticketPrice = Integer.parseInt(tickets.getString("fare")) + Integer.parseInt(tickets.getString("booking_fee"));
				ResultSet rs = flightStmt.executeQuery("SELECT * FROM Flight f JOIN Ticket_Flight tf ON tf.flight_num = f.num "
				+ "AND tf.airline_id = f.airline_id JOIN Ticket t ON t.num = tf.ticket_num WHERE t.num = " + ticketNum);
				ArrayList<String> flightNum = new ArrayList<String>();
				ArrayList<String> flightType = new ArrayList<String>();
				ArrayList<String> aircraftId = new ArrayList<String>();
				ArrayList<String> airline = new ArrayList<String>();
				ArrayList<String> depAirport = new ArrayList<String>();
				ArrayList<String> depDate = new ArrayList<String>();
				ArrayList<String> depTime = new ArrayList<String>();
				ArrayList<String> arrAirport = new ArrayList<String>();
				ArrayList<String> arrDate = new ArrayList<String>();
				ArrayList<String> arrTime = new ArrayList<String>();
				while (rs.next()) {
					flightNum.add(rs.getString("num"));
					flightType.add(rs.getString("flight_type"));
					aircraftId.add(rs.getString("registration"));
					airline.add(rs.getString("airline_id"));
					depAirport.add(rs.getString("dep_airport_id"));
					depDate.add(rs.getString("dep_date"));
					depTime.add(rs.getString("dep_time"));
					arrAirport.add(rs.getString("arr_airport_id"));
					arrDate.add(rs.getString("arr_date"));
					arrTime.add(rs.getString("arr_time"));
				}
			%>

			<tr>
				<td><%=ticketNum%></td>
				<td>
					<%
					for (String fNum : flightNum) {
					%> <%=fNum%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String fType : flightType) {
					%> <%=fType%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String aId : aircraftId) {
					%> <%=aId%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String a : airline) {
					%> <%=a%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String dAir : depAirport) {
					%> <%=dAir%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String dDate : depDate) {
					%> <%=dDate%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String dTime : depTime) {
					%> <%=dTime%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String aAir : arrAirport) {
					%> <%=aAir%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String aDate : arrDate) {
					%> <%=aDate%><br> <%
 }
 %>
				</td>
				<td>
					<%
					for (String aTime : arrTime) {
					%> <%=aTime%><br> <%
 }
 %>
				</td>
				<td><%=ticketPrice%></td>
				<td><select id="class" name="class">
						<option value="Economy">Economy</option>
						<option value="Business">Business</option>
						<option value="First Class">First Class</option>
				</select></td>
				<td><button onclick="reserve(this.parentNode.parentNode)">Reserve</button></td>
			</tr>
			<%
			}
			%>
		</tbody>
	</table>
	<%
	if (session.getAttribute("cust_rep") != null) {
	%>
	<h2>Edit Reservations</h2>
	
	<form method="POST" action="reservation.jsp">
		<label for="username">Select Customer:</label>
		<select id="customer2" name="username">
			<%
			for (String user : userList) {
				String username = user;
			%>
			<option value="<%=username%>"><%=username%></option>
			<%
			}
			%>
		</select>
		<input type="submit" value="Submit">
	</form>
	<% 
	
	String user_name = request.getParameter("username");
	ResultSet user = null;
	if (user_name != null) {
		PreparedStatement userStmt2 = con.prepareStatement("SELECT id FROM Users WHERE username = ?");
		userStmt2.setString(1, user_name);
		user = userStmt2.executeQuery();
	}
	
	if (user != null && user.next()) {
		out.println("Showing reservations for " + user_name);
		Statement ticketStmt2 = con.createStatement();
		Statement flightStmt2 = con.createStatement();
		ResultSet tickets2 = ticketStmt.executeQuery("SELECT * FROM Ticket t JOIN Cust_Ticket ct ON ct.ticket_num = t.num" 
			+ " WHERE ct.cust_id = " + user.getInt("id"));
	%>
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
				<th>Edit</th>
			</tr>
		</thead>
		<tbody>
			<%
			while (tickets2.next()) {
				int ticketNum2 = Integer.parseInt(tickets2.getString("num"));
				int ticketPrice2 = Integer.parseInt(tickets2.getString("fare")) + Integer.parseInt(tickets2.getString("booking_fee"));
				String ticketClass2 = tickets2.getString("class");
				ResultSet rs2 = flightStmt2.executeQuery("SELECT * FROM Flight f JOIN Ticket_Flight tf ON tf.flight_num = f.num "
				+ "AND tf.airline_id = f.airline_id JOIN Ticket t ON t.num = tf.ticket_num WHERE t.num = " + ticketNum2);
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
				<td><button onclick="edit(this.parentNode.parentNode, '<%= user_name %>')">Edit</button></td>
			</tr>
	<%
		}
	%>
		</tbody>
	</table>
	<%
	}
	}
	con.close();
	%>
	<script>
		function reserve(row) {
			var form = document.createElement('form');
			form.method = 'post';
			form.action = 'reserveTicket.jsp';

			var dataUserInput = document.createElement('input');
			dataUserInput.type = 'hidden';
			dataUserInput.name = 'username';
			<%if (session.getAttribute("cust_rep") != null) {%>
    			dataUserInput.value = document.getElementById("customer1").value;
			<%} else {%>
    			dataUserInput.value = '<%=session.getAttribute("user")%>';
			<%}%>
			
			var dataNumInput = document.createElement('input');
			dataNumInput.type = 'hidden';
			dataNumInput.name = 'ticketNum';
			dataNumInput.value = row.cells[0].innerText;

			var dataClassInput = document.createElement('input');
			dataClassInput.type = 'hidden';
			dataClassInput.name = 'class';
			dataClassInput.value = row.cells[12].querySelector('select').value;

			form.appendChild(dataUserInput);
			form.appendChild(dataNumInput);
			form.appendChild(dataClassInput);
			document.body.appendChild(form);
			form.submit();
		}
		function edit(row, username) {
			var form = document.createElement('form');
			form.method = 'post';
			form.action = 'editTicket.jsp';
			
			var dataUserInput = document.createElement('input');
			dataUserInput.type = 'hidden';
			dataUserInput.name = 'username';
			dataUserInput.value = username;
			
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
	} catch (Exception e) {
			out.println("Exception: " + e.getMessage());
}
%>
</body>
</html>