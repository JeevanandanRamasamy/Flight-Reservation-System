<%@ page import="java.sql.*" %>
<%
if (session.getAttribute("cust_rep") == null) {
%>
    You are not logged in<br/>
    <a href="login.jsp">Please Login</a>
<%
} else {
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation_system", "root", "your_password");
%>
        <!DOCTYPE html>
        <html>
        <head>
            <title>Change Flight, Aircraft, and Airport Information</title>
        </head>
        <body>
            <h2>Change Flight, Aircraft, and Airport Information</h2>
            
            <h3>Flight Information</h3>
            <form action="addData.jsp" method="post">
    			<input type="number" name="flightNumber" placeholder="Flight Number" required>
    			<select name="flighttype" required>
        			<option value="Domestic">Domestic</option>
        			<option value="International">International</option>
    			</select>
    			<input type="text" name="registration" placeholder="Aircraft Registration ID" pattern="[A-Za-z0-9]{2,6}" title="Enter 2-6 alphanumeric characters" required>
    			<input type="text" name="airlineID" placeholder="Airline ID" pattern="[A-Z]{2}" title="Enter 2 capital letters" required>
    			<input type="text" name="depAirportID" placeholder="Departure Airport ID" pattern="[A-Z]{3}" title="Enter 3 capital letters" required>
    			<input type="date" name="depDate" placeholder="Departure Date" required>
    			<input type="time" name="depTime" placeholder="Departure Time" required>
    			<input type="text" name="arrAirportID" placeholder="Arrival Airport ID" pattern="[A-Z]{3}" title="Enter 3 capital letters" required>
    			<input type="date" name="arrDate" placeholder="Arrival Date" required>
    			<input type="time" name="arrTime" placeholder="Arrival Time" required>
    			<input type="number" name="price" placeholder="Price" required>
    			<input type="hidden" name="type" value="flight">
    			<input type="submit" value="Add Flight">
			</form>
			<br>
            <table border="1">
                <thead>
                    <tr>
                        <th>Flight Number</th>
                        <th>Type</th>
                        <th>Aircraft ID</th>
                        <th>Airline</th>
                        <th>Departure Airport</th>
                        <th>Departure Date</th>
                        <th>Departure Time</th>
                        <th>Arrival Airport</th>
                        <th>Arrival Date</th>
                        <th>Arrival Time</th>
                        <th>Price</th>
                        <th>Edit</th>
                        <th>Delete</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    Statement stmtFlights = con.createStatement();
                    ResultSet rsFlights = stmtFlights.executeQuery("SELECT * FROM Flight");
                    while (rsFlights.next()) {
                    %>
                        <tr>
                            <td><%= rsFlights.getString("num") %></td>
                            <td><%= rsFlights.getString("flight_type") %></td>
                            <td><%= rsFlights.getString("registration") %></td>
                            <td><%= rsFlights.getString("airline_id") %></td>
                            <td><%= rsFlights.getString("dep_airport_id") %></td>
                            <td><%= rsFlights.getString("dep_date") %></td>
                            <td><%= rsFlights.getString("dep_time") %></td>
                            <td><%= rsFlights.getString("arr_airport_id") %></td>
							<td><%= rsFlights.getString("arr_date") %></td>
                            <td><%= rsFlights.getString("arr_time") %></td>
                            <td><%= rsFlights.getString("price") %></td>
                			<td><button onclick="toggleEdit(this)">Edit</button>
                				<form style="display: none;" onsubmit="confirmEdit(this)">
                                    <input type="hidden" name="type" value="flight">
                                    <input type="submit" value="Confirm">
                                </form></td>
                			<td><button onclick="confirmDelete(this.parentNode.parentNode, 'flight')">Delete</button></td>
                        </tr>
                    <% }
                    rsFlights.close();
                    stmtFlights.close();
                    %>
                </tbody>
            </table>
            
            <h3>Aircraft Information</h3>
            <form action="addData.jsp" method="post">
    			<input type="text" name="registration" placeholder="Aircraft Registration ID" pattern="[A-Za-z0-9]{2,6}" title="Enter 2-6 alphanumeric characters" required>
    			<input type="number" name="seats" placeholder="Number of Seats" required>
    			<input type="text" name="airlineID" placeholder="Airline ID" pattern="[A-Z]{2}" title="Enter 2 capital letters" required>
    			<input type="hidden" name="type" value="aircraft">
    			<input type="submit" value="Add Aircraft">
			</form>
			<br>
            <table border="1">
                <thead>
                    <tr>
                        <th>Aircraft ID</th>
                        <th>Seats</th>
                        <th>Airline</th>
                        <th>Edit</th>
                        <th>Delete</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    Statement stmtAircrafts = con.createStatement();
                    ResultSet rsAircrafts = stmtAircrafts.executeQuery("SELECT * FROM Aircraft");
                    while (rsAircrafts.next()) {
                    %>
                        <tr>
                            <td><%= rsAircrafts.getString("registration") %></td>
                            <td><%= rsAircrafts.getString("seats") %></td>
                            <td><%= rsAircrafts.getString("airline_id") %></td>
							<td><button onclick="toggleEdit(this)">Edit</button>
                				<form style="display: none;" onsubmit="confirmEdit(this)">
                                    <input type="hidden" name="type" value="aircraft">
                                    <input type="submit" value="Confirm">
                                </form></td>
                			<td><button onclick="confirmDelete(this.parentNode.parentNode, 'aircraft')">Delete</button></td>
                        </tr>
                    <% }
                    rsAircrafts.close();
                    stmtAircrafts.close();
                    %>
                </tbody>
            </table>
          	
            <h3>Airport Information</h3>
          	<form action="addData.jsp" method="post">
    			<input type="text" name="airportID" placeholder="Airport ID" pattern="[A-Z]{3}" title="Enter 3 capital letters" required>
    			<input type="hidden" name="type" value="airport">
    			<input type="submit" value="Add Airport">
			</form>
			<br>
            <table border="1">
                <thead>
                    <tr>
                        <th>Airport Code</th>
                        <th>Edit</th>
                        <th>Delete</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    Statement stmtAirports = con.createStatement();
                    ResultSet rsAirports = stmtAirports.executeQuery("SELECT * FROM Airport");
                    while (rsAirports.next()) {
                    %>
                        <tr>
                            <td><%= rsAirports.getString("id") %></td>
							<td><button onclick="toggleEdit(this)">Edit</button>
                				<form style="display: none;" onsubmit="confirmEdit(this)">
                                    <input type="hidden" name="type" value="airport">
                                    <input type="submit" value="Confirm">
                                </form></td>
                			<td><button onclick="confirmDelete(this.parentNode.parentNode, 'airport')">Delete</button></td>
                        </tr>
                    <% }
                    rsAirports.close();
                    stmtAirports.close();
                    con.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    %>
                </tbody>
            </table>
            <script>
            	var id1, id2;
            
	            function toggleEdit(button) {
	                var row = button.parentNode.parentNode;
	                var cells = row.cells;
	                
	                id1 = cells[0].innerText.trim();
	                if (cells.length > 5) {
	                    id2 = cells[3].innerText.trim();
	                }
	                
	                for (var i = 0; i < cells.length - 2; i++) {
	                    var currentValue = cells[i].innerText.trim();
	                    cells[i].innerHTML = '<input type="text" value="' + currentValue + '">';
	                }
	                
	                button.style.display = "none";
	                button.parentNode.querySelector("[onsubmit='confirmEdit(this)']").style.display = "block";
	            }
	
	            function confirmEdit(form) {
	            	var row = form.parentNode.parentNode;
	                var inputFields = row.querySelectorAll("input[type='text']");
	                var hiddenInputs = "";
	                var type = form.querySelector('input[name="type"]').value;
	                
	                for (var i = 0; i < inputFields.length; i++) {
	                	var updatedValue = inputFields[i].value;
	                    hiddenInputs += '<input type="hidden" name="updatedValue' + (i + 1) + '" value="' + updatedValue + '">';
	                }
	                
	                hiddenInputs += '<input type="hidden" name="type" value="' + type + '">';
	                hiddenInputs += '<input type="hidden" name="id1" value="' + id1 + '">';
	                hiddenInputs += '<input type="hidden" name="id2" value="' + id2 + '">';
	                form.innerHTML += hiddenInputs;
	                
	                form.action = "editData.jsp";
	                document.body.appendChild(form);
	                form.submit();
	            }
	            
				function confirmDelete(row, dataType) {
    				var confirmDelete = confirm("Are you sure you want to delete this record?");
    				if (confirmDelete) {
        				var form = document.createElement('form');
        		        form.method = 'post';
        		        form.action = 'deleteData.jsp';
        		        
        		        var dataIdInput = document.createElement('input');
        		        dataIdInput.type = 'hidden';
        		        dataIdInput.name = 'id';
        		        dataIdInput.value = row.cells[0].innerText;

        		        var dataTypeInput = document.createElement('input');
        		        dataTypeInput.type = 'hidden';
        		        dataTypeInput.name = 'type';
        		        dataTypeInput.value = dataType;

        		        form.appendChild(dataTypeInput);
        		        form.appendChild(dataIdInput);
        		        document.body.appendChild(form);
        		        form.submit();
    				}
				}
			</script>
        </body>
        </html>
<%
}
%>