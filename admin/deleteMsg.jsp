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
				String[] msg = request.getParameterValues("msgItem");
				String status = request.getParameter("status");
				int st = -1;
				if(status.equals("Pending"))
					st = -1;
				else if(status.equals("Accepted_and_Under_Process"))
					st = 0;
				else if(status.equals("Resolved"))
					st = 1;
				else if(status.equals("Closed"))
					st = 2;
				String alert = "";
				int i = 0;
				Class.forName("com.mysql.jdbc.Driver");
				Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
				PreparedStatement ps;
				ResultSet rs;
				for(i = 0;i<msg.length;i++)
				{
					ps = conn.prepareStatement("update message set status = ? where msgID = ?");
					ps.setInt(1, st);
					ps.setInt(2, Integer.parseInt(msg[i]));
					ps.executeUpdate();
				}
				alert = "Status updated...";
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
	catch(Exception e) {
		%>
		<jsp:forward page="/error/"></jsp:forward>
		<%
	}
	
%>