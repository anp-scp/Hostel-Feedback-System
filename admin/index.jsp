<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/jspConfig.jsp" %>
<%
	
		try {
			if("admin".equals((String)session.getAttribute("type")))
			{
			%>
			<jsp:forward page="welcome.jsp"></jsp:forward>
			<%	
			}
			else
			{
			if("student".equals((String)session.getAttribute("type")))
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
				    	.loginForm {
				    		width: 300px;
				    		margin: 0 auto;
				    		text-align: center;
				    	}
				    	.loginForm h4 {
				    		color: #3b5998;
				    		margin-bottom: 50px;
				    		font-weight: bold;
				    		line-height: 30px;
				    	}
				    	.loginForm p{
				    		font-weight: 100;
				    		margin-top: 40px;
				    		font-size: 16px;
				    		opacity: 0.6;
				    	}
				    	.loginForm input {
				    		width: 300px;
				    		height: 33px;
				    	
				    	}
				    	button {
				    		height: 33px;
				    		
				    	}
				    	.btn-primary {
				    		background-color: #1d94e4;
				    	}
				    	.alertDiv {
					    		margin: 0 auto;
					    		text-align: center;
					    }
					    .alertContainer {
					    	height: 70px;
					    }
					    .cap {
					    	margin: 5px;
					    	position: relative;
					    	left: -6px;
					    }
					    .modal-header {
					    		background-color: #4c4a4a;
					    	}
					    .modal-header h5 {
					    	color: #ffffff;
					    } 
				    	.form-control::-webkit-input-placeholder { opacity: 0.5; }  /* WebKit, Blink, Edge */
						.form-control:-moz-placeholder { opacity: 0.5; }  /* Mozilla Firefox 4 to 18 */
						.form-control::-moz-placeholder { opacity: 0.5; }  /* Mozilla Firefox 19+ */
						.form-control:-ms-input-placeholder { opacity: 0.5; }  /* Internet Explorer 10-11 */
						.form-control::-ms-input-placeholder { opacity: 0.5; }  /* Microsoft Edge */
				    </style>
				    <script src='https://www.google.com/recaptcha/api.js'></script>
				  </head>
				  <body>
				    
				    
				   <div class="container">
				   <div class="row alertContainer">
					 			<div class="col-sm-6 alertDiv">
					 				<%
							    	if(session.getAttribute("alert") != null)
							    	{
							    	String alert = (String)session.getAttribute("alert");
							    	%>
							    	<div class="alert alert-warning alert-dismissible fade show" role="alert">
									  <button type="button" class="close" data-dismiss="alert" aria-label="Close">
									    <span aria-hidden="true">&times;</span>
									  </button>
									  <%=alert%>
									</div>
									<% 
							    	session.removeAttribute("alert");
							    	}
							    	%>
					 			</div>
					 		</div>
				    	<div class="loginForm">
				    		<h4>Administrator Login</h4>
				    		<form action="login.jsp" method="post">
				    			<div class="form-group">
				    				<input type="email" name="uname" class="form-control" required="required" placeholder="Username" value="${fn.escapeXml(param.uname) }">
				    			</div>
				           		<div class="form-group">
				           			<input type="password" name="pass" class="form-control" required="required" placeholder="Password" value="${fn.escapeXml(param.password) }">
				           		</div>
				           		<div class="g-recaptcha cap" data-sitekey="<%=recaptchaDataSiteKey %>"></div>
				           		<button type="submit" class="btn btn-success">Log In</button>
				    		</form>
				    		<a href="#" data-toggle="modal" data-target="#forgotPass">Forgot Password...</a>
				    		<p>Hostel Feedback System</p>
				    	</div>
				   </div> 
				   
				   <!-- Modal -->
						<div class="modal fade" id="forgotPass" tabindex="-1" role="dialog" aria-labelledby="forgotPassLabel" aria-hidden="true">
						  <div class="modal-dialog" role="document">
						    <div class="modal-content">
						      <div class="modal-header">
						        <h5 class="modal-title mx-auto" id="exampleModalLabel">Reset Your Password</h5>
						        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
						          <span aria-hidden="true">&times;</span>
						        </button>
						      </div>
						      <div class="modal-body text-center">
						        <p class="">Enter your email address and we will send you a link to reset your password. </p>
						        <form class="forgot">
						        	<div class="form-group mx-auto">
						        	<div class="input-group">
							        	<input class="form-control" type="text" name="user" min="8" maxlength="80" required="required" placeholder="email" value="${fn.escapeXml(param.roll) }">
							 			
						        	</div>
						        	<br>
						 			<button type="submit" class="btn btn-success">Send password reset email</button>
						        	</div>
						        </form>
						        <div class="forgotAlert" style="height: 50px;">
						        
						        </div>
						      </div>
						      <div class="modal-footer">
						        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
						      </div>
						    </div>
						  </div>
						</div>
				
				    <!-- jQuery first, then Tether, then Bootstrap JS. -->
				    <script src="jQuery/jquery-3.2.1.min.js"></script>
				    <script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js" integrity="sha384-DztdAPBWPRXSA/3eYEEUWrWCy7G5KFbe8fFjk5JAIxUYHKkDx6Qin1DkWx51bBrb" crossorigin="anonymous"></script>
				    <script src="bootstrap/js/bootstrap.min.js"></script>
				  </body>
				  <script>
				    $( ".forgot" ).submit(function( event ) {
						  event.preventDefault();
						    $.ajax('forgotPass.jsp', {
						    	  type: "POST",
							      data: {user: $("form.forgot input").val()
							      },
							      success: function(response) {
							        $('.forgotAlert').html(response);
							      },
							      error: function() {
							        $('.forgotAlert').html('<li>There was a problem fetching the data. Please try again.</li>');
							      },
							      timeout: 15000,
							      beforeSend: function() {
							        $('.forgotAlert').html('Loading...');
							      },
							      complete: function() {
							        
							      }
							    });
						});
				    </script>
				</html>
			<%
			}
		}
	catch(Exception e) {
		%>
		<jsp:forward page="/error/"></jsp:forward>
		<%
	}
 	
%>