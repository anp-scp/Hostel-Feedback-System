<%@page import="java.sql.ResultSet"%>
<%@page import="java.security.cert.CertPathValidatorException.Reason"%>
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
				String alert ="";
				if(request.getParameter("emailrec") != null)
				{
					String email = request.getParameter("emailrec");
					Class.forName("com.mysql.jdbc.Driver");
					Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
					PreparedStatement ps;
					ResultSet rs;
					ps = conn.prepareStatement("insert into emailReciepents(emailId) values(?)");
					ps.setString(1, email);
					ps.executeUpdate();
					conn.close();
					alert = "Email Added";
					session.setAttribute("alert", alert);
					%>
					<script>document.location = "/hostelFeedback/admin"</script>
					<%
				}
				else if(request.getParameter("hostel") != null)
				{
					String hostel = request.getParameter("hostel");
					Class.forName("com.mysql.jdbc.Driver");
					Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
					PreparedStatement ps;
					ResultSet rs;
					ps = conn.prepareStatement("insert into hostel(name) values(?)");
					ps.setString(1, hostel);
					ps.executeUpdate();
					conn.close();
					alert = "Hostel Added";
					session.setAttribute("alert", alert);
					%>
					<script>document.location = "/hostelFeedback/admin"</script>
					<%
				}
				else if(request.getParameter("type") != null)
				{
					String type = request.getParameter("type");
					Class.forName("com.mysql.jdbc.Driver");
					Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
					PreparedStatement ps;
					ResultSet rs;
					ps = conn.prepareStatement("insert into typeOfMessage(type) values(?)");
					ps.setString(1, type);
					ps.executeUpdate();
					conn.close();
					alert = "New Category Created...";
					session.setAttribute("alert", alert);
					%>
					<script>document.location = "/hostelFeedback/admin"</script>
					<%
				}
				else
				{
				%>
				<script>document.location = "/hostelFeedback/admin"</script>
				<% 
				}
			}
			else
			{
			%>
			<script>document.location = "/hostelFeedback/admin"</script>
			<% 
			}
		}
	catch(Exception e){
		%>
		<jsp:forward page="/error/"></jsp:forward>
		<%
	}
		%>