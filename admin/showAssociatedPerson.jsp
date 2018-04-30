<%@page import="javax.xml.bind.DatatypeConverter"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="com.sun.mail.smtp.SMTPTransport"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.Session"%>
<%@page import="java.util.Properties"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.UUID"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.security.cert.CertPathValidatorException.Reason"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ include file="/jspConfig.jsp" %>
<%@ include file="/mail.jsp" %>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%!

public static String MD5(String str) throws Exception {
	MessageDigest md = MessageDigest.getInstance("MD5");
	md.update(str.getBytes());
	byte[] digest = md.digest();
	String hash = DatatypeConverter.printHexBinary(digest).toUpperCase();
	return hash;
}

%>
<%
	try	
	{
			if("admin".equals((String)session.getAttribute("type")))
			{
				Class.forName("com.mysql.jdbc.Driver");
				Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
				PreparedStatement ps;
				ResultSet rs;
				String type = request.getParameter("type");
				String name = request.getParameter("name");
				String personName = request.getParameter("pname");
				String pmail = request.getParameter("pmail");
				String status = "";
				String sql = "";
				String alert="";
				if(request.getParameter("action") != null) {
					if(type.equals("hostel"))
						sql = "delete from hostelAdmin where email = ? and hostel = ?";
					else
						sql = "delete from typeOfMessageAdmin where email = ? and type = ?";
					ps = conn.prepareStatement(sql);
					ps.setString(1, pmail);
					ps.setString(2, name);
					ps.executeUpdate();
					alert = "Deleted...";
				}
				if(pmail != null && personName != null)
				{
					ps = conn.prepareStatement("select * from admin where email = ?");
					ps.setString(1, pmail);
					rs = ps.executeQuery();
					if(rs.next() == false)
					{
						final String uid = UUID.randomUUID().toString().replace("-", "");
						final String data = MD5(pmail);
						File path = new File("/home/anupam/data/" + data);
						path.mkdir();
						Date ct = new Date();
						long time = ct.getTime();
						ps = conn.prepareStatement("insert into admin (name,email,role,data,otp,otpTime) values(?,?,?,?,?,?)");
						ps.setString(1, personName);
						ps.setString(2, pmail);
						ps.setString(3, "otherAdmin");
						ps.setString(4, data);
						ps.setString(5, uid);
						ps.setLong(6, time);
						ps.executeUpdate();
						String subject = "[Hostel Feedback System] Email Verification";
						String msg = "The administrator of the Hostel Feedback System has invited you as the administrator for the hostel/department under your supervision. Please click the link below to verify yourself.\n";
						msg += "http://" + mailRedirectURL + "/admin/activation/?id=" + uid + "&user=" + pmail;
						msg += "\n\nIf u can't click the link then copy the link in the address bar and then press enter.\n";
						msg += "If you think that this mail is not for you, then please disregard this mail and no action will be taken.\n\n";
						msg += "Hostel Feedback System";	
						// sendMail(pmail, subject, msg);    // uncomment this line to send mail to specific mail (for production)
						sendMail("b15cs154@cit.ac.in", subject, msg); // this code is for development purpose.....
					}
					if(type.equals("hostel"))
						sql = "insert into hostelAdmin values(?,?)";
					else
						sql = "insert into typeOfMessageAdmin values(?,?)";
					ps = conn.prepareStatement(sql);
					ps.setString(1, pmail);
					ps.setString(2, name);
					ps.executeUpdate();
					alert = "Added...";
				}
				if(type.equals("hostel"))
					sql = "select name,admin.email,verified from hostelAdmin,admin where hostelAdmin.email = admin.email and hostel = ?";
				else
					sql = "select name,admin.email,verified from typeOfMessageAdmin,admin where typeOfMessageAdmin.email = admin.email and type = ?";
				ps = conn.prepareStatement(sql);
				ps.setString(1, name);
				rs = ps.executeQuery();
			%>
				<style>
					.addAssociatedPerson {
						padding: 5px;
					}
				</style>
				<div class="modal-header">
					<h5 class="modal-title mx-auto" id="exampleModalLongTitle">Associated Person(<c:out value="<%=name %>"></c:out>)</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<h6>Given are the list of associated person with this <b><%=type %></b></h6>
					<br>
					<br>
					<div class="cardBodyList">
						<table class="table table-hover">
							<thead>
								<tr>
									<th>Name</th>
									<th>E-mail</th>
									<th>Status</th>
									<th>Action</th>
								</tr>
							</thead>
							<tbody>
							<%
							while(rs.next())
							{
								if(rs.getString(3).equals("0"))
									status = "Invitation Sent";
								else
									status = "Added";
								%>
								<tr>
									<td><c:out value="<%=rs.getString(1) %>"></c:out></td>
									<td class="mail"><c:out value="<%=rs.getString(2) %>"></c:out></td>
									<td><c:out value="<%=status %>"></c:out></td>
									<td><a href="#" data-action="delete" data-mail="<c:out value="<%=rs.getString(2) %>"></c:out>">Delete</a></td>
								</tr>
								<%
							}
							%>
							</tbody>
						</table>
					</div>
					<div style="height: 100px;" class="inAlert">
						<%
						if(alert.equals("") == false)
						{
							%>
							<div class="alert alert-warning alert-dismissible fade show" role="alert">
								<button type="button" class="close" data-dismiss="alert" aria-label="Close">
									<span aria-hidden="true">&times;</span>
								</button>
								<%=alert %>
							</div>
							<%
						}
						%>
					</div>
					<div class="row addAssociatedPerson">
					<h6>Enter the details of associated Person below:</h6>
						<form class="addAssociatedPerson" data-value="<%=name %>" data-type="<%=type %>">
							<div class="form-inline">
								<input class="form-control" type="text" name="personName" required="required" placeholder="Name" value="${fn.escapeXml(param.personName) }">
								<input class="form-control" type="email" name="personEmail" required="required" placeholder="E-mail" value="${fn.escapeXml(param.personEmail) }">
								<button class="btn btn-outline-primary" type="submit">Add</button>
							</div>
						</form>
					</div>
				</div>
				<div class="modal-footer">
				    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				</div>
			<%
			}
			else
			{
			%>
			<p>Authentication failed</p>
			<% 
			}
	}

	catch(Exception e) {
		%>
		<jsp:forward page="/error/"></jsp:forward>
		<%
	}
		
		%>