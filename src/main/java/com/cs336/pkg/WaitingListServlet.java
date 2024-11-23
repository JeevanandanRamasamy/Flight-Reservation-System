package com.cs336.pkg;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/WaitingListServlet")
public class WaitingListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String flightId = request.getParameter("flightNum");
        List<String> waitingList = null;
		try {
			waitingList = retrieveWaitingListFromDatabase(flightId);
		} catch (SQLException e) {
			e.printStackTrace();
		}
        
        request.setAttribute("waitingList", waitingList);
        request.getRequestDispatcher("waitingList.jsp").forward(request, response);
    }
    
    private List<String> retrieveWaitingListFromDatabase(String flightNum) throws SQLException {
    	ApplicationDB dao = new ApplicationDB();
		Connection connection = dao.getConnection();
        Statement st = connection.createStatement();
        ResultSet rs = st.executeQuery("SELECT * FROM Waiting_list WHERE flight_num = '" + flightNum + "';");
        List<String> waitingList = new ArrayList<String>();
        while (rs.next()) {
        	waitingList.add(rs.getString("cust_id"));
        }
        return waitingList;
    }
}