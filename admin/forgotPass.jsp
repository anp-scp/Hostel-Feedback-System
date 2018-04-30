<%@page import="java.util.UUID"%>
<%@page import="com.sun.mail.smtp.SMTPTransport"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.Session"%>
<%@page import="java.util.Properties"%>
<%@page import="java.util.Random"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ include file="/jspConfig.jsp" %>
<%@ include file="/mail.jsp" %>
<%
	
		try {
			
			if(request.getParameter("user") != null)
			{
				String alert ="";
				String user = request.getParameter("user");
				String to = user;
				Class.forName("com.mysql.jdbc.Driver");
				Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
				PreparedStatement ps1;
				ResultSet rs;
				ps1 = conn.prepareStatement("select * from admin where email = ? and verified = 1");
				ps1.setString(1, user);
				rs = ps1.executeQuery();
				if(rs.next())
						{
							final String uid = UUID.randomUUID().toString().replace("-", "");
							Date  ct = new Date();
							long time = ct.getTime();
							//System.out.println(uid + " " + time);
							String subject = "[Hostel Feedback System] Password Reset";
							String msg = "Someone (hopefully you) requested for a password reset. Please click the link below to verify yourself.\n";
							msg += "http://" + mailRedirectURL + "/admin/reset/?id=" + uid + "&user=" + user;
							msg += "\n\nIf u can't click the link then copy the link in the address bar and then press enter.\n";
							msg += "If u have not requested for registration then please disregard this mail and no action will be taken.\n\n";
							msg += "Hostel Feedback System";
							ps1 = conn.prepareStatement("update admin set otp = ?, otpTime = ? where email = ?");
							ps1.setString(1, uid);
							ps1.setLong(2, time);
							ps1.setString(3, user);
							ps1.executeUpdate();
							sendMail("b15cs154@cit.ac.in", subject, msg);
							//sendMail(to, subject, msg);
							conn.close();
							%>
							<div class="alert alert-success alert-dismissible fade show" role="alert">
							  <button type="button" class="close" data-dismiss="alert" aria-label="Close">
							    <span aria-hidden="true">&times;</span>
							  </button>
							  A password reset link was successfully send to your email. If u don't find the mail in your inbox then check it in your spam/junk folder.
							</div>
							<%
						}
				else
				{
				%>
					<div class="alert alert-danger alert-dismissible fade show" role="alert">
					<button type="button" class="close" data-dismiss="alert" aria-label="Close">
				 	 <span aria-hidden="true">&times;</span>
					  </button>
					The email entered is not found in our system.
					</div>		 	
				<%		
				conn.close();
				}
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