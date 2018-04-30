<%@page import="java.sql.ResultSet"%>
<%@page import="java.security.cert.CertPathValidatorException.Reason"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
	
		try {
			if(session.getAttribute("status") == null)
			{
			%>
			<script>document.location = "/hostelFeedback/";</script>
			<% 
			}
			else
			{	
			 session.removeAttribute("status");
			 session.invalidate();
			%>
				<!DOCTYPE html>
				<html lang="en">
				  <head>
				    <!-- Required meta tags -->
				    <meta charset="utf-8">
				    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
					<title>Administrator - Login</title>
					<script src="jQuery/jquery-3.2.1.min.js"></script>
				    <!-- Bootstrap CSS -->
				    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
				    
				    <style type="text/css">
				    	body {
				    		background-color: #f5f8fa;
				    	}
				    	.container {
				    		top: 160px;
				    	}
				    	.message {
				    		margin: 0 auto;
				    		text-align: center;
				    	}
				    	.message p{
				    		font-weight: 100;
				    		font-size: 16px;
				    		opacity: 0.6;
				    	}
				    	.message input {
				    		width: 300px;
				    		height: 33px;
				    	
				    	}
				    	.card-body {
				    		padding: 5px;
				    	}
				    	button {
				    		height: 33px;
				    		
				    	}
				    	.btn-primary {
				    		background-color: #1d94e4;
				    	}
				    	.form-control::-webkit-input-placeholder { opacity: 0.5; }  /* WebKit, Blink, Edge */
						.form-control:-moz-placeholder { opacity: 0.5; }  /* Mozilla Firefox 4 to 18 */
						.form-control::-moz-placeholder { opacity: 0.5; }  /* Mozilla Firefox 19+ */
						.form-control:-ms-input-placeholder { opacity: 0.5; }  /* Internet Explorer 10-11 */
						.form-control::-ms-input-placeholder { opacity: 0.5; }  /* Microsoft Edge */
				    </style>
				    
				  </head>
				  <body>
				    
				    
				   <div class="container">
				    	<div class="row">
				    		<div class="message col-sm-4">
				    			<div class="card text-center">
								  <div class="card-header">
								    Great!!! Just one more step to go...
								  </div>
								  <div class="card-body">
								    <p class="card-text">Please check your email and click the verification link so that we can verify you. If you don't find your mail in inbox then check it in your spam/junk folder...</p>
								  </div>
								</div>
				    		</div>
				    	</div>
				   </div> 
				
				    <!-- jQuery first, then Tether, then Bootstrap JS. -->
				    <script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js" integrity="sha384-DztdAPBWPRXSA/3eYEEUWrWCy7G5KFbe8fFjk5JAIxUYHKkDx6Qin1DkWx51bBrb" crossorigin="anonymous"></script>
				    <script src="bootstrap/js/bootstrap.min.js"></script>
				  </body>
				</html>
			<%}
		}
	catch(Exception e){
		%>
		<jsp:forward page="/error/"></jsp:forward>
		<%
	}
	
%>