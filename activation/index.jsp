<%@page import="java.util.Date"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ include file="/jspConfig.jsp" %>
<%
		try {
			String alert = "";
			String uid = request.getParameter("id");
			String user = request.getParameter("user");
			if(uid != null && user != null)
			{
				Class.forName("com.mysql.jdbc.Driver");
				Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
				PreparedStatement ps = conn.prepareStatement("select otp,otpTime,name,verified from student where email = ?");
				ps.setString(1, request.getParameter("user"));
				ResultSet rs = ps.executeQuery();
				if(rs.next())
				{
					if(rs.getInt(4) == 0)
					{
						if(rs.getString(1).equals(uid))
						{
							Date cd = new Date();
							long currentTime = cd.getTime();
							long registeredTime = rs.getLong(2);
							long timediff = currentTime - registeredTime;
							timediff = timediff/1000L;
							timediff = timediff/3600L;
							if(timediff < 12L)//chnge it
							{
								session.setAttribute("user", request.getParameter("user"));
								session.setAttribute("name", rs.getString(3));
								session.setAttribute("type", "student");
								alert = "Great!!! You are verified now...";
								session.setAttribute("alert", alert);
								ps = conn.prepareStatement("update student set otp = '-1',verified = 1,otpTime = -1 where email = ?");
								ps.setString(1, user);
								ps.executeUpdate();
								conn.close();
								%>	
								<script>document.location = "/hostelFeedback/";</script>
								<%	
							}
							else
							{
								alert = "The link you tried was expired.... <a href='/hostelFeedback/resend.jsp?user=" + user + "' > Click here to resend the mail.</a>";
								session.setAttribute("alert", alert);
								ps = conn.prepareStatement("update student set otp = '-1',verified = 0,otpTime = -1 where email = ?");
								ps.setString(1, user);
								ps.executeUpdate();
								ps.close();
								conn.close();
								%>	
								<script>document.location = "/hostelFeedback/";</script>
								<%					
							}
									
						}
						else
						{
							alert="Something went wrong...";
							session.setAttribute("alert", alert);
							%>	
							<script type="text/javascript">document.location = "/hostelFeedback/";</script>
							<%
						}
					}
					else
					{
						alert="You are already verified. Please login here...";
						session.setAttribute("alert", alert);
						%>	
						<script type="text/javascript">document.location = "/hostelFeedback/";</script>
						<%
					}
				conn.close();
				}
				else
				{
				alert = "The account linked with this link is not found...";
				session.setAttribute("alert", alert);
				conn.close();
				%>
				<script type="text/javascript">document.location = "/hostelFeedback/";</script>
				<%
				
				}
			}
			else
			{
				%>
				<script type="text/javascript">document.location = "/hostelFeedback/";</script>
				<%
			}
		}
	catch(Exception e) {
		%>
		<jsp:forward page="/error/"></jsp:forward>
		<%
	}
	
%>