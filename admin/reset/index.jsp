<%@page import="java.util.Date"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>										
<%@page import="java.sql.Connection"%>
<%@ include file="/jspConfig.jsp" %>
<%
		try {
			String alert = "";
			String uid = request.getParameter("id");
			String user = request.getParameter("user");
			if(uid != null && user != null)
			{
				Class.forName("com.mysql.jdbc.Driver");
				Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
				PreparedStatement ps = conn.prepareStatement("select otp,otpTime,name,verified from admin where email = ?");
				ps.setString(1, request.getParameter("user"));
				ResultSet rs = ps.executeQuery();
				if(rs.next())
				{
					if(rs.getInt(4) == 1)
					{
						if(rs.getString(1).equals(uid))
						{
							Date cd = new Date();
							long currentTime = cd.getTime();
							long registeredTime = rs.getLong(2);
							long timediff = currentTime - registeredTime;
							timediff = timediff/1000L;
							timediff = timediff/3600L;
							if(timediff < 12L)//chnge it
							{
								session.setAttribute("key", uid);
								session.setAttribute("keyUser", user);
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
												    Enter Your New Password Below...
												  </div>
												  <div class="card-body text-center">
												    <form class="pass" action="resetPassword.jsp" method="post">
												    	<div class="form-group">
												    		<input type="password" class="form-control mx-auto" id="pass1" required="required" placeholder="Enter Your New Password">
												    		<small id="passwordHelpBlock" class="form-text text-muted" aria-describedby="passwordHelpBlock">
															  Your password must be at least 8 characters long<br>
															  Please make it as the combination of capital letters<br>
															  and special characters to make your password strong <br>
															  and your account secured.
															</small>
												    		
												    	</div>
												    	<div class="form-group">
												    		<input type="password" class="form-control mx-auto" id="pass2" required="required" name="pass" placeholder="Re-enter Your Password" disabled="disabled">
												    	</div>
												    	<button type="submit" class="btn btn-success">Reset Password...</button>
												    </form>
												    <div class="putAlertHere" style="height: 70px;">
												    </div>
												  </div>
												</div>
								    		</div>
								    	</div>
								   </div> 
								
								    <!-- jQuery first, then Tether, then Bootstrap JS. -->
								    <script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js" integrity="sha384-DztdAPBWPRXSA/3eYEEUWrWCy7G5KFbe8fFjk5JAIxUYHKkDx6Qin1DkWx51bBrb" crossorigin="anonymous"></script>
								    <script src="bootstrap/js/bootstrap.min.js"></script>
								    <script>
								    $(document).ready(function() {
								    	 $('#pass1').keyup( function() {
								    		 
								    		 if($('#pass1').val().length >= 8) {
								    			 $('#pass2').prop('disabled', false);
								    		 }
								    		 else {
								    			 
								    			 $('#pass2').prop('disabled', true);
								    		 }
								    	 });
										 $('.pass').submit(function( event ) {
											 
											 var pass = $('#pass1').val();
											 var confirmPass = $('#pass2').val();
											 
											 if(pass != confirmPass)
												 {
												 	event.preventDefault();
												 	$('.putAlertHere').html('<div class="alert alert-danger alert-dismissible fade show" role="alert"><button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>Pasword doesn\'t match.</div>');
															  
												 }
										 });
										  
										});
								    </script>
								  </body>
								</html>
								
								<%
							}
							else
							{
								alert = "The link you tried was expired. Try the process again";
								session.setAttribute("alert", alert);
								ps = conn.prepareStatement("update admin set otp = '-1',otpTime = -1 where email = ?");
								ps.setString(1, user);
								ps.executeUpdate();
								ps.close();
								conn.close();
								%>	
								<script>document.location = "/hostelFeedback/admin";</script>
								<%					
							}
									
						}
						else
						{
							alert="Something went wrong...";
							session.setAttribute("alert", alert);
							%>	
							<script type="text/javascript">document.location = "/hostelFeedback/admin";</script>
							<%
						}
					}
					else
					{
						alert="You are not yet verified. ";
						session.setAttribute("alert", alert);
						%>	
						<script type="text/javascript">document.location = "/hostelFeedback/admin";</script>
						<%
					}
				conn.close();
				}
				else
				{
				alert = "The account linked with this link is not found...";
				session.setAttribute("alert", alert);
				conn.close();
				%>
				<script type="text/javascript">document.location = "/hostelFeedback/admin";</script>
				<%
				
				}
			}
			else
			{
				%>
				<script type="text/javascript">document.location = "/hostelFeedback/admin";</script>
				<%
			}
		}
	catch(Exception e) {
		%>
		<jsp:forward page="/error/"></jsp:forward>
		<%
	}
	
%>