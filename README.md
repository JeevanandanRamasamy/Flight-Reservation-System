# Flight Reservation System

This project is a flight reservation system with different user roles including customers, customer representatives, and admins. It includes functionalities for searching flights, booking tickets, viewing flight details, and managing reservations. The system also allows customer representatives to assist customers, and admins to manage users and reports.

---

## Table of Contents
1. [Register/Log-in Page](#1---registerlog-in-page)
2. [Customer Page](#2---customer-page)
3. [Admin Page](#3---admin-page)
4. [Customer Representative Page](#4---customer-representative-page)
5. [Additional Info](#5---additional-information)

---

## 1 - Register/Log-in Page
The login page (`checkAccountDetails.jsp`) allows users to either log in or register.

- **Login**: Enter your username and password. Options: customer, customer representative (csrep), or admin.
- **Register**: Customers can create an account by providing details. 
    - If registration is successful, you can log in with your new credentials.
    - If "User already exists", try registering with a different username.

---

## 2 - Customer Page
Once logged in as a customer, you are redirected to a page where you can search for flights, view reservations, and manage your bookings.

### 2.1 Search for Flights
- **View available reservations**: Enter Departure and Destination Airports (leave empty for no specific airport) and Departure Date/Time.
- **One-way trip**: Choose "One-Way" and provide the trip date.
- **Round-trip**: Choose "Round-trip" and provide departure and return dates.
- **Flexible Dates**: You can select yes/no to search for flights within +/- 3 days of your selected dates.

### 2.2 Browse and Filter Flights
- **Browse flights**: After searching, you'll see a list of matching flights.
- **Sort**: Sort by price, airline, take-off time, or duration.
- **Filter**: Apply filters for price, number of stops, airline, etc.

### 2.3 View and Post Questions
- **View message boards**: Read existing questions under "Current Questions".
- **Post a question**: Submit your question for the customer representative to respond.

### 2.4 Flight Reservations
- **Make reservations**: Select your flight and ticket class (Economy, Business, First Class), then press "Reserve".
- **Waiting list**: If the flight is full, your reservation will be placed in the waiting list automatically.
- **Cancel reservations**: Cancel Business or First Class reservations from your account page.
- **View past and upcoming reservations**: See all your past and upcoming flight bookings.

---

## 3 - Admin Page
Login as an admin (username: admin, password: 1234) to manage users and view reports.

### 3.1 User Management
- **Add User**: Add new users and set them as customers or customer representatives.
- **Edit User**: Update user details.
- **Delete User**: Remove users from the system.

### 3.2 Sales and Reservation Reports
- **Sales report**: View sales reports by month.
- **List reservations**: View reservations by flight number or customer name.
- **Revenue Summary**: Generate revenue reports by flight, airline, or customer.

### 3.3 Active Flights and Revenue Reports
- **Most active flights**: Find flights with the highest number of reservations.
- **Customer with most revenue**: View the customer who has generated the most revenue.

---

## 4 - Customer Representative Page
Login as a customer representative (username: csrep, password: 1234) to assist customers with reservations.

### 4.1 Manage Reservations for Customers
- **Reserve flights**: Book flights for customers.
- **Edit reservations**: Modify ticket details like class or ticket number.

### 4.2 Flight and User Management
- **Add/Edit/Delete Flight, Aircraft, Airport Information**: Manage flight and travel data.
- **Waiting list management**: View and manage customers on the waiting list.

### 4.3 Customer Queries
- **Respond to customer questions**: Answer questions posted by customers on the message boards.

---

## 5 - Additional Information

### Server Used
- **Apache Tomcat v8.0**

### Troubleshooting
- If you encounter login errors, replace the "password" in the following JSP files with your MySQL password:
    - `account.jsp`, `addData.jsp`, `addEditDeleteData.jsp`, `airportFlights.jsp`, `cancelTicket.jsp`, `checkAccountDetails.jsp`, `deleteData.jsp`, `editData.jsp`, `editTicket.jsp`, `postQuestion.jsp`, `questions.jsp`, `queryFlights.jsp`, `replyQuestions.jsp`, `reservation.jsp`, `reserveTickets.jsp`, `searchedQuestions.jsp`, `waitingList.jsp`.

--- 

This flight reservation system simplifies the process of booking and managing flights while also allowing administrative control and customer support functionalities.
 
