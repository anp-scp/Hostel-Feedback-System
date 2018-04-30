<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.security.cert.CertPathValidatorException.Reason"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ include file="/jspConfig.jsp" %>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
try{
	if("admin".equals((String)session.getAttribute("type")) == false)
	{
	%>
	<p>Authentication failed</p>
	<% 
	}
	else
	{	
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
		PreparedStatement ps;
		ResultSet rs;
		ps = conn.prepareStatement("select rollNo,email,name,branch,module,hostel,roomNo from student where rollNo = ?");
		ps.setString(1, request.getParameter("user"));
		rs = ps.executeQuery();
		rs.next();
		String name = rs.getString(3);
		String rollNo = rs.getString(1);
		String email = rs.getString(2);
		String branch = rs.getString(4);
		String module = rs.getString(5);
		String hostel = rs.getString(6);
		int room = rs.getInt(7);
	%>	
		<style>
			legend {
				 width:auto;
				 padding:0 10px; /* To give a bit of padding on the left and right */
				 border-bottom:none;
			}
			fieldset {
				width: 100%;
				border: 1px solid #c0cbd6;
				margin: 5px;
				padding: 5px;
				
			}
		</style>
		<div class="modal-header">
			<h5 class="modal-title mx-auto" id="exampleModalLongTitle">Profile</h5>
			<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
			</button>
		</div>
		<div class="modal-body po">
			<form>
				<div class="row">
					<fieldset>
						<legend>Personal Information</legend>
						<div class="row">
							<div class="col-sm-6">
								<div class="form-inline">
									<p>Name &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:<input id="name" disabled="disabled" class="form-control" type="text" name="name" required="required" value="<c:out value="<%=name %>"></c:out>" maxlength="80"></p>
								</div>
								<div class="form-inline">
									<p>Roll No.&nbsp;&nbsp;&nbsp;&nbsp;:<input class="form-control" disabled="disabled" type="text" required="required" value='<c:out value="<%=rollNo %>"></c:out>' maxlength="80"></p>
								</div>
								<div class="form-inline">
									<p>E-mail&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:<input class="form-control" disabled="disabled" type="email" required="required" value='<c:out value="<%=email %>"></c:out>@cit.ac.in' maxlength="80"></p>
								</div>
								<div class="form-inline">
									<p>Room No.&nbsp;:<input id="roomNo" class="form-control" disabled="disabled" type="number" name="roomNo" required="required" value="<c:out value="<%=room %>"></c:out>"></p>
								</div>
								<div class="form-inline">
									<p>Hostel&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:
										<select disabled="disabled" class="form-control ho" name="hostel" required="required">
										<%
										ps = conn.prepareStatement("select * from hostel");
										rs = ps.executeQuery();
										while(rs.next()){
											if(rs.getString(1).equals(hostel)){
												%><option selected="selected"><c:out value="<%=rs.getString(1) %>"></c:out></option> 
												<%
											}
											else {
												%><option><c:out value="<%=rs.getString(1) %>"></c:out></option>
												<% 
											}
										}
										%>	
										</select>
									</p>
								</div>
								<div class="form-inline">
									<p>Module:<%=module %>
									</p>
								</div>
								<div class="form-inline">
									<p>Branch:<%=branch %>
									</p>
								</div>
							</div>
							<div class="col-sm-4">
								<img class="img-thumbnail" alt="profileImage" src="download.jsp?id=noId&file=profile.jpg&by=<%= email%>">
							</div>
						</div>
					</fieldset>
				</div>
			</form>
		</div>
		<div class="modal-footer">
		    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
		</div>
	<%
	}
}
catch(Exception e) {
	%>
	<jsp:forward page="/error/"></jsp:forward>
	<%
}
%>