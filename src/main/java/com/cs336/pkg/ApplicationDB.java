package com.cs336.pkg;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ApplicationDB {
	
	public ApplicationDB(){
		
	}

	public Connection getConnection(){
		
		//Create a connection string
		String connectionUrl = "jdbc:mysql://localhost:3306/reservation_system";
		Connection connection = null;
		
		try {
			//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
			Class.forName("com.mysql.jdbc.Driver").newInstance();
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			//Create a connection to your DB
			connection = DriverManager.getConnection(connectionUrl,"root", "Jeeva@123");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return connection;
	}
	
	public void closeConnection(Connection connection){
		try {
			connection.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	
	
	
	public static void main(String[] args) {
		ApplicationDB dao = new ApplicationDB();
		Connection connection = dao.getConnection();
		
		// // For this deliverable you should develop a web application for:
		// 1. logging in an already created account. The data required for the login (username/password) can be directly inserted into the database. 
		// 2. logging outsp

		// Steps:
		// a) create a login.jsp to grab username and password of user.
		// b) checkLoginDetails.jsp which will check the username and password are correct. If they are correct it will
		// store the username in session and redirect to success.jsp.
		// c) success.jsp will print the username of the user stored in the session.
		// d) logout.jsp will call session.invalidate() to kill the server session.
		// e) will try to access session object after invalidate which will throw an error.
		
		System.out.println(connection);		
		dao.closeConnection(connection);
	}
	
	

}
