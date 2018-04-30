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
<%!
public static void sendMail(String to,String subject,String mail) throws Exception {

    Properties props = System.getProperties();
    props.put("mail.smtps.host", "smtp.mailgun.org");
    props.put("mail.smtps.auth", "true");

    Session session = Session.getInstance(props, null);
    Message msg = new MimeMessage(session);
    msg.setFrom(new InternetAddress("postmaster@sandboxf9b041fb9a844424842069af9255c337.mailgun.org"));

    InternetAddress[] addrs = InternetAddress.parse(to, false);
    msg.setRecipients(Message.RecipientType.TO, addrs);

    msg.setSubject(subject);
    msg.setText(mail);
    msg.setSentDate(new Date());

    SMTPTransport t =
        (SMTPTransport) session.getTransport("smtps");
    t.connect("smtp.mailgun.com", "postmaster@sandboxf9b041fb9a844424842069af9255c337.mailgun.org", "0c8bf3d05583cb4c39419e6df26aa297");
    t.sendMessage(msg, msg.getAllRecipients());

    System.out.println("Response: " + t.getLastServerResponse());

    t.close();
}

%>
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
				ps1 = conn.prepareStatement("select * from admin where email = ?");
				ps1.setString(1, user);
				rs = ps1.executeQuery();
				if(rs.next() && rs.getInt(6) == 0)
						{
							final String uid = UUID.randomUUID().toString().replace("-", "");
							Date  ct = new Date();
							long time = ct.getTime();
							System.out.println(uid + " " + time);
							String subject = "[Hostel Feedback System] Email Verification";
							String msg = "The administrator of the Hostel Feedback System has invited you as the administrator for the hostel/department under your supervision. Please click the link below to verify yourself.\n";
							msg += "http://" + mailRedirectURL + "/admin/activation/?id=" + uid + "&user=" + user;
							msg += "\n\nIf u can't click the link then copy the link in the address bar and then press enter.\n";
							msg += "If you think that this mail is not for you, then please disregard this mail and no action will be taken.\n\n";
							msg += "Hostel Feedback System";
							ps1 = conn.prepareStatement("update admin set otp = ?, otpTime = ? where email = ?");
							ps1.setString(1, uid);
							ps1.setLong(2, time);
							ps1.setString(3, user);
							ps1.executeUpdate();
							sendMail("b15cs154@cit.ac.in", subject, msg); // change it....
							conn.close();
							session.setAttribute("status", "inProcess");
							%>
							<script>document.location = "/hostelFeedback/activation.jsp"</script>
							<%
						}
				else
				{
				%>
					<script>document.location = "/hostelFeedback/admin/"</script>
				<%		
				conn.close();
				}
			}
			else
			{
			%>
				<script>document.location = "/hostelFeedback/admin/"</script>
			<%	
			}
		}
	catch(Exception e) {
		%>
		<jsp:forward page="/error/"></jsp:forward>
		<%
	}
%>