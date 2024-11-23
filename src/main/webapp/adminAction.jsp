<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*, java.util.*" %>
<%@ page import="com.cs336.pkg.*" %>

<%
    ApplicationDB db = new ApplicationDB();
    Connection connection = db.getConnection();

    String action = request.getParameter("action");
    String month = request.getParameter("month");
    String listType = request.getParameter("listType");
    String summaryType = request.getParameter("summaryType");
    
    if (month != null) {
    	Map<String, String> monthMap = new HashMap<String, String>();
    	monthMap.put("January", "01");
    	monthMap.put("February", "02");
    	monthMap.put("March", "03");
    	monthMap.put("April", "04");
    	monthMap.put("May", "05");
    	monthMap.put("June", "06");
    	monthMap.put("July", "07");
    	monthMap.put("August", "08");
    	monthMap.put("September", "09");
    	monthMap.put("October", "10");
    	monthMap.put("November", "11");
    	monthMap.put("December", "12");

    	if (monthMap.containsKey(month)) {
    	    String monthNumber = monthMap.get(month);
    	    out.print("<h2>Sales Report for " + month + "</h2>");
            		
            boolean hasResults = false;

            try {
                Statement stmt = connection.createStatement();
                
                String query = "SELECT YEAR(ct.time_purchased) AS year, MONTH(ct.time_purchased) AS month, " +
                        "SUM(t.fare) AS total_fare, SUM(t.booking_fee) AS total_booking_fee, " +
                        "SUM(t.fare + t.booking_fee) AS total_revenue " +
                        "FROM Cust_Ticket ct " +
                        "JOIN Ticket t ON ct.ticket_num = t.num " +
                        "WHERE MONTH(ct.time_purchased) = " + monthNumber + " " +
                        "GROUP BY YEAR(ct.time_purchased), MONTH(ct.time_purchased) " +
                        "ORDER BY year, month";
                
                ResultSet result = stmt.executeQuery(query);

                while (result.next()) {
                	hasResults = true;
                	int year = result.getInt("year");
                    int mmonth = result.getInt("month");
                    double totalFare = result.getDouble("total_fare");
                    double totalBookingFee = result.getDouble("total_booking_fee");
                    double totalRevenue = result.getDouble("total_revenue");

                    out.print("Year: " + year + ", Month: " + mmonth + "<br>");
                    out.print("Total Fare: " + totalFare + "<br>");
                    out.print("Total Booking Fee: " + totalBookingFee + "<br>");
                    out.print("Total Revenue: " + totalRevenue + "<br>");
                    out.print("<hr>");
                }
                
                if (!hasResults) {
                    out.print("None");
                }

            } catch (SQLException e) {
            	out.print("Error: " + e.getMessage());
                e.printStackTrace();
            }

        } else {
            out.print("Invalid month selected");
        }
    }
    
    if (listType != null) {
        if ("byFlightNumber".equals(listType)) {
        	out.print("<h2>List of Reservations by Flight Number</h2>");

        	try {
                Statement stmt = connection.createStatement();

                String query = "SELECT f.num AS flight_number, f.airline_id, " +
                        "GROUP_CONCAT(CASE WHEN ct.ticket_num IS NOT NULL THEN CONCAT(u.username, ' - ', ct.time_purchased) ELSE NULL END) AS reservations " +
                        "FROM Flight f " +
                        "LEFT JOIN Ticket_Flight tf ON f.num = tf.flight_num AND f.airline_id = tf.airline_id " +
                        "LEFT JOIN Cust_Ticket ct ON tf.ticket_num = ct.ticket_num " +
                        "LEFT JOIN Users u ON ct.cust_id = u.id " +
                        "GROUP BY f.num, f.airline_id";
                
                ResultSet result = stmt.executeQuery(query);

                while (result.next()) {
                    String flightNum = result.getString("flight_number");
                    String airlineId = result.getString("airline_id");
                    String reservations = result.getString("reservations");

                    out.print("Flight Number: " + flightNum + "<br>");
                    out.print("Airline ID: " + airlineId + "<br>");
                    out.print("Reservations: " + (reservations != null ? reservations : "None") + "<br>");
                    out.print("<hr>");
                }
            } catch (SQLException e) {
                out.print("Error");
            }
        	
        } else if ("byCustomerName".equals(listType)) {
        	out.print("<h2>List of Reservations by Customer Name</h2>");
        	
        	try {
                Statement stmt = connection.createStatement();

                String query = "SELECT u.id as cust_id, u.lname, u.fname, GROUP_CONCAT(ct.ticket_num) AS ticketNumbers " +
                       		   "FROM Users u " +
                               "LEFT JOIN Cust_Ticket ct ON u.id = ct.cust_id " +
                               "GROUP BY u.id, u.lname, u.fname " +
                               "ORDER BY u.lname, u.fname";
                ResultSet result = stmt.executeQuery(query);

                while (result.next()) {
                    int cust_id = result.getInt("cust_id");
                    String lname = result.getString("lname");
                    String fname = result.getString("fname");
                    String ticketNumbers = result.getString("ticketNumbers");

                    out.print("Customer ID: " + cust_id + "<br>");
                    out.print("Last Name: " + lname + "<br>");
                    out.print("First Name: " + fname + "<br>");
                    out.print("Ticket Numbers: " + (ticketNumbers != null ? ticketNumbers : "None") + "<br>");
                    out.print("<hr>");
                }
            } catch (SQLException e) {
                out.print("Error");
            }
        	
        }
    }
    
    if (summaryType != null) {
        if ("byFlight".equals(summaryType)) {
        	out.print("<h2>Summary Listing of Revenue by Flight</h2>");
        	
        	try {
                Statement stmt = connection.createStatement();

                String query = "SELECT f.num AS flight_number, f.airline_id, f.price AS price, COALESCE(COUNT(ct.ticket_num) * f.price, 0) AS totalRevenue " +
                               "FROM Flight f " +
                               "LEFT JOIN Ticket_Flight tf ON f.num = tf.flight_num AND f.airline_id = tf.airline_id " +
                               "LEFT JOIN Cust_Ticket ct ON tf.ticket_num = ct.ticket_num " +
                               "GROUP BY f.num, f.airline_id";
                
                ResultSet result = stmt.executeQuery(query);

                while (result.next()) {
                    String flightNum = result.getString("flight_number");
                    String airlineId = result.getString("airline_id");
                    double price = result.getDouble("price");
                    double totalRevenue = result.getDouble("totalRevenue");

                    out.print("Flight Number: " + flightNum + "<br>");
                    out.print("Airline ID: " + airlineId + "<br>");
                    out.print("Flight Price: " + price + "<br>");
                    out.print("Total Revenue: " + totalRevenue + "<br>");
                    out.print("<hr>");
                }
            } catch (SQLException e) {
                out.print("Error");
            }
        } else if ("byAirline".equals(summaryType)) {
        	out.print("<h2>Summary Listing of Revenue by Airline</h2>");
        	
        	try {
                Statement stmt = connection.createStatement();

                String query = "SELECT a.id AS airline_id, COALESCE(SUM(subquery.price_total), 0) AS totalRevenue " +
                        "FROM Airline a " +
                        "LEFT JOIN ( " +
                        "    SELECT a.id AS airline_id, COALESCE(SUM(f.price), 0) AS price_total " +
                        "    FROM Airline a " +
                        "    LEFT JOIN Flight f ON a.id = f.airline_id " +
                        "    LEFT JOIN Ticket_Flight tf ON f.num = tf.flight_num AND a.id = tf.airline_id " +
                        "    LEFT JOIN Cust_Ticket ct ON tf.ticket_num = ct.ticket_num " +
                        "    WHERE ct.cust_id IS NOT NULL" + 
                        "    GROUP BY a.id " +
                        ") AS subquery ON a.id = subquery.airline_id " +
                        "GROUP BY a.id";
                
                ResultSet result = stmt.executeQuery(query);

                while (result.next()) {
                    String airlineId = result.getString("airline_id");
                    double totalRevenue = result.getDouble("totalRevenue");

                    out.print("Airline ID: " + airlineId + "<br>");
                    out.print("Total Revenue: " + totalRevenue + "<br>");
                    out.print("<hr>");
                }
            } catch (SQLException e) {
            	String sqlState = e.getSQLState();
                String errorMessage = e.getMessage();

                out.println("SQL State: " + sqlState);
                out.println("Error Message: " + errorMessage);
                out.print("Error");
            }
        } else if ("byCustomer".equals(summaryType)) {
        	out.print("<h2>Summary Listing of Revenue by Customer</h2>");
        	
        	try {
                Statement stmt = connection.createStatement();

                String query = "SELECT u.id AS cust_id, u.lname, u.fname, COALESCE(SUM(t.fare + t.booking_fee), 0) AS totalRevenue " +
                               "FROM Users u " +
                               "LEFT JOIN Cust_Ticket ct ON u.id = ct.cust_id " +
                               "LEFT JOIN Ticket t ON ct.ticket_num = t.num " +
                               "GROUP BY u.id, u.lname, u.fname";
                
                ResultSet result = stmt.executeQuery(query);

                while (result.next()) {
                    int customerId = result.getInt("cust_id");
                    String lastName = result.getString("lname");
                    String firstName = result.getString("fname");
                    double totalRevenue = result.getDouble("totalRevenue");

                    out.print("Customer ID: " + customerId + "<br>");
                    out.print("Last Name: " + lastName + "<br>");
                    out.print("First Name: " + firstName + "<br>");
                    out.print("Total Revenue: " + totalRevenue + "<br>");
                    out.print("<hr>");
                }
            } catch (SQLException e) {
                out.print("Error");
            }
        }
    }
    
    if (action != null) {
        if ("addUser".equals(action)) {
        	out.print("<h2>Add User</h2>");
        	
        	try {
        	    Statement stmt = connection.createStatement();

        	    String username = request.getParameter("username");

        	    String checkUsernameQuery = "SELECT COUNT(*) FROM Users WHERE username=?";
        	    PreparedStatement psCheckUsername = connection.prepareStatement(checkUsernameQuery);
        	    psCheckUsername.setString(1, username);

        	    ResultSet resultSet = psCheckUsername.executeQuery();
        	    resultSet.next();
        	    int count = resultSet.getInt(1);

        	    if (count > 0) {
        	        out.print("Username already in use");
        	    } else {
        	        String password = request.getParameter("password");
        	        String fname = request.getParameter("fname");
        	        String lname = request.getParameter("lname");
        	        boolean isCustomerRep = "on".equals(request.getParameter("checkbox"));

        	        String query = "INSERT INTO Users(username, password, fname, lname, permission) VALUES (?, ?, ?, ?, ?)";
        	        
        	        PreparedStatement psUser = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);

        	        psUser.setString(1, username);
        	        psUser.setString(2, password);
        	        psUser.setString(3, fname);
        	        psUser.setString(4, lname);

        	        if (isCustomerRep) {
        	            psUser.setString(5, "cust_rep");
        	        } else {
        	            psUser.setString(5, "customer");
        	        }

        	        psUser.executeUpdate();

        	        ResultSet generatedKeys = psUser.getGeneratedKeys();

        	        if (generatedKeys.next()) {
        	            int userId = generatedKeys.getInt(1);

        	            out.print("User added");
        	        }
        	    }

        	    connection.close();
        	} catch (Exception ex) {
        	    out.print(ex);
        	    out.print("Error");
        	}
            
        } else if ("editUser".equals(action)) {
        	out.print("<h2>Edit User</h2>");
        	String selectedUser = request.getParameter("selectedUser");
        	
        	try {
                String getUserQuery = "SELECT * FROM Users WHERE id=?";
                PreparedStatement psGetUser = connection.prepareStatement(getUserQuery);
                psGetUser.setString(1, selectedUser);
                ResultSet userResultSet = psGetUser.executeQuery();

                if (userResultSet.next()) {
                    out.print("<form method=\"post\" action=\"adminAction.jsp\">");
                    out.print("<input type=\"hidden\" name=\"action\" value=\"updateUser\">");

                    out.print("<label for=\"username\">Username:</label>");
                    out.print("<input type=\"text\" name=\"username\" id=\"username\" value=\"" + userResultSet.getString("username") + "\" readonly><br>");

                    out.print("<label for=\"password\">Password:</label>");
                    out.print("<input type=\"text\" name=\"password\" id=\"password\" value=\"" + userResultSet.getString("password") + "\"><br>");

                    out.print("<label for=\"fname\">First Name:</label>");
                    out.print("<input type=\"text\" name=\"fname\" id=\"fname\" value=\"" + userResultSet.getString("fname") + "\"><br>");

                    out.print("<label for=\"lname\">Last Name:</label>");
                    out.print("<input type=\"text\" name=\"lname\" id=\"lname\" value=\"" + userResultSet.getString("lname") + "\"><br>");

                    boolean isCustRep = false;
                    int userId = userResultSet.getInt("id");
                    String permissionQuery = "SELECT permission FROM Users WHERE id=?";
                    PreparedStatement psPermission = null;
                    ResultSet permissionResultSet = null;

                    try {
                        psPermission = connection.prepareStatement(permissionQuery);
                        psPermission.setInt(1, userId);
                        permissionResultSet = psPermission.executeQuery();

                        if (permissionResultSet.next()) {
                            String permission = permissionResultSet.getString("permission");
                            isCustRep = "cust_rep".equals(permission);
                        }
                    } finally {
                        if (permissionResultSet != null) {
                            permissionResultSet.close();
                        }
                        if (psPermission != null) {
                            psPermission.close();
                        }
                    }

                    out.print("<label for=\"isCustRep\">Customer Representative:</label>");
                    out.print("<input type=\"checkbox\" name=\"isCustRep\" id=\"isCustRep\"" +
                            (isCustRep ? " checked" : "") + "><br>");

                    out.print("<input type=\"submit\" value=\"Update\">");
                    out.print("</form>");
                }

                userResultSet.close();
                psGetUser.close();

            } catch (Exception ex) {
                out.print(ex);
                out.print("Error");
            }
        	
        } else if ("updateUser".equals(action)) {
        	
        	PreparedStatement psGetUserId = null;
            ResultSet userIdResultSet = null;

            try {
                String updatedUsername = request.getParameter("username");
                String updatedPassword = request.getParameter("password");
                String updatedFname = request.getParameter("fname");
                String updatedLname = request.getParameter("lname");
                boolean isCustRep = "on".equals(request.getParameter("isCustRep"));

                String getUserIdQuery = "SELECT id, permission FROM Users WHERE username=?";
                psGetUserId = connection.prepareStatement(getUserIdQuery);
                psGetUserId.setString(1, updatedUsername);
                userIdResultSet = psGetUserId.executeQuery();

                if (userIdResultSet.next()) {
                    int userId = userIdResultSet.getInt("id");
                    String permission = userIdResultSet.getString("permission");

                    String updateUserQuery = "UPDATE Users SET username=?, password=?, fname=?, lname=? WHERE id=?";
                    PreparedStatement psUpdateUser = null;
                    try {
                        psUpdateUser = connection.prepareStatement(updateUserQuery);
                        psUpdateUser.setString(1, updatedUsername);
                        psUpdateUser.setString(2, updatedPassword);
                        psUpdateUser.setString(3, updatedFname);
                        psUpdateUser.setString(4, updatedLname);
                        psUpdateUser.setInt(5, userId);
                        psUpdateUser.executeUpdate();
                    } finally {
                        if (psUpdateUser != null) {
                            psUpdateUser.close();
                        }
                    }

                    if (!"admin".equals(permission)) {
                        if (isCustRep) {
                            String updateUserPermissionQuery = "UPDATE Users SET permission=? WHERE id=?";
                            PreparedStatement psUpdateUserPermission = null;
                            try {
                                psUpdateUserPermission = connection.prepareStatement(updateUserPermissionQuery);
                                psUpdateUserPermission.setString(1, "cust_rep");
                                psUpdateUserPermission.setInt(2, userId);
                                psUpdateUserPermission.executeUpdate();
                            } finally {
                                if (psUpdateUserPermission != null) {
                                    psUpdateUserPermission.close();
                                }
                            }
                        } else {
                            String updateUserPermissionQuery = "UPDATE Users SET permission=? WHERE id=?";
                            PreparedStatement psUpdateUserPermission = null;
                            try {
                                psUpdateUserPermission = connection.prepareStatement(updateUserPermissionQuery);
                                psUpdateUserPermission.setString(1, "customer");
                                psUpdateUserPermission.setInt(2, userId);
                                psUpdateUserPermission.executeUpdate();
                            } finally {
                                if (psUpdateUserPermission != null) {
                                    psUpdateUserPermission.close();
                                }
                            }
                        }
                    }

                    out.print("User updated successfully");
                } else {
                    out.print("User not found");
                }
            } catch (Exception ex) {
                out.print(ex);
                out.print("Error updating user");
            } finally {
                if (userIdResultSet != null) {
                    userIdResultSet.close();
                }
                if (psGetUserId != null) {
                    psGetUserId.close();
                }
            }
        	
        } else if ("deleteUser".equals(action)) {
        	out.print("<h2>Delete User</h2>");
            String selectedUser = request.getParameter("selectedUser");

            PreparedStatement psDeleteUser = null;

            try {
                int userId = Integer.parseInt(selectedUser);

                String deleteUserQuery = "DELETE FROM Users WHERE id=?";
                psDeleteUser = connection.prepareStatement(deleteUserQuery);
                psDeleteUser.setInt(1, userId);
                int rowsAffected = psDeleteUser.executeUpdate();

                if (rowsAffected > 0) {
                    out.print("User deleted successfully");
                } else {
                    out.print("User not found");
                }
            } catch (NumberFormatException ex) {
                out.print("Invalid user ID format");
            } catch (SQLException ex) {
                ex.printStackTrace();
                out.print("Error deleting user: " + ex.getMessage());
            } finally {
                try {
                    if (psDeleteUser != null) {
                        psDeleteUser.close();
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    out.print("Error closing resources: " + e.getMessage());
                }
            }
        	
        } else if ("mostTotalRevenue".equals(action)) {
        	out.print("<h2>Customer with the Most Total Revenue</h2>");
        	
        	try {
        	    Statement stmt = connection.createStatement();

        	    String query = "SELECT cust_id, SUM(fare + booking_fee) AS totalAmount " +
        	                   "FROM Cust_Ticket ct " +
        	                   "JOIN Ticket t ON ct.ticket_num = t.num " +
        	                   "JOIN Users u ON ct.cust_id = u.id " +
        	                   "GROUP BY cust_id " +
        	                   "ORDER BY totalAmount DESC " +
        	                   "LIMIT 1";
        	    
        	    ResultSet result = stmt.executeQuery(query);

        	    if (result.next()) {
        	        String mostRevenueCustomer = result.getString("cust_id");
        	        String totalFare = result.getString("totalAmount");

        	        String userQuery = "SELECT username, fname, lname FROM Users WHERE id = ?";
        	        PreparedStatement userStmt = connection.prepareStatement(userQuery);
        	        userStmt.setString(1, mostRevenueCustomer);
        	        ResultSet userResult = userStmt.executeQuery();

        	        if (userResult.next()) {
        	            String username = userResult.getString("username");
        	            String fname = userResult.getString("fname");
        	            String lname = userResult.getString("lname");

        	            out.print("Cust_ID: " + mostRevenueCustomer + "<br>");
        	            out.print("Username: " + username + "<br>");
        	            out.print("Last Name: " + lname + "<br>");
        	            out.print("First Name: " + fname + "<br>");
        	            out.print("Total Revenue: " + totalFare + "<br>");
        	        } else {
        	            out.print("No User");
        	        }
        	    } else {
        	        out.print("No Data");
        	    }
        	} catch (SQLException e) {
        	    out.print("Error");
        	}

        } else if ("mostActiveFlights".equals(action)) {
        	out.print("<h2>Most Active Flights</h2>");
        	
            try {
                Statement stmt = connection.createStatement();

                String query = "SELECT F.num AS flight_number, F.airline_id, COUNT(CT.ticket_num) AS sold " +
                               "FROM Flight F " +
                               "JOIN Ticket_Flight TF ON F.num = TF.flight_num AND F.airline_id = TF.airline_id " +
                               "JOIN Cust_Ticket CT ON TF.ticket_num = CT.ticket_num " +
                               "GROUP BY F.num, F.airline_id " +
                               "ORDER BY sold DESC";

                ResultSet result = stmt.executeQuery(query);

                out.print("<table>");
                out.print("<tr>");
                out.print("<th>F_id</th>");
                out.print("<th>A_id</th>");
                out.print("<th>Count</th>");
                out.print("</tr>");

                while (result.next()) {
                    int flightNum = result.getInt("flight_number");
                    String airlineId = result.getString("airline_id");
                    int sold = result.getInt("sold");

                    out.print("<tr>");
                    out.print("<td>" + flightNum + "</td>");
                    out.print("<td>" + airlineId + "</td>");
                    out.print("<td>" + sold + "</td>");
                    out.print("</tr>");
                }

                out.print("</table>");

            } catch (SQLException e) {
                out.print("Error");
            }
        } else {
            out.print("Invalid action");
        }
    }
    
    if (connection != null) {
        connection.close();
    }
%>
