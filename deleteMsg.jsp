<%@page import="java.io.File"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.security.cert.CertPathValidatorException.Reason"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ include file="jspConfig.jsp" %>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
	
		try{
			if(session.getAttribute("user") == null)
			{
			%>
			<p>Authentication failed</p>
			<% 
			}
			else
			{	
				String roll = (String)session.getAttribute("user");
				String[] msg = request.getParameterValues("msgItem");
				String alert = "";
				String data1 = "";
				String data = "";
				String user = "";
				int i = 0;
				int ids;
				File file;
				Class.forName("com.mysql.jdbc.Driver");
				Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
				PreparedStatement ps;
				ResultSet rs;
				ps = conn.prepareStatement("select data from student where email = ?");
				ps.setString(1, roll);
				rs = ps.executeQuery();
				rs.next();
				data1 = rs.getString(1);
				for(i = 0;i<msg.length;i++)
				{
					ps = conn.prepareStatement("select * from message where msgId = ?");
					ps.setInt(1, Integer.parseInt(msg[i]));
					rs = ps.executeQuery();
					rs.next();
					if(rs.getInt(9) == 0)
						continue;
					if(rs.getString(1).equals("admin"))
					{
						data = "cda15f410a0848d4ad4217d15bdeadb6";
					}
					else
						data = data1;
					file = new File(storageURL + data + "/" + msg[i] + "/");
					if(file.isDirectory())
					{
						for(File each:file.listFiles())
						{
							each.delete();
						}
						file.delete();
					}
					ps = conn.prepareStatement("select * from message where repliedToId = ?");
					ps.setInt(1, Integer.parseInt(msg[i]));
					rs = ps.executeQuery();
					while(rs.next())
					{
						if(rs.getString(1).equals("admin"))
						{
							data = "cda15f410a0848d4ad4217d15bdeadb6";
						}
						else
							data = data1;
						file = new File(storageURL + data + "/" + rs.getInt(2) + "/");
						if(file.isDirectory())
						{
							for(File each:file.listFiles())
							{
								each.delete();
							}
							file.delete();
						}
					}
				}
				boolean all = false;
				for(i = 0;i<msg.length;i++)
				{
					ps = conn.prepareStatement("select status from message where msgId = ?");
					ps.setInt(1, Integer.parseInt(msg[i]));
					rs = ps.executeQuery();
					rs.next();
					if(rs.getInt(1) == 0)
					{
						all = true;
						continue;
					}
					ps = conn.prepareStatement("delete from message where repliedToId = ?");
					ps.setInt(1, Integer.parseInt(msg[i]));
					ps.executeUpdate();
					ps = conn.prepareStatement("delete from message where msgId = ?");
					ps.setInt(1, Integer.parseInt(msg[i]));
					ps.executeUpdate();
				}
				alert = "Messages deleted....";
				if(all)
					alert += "But some of the messages were not deleted as they are accepted by admin and are under process.";
				session.setAttribute("alert", alert);
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