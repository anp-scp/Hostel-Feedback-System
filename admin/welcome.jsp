<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ include file="/jspConfig.jsp" %>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
	
		try {
			if("admin".equals((String)session.getAttribute("type")))
			{
				String type = (String)session.getAttribute("type");
				String subject = "";
				String referenceNo = "";
				String status = "";
				String color = "";
				String bgcolor = "";
				String sql = "";
				String types = "";
				String hostels = "";
				Class.forName("com.mysql.jdbc.Driver");
				Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
				PreparedStatement ps;
				ResultSet rs;
			%>	
			<!DOCTYPE html>
			<html lang="en">
			  <head>
			    <!-- Required meta tags -->
			    <meta charset="utf-8">
			    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
				<title>Dash Board</title>
				<script src="jQuery/jquery-3.2.1.min.js"></script>
				<link rel="stylesheet" href="font-awesome/css/font-awesome.min.css">
				<script>

					$(document).ready(function() {
						 
						  var el = $(".msgItem");
						  el.click(function() {
							var $div = $(this);  
							
						    $.ajax('viewMsg.jsp', {
						      data: {location: $div.attr('data-location'),
						    		 type: $div.attr('data-type'),
						    		 reference: $div.attr('data-reference')
						      },
						      success: function(response) {
						        $('.modal-content').html(response);
						        $div.parent().css("background-color","");
						      },
						      error: function() {
						        $('.modal-content').html('<li>There was a problem fetching the latest photos. Please try again.</li>');
						      },
						      timeout: 1000,
						      beforeSend: function() {
						        $('.modal-content').html('Loading...');
						      },
						      complete: function() {
						        
						      }
						    });
						  });
						  var el1 = $(".byRoll");
						  el1.keyup(function() { 
							  
						      if($(".byRoll").val() != "") {
						    	  $.ajax('studentInfo.jsp', {
								      data: {searchKey: $(".byRoll").val(),
								    		 searchType: "rollNo"
								      },
								      success: function(response) {
								        $('.info').html(response);
								      },
								      error: function() {
								        $('.info').html('<li>There was a problem fetching the latest photos. Please try again.</li>');
								      },
								      timeout: 1000,
								      beforeSend: function() {
								        $('.info').html('Loading...');
								      },
								      complete: function() {
								        
								      }
								    });
						      }
						      else {
						    	  $('.info').html('Please Enter Something');
						      }
						  });
						  var el2 = $(".byName");
						  el2.keyup(function() { 
							  
						      if($(".byName").val() != "") {
						    	  $.ajax('studentInfo.jsp', {
								      data: {searchKey: $(".byName").val(),
								    		 searchType: "name"
								      },
								      success: function(response) {
								        $('.info').html(response);
								      },
								      error: function() {
								        $('.info').html('<li>There was a problem fetching the latest photos. Please try again.</li>');
								      },
								      timeout: 1000,
								      beforeSend: function() {
								        $('.info').html('Loading...');
								      },
								      complete: function() {
								        
								      }
								    });  
						      }
						      else {
						    	  $('.info').html('Please Enter Something');
						      }
						  });
						  var el3 = $(".listItem");
						  el3.click(function() {
							var $listItem = $(this);  
						    $.ajax('showAssociatedPerson.jsp', {
						      data: {type: $listItem.attr('data-type'),
						    	     name: $listItem.text()
						      },
						      success: function(response) {
						        $('.modal-content').html(response);
						      },
						      error: function() {
						        $('.modal-content').html('<li>There was a problem fetching the latest photos. Please try again.</li>');
						      },
						      timeout: 1000,
						      beforeSend: function() {
						        $('.modal-content').html('Loading...');
						      },
						      complete: function() {
						        
						      }
						    });
						  });
						  $('.modal').on('submit','.modal-content form.addAssociatedPerson',function(event) {
							  	var givenmail = $('.modal-content input[name=personEmail]').val();
							  	var addedmail;
							  	var found = false;
								$('.mail').each(function () {
									addedmail = $(this).text().trim();
									if(addedmail === givenmail)
										{
											$('.modal-content .inAlert').html('<div class="alert alert-warning alert-dismissible fade show" role="alert"> <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>Email already Exist</div>');
											event.preventDefault();found = true;return false;
										}
								});
								if(found == false)
									{
										 event.preventDefault();
										 $.ajax('showAssociatedPerson.jsp', {
										 data: {
											 type: $('.modal-content form.addAssociatedPerson').attr('data-type'),
											 name: $('.modal-content form.addAssociatedPerson').attr('data-value'),
											 pname: $('.modal-content form.addAssociatedPerson input[name=personName]').val(),
											 pmail: $('.modal-content form.addAssociatedPerson input[name=personEmail]').val(),
										 },
										 success: function(response) {
											 $('.modal-content').html(response);
										 },
										 error: function() {
										     $('.modal-content').html('<li>There was a problem fetching the latest photos. Please try again.</li>');
										 },
										 timeout: 10000,
										 beforeSend: function() {
										     $('.modal-content').html('Loading...');
										 },
										 complete: function() {
										        
										 }
									 });
									}
								 
						  });
						  $('.modal').on('click','.modal-content a[data-action=delete]',function(event) {
								 $.ajax('showAssociatedPerson.jsp', {
									 data: {
										 type: $('.modal-content form.addAssociatedPerson').attr('data-type'),
										 name: $('.modal-content form.addAssociatedPerson').attr('data-value'),
										 action: $('.modal-content a[data-action=delete]').attr('data-action'),
										 pmail: $('.modal-content a[data-action=delete]').attr('data-mail')
									 },
									 success: function(response) {
										 $('.modal-content').html(response);
									 },
									 error: function() {
									     $('.modal-content').html('<li>There was a problem fetching the latest photos. Please try again.</li>');
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
								  $("#deleteSentButton").css("display","block");
							  }
							  else {
								  $("#deleteSentButton").css("display","none");
							  }
						  });
						  $("#deleteRecieved").click(function() {
							  if($("#deleteRecieved input:checkbox:checked").length > 0) {
								  $("#changeStatus").removeAttr('disabled');
							  }
							  else {
								  $("#changeStatus").attr('disabled','disabled');
							  }	
						  });
						  $("#selectTypeOfRecievedMsg").click(function() {
							  var selected = $("#selectTypeOfRecievedMsg option:selected").text();
						  	  
						  	  if(selected == "All" || selected == "Filter Message by Type")
						  		  {
						  		 	 $("table.rec tr").slideDown();
						  		  }
						  	  else 
						  		  {
						  			$("table.rec tr").slideUp(function(){
						  				var toHide = "table.rec tr:first,table.rec tr." + selected;
						  				$(toHide).slideDown();
						  			});
						  		  }
						  });
						  $("#selectStatus").click(function() {
							  var selected = $("#selectStatus option:selected").text();
						  	  
						  	  if(selected == "All" || selected == "Filter message by status")
						  		  {
						  		 	 $("table.rec tr").slideDown();
						  		  }
						  	  else 
						  		  {
						  			$("table.rec tr").slideUp(function(){
						  				var toHide = "table.rec tr:first,table.rec tr." + selected;
						  				$(toHide).slideDown();
						  			});
						  		  }
						  });
						  $("#changeStatus").click(function() {
							  var selected = $("#changeStatus option:selected").text();
							  if(selected != "Change Status Here")
								  {
								  	$("input.del").val(selected);
								  	$("button.delete").click();
								  }
						  });
						  $('.addEmailForm').submit(function(event) {
							  	var givenMail = $('.addEmailForm input').val();
							  	var addedMail;
								$('li', $('.addEmail')).each(function () {
									addedMail = $(this).text().trim();
									if(addedMail === givenMail)
										{
											$('.addEmail .alertcontain').html('<div class="alert alert-warning alert-dismissible fade show" role="alert"> <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>Email already Exist</div>');
											event.preventDefault();return false;
										}
								});
							});
						  $('.addHostelForm').submit(function(event) {
							  	var givenHostel = $('.addHostelForm input').val();
							  	var addedHostel;
								$('li', $('.addHostel')).each(function () {
									addedHostel = $(this).text().trim();
									if(addedHostel === givenHostel)
										{
											$('.addHostel .alertcontain').html('<div class="alert alert-warning alert-dismissible fade show" role="alert"> <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>Hostel already Exist</div>');
											event.preventDefault();return false;
										}
								});
							});
						  $('.addCategoryForm').submit(function(event) {
							  	var givenCategory = $('.addCategoryForm input').val();
							  	var addedCategory;
								$('li', $('.addCategory')).each(function () {
									addedCategory = $(this).text().trim();
									if(addedCategory === givenCategory)
										{
											$('.addCategory .alertcontain').html('<div class="alert alert-warning alert-dismissible fade show" role="alert"> <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>Category already Exist</div>');
											event.preventDefault();return false;
										}
								});
							});
						  $('.modal').on('click','.modal-content .senderTitle', function() {
								$(this).next().toggle();
							 });
						  var studEle = $(".studItem");
						  $('.info').on('click',studEle,function(event) {
							var $divEle = $(event.target);
						    $.ajax('showProfile.jsp', {
						      data: {user: $divEle.attr('data-roll'), 	
						      },
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
			    
				        <style type="text/css">
				    	body {
				    		background-color: #ffffff;
				    	}
				    	.main {
				    		top: 75px;
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
					  		border-left: 1px solid #eff0f1;
					  		display: block;
					  		width: inherit;
					  		padding-left: 10px;
					  	}
					  	button.delete {
					  		display: none;
					  	}
					  	form.addStudent input {
					  		margin: 20px;
					  	}
					  	.add-delete {
					  		border: 2px solid #eff0f1;
					  		border-radius: 5px;
					  	} 
					  	.byName {
					  		margin-right: 30px;
					  	}
					  	td a {
					  		display: block;
					  	}
					  	.card {
					  		margin-bottom: 20px;
					  	}
					  	.card-body {
					  		padding: 10px;
					  	}
					  	.alertContainer {
					  		position : relative;
					  		top: 15px;
					  		height: 70px;
					  	}
					  	.alertDiv {
					    		margin: 0 auto;
					    		text-align: center;
					    }
					  	.dashTitle {
					  		color: #3b5998;
					  		margin: 15px 0 35px 15px;
					  	}
					  	.modal-header,.card-header {
				    		background-color: #3b5998;
				    		color: #ffffff;
				    	}
				    	.modal-header h5 {
				    		color: #ffffff;
				    	} 
				    	.cardBodyList {
				    		height: 170px;
				    		overflow-y: scroll;
				    		overflow-x: hidden; 
				    	}
				    	#recieved, #sent, #studentInfo {
				    		height: 400px;
				    		overflow-y: scroll;
				    		overflow-x: hidden;
				    	}
				    	.titleMenu .col-sm-12{
				    	    background-color: #3b62b5;
						    position: fixed;
						    top: 54px;
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
				    	.main .col-sm-10 {
				    		padding-left: 0px;
				    	}
				    	.msgControl {
				    		height: 55px;
				    		background-color: #F5F5F5;
				    	}
				    	.msgControl form {
				    		margin-left: 15px;
				    	}
				    	.msgControl select {
				    		height: 30px;
				    		font-size: 13px;
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
				    		background-color: #3b62b5;
				    		color: #ffffff;
				    	}
				    	tbody tr {
				    		cursor: pointer;
				    	}
				    	.msgDetails {
							display: none;
							
						}
						.msgDetails p {
							margin: 0px;
						}
				    	
				    	/* Let's get this party started */
						::-webkit-scrollbar {
						    width: 8px;
						}
						 
						/* Track */
						::-webkit-scrollbar-track {
						    -webkit-box-shadow: inset 0 0 6px rgba(59, 89, 152, 1); 
						    -webkit-border-radius: 10px;
						    border-radius: 10px;
						}
						 
						/* Handle */
						::-webkit-scrollbar-thumb {
						    -webkit-border-radius: 10px;
						    border-radius: 10px;
						    background: rgba(59, 89, 152, 1); 
						    -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.5); 
						}
						::-webkit-scrollbar-thumb:window-inactive {
							background: rgba(255,0,0,0.4); 
						}
				    </style>
			  </head>
			  <body>
			    <nav class="navbar fixed-top navbar-toggleable-md navbar-light" style="background-color: #3b5998;">
					  <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
					    <span class="navbar-toggler-icon"></span>
					  </button>
					  <a class="navbar-brand" href="#" style="color: #ffffff;">Hostel Feedback System - Dash Board</a>
					
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
						  <button type="button" class="btn btn-primary">Welcome <%=(String)session.getAttribute("name") %> !!!</button>
						  <button type="button" class="btn btn-primary dropdown-toggle dropdown-toggle-split" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
						    <span class="sr-only">Toggle Dropdown</span>
						  </button>
						  <div class="dropdown-menu">
						    
						    <div class="dropdown-divider"></div>
						    <a class="dropdown-item" href="/hostelFeedback/admin/signout.jsp">Logout</a>
						  </div>
						</div>
					  </div>
					</nav>
			    
			    <div class="container-fluid titleMenu">
						<div class="row">
							<div class="col-sm-12">
								<h6>Dashboard</h6>
							</div>
						</div>
					</div>
			    
			    <div class="container-fluid main">
			    	<div class="row">
			    		<div class="col-sm-2 sideMenu">
			    			<ul class="nav flex-column" id="myTab" role="tablist">
								<li class="nav-item">
									<a class="nav-link active" id="recieved-tab" data-toggle="tab" href="#recieved" role="tab" aria-controls="recieved" aria-expanded="true">Recieved</a>
								</li>
								<%
								if("superAdmin".equals((session.getAttribute("role"))))
								{
									%>
									<li class="nav-item">
									    <a class="nav-link" id="addStudent-tab" data-toggle="tab" href="#addStudent" role="tab" aria-controls="addStudent">Other Settings</a>
									</li>
									<%
								}
								%>
								<li class="nav-item">
								    <a class="nav-link" id="studentInfo-tab" data-toggle="tab" href="#studentInfo" role="tab" aria-controls="studentInfo">Student Info</a>
								</li>
							</ul>
			    		</div>
			    		<div class="col-sm-10">
								<div class="tab-content" id="myTabContent">
								  <div class="tab-pane fade show active" id="recieved" role="tabpanel" aria-labelledby="recieved-tab">	
								  	<div class="row msgControl"> 
								  			
									  		<form class="form-inline">
												<select id="selectTypeOfRecievedMsg" class="custom-select d-block my-3">
													<option value="Filter Message by Type" selected>Filter Message by Type</option>
													<option value="all">All</option>
													<% 
													if("superAdmin".equals((String)session.getAttribute("role")))
													{
														ps = conn.prepareStatement("select * from typeOfMessage");
														rs  = ps.executeQuery();
														while(rs.next())
														{
															%>
															<option value="<%= rs.getString(1) %>"><%= rs.getString(1) %></option>
															<%
														}
													}
													else if("otherAdmin".equals((String)session.getAttribute("role")))
													{
														ps = conn.prepareStatement("select type from typeOfMessageAdmin where email = ?");
														ps.setString(1, (String)session.getAttribute("email"));
														rs  = ps.executeQuery();
														while(rs.next())
														{
															%>
															<option value="<%= rs.getString(1) %>"><%= rs.getString(1) %></option>
															<%
														}
													}
													
													%>
												</select>
											</form>
											<form class="form-inline">
												<select id="selectStatus" class="custom-select d-block my-3">
													<option value="Filter message by status" selected>Filter message by status</option>
													<option value="all">All</option>
													<option value="Pending">Pending</option>
													<option value="Accepted_and_Under_Process">Accepted_and_Under_Process</option>
													<option value="Resolved">Resolved</option>
													<option value="Closed">Closed</option>
												</select>
											</form>
											<form class="form-inline">
												<select id="changeStatus" class="custom-select d-block my-3" disabled="disabled">
													<option value="Change Staus Here" selected>Change Status Here</option>
													<option value="Pending">Pending</option>
													<option value="Accepted_and_Under_Process">Accepted_and_Under_Process</option>
													<option value="Resolved">Resolved</option>
													<option value="Closed">Closed</option>
												</select>
											</form>
								  	</div>
								  	<span class="addAlertHere"></span>
						    		<div class="alertContainer">
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
								  	<form  id="deleteRecieved" action="deleteMsg.jsp" method="get">
									  	<table class="table table-hover rec">
										  <thead>
										    <tr>
										      <th>#</th>
										      <th>From</th>
										      <th>Date</th>
										      <th>Subject</th>
										      <th>Reference No.</th>
										      <th>Status</th>
										    </tr>
										  </thead>
										  <tbody class="recieved">
										  	<%
										  		ps = conn.prepareStatement("select type from typeOfMessageAdmin where email = ?");
										  		ps.setString(1, (String)session.getAttribute("email"));
										  		rs = ps.executeQuery();
										  		while(rs.next())
										  			types += "'" + rs.getString(1) + "',";
										  		ps = conn.prepareStatement("select hostel from hostelAdmin where email = ?");
										  		ps.setString(1, (String)session.getAttribute("email"));
										  		rs = ps.executeQuery();
										  		while(rs.next())
										  			hostels += "'" + rs.getString(1) + "',";
										  		try
										  		{
										  			char[] arr = types.toCharArray();
										  			arr[arr.length - 1] = ' ';
										  			types = String.valueOf(arr);
										  		}
										  		catch(Exception e)
										  		{
										  			types = "\"\"";
										  		}
										  		try
										  		{
										  			char[] arr = hostels.toCharArray();
										  			arr[arr.length - 1] = ' ';
										  			hostels = String.valueOf(arr);
										  		}
										  		catch(Exception e)
										  		{
										  			hostels  = "\"\"";
										  		}
										  	
										  		if("superAdmin".equals((String)session.getAttribute("role")))
										  			sql = "select * from message join student where message.user = student.email and repliedToId = -1 order by timeStamp desc";
										  		else
										  			sql = "select * from message join student where message.user = student.email and repliedToId = -1 and (type IN (" + types + ") or hostel IN (" + hostels + ")) order by timeStamp desc";
										  		ps = conn.prepareStatement(sql);
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
														status = "Accepted_and_Under_Process";
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
													if(rs.getInt(10) == 0)
														bgcolor = "darkgray";
													else
														bgcolor = "";
											  	%>
												    <tr class="<%=rs.getString(3)%> <%=status%>" style="background-color: <%=bgcolor%>;">
												      <th scope="row"><input type="checkbox" name="msgItem" value="<%=rs.getString(2)%>"></th>
												      <td class="msgItem"  data-toggle="modal" data-target="#exampleModalLong" data-location="<%=rs.getString(2) %>" data-type="recieved" data-reference="<%=rs.getString(1) %>"><a><c:out value="<%=rs.getString(13) %>"></c:out></a></td>
												       <td class="msgItem"  data-toggle="modal" data-target="#exampleModalLong" data-location="<%=rs.getString(2) %>" data-type="recieved" data-reference="<%=rs.getString(1) %>"><a><c:out value="<%=rs.getString(8).substring(0, 10) %>"></c:out></a></td>   
												      <td  class="msgItem"  data-toggle="modal" data-target="#exampleModalLong" data-location="<%=rs.getString(2) %>" data-type="recieved" data-reference="<%=rs.getString(1) %>"><a><c:out value="<%=subject %>"></c:out></a></td>
												      <td class="msgItem"  data-toggle="modal" data-target="#exampleModalLong" data-location="<%=rs.getString(2) %>" data-type="recieved" data-reference="<%=rs.getString(1) %>"><a><c:out value="<%=referenceNo %>"></c:out></a></td>
												      <td  class="msgItem"  data-toggle="modal" data-target="#exampleModalLong" data-location="<%=rs.getString(2) %>" data-type="recieved" data-reference="<%=rs.getString(1) %>"><a><span class="badge badge-pill" style="background-color: <%= color%>"><c:out value="<%=status %>"></c:out></span></a></td>
												    </tr>
												<%
												}
											%>
										  </tbody>
										</table>
										<input class="del" type="hidden" name="status" value="recieved">
										<button id="deleteRecievedButton" type="submit" class="btn hidden delete">Delete</button>
								  	</form>
								  
								 
								  </div>
								  <%
								  if("superAdmin".equals((String)session.getAttribute("role")))
								  {
									  %>
									  <div class="tab-pane fade" id="addStudent" role="tabpanel" aria-labelledby="addStudent-tab">
									  	<br>
									  	<div class="row">
									  		
									  	</div>
									  	<div class="row">
									  		<div class="col-sm-6">
										  		<div class="card">
												  <div class="card-header">
												    Add hostels
												  </div>
												  <div class="card-body addHostel">
												    <p class="card-text">Add new hostels.</p>
												    <div class="cardBodyList">
												    	<%
														    ps = conn.prepareStatement("select * from hostel");
														    rs = ps.executeQuery();
														    while(true)
														    {
														    	if(rs.next() == false)
														    	{
														    		break;
														    	}
														    	else
														    	{
														    		%>
														    		<ul>
														    			<li><a class="listItem" href="#" data-toggle="modal" data-target="#exampleModalLong" data-type="hostel"><%= rs.getString(1) %></a> <a href="deleteEmailRec.jsp?hostel=<%= rs.getString(1) %>" ><i class="fa fa-trash-o" aria-hidden="true"></i></a></li>
														    		</ul>
														    		<%
														    		
														    	}
														    }
														    %>
												    </div>
										    		<br>
										    		<div class="alertcontain">
												    </div>
										    		<form action="addEmailRec.jsp" class="addHostelForm">
										    			<div class="form-inline">
										    				<input class="form-control" type="text" name="hostel" required="required" placeholder="Enter Hostel Name Here..." value="${fn.escapeXml(param.roll) }">
										    				<button class="btn btn-outline-primary" type="submit">Add</button>
										    			</div>
										    		</form>
										    		<%
												    %>
												  </div>
												</div>
											</div>
											<div class="col-sm-6">
										  		<div class="card">
												  <div class="card-header">
												    Add message category
												  </div>
												  <div class="card-body addCategory">
												    <p class="card-text">Create different categories of message</p>
												    <div class="cardBodyList">
												    	<%
														    ps = conn.prepareStatement("select * from typeOfMessage");
														    rs = ps.executeQuery();
														    while(true)
														    {
														    	if(rs.next() == false)
														    	{
														    		break;
														    	}
														    	else
														    	{
														    		%>
														    		<ul>
														    			<li><a class="listItem" href="#" data-toggle="modal" data-target="#exampleModalLong" data-type="category"><%= rs.getString(1) %></a> <a href="deleteEmailRec.jsp?type=<%= rs.getString(1) %>" ><i class="fa fa-trash-o" aria-hidden="true"></i></a></li>
														    		</ul>
														    		<%
														    		
														    	}
														    }
														    %>
												    </div>
										    		<br>
										    		<div class="alertcontain">
												    </div>
										    		<form action="addEmailRec.jsp" class="addCategoryForm">
										    			<div class="form-inline">
										    				<input class="form-control" type="text" name="type" required="required" placeholder="Enter actegory name Here..." value="${fn.escapeXml(param.roll) }">
										    				<button class="btn btn-outline-primary" type="submit">Add</button>
										    			</div>
										    		</form>
										    		<%
												    %>
												  </div>
												</div>
											</div>
									  	</div>
									  </div>
									  <%
								  }
								  %>
								   <div class="tab-pane fade" id="studentInfo" role="tabpanel" aria-labelledby="studentInfo-tab">
								  	<br>
								  	<form>
								  		<div class="form-inline">
								  			<input type="text" maxlength="50" class="form-control byName" placeholder="Search by Name"><span>     </span>
								  			<input type="text" maxlength="14" class="form-control byRoll" placeholder="Search by Roll No.">
								  		</div>
								  	</form>
								  	<table class="table table-hover">
										  <thead>
										    <tr>
										      <th>Name</th>
										      <th>Roll No.</th>
										      <th>e-Mail Id</th>
										      <th>Branch</th>
										      <th>Module</th>
										    </tr>
										  </thead>
										  <tbody class="info">
										  	
										  </tbody>
										</table>
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
					  
				</div>
			
			    <!-- jQuery first, then Tether, then Bootstrap JS. -->
			    
			   
			    <script src="bootstrap/js/bootstrap.min.js"></script>
			  </body>
			</html>
			<%
			}
			else
			{
			%>
			<script>document.location = "/hostelFeedback/admin"</script>
			<%
			}
		}
	catch(Exception e) {
		%>
		<jsp:forward page="/error/"></jsp:forward>
		<%
	}
	
%>