<%
if (session.getAttribute("cust_rep") == null) {
%>
    You are not logged in<br/>
    <a href="login.jsp">Please Login</a>
<%
} else {
%>
    Welcome <%=session.getAttribute("cust_rep")%>
    <a href='logout.jsp'>Log out</a>
    <a href='reservation.jsp'>Make/edit reservations for customer</a>
    <a href='questions.jsp'>Reply to customer questions</a>
    <a href='addEditDeleteData.jsp'>Add, Edit, Delete information for aircrafts, airports and flights</a>
    <form action='waitingList.jsp' method='get' onsubmit='return validateWaitingListForm()'>
        <input type='text' name='flightID' id='flightID' placeholder='Enter Flight ID'>
        <input type='submit' value='Show waiting list'>
    </form>
    <form action='airportFlights.jsp' method='get' onsubmit='return validateAirportFlightsForm()'>
        <input type='text' name='selectedAirport' id='selectedAirport' placeholder='Enter Airport Code'>
        <input type='submit' value='View Airport Flights'>
    </form>
    <script>
        function validateWaitingListForm() {
            var flightId = document.getElementById('flightId').value.trim();
            if (flightId === '') {
                alert('Please enter a Flight ID');
                return false;
            }
            return true;
        }

        function validateAirportFlightsForm() {
            var selectedAirport = document.getElementById('selectedAirport').value.trim();
            if (selectedAirport === '') {
                alert('Please enter an Airport Code');
                return false;
            }
            return true;
        }
    </script>
<%
}
%>