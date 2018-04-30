<%@page import="java.sql.ResultSet"%>
<%@page import="java.security.cert.CertPathValidatorException.Reason"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ include file="jspConfig.jsp" %>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
	try
	{
			if(session.getAttribute("user") == null)
			{
			%>
			<script>document.location = "/hostelFeedback/";</script>
			<% 
			}
			else
			{	
			String roll = (String)session.getAttribute("user");
			String subject = "";
			String referenceNo = "";
			String status = "";
			String color = "";
			String bgcolor = "";
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
			PreparedStatement ps;
			ResultSet rs;	
			%>
				<!DOCTYPE html>
				<html lang="en">
				  <head>
				  	<title>Student - Dash board</title>
				    <!-- Required meta tags -->
				    <meta charset="utf-8">
				    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
					<script src="jQuery/jquery-3.2.1.min.js"></script>
					<script>

					$(document).ready(function() {
						  var it = 3;
						  var el = $(".msgItem");
						  el.click(function() {
							var $div = $(this);  
						    $.ajax('viewMsg.jsp', {
						      data: {location: $div.attr('data-location'), 	
						      },
						      success: function(response) {
						        $('.modal-content').html(response);
						        $div.parent().css("background-color","");
						      },
						      error: function() {
						        $('.modal-content').html('<li>There was a problem fetching info. Please try again.</li>');
						      },
						      timeout: 1000,
						      beforeSend: function() {
						        $('.modal-content').html('Loading...');
						      },
						      complete: function() {
						        
						      }
						    });
						  });
						  $("#deleteSent").click(function() {
							  if($("#deleteSent input:checkbox:checked").length > 0) {
								  $(".del").removeAttr('disabled');
							  }
							  else {
								  $(".del").attr('disabled','disabled');
							  }
						  });
						  $(".del").click(function() {
							  $("#deleteSentButton").click();
						  });
						  $(".sideMenu a.sideMenuItem").click(function() {
							  var $anchor = $(this);
							  var selected = $anchor.attr("data-type");
						  	  
						  	  if(selected == "All")
						  		  {
						  		 	 $("table.sent tr").slideDown(100);
						  		  }
						  	  else 
						  		  {
						  			$("table.sent tr").slideUp(100,function(){
						  				var toHide = "table.sent tr:first,table.sent tr." + selected;
						  				$(toHide).slideDown(100);
						  			});
						  		  }
						  });
						 $("button.create").click(function() {
							 
							 $(".modal-content").html($("div.compose").html());
							 
						 });
						 $(document).on('click','.modal-content .addAttachments',function() {
							 it = 3;
							 $(".modal-content .addAttachments").slideUp(100,function() {
								 $(".modal-content .attachments").slideDown(100);
							 });
						 });
						 $(document).on('click','.modal-content .addMore',function() {
							 it++;
							 $(".modal-content .addMore").after('<div class="form-group"><input class="form-control-file" type = "file" name = "file' + it + '" size = "50" /></div>');
						 });
						 $('.modal').on('submit','.modal-content .msgForm',function(event) {
							 if($(".modal-content select[name=type] option:selected").val() == "Select Message Category") {
								 event.preventDefault();
								 alert("Please select a message type");
								 $("select[name=type]").addClass("unselected");	 
							 }
						 }); 
						 $('.modal').on('click','.modal-content select[name=type]', function() {
							 if($('.modal-content select[name=type] option:selected').val() != "Select Message Category") {
								 $('.modal-content select[name=type]').removeClass("unselected");
							 }
						 });
						 $('.modal').on('click','.modal-content .senderTitle', function() {
							$(this).next().toggle();
						 });
						 $('.profile').click(function() {
							 $.ajax('profile.jsp', {
							      success: function(response) {
							        $('.modal-content').html(response);
							      },
							      error: function() {
							        $('.modal-content').html('<li>There was a problem fetching info. Please try again.</li>');
							      },
							      timeout: 1000,
							      beforeSend: function() {
							        $('.modal-content').html('Loading...');
							      },
							      complete: function() {
							        
							      }
							    });
							 });
						});

					
					</script>
				    <!-- Bootstrap CSS -->
				    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
				    <link rel="stylesheet" href="font-awesome/css/font-awesome.min.css">
				    <link href="https://fonts.googleapis.com/css?family=Open+Sans+Condensed:300" rel="stylesheet">
				    
				    <style type="text/css">
				    	body {
				    		background-color:  #ffffff;	
				    	}
				    	.main {
				    		top: 90px;
				    	}
				    	.title {
				    		margin-top: 20px;
				    		margin-bottom: 20px;
				    	}
				    	a:link {
				  		text-decoration:none;
				  		color: #292b2c;
					  	}
					  	a:visited {
					  		text-decoration:none;
					  		color: #292b2c;
					  	}
					  	a:hover {
					  		text-decoration:none;
					  		color: #292b2c;
					  	}
					  	a:active {
					  		text-decoration:none;
					  		color: #292b2c;
					  	}
					  	.replyMsg {
					  		border-left: 1px solid #c0cbd6;
					  		display: block;
					  		width: inherit;
					  		padding-left: 10px;
					  	}
					  	button.delete {
					  		display: none;
					  	}
					  	.alertContainer {
					  		height: 70px;
					  	}
					  	.dashTitle {
					  		color: #FF8157;
					  		margin: 15px 0 35px 15px;
					  	}
					  	.modal-header {
				    		background-color: #4c4a4a;
				    	}
				    	.modal-header h5 {
				    		color: #ffffff;
				    	} 
				    	#compose-tab {
				    		border: 2px solid #fc8a66;
				    		border-radius: 5px;
				    	}
				    	
				    	.titleMenu .col-sm-12{
				    		background-color: #313131;
				    		position: fixed;
				    		top: 54px;
				    		padding: 5px;
				    		color: #FFFFFF;
				    		z-index: 10;
				    	}
				    	.titleMenu .col-sm-12 .btn{
				    		float: right;
				    		margin-right: 10px;
				    	}
				    	.titleMenu .col-sm-12 h6{
				    		display: inline-block;
				    	}
				    	.navbar-brand {
				    		font-weight:bold;
				    		font-family: 'Open Sans Condensed', sans-serif;
				    	}
				    	.sideMenu {
				    		padding: 0px;
				    		background-color: #f5f5f5;
				    	}
				    	.sideMenu a.title {
				    		color: #ffffff;
				    		background-color: #313131;
				    	}
				    	.sideMenu a {
				    		display: block;
				    	}
				    	.sideMenu a:hover {
				    		background-color: #313131;
				    		color: #ffffff;
				    	}
				    	.compose {
				    		display: none;
				    	}
				    	tbody tr {
				    		cursor: pointer;
				    	}
				    	.attachments {
				    		display: none;
				    	}
				    	.addAttachments {
				    		background-color: #4c4a4a;
				    		text-decoration: none;
				    		cursor: pointer;
				    	}
				    	.addMore {
				    		background-color: #4c4a4a;
				    		text-decoration: none;
				    		cursor: pointer;
				    	}
				    	.unselected {
				    		border-color: red;
				    	}
				    		/* Let's get this party started */
						::-webkit-scrollbar {
						    width: 8px;
						}
						 
						/* Track */
						::-webkit-scrollbar-track {
						    -webkit-box-shadow: inset 0 0 6px rgba(253, 138, 95, 1); 
						    -webkit-border-radius: 10px;
						    border-radius: 10px;
						}
						.msgDetails {
							display: none;
							
						}
						.msgDetails p {
							margin: 0px;
						}
						.ho {
							width: 200px;
						}
						 
						/* Handle */
						::-webkit-scrollbar-thumb {
						    -webkit-border-radius: 10px;
						    border-radius: 10px;
						    background: rgba(253, 138, 95, 1); 
						    -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.5); 
						}
						::-webkit-scrollbar-thumb:window-inactive {
							background: rgba(255,0,0,0.4); 
						}
						.btn-dark  { color: #ffffff; background-color: #4c4a4a; border-color: #555; }
						.btn-dark:hover, .btn-secondary:focus, .btn-secondary:active, .btn-secondary.active, .open .dropdown-toggle.btn-secondary
                        { color: #ffffff; background-color: #888; border-color: #444; }
				    </style>
				  </head>
				  <body>
				    
				    <nav class="navbar fixed-top navbar-toggleable-md navbar-light" style="background-color: #4c4a4a;">
					  <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
					    <span class="navbar-toggler-icon"></span>
					  </button>
					  <a class="navbar-brand" href="#" style="color: #ffffff;">Hostel Feedback System</a>
					
					  <div class="collapse navbar-collapse" id="navbarSupportedContent" style="color: #ffffff;">
					    <ul class="navbar-nav mr-auto">
					      <li class="nav-item active">
					        <a class="nav-link" href="#"><span class="sr-only">(current)</span></a>
					      </li>
					      <li class="nav-item">
					        <a class="nav-link" href="#"></a>
					      </li>
					      <li class="nav-item">
					        <a class="nav-link" href="#"></a>
					      </li>
					    </ul>
					    <div class="btn-group">
						  <button type="button" class="btn btn-dark">Welcome <%=session.getAttribute("name")%> !!!</button>
						  <button type="button" class="btn btn-dark dropdown-toggle dropdown-toggle-split" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
						    <span class="sr-only">Toggle Dropdown</span>
						  </button>
						  <div class="dropdown-menu">
						    <div class="dropdown-divider"></div>
						    <a class="dropdown-item profile" href="#" data-toggle="modal" data-target="#exampleModalLong">Profile</a>
						    <a class="dropdown-item" href="/hostelFeedback/signout.jsp">Logout</a>
						  </div>
						</div>
					  </div>
					</nav>
					<div class="container-fluid titleMenu">
						<div class="row">
							<div class="col-sm-12">
								<h6>Dashboard</h6>
								<button class="btn btn-success btn-sm create" data-toggle="modal" data-target="#exampleModalLong">Create Ticket</button>
								<button class="btn btn-danger btn-sm del" disabled="disabled">Delete Ticket</button>
							</div>
						</div>
					</div>
					
					<div class="container-fluid main">
						<div class="row">
							<div class="col-sm-2 sideMenu">
								<nav class="nav flex-column">
								  <a class="nav-link title" href="#">Filter by message type</a>
								  <a class="nav-link sideMenuItem" href="#" data-type="All">---All</a>
								  <% 
									ps = conn.prepareStatement("select * from typeOfMessage");
									rs  = ps.executeQuery();
									while(rs.next())
									{
										%>
										<a class="nav-link sideMenuItem" href="#" data-type="<%= rs.getString(1) %>">---<%= rs.getString(1) %></a>
										<%
									}
								  %>
								</nav>
							</div>
							<div class="col-sm-10">
								<span class="addAlertHere"></span>
							   	<div class="row alertContainer">
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
								
								  	<form id="deleteSent" action="deleteMsg.jsp">
									  	<table class="table table-hover sent">
										  <thead>
										    <tr>
										      <th>#</th>
										      <th>Date</th>
										      <th>Subject</th>
										      <th>Reference No.</th>
										      <th>Status</th>
										    </tr>
										  </thead>
										  <tbody>
										  	<%
										  	ps = conn.prepareStatement("select * from message join student where message.user = student.email and user = ? and repliedToId = -1 order by timeStamp desc");
										  	ps.setString(1, roll);
											rs = ps.executeQuery();
											while(rs.next())
											{
												referenceNo = rs.getString(11) + "/" + rs.getString(8).substring(0, 10) + "/" + rs.getInt(2);
												if(rs.getInt(6) == -1)
													subject = rs.getString(4);
												else
													subject = "Re:" + rs.getString(4);
												if(rs.getInt(9) == -1)
												{
													status = "Pending";
													color = "red";
												}
												else if(rs.getInt(9) == 0)
												{
													status = "Accepted/Under Process";
													color = "#FF7B00";
												}
												else if(rs.getInt(9) == 1)
												{
													status = "Resolved";
													color = "green";
												}
												else if(rs.getInt(9) == 2)
												{
													status = "Closed";
													color = "red";
												}
												if(rs.getInt(10) == 2)
													bgcolor = "darkgray";
												else
													bgcolor = "";
										  	%>
											    <tr class="<%=rs.getString(3) %>" style="background-color: <%=bgcolor%>;">
											      <th scope="row"><input type="checkbox" name="msgItem" value="<%=rs.getString(2)%>"></th>
											      <td class="msgItem" href="#" data-toggle="modal" data-target="#exampleModalLong" data-location="<%=rs.getString(2) %>" data-type="sent"><a><c:out value="<%=rs.getString(8).substring(0, 10) %>"></c:out></a></td>
											      <td class="msgItem" href="#" data-toggle="modal" data-target="#exampleModalLong" data-location="<%=rs.getString(2) %>" data-type="sent"><a><c:out value="<%=subject %>"></c:out></a></td>
											      <td class="msgItem" href="#" data-toggle="modal" data-target="#exampleModalLong" data-location="<%=rs.getString(2) %>" data-type="sent"><a><c:out value="<%=referenceNo %>"></c:out></a></td>
											       <td class="msgItem" href="#" data-toggle="modal" data-target="#exampleModalLong" data-location="<%=rs.getString(2) %>" data-type="sent"><a><span class="badge badge-pill" style="background-color: <%= color%>"><c:out value="<%=status %>"></c:out></span></a></td>
											    </tr>
											<%
											}
											%>
										  </tbody>
										</table>
										<input type="hidden" name="msgType" value="sent">
										<button id="deleteSentButton" type="submit" class="btn hidden delete">Delete</button>
								  	</form>
								<div class="compose">
									  <div class="modal-header">
								        <h5 class="modal-title mx-auto">Compose Your Message Below...</h5>
								        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
								          <span aria-hidden="true">&times;</span>
								        </button>
								      </div>
								      <div class="modal-body">
								        <br>
									  	<form class="msgForm" action="sendMsg.jsp" method="post" enctype="multipart/form-data">
									  		<div class="form-group">
									  		<select class="form-control" required="required" name="type">
									  		  	<option>Select Message Category</option>
									  			<%
									  			ps = conn.prepareStatement("select * from typeOfMessage");
									  			rs = ps.executeQuery();
									  			while(rs.next())
									  			{
									  			%>
									  			<option><%=rs.getString(1) %></option>
									  			<%} 
									  			%>
									  			<option>Other</option>
									  		</select>
									  		</div>
									  		<div class="form-group">
									  			<input class="form-control" type="text" name="subject" required="required" placeholder="Subject" maxlength="254" value="${fn.escapeXml(param.subject) }">
									  		</div>
									  		<div class="form-group">
									  			<textarea class="form-control" name="message" rows="10" cols="10" required="required" placeholder="Enter your message here...."><c:out value="${param.message}" /></textarea>
									  		</div>
									  		<a class="addAttachments">Add Attachments</a>
									  		<div class="attachments">
									  			<a class="addMore">Add More</a>
									  			<div class="form-group">
									  			<input class="form-control-file" type = "file" name = "file" size = "50" />
										  		</div>
										  		<div class="form-group">
										  			<input class="form-control-file" type = "file" name = "file1" size = "50" />
										  		</div>
										  		<div class="form-group">
										  			<input class="form-control-file" type = "file" name = "file2" size = "50" />
										  		</div>
										  		</div>
									  		<div class="form-group">
									  			<button type="submit" class="btn btn-primary">Send</button>
									  		</div>
									  	</form>
								      </div>
								  	
								  </div>
								   <!-- Modal -->
									<div class="modal fade" id="exampleModalLong" tabindex="-1" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
									  <div class="modal-dialog modal-lg" role="document">
									    <div class="modal-content">
									      
									    </div>
									  </div>
									</div>
							</div>
						</div>
					</div>
				
				    <!-- jQuery first, then Tether, then Bootstrap JS. -->
				    
				    
				    <script src="bootstrap/js/bootstrap.min.js"></script>
				  </body>
				</html>
			<%}
	}
	catch(Exception e) {
		%>
		<jsp:forward page="/error/"></jsp:forward>
		<%
	}
	
%>