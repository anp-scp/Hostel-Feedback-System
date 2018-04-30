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
			String roll = (String)session.getAttribute("user");
			String id = request.getParameter("location");
			String repliedToWhom = "";
			String repliedTo="";
			String type = (String)request.getParameter("type");
			String reference = "";
			String replyingSubject = "";
			String subject = "";
			String replyingId = id;
			String category = "";
			if(type.equals("sent"))
				reference = "admin";
			if(type.equals("recieved"))
				reference = request.getParameter("reference");
			int replied;
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
			PreparedStatement ps;
			ResultSet rs;
			ps = conn.prepareStatement("select * from message where user = ? and msgId = ?");
			ps.setString(1, reference);
			ps.setInt(2, Integer.parseInt(id));
			rs = ps.executeQuery();
			if(rs.next())
			{
				category = rs.getString(3);
				if(rs.getInt(6) == -1)
					subject = rs.getString(4);
				else
					subject = "Re:" + rs.getString(4);
			%>
				<div class="modal-header">
					<h5 class="modal-title mx-auto" id="exampleModalLongTitle"><c:out value="<%=subject %>"></c:out></h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<p style="white-space: pre-wrap;"><c:out value="<%=rs.getString(5) %>"></c:out></p>
					<%
						replyingSubject = rs.getString(4);
						while(rs.getInt(6) != -1)
						{
							replied = rs.getInt(6);
							repliedToWhom = rs.getString(7);
							if(repliedToWhom.equals("admin"))
								ps = conn.prepareStatement("select * from message join student where msgId = ?");
							else
								ps = conn.prepareStatement("select * from message join student where msgId = ? and message.user = student.email");
							ps.setInt(1, replied);
							rs = ps.executeQuery();
							if(rs.next() == false)
								break;
							if(rs.getInt(6) == -1)
								subject = rs.getString(4);
							else
								subject = "Re:" + rs.getString(4);
							if(repliedToWhom.equals("admin"))
								repliedTo = "You";
							else 
								repliedTo = rs.getString(13);
							%>
							<hr style="display: block; height: 1px; border-top: 1px solid #eff0f1;">
							<p>On <%=rs.getString(8) %> <%=repliedTo %> wrote :</p>
							<div class="replyMsg">
								<p>Subject: <c:out value="<%=subject %>"></c:out></p>
								<p style="white-space: pre-wrap;"><c:out value="<%=rs.getString(5) %>"></c:out></p>
							</div>
						<%	
						}
					
					%>
					<form action="replyMsg.jsp" method="post">
						<div class="form-group">
							<input type="hidden" name="replyingSubject" value="<%= replyingSubject%>">
							<input type="hidden" name="type" value="<%= category %>">
							<input type="hidden" name="replyingId" value="<%= replyingId%>">
							<input type="hidden" name="rtw" value="<%= reference %>">
							<textarea class="form-control" name="reply" rows="5" cols="10" required="required" placeholder="Enter your reply here...."><c:out value="${param.reply}" /></textarea>
						</div>
						<div class="form-group">
							<button type="submit" class="btn btn-primary">Reply</button>
						</div>
					</form>
				</div>
				<div class="modal-footer">
				    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				</div>
			<%}
			conn.close();
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