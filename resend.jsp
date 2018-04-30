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
<%@ include file="jspConfig.jsp" %>
<%@ include file="mail.jsp" %>
<%
	
		try {
			if(request.getParameter("user") != null)
			{
				String alert ="";
				String user = request.getParameter("user");
				Class.forName("com.mysql.jdbc.Driver");
				Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
				PreparedStatement ps1;
				ResultSet rs;
				ps1 = conn.prepareStatement("select * from student where email = ?");
				ps1.setString(1, user);
				rs = ps1.executeQuery();
				if(rs.next() && rs.getInt(8) == 0)
						{
							final String uid = UUID.randomUUID().toString().replace("-", "");
							Date  ct = new Date();
							long time = ct.getTime();
							System.out.println(uid + " " + time);
							String subject = "[Hostel Feedback System] Email Verification";
							String msg = "Someone (hopefully you) tried to create an account in our portal. Please click the link below to verify yourself.\n";
							msg += "http://" + mailRedirectURL + "/activation/?id=" + uid + "&user=" + user;
							msg += "\n\nIf u can't click the link then copy the link in the address bar and then press enter.\n";
							msg += "If u have not requested for registration then please disregard this mail and no action will be taken.\n\n";
							msg += "Hostel Feedback System";
							ps1 = conn.prepareStatement("update student set otp = ?, otpTime = ? where email = ?");
							ps1.setString(1, uid);
							ps1.setLong(2, time);
							ps1.setString(3, user);
							ps1.executeUpdate();
							sendMail("b15cs154@cit.ac.in", subject, msg);
							conn.close();
							session.setAttribute("status", "inProcess");
							%>
							<script>document.location = "/hostelFeedback/activation.jsp"</script>
							<%
						}
				else
				{
				%>
					<script>document.location = "/hostelFeedback/"</script>
				<%		
				conn.close();
				}
			}
			else
			{
			%>
				<script>document.location = "/hostelFeedback/"</script>
			<%	
			}
		}
	catch(Exception e) {
		%>
		<jsp:forward page="/error/"></jsp:forward>
		<%
	}
%>