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
				Class.forName("com.mysql.jdbc.Driver");
				Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
				PreparedStatement ps;
				ResultSet rs;
				boolean found;
				String key = request.getParameter("searchKey");
				String type = request.getParameter("searchType");
				String email = "";
				if(type.equals("rollNo"))
				{
					key = key.toUpperCase();
					ps = conn.prepareStatement("select name,rollNo,email,branch,module from student where email != 'admin'");
					rs = ps.executeQuery();
					while(rs.next())
					{
						if(rs.getString(2).contains(key))
						{
								email = rs.getString(3) + "@cit.ac.in";
								%>
								<tr>
						        <td class="studItem"  data-toggle="modal" data-target="#exampleModalLong" data-roll="<c:out value="<%=rs.getString(2) %>"></c:out>"><c:out value="<%=rs.getString(1) %>"></c:out></td>
						        <td class="studItem"  data-toggle="modal" data-target="#exampleModalLong" data-roll="<c:out value="<%=rs.getString(2) %>"></c:out>"><c:out value="<%=rs.getString(2) %>"></c:out></td>
						        <td class="studItem"  data-toggle="modal" data-target="#exampleModalLong" data-roll="<c:out value="<%=rs.getString(2) %>"></c:out>"><c:out value="<%=email %>"></c:out></td>
						        <td class="studItem"  data-toggle="modal" data-target="#exampleModalLong" data-roll="<c:out value="<%=rs.getString(2) %>"></c:out>"><c:out value="<%=rs.getString(4) %>"></c:out></td>
						        <td class="studItem"  data-toggle="modal" data-target="#exampleModalLong" data-roll="<c:out value="<%=rs.getString(2) %>"></c:out>"><c:out value="<%=rs.getString(5) %>"></c:out></td>
							    </tr>
								<%
							
						}
					}
				}
				else if(type.equals("name"))
				{
					key = key.toUpperCase();
					ps = conn.prepareStatement("select name,rollNo,email,branch,module from student where email != 'admin'");
					rs = ps.executeQuery();
					while(rs.next())
					{
						if(rs.getString(1).toUpperCase().contains(key))
						{
								email = rs.getString(3) + "@cit.ac.in";
								%>
								<tr>
						        <td class="studItem"  data-toggle="modal" data-target="#exampleModalLong" data-roll="<c:out value="<%=rs.getString(2) %>"></c:out>"><c:out value="<%=rs.getString(1) %>"></c:out></td>
						        <td class="studItem"  data-toggle="modal" data-target="#exampleModalLong" data-roll="<c:out value="<%=rs.getString(2) %>"></c:out>"><c:out value="<%=rs.getString(2) %>"></c:out></td>
						        <td class="studItem"  data-toggle="modal" data-target="#exampleModalLong" data-roll="<c:out value="<%=rs.getString(2) %>"></c:out>"><c:out value="<%=email %>"></c:out></td>
						        <td class="studItem"  data-toggle="modal" data-target="#exampleModalLong" data-roll="<c:out value="<%=rs.getString(2) %>"></c:out>"><c:out value="<%=rs.getString(4) %>"></c:out></td>
						        <td class="studItem"  data-toggle="modal" data-target="#exampleModalLong" data-roll="<c:out value="<%=rs.getString(2) %>"></c:out>"><c:out value="<%=rs.getString(5) %>"></c:out></td>
							    </tr>
								<%
						}
					}
				}
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