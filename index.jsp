<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ include file="jspConfig.jsp" %>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
	
		try {
			
			if(session.getAttribute("user") == null)
			{	
				Class.forName("com.mysql.jdbc.Driver");
				Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
				PreparedStatement ps1;
				ResultSet rs;
				%>
					<!DOCTYPE html>
					<html lang="en">
					  <head>
					    <!-- Required meta tags -->
					    <meta charset="utf-8">
					    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
						<title>Student - Login</title>
						<script src="jQuery/jquery-3.2.1.min.js"></script>
					    <!-- Bootstrap CSS -->
					    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
					    
					    
					    <style type="text/css">
					    	html, body {
					    		margin:0;
					    		padding: 0;
					    		background-color: #ffffff;
					    	}
					    	h2,h3 {
					    		color: #4c4a4a;
					    	}
					    	body {
					    		
					    	}
					    	.container {
					    		top: 160px;
					    	}
					   
					    	.main h2 {
					    		margin: 40px 20px 20px 5px;;
					    		font-weight: bold;
					    		line-height: 30px;
					    	}
					    	.main p{
					    		font-weight: 100;
					    		margin: 10px 20px 10px 7px;
					    		font-size: 16px;
					    		opacity: 0.6;
					    	}
					    	.main input {
					    		margin: 5px;
					    		height: 33px;
					    	
					    	}
					    	button {
					    		height: 33px;
					    		
					    	}
					    	.signup .btn-primary {
					    		background-color: #1d94e4;
					    	}
					    	.main {
					    		top: 70px;
					    		background-color: #ffffff;
					    		
					    	}
					    	.main .form-inline input {
					    		margin : 5px 1px;
					    	}
					    	
					    	.main .form-inline .form-che {
					    		margin : 5px 20px;
					    	}
					    	
					    	.main form button {
					    		margin: 5px 10px;	
					    	}
					    	.slo{
					    		top: 30px;
					    	}
					    	.login .input-group-addon {
					    		margin-left: 0px;
					    	}
					    	.forgotButton {
					    		position: relative;
							    margin-left: 5px;
							    margin-top: 3.4px;
					    	}
					    	.alertDiv {
					    		margin: 0 auto;
					    		text-align: center;
					    	}
					    	.alertContainer {
					    		height: 70px;
					    	}
					    	.modal-header {
					    		background-color: #4c4a4a;
					    	}
					    	.modal-header h5 {
					    		color: #ffffff;
					    	} 
					    	.slo img{
					    		width:250px;
					    		margin-bottom: 20px;
					    	}
					    	
					    	.navbar-brand {
					    		font-weight: bold;
					    		font-family: 'Open Sans Condensed', sans-serif;
					    	}
					    	.unselected {
					    		border-color: red;
					    	}
					    	.cap {
					    		position: absolute;
							    top: 70px;
							    right: 100px;
					    	}
					    	@media only screen and (max-width: 768px) {
					    		.cap {
					    			position: relative;
					    			top: 0px;
					    			right: 0px;
					    		}
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
					    
					    <nav class="navbar fixed-top navbar-toggleable-md navbar-light" style="background-color: #4E4B4B;">
							  <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
							    <span>Login Here</span>
							  </button>
							  <a class="navbar-brand" href="#" style="color: white;">Hostel Feedback System</a>
							
							  <div class="collapse navbar-collapse" id="navbarSupportedContent">
							  	<ul class="navbar-nav mr-auto">
							     
							    </ul>
							    <form class="form-inline my-2 my-lg-0 login" action="login.jsp" method="post">
							      <div class="input-group">
							      	<input style="margin-right: 1px;" class="form-control mr-sm-2" name="roll" required="required" type="text" placeholder="email" aria-describedby="basic-addon2" min="8" maxlength="14" value="${fn.escapeXml(param.roll) }">
							      	<span class="input-group-addon" id="basic-addon2">@cit.ac.in</span>
							      </div>
							      <input class="form-control mr-sm-2" name="pass" required="required" type="password" min="8" placeholder="password" value="${fn.escapeXml(param.pass) }">
							      <div class="g-recaptcha cap" data-sitekey="<%= recaptchaDataSiteKey%>"></div>
							      <button class="btn btn-success my-2 my-sm-0" type="submit">Log In</button>
							    </form>
							    <script src="https://www.google.com/recaptcha/api.js?onload=onloadCallback&render=explicit"
        							async defer>
    							</script>
							    <button class="btn btn-danger forgotButton" data-toggle="modal" data-target="#forgotPass">Forgot Password</button>
							  </div>
						</nav>
					 
					 	<div class="container-fluid main">
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
					 		<div class="row">
					 			<div class="col-sm-6 text-center slo">
					 			<img alt="CIT" src="image/front.jpg" class="">
					 			<h3>Central Institute of Technology,Kokrajhar</h3>
					 			</div>
					 			<div class="col-sm-6">
					 				<h2>Create an account...</h2>
					 				<p>Don't Stress... Do your Best... Forget the rest...</p>
					 				<form  class="create" action="signup.jsp" method="post">
					 					<div class="form-inline">
					 						<input class="form-control" type="text" name="fname" required="required" maxlength="30" placeholder="First Name" value="${fn.escapeXml(param.fname) }">
					 						<input class="form-control" type="text" name="lname" required="required" maxlength="30" placeholder="Surname" value="${fn.escapeXml(param.lname) }">
					 					</div>
					 					<div class="form-inline">
											<select class="form-control" required="required" name="module" style="height: 33px;width: 204px;">
												<option>Select Module</option>
												<option>B.Tech.</option>
												<option>B.Des</option>
												<option>Diploma</option>
											</select>
											<select class="form-control" required="required" name="branch" style="height: 33px;width: 204px;">
												<option>Select branch</option>
												<option>Civil Engg.</option>
												<option>Computer Science and engg.</option>
												<option>Electronics and communication engg.</option>
												<option>Food engineering and technology</option>
												<option>Information Technology</option>
												<option>Instrumentation Engg.</option>
												<option>Multimedia Communication and design</option>
											</select>
											<div id="btech">
												
											</div>
					 					</div>
					 					<div class="form-inline">
					 						<input class="form-control" type="text" name="rollno" required="required" maxlength="14" placeholder="Roll No" aria-describedby="basic-addon2" value="${fn.escapeXml(param.rollno) }">
											<input class="form-control" type="password" min="8" name="pass" required="required" placeholder="Password" value="${fn.escapeXml(param.pass) }">
					 					</div>
					 					<div class="form-inline">
					 						<select class="form-control" required="required" name="hostel" style="height: 33px;width: 204px;">
					 						<option>Select Hostel</option>
					 					<%
					 						ps1 = conn.prepareStatement("select name from hostel");
					 						rs = ps1.executeQuery();
					 						while(rs.next())
					 						{
					 							%>
					 							<option><%= rs.getString(1) %></option>
					 							<%
					 						}
					 					%>
											</select>
					 						<input class="form-control" type="number" maxlength="3" name="roomNo" required="required" placeholder="Room No." value="${fn.escapeXml(param.roomNo) }">
					 					</div>
					 					<div class="form-inline">
					 						<div class="input-group">
					 						<input style="width: 310px" class="form-control" type="text" name="roll" min="8" maxlength="14" required="required" placeholder="email" value="${fn.escapeXml(param.roll) }">
					 						<span class="input-group-addon" id="basic-addon2" style="height:33px;margin-top: 5px;">@cit.ac.in</span>
					 						</div>
					 					</div>
					 					<button type="submit" class="btn btn-success">Create account</button>
					 				</form>
					 			</div>
					 		</div>
					 		<br>
					 		<br>
					 		<br>
					 		<br>
					 		<br>
					 		<br>
					 		<br>
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
							        	<input class="form-control" type="text" name="user" min="8" maxlength="10" required="required" placeholder="email" value="${fn.escapeXml(param.roll) }">
							 			<span class="input-group-addon" id="basic-addon2">@cit.ac.in</span>
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
					    <script src="bootstrap/js/bootstrap.min.js"></script>
					    <script src="bootstrap/js/tether.min.js"></script>
					  </body>
					  
					  <script type="text/javascript">
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
					  $(".create").submit(function(event) {
						  var submit = true;
						  var room = $("input[name=roomNo]").val();
						  var roomFound = false;
						  if($("select[name=module] option:selected").val() == "Select Module") {
							  submit = false;
							  alert("Please select your module");
							  $("select[name=module]").addClass("unselected");
						  }
						  else if($("select[name=branch] option:selected").val() == "Select branch") {
							  submit = false;
							  alert("Please select your branch/department");
							  $("select[name=branch]").addClass("unselected");
						  }
						  else if($("select[name=hostel] option:selected").val() == "Select Hostel") {
							  submit = false;
							  alert("Please select your hostel");
							  $("select[name=hostel]").addClass("unselected");
						  }
						  if(room>100 && room<134)
							  roomFound = true;
						  if(room>200 && room<234)
							  roomFound = true;
						  if(room>300 && room<334)
							  roomFound = true;
						  if(room>400 && room<434)
							  roomFound = true;
						  if(roomFound == false) {
							  alert("Please enter valid room no.");
							  $("input[name=roomNo]").addClass("unselected");
						  }
						  if(submit == false || roomFound == false)
							  event.preventDefault();
					  });
					  $("select[name=module]").click(function(){
						  if($("select[name=module] option:selected").val() != "Select Module")
							  $("select[name=module]").removeClass("unselected");
					  });
					  $("select[name=hostel]").click(function(){
						  if($("select[name=hostel] option:selected").val() != "Select Hostel")
							  $("select[name=hostel]").removeClass("unselected");
					  });
					  $("select[name=branch]").click(function(){
						  if($("select[name=branch] option:selected").val() != "Select branch")
							  $("select[name=branch]").removeClass("unselected");
					  });
					  </script>
					</html>
			
				<%
				rs.close();
				ps1.close();
				conn.close();
			}
			else
			{
				String session_name = (String)session.getAttribute("user");
				Class.forName("com.mysql.jdbc.Driver");
				Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
				PreparedStatement ps = conn.prepareStatement("select * from student where email = ?");
				ps.setString(1, session_name);
				ResultSet rs = ps.executeQuery();
				if(rs.next())
				{%>
					<jsp:forward page="welcome.jsp"></jsp:forward>
				<%
				conn.close();
				}
			}
		}
	catch(Exception e) {

		%>
		<%=e.toString() %>
		<%
	}
	
	
%>