<%@ page import="java.sql.*"%>
<%@ page import="com.cs336.pkg.*"%>
<%@ page import="java.time.temporal.ChronoUnit"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.util.ArrayList"%>

<%
Class.forName("com.mysql.jdbc.Driver");
Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/reservation_system", "root", "your_password");

String searchDeparture = request.getParameter("departure"); //departure airport
String searchDestination = request.getParameter("destination"); //destination airport

String tripType = request.getParameter("trip"); //trip type? oneway, roundtrip

String searchDepDate = request.getParameter("departure date"); //departure date
String searchRetDate = request.getParameter("return date"); //return date (if round trip)

String flexibleDate = request.getParameter("flexibility"); //flexible date? isflexible, notflexible

String sortCriteria = request.getParameter("sort"); //sort criteria? dont sort, sort price, sort landing, sort takeoff, sort duration

String filterPrice = request.getParameter("filter price"); //filter by price
float filterFloat; //conversion to float
int filterStops=0;
String filterAirline = request.getParameter("filter airline"); //filter by price
String filterTakeoff = request.getParameter("filter takeoff"); //filter by price
String filterLanding = request.getParameter("filter landing"); //filter by price
if(request.getParameter("filter stops")!=null){
    filterStops = Integer.parseInt(request.getParameter("filter stops"));
}

%>
<h2>Resulting Flights</h2>
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
			<th>Destination Airport</th>
			<th>Destination Date</th>
			<th>Destination Time</th>
			<th>Price</th>
		</tr>
	</thead>
	<tbody>
		<%
		int oneOrRound = 0; //0 meaning one way, 1 meaning round trip

		switch (tripType) {
		case "oneway":
			oneOrRound = 0;
			break;
		case "roundtrip":
			oneOrRound = 1;
			break;
		}

		int flexibleOrNot = 0; //0 meaning not flexible, 1 meaning flexible
		switch (flexibleDate) {
		case "isflexible":
			flexibleOrNot = 1;
			break;
		case "notflexible":
			flexibleOrNot = 0;
			break;
		}

		boolean isDepDateEmpty;
		if (searchDepDate.isEmpty()) {
			isDepDateEmpty = true;
		} else
			isDepDateEmpty = false;

		boolean isRetDateEmpty;
		if (searchRetDate.isEmpty()) {
			isRetDateEmpty = true;
		} else
			isRetDateEmpty = false;

		boolean isDepLocationEmpty;
		if (searchDeparture.isEmpty()) {
			isDepLocationEmpty = true;
		} else
			isDepLocationEmpty = false;

		boolean isArrLocationEmpty;
		if (searchDestination.isEmpty()) {
			isArrLocationEmpty = true;
		} else
			isArrLocationEmpty = false;

		if ((searchDeparture != null) && (searchDestination != null)) {
			try {
				Statement stmt = connection.createStatement();
				ResultSet rs;
				
				ArrayList<String> flightNums = new ArrayList<String>();
				if (filterStops > 0) {
					Statement ticketStmt = connection.createStatement();
					ResultSet tickets = ticketStmt.executeQuery("SELECT ticket_num FROM Ticket_Flight GROUP BY ticket_num HAVING COUNT(flight_num) - 1 = " + filterStops);
					while (tickets.next()) {
						Statement flightStmt = connection.createStatement();
						ResultSet flights = flightStmt.executeQuery("SELECT flight_num FROM Ticket_Flight WHERE ticket_num = " + tickets.getString("ticket_num"));
						while (flights.next() && !flightNums.contains(flights.getString("flight_num"))) {
							flightNums.add(flights.getString("flight_num"));
						}
					}
				}

				/////////////////////////////////////

				///////////     SORTS     ///////////

				/////////////////////////////////////	

				if (sortCriteria.substring(0).equals("sort price")) { //sort by price
			rs = stmt.executeQuery("select * from flight ORDER BY price");
				} else if (sortCriteria.substring(0).equals("sort takeoff")) { //sort by takeoff time
			rs = stmt.executeQuery("select * from flight ORDER BY dep_time");
				} else if (sortCriteria.substring(0).equals("sort airline")) { //sort by airline ID
			rs = stmt.executeQuery("select * from flight ORDER BY airline_id");
				} else if (sortCriteria.substring(0).equals("sort duration")) { //sort by duration of flight
			rs = stmt.executeQuery(
					"SELECT *,TIMESTAMPDIFF(MINUTE, CONCAT(dep_date, ' ', dep_time), CONCAT(arr_date, ' ', arr_time)) AS total_duration_minutes FROM flight ORDER BY total_duration_minutes;"); //in a perfect world this would work
				} else {
			rs = stmt.executeQuery("select * from flight"); //default - no sort
				}

				//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

				while (rs.next()) {
			String airportOne = rs.getString("dep_airport_id"); //departure airport
			String airportTwo = rs.getString("arr_airport_id"); //destination airport
			String depDate = rs.getString("dep_date"); //departure date - when the plane leaves

			/////////////////////////////////////

			///////////    FILTERS    ///////////

			/////////////////////////////////////

			//check if price filter is empty
            String flightPrice = rs.getString("price"); //check price from db, convert to float
            float getPrice = Float.parseFloat(flightPrice);

            if (!filterPrice.isEmpty()) {
                filterFloat = Float.parseFloat(filterPrice);
                if (getPrice <= filterFloat) { //if price isn't smaller or equal to filter, then skip
                } else
                    continue;
            }

            String airline = rs.getString("airline_id");

            if (!filterAirline.isEmpty()) { //check if airline filter isn't empty
                if (filterAirline.substring(0).equals(airline)) { //if isn't equal to filter, then skip
                } else
                    continue;
            }

            //String filterTakeoff = request.getParameter("filter takeoff"); //filter by price
            String depTime = rs.getString("dep_time");

            if (filterTakeoff != null) { //check if takeoff time filter is empty
                if (!filterTakeoff.isEmpty()) {
                    if (filterTakeoff.substring(0).equals(depTime)) { //if isn't equal to filter, then skip
                    } else
                        continue;
                }
            }

            //String filterLanding = request.getParameter("filter landing"); //filter by price
            String arrTime = rs.getString("arr_time");
            if (filterLanding != null) { //check if takeoff time filter is empty
                if (!filterLanding.isEmpty()) {
                    if (filterLanding.substring(0).equals(arrTime)) { //if isn't equal to filter, then skip
                    } else
                        continue;
                }
            }
            
            String flightNum = rs.getString("num");
            if (filterStops > 0) {
                if (flightNums.contains(flightNum)) {
                    
                } else continue;
            }

			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			/////////////////////////
			/// CHECKING LOCATION ///
			/////////////////////////

			if (isDepLocationEmpty) { //do nothing if departure airport is left empty
			} else {
				if (airportOne.substring(0).equals(searchDeparture)) { //checks if dep airport matches
				} else if (oneOrRound == 1) { //round trip
					if (airportTwo.substring(0).equals(searchDeparture)) { //checks if this flight fits in a round trip (flying back from destination)
					} else
						continue;
				} else
					continue;
			}

			if (isArrLocationEmpty) { //do nothing if destination airport is left empty
			} else {
				if (airportTwo.substring(0).equals(searchDestination)) { //checks if dest airport matches
				} else if (oneOrRound == 1) { //round trip
					if (airportOne.substring(0).equals(searchDestination)) { //checks if this flight fits in a round trip (flying back to departure airport)
					} else
						continue;
				} else
					continue;
			}

			/////////////////////////
			////  CHECKING DATE  ////
			/////////////////////////

			if (isDepDateEmpty && isRetDateEmpty) { //do nothing. don't continue
			} else if (isDepDateEmpty) { //check if return date matches
				if (flexibleOrNot == 1) { //flexible +/- 3 days, single trip
					if (oneOrRound == 1) { //if a round trip
						LocalDate convertedDepDate = LocalDate.parse(depDate); //converts db's departure date to localdate
						LocalDate convertedSearchDepDate = LocalDate.parse(searchRetDate); //checked searched return date
						long daysBtwn = ChronoUnit.DAYS.between(convertedDepDate, convertedSearchDepDate);
						if (daysBtwn < 0)
							daysBtwn = daysBtwn * -1; //if days are negative, make it positive

						if (daysBtwn <= 3) { //check if the day difference is <= 3. If not? Skip to next flight
						} else
							continue;
					}
				} else if (flexibleOrNot == 0) { //not flexible, will only check day of
				}
				if (oneOrRound == 1) { //round trip
					if (depDate.equals(searchRetDate)) { //checks if this flight works for a round trip
					} else
						continue;
				}
			} else { //neither are empty
				if (flexibleOrNot == 1) { //flexible +/- 3 days, single trip
					LocalDate convertedDepDate = LocalDate.parse(depDate); //converts db's departure date to localdate
					LocalDate convertedSearchDepDate = LocalDate.parse(searchDepDate); //converts searched departure date to localdate
					long daysBtwn = ChronoUnit.DAYS.between(convertedDepDate, convertedSearchDepDate);
					if (daysBtwn < 0)
						daysBtwn = daysBtwn * -1;

					if (daysBtwn <= 3) {
					} else if (oneOrRound == 1) { //if a round trip
						convertedSearchDepDate = LocalDate.parse(searchRetDate); //checked searched return date
						daysBtwn = ChronoUnit.DAYS.between(convertedDepDate, convertedSearchDepDate);
						if (daysBtwn < 0)
							daysBtwn = daysBtwn * -1; //if days are negative, make it positive

						if (daysBtwn <= 3) {
						} else
							continue;
					} else
						continue;

				} else if (flexibleOrNot == 0) { //not flexible, will only check day of
					if (depDate.equals(searchDepDate)) {
					} else if (oneOrRound == 1) { //round trip
						if (depDate.equals(searchRetDate)) { //checks if this flight works for a round trip
						} else
							continue;
					} else
						continue;
				}
			}

			PreparedStatement pstmt = null;

			String arrDate = rs.getString("arr_date");

			String flightType = rs.getString("flight_type");
			String aircraftId = rs.getString("registration");
		%>
		<tr>
			<td><%=flightNum%></td>
			<td><%=flightType%></td>
			<td><%=aircraftId%></td>
			<td><%=airline%></td>
			<td><%=airportOne%></td>
			<td><%=depDate%></td>
			<td><%=depTime%></td>
			<td><%=airportTwo%></td>
			<td><%=arrDate%></td>
			<td><%=arrTime%></td>
			<td><%=flightPrice%></td>
		</tr>
		<%
		}
		rs.close();
		stmt.close();
		connection.close();
		} catch (Exception e) {
			e.printStackTrace();
		out.println("Exception: " + e.getMessage());
		}
		} else {
		out.print("<p>Error. Wrong airport input!</p>");
		}

		if (connection != null) {
		connection.close();
		}
		%>
	</tbody>
</table>