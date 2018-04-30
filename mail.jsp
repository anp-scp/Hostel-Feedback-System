<%@page import="com.sun.mail.smtp.SMTPTransport"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.Session"%>
<%@page import="java.util.Properties"%>
<%@page import="java.util.Date"%>
<%!
public static void sendMail(String to,String subject,String mail) throws Exception {

	String SMTPHost = "";
	String mailUser = "";
	String mailPass = "";
	
    Properties props = System.getProperties();
    props.put("mail.smtps.host", "smtp.mailgun.org");
    props.put("mail.smtps.auth", "true");

    Session session = Session.getInstance(props, null);
    Message msg = new MimeMessage(session);
    msg.setFrom(new InternetAddress(mailUser));
    InternetAddress[] addrs = InternetAddress.parse(to, false);
    msg.setRecipients(Message.RecipientType.TO, addrs);

    msg.setSubject(subject);
    msg.setText(mail);
    msg.setSentDate(new Date());

    SMTPTransport t =
        (SMTPTransport) session.getTransport("smtps");
    t.connect(SMTPHost, mailUser, mailPass);
    t.sendMessage(msg, msg.getAllRecipients());

    //System.out.println("Response: " + t.getLastServerResponse());

    t.close();
}

%>