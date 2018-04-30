<%@page import="java.sql.ResultSet"%>
<%@page import="java.security.cert.CertPathValidatorException.Reason"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ include file="jspConfig.jsp" %>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
	
		try {
			if(session.getAttribute("user") == null)
			{
			%>
			<p>Authentication failed</p>
			<% 
			}
			else
			{	
				Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
				PreparedStatement ps;
				ResultSet rs;
				String sql1 = "select * from message join student where message.user = student.email and user != 'admin' order by timeStamp desc";
				String key = request.getParameter("searchKey");
				String type = request.getParameter("serachType");
				String referenceNo = "";
				String subject = "";
				ps = conn.prepareStatement(sql1);
				rs = ps.executeQuery();
				while(rs.next())
				{
					referenceNo = rs.getString(9) + "/" + rs.getString(8).substring(0, 10) + "/" + rs.getInt(2);
					if(rs.getInt(6) == -1)
						subject = rs.getString(4);
					else
						subject = "Re:" + rs.getString(4);
			  	%>
				    <tr class="<%=rs.getString(3) %>">
				      <th scope="row"><input type="checkbox" name="msgItem" value="<%=rs.getString(2)%>"></th>
				      <td><a class="msgItem" href="#" data-toggle="modal" data-target="#exampleModalLong" data-location="<%=rs.getString(2) %>" data-type="recieved" data-reference="<%=rs.getString(1) %>"><c:out value="<%=rs.getString(11) %>"></c:out></a></td>
				       <td><a class="msgItem" href="#" data-toggle="modal" data-target="#exampleModalLong" data-location="<%=rs.getString(2) %>" data-type="recieved" data-reference="<%=rs.getString(1) %>"><c:out value="<%=rs.getString(3) %>"></c:out></a></td>   
				      <td><a class="msgItem" href="#" data-toggle="modal" data-target="#exampleModalLong" data-location="<%=rs.getString(2) %>" data-type="recieved" data-reference="<%=rs.getString(1) %>"><c:out value="<%=subject %>"></c:out></a></td>
				      <td><a class="msgItem" href="#" data-toggle="modal" data-target="#exampleModalLong" data-location="<%=rs.getString(2) %>" data-type="recieved" data-reference="<%=rs.getString(1) %>"><c:out value="<%=rs.getString(8) %>"></c:out></a></td>
				      <td><a class="msgItem" href="#" data-toggle="modal" data-target="#exampleModalLong" data-location="<%=rs.getString(2) %>" data-type="recieved" data-reference="<%=rs.getString(1) %>"><c:out value="<%=referenceNo %>"></c:out></a></td>
				    </tr>
				<%
				}
			}
		}
	catch(Exception e) {
		%>
		<jsp:forward page="/error/"></jsp:forward>
		<%
	}
		%>