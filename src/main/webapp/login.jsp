<!DOCTYPE html>
<html>
<head>
    <title>Login/Register Form</title>
</head>
<body>
    <form method="POST" action="checkAccountDetails.jsp">
        <input type="text" name="username" placeholder="Username"/> <br/>
        <input type="password" name="password" placeholder="Password"/> <br/>
        <input type="submit" name="action" value="login"/> <!-- Submit as Login -->
    </form>
    <form method="POST" action="checkAccountDetails.jsp">
    	<input type="text" name="fname" placeholder="First Name"/> <br/>
    	<input type="text" name="lname" placeholder="Last Name"/> <br/>
        <input type="text" name="username" placeholder="Username"/> <br/>
        <input type="password" name="password" placeholder="Password"/> <br/>
        <input type="submit" name="action" value="register"/> <!-- Submit as Register -->
    </form>
</body>
</html>