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
				if(request.getParameter("email") != null)
				{
					String email = request.getParameter("email");
					String alert = "";
					Class.forName("com.mysql.jdbc.Driver");
					Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
					PreparedStatement ps;
					ResultSet rs;
					ps = conn.prepareStatement("delete from emailReciepents where emailId = ?");
					ps.setString(1, email);
					ps.executeUpdate();
					alert = "Email deleted...";
					session.setAttribute("alert", alert);
					%>
					<script>document.location = "/hostelFeedback/admin"</script>
					<%
				}
				else if(request.getParameter("hostel") != null)
				{
					String hostel = request.getParameter("hostel");
					String alert = "";
					Class.forName("com.mysql.jdbc.Driver");
					Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
					PreparedStatement ps;
					ResultSet rs;
					ps = conn.prepareStatement("select * from student where hostel = ?");
					ps.setString(1, hostel);
					rs = ps.executeQuery();
					if(rs.next())
					{
						alert = "Can't delete this hostel. There are lot of students who still belongsto this hostel. ";
						session.setAttribute("alert", alert);
					}
					else
					{
						ps = conn.prepareStatement("delete from hostelAdmin where hostel = ?");
						ps.setString(1, hostel);
						ps.executeUpdate();
						ps = conn.prepareStatement("delete from hostel where name = ?");
						ps.setString(1, hostel);
						ps.executeUpdate();
						alert = "Hostel removed...";
						session.setAttribute("alert", alert);
					}
					%>
					<script>document.location = "/hostelFeedback/admin"</script>
					<%
				}
				else if(request.getParameter("type") != null)
				{
					String type = request.getParameter("type");
					String alert = "";
					Class.forName("com.mysql.jdbc.Driver");
					Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
					PreparedStatement ps;
					ResultSet rs;
					ps = conn.prepareStatement("delete from typeOfMessageAdmin where type = ?");
					ps.setString(1, type);
					ps.executeUpdate();
					ps = conn.prepareStatement("delete from typeOfMessage where type = ?");
					ps.setString(1, type);
					ps.executeUpdate();
					alert = "Category removed...";
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
	catch(Exception e) {
		%>
		<jsp:forward page="/error/"></jsp:forward>
		<%
	}
%>