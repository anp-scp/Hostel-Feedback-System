<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
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
		
			if(session.getAttribute("user") == null)
			{
			%>
			<p>Authentication failed</p>
			<% 
			}
			else
			{	
				try{
					String roll = (String)session.getAttribute("user");
					String id = request.getParameter("location");
					String tempId = id;
					int view;
					String repliedBy = "";
					String replyingSubject = "";
					String subject = "";
					String category = "";
					String dateS = "";
					Date date = new Date();
					SimpleDateFormat dt1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					SimpleDateFormat dt2 = new SimpleDateFormat("dd-MM-yyyy E");
					SimpleDateFormat dt3 = new SimpleDateFormat("hh:mm aa");
					int status = -1;
					Class.forName("com.mysql.jdbc.Driver");
					Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
					PreparedStatement ps;
					ResultSet rs;
					ps = conn.prepareStatement("select data from student where email = ?");
					ps.setString(1, roll);
					rs = ps.executeQuery();
					rs.next();
					String data1 = rs.getString(1);
					String data = data1;
					ps = conn.prepareStatement("select * from message where msgId = ?");
					ps.setInt(1, Integer.parseInt(id));
					rs = ps.executeQuery();
					if(rs.next())
					{
						view = rs.getInt(10);
						status = rs.getInt(9);
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
							<p class="senderTitle" style="font-weight:bold"><a href="#" style="text-decoration: none;">You wrote:<i class="fa fa-question-circle" aria-hidden="true"></i></a></p>
							<div class="msgDetails">
								<p style="font-size: 11px;">Date: <%= dt2.format(date) %></p>
								<p style="font-size: 11px;">Time: <%= dt3.format(date) %></p>
							</div>
							<p style="white-space: pre-wrap;"><c:out value="<%=rs.getString(5) %>"></c:out></p>
							<%
							File path = new File(storageURL + data + "/" + id);
							if(path.isDirectory() && (path.list().length > 0))
							{
								%>
								<hr style="display: block; height: 1px; border-top: 1px solid #eff0f1;">
								<p style="font-size: 15px;">Attachments are:</p>
								<ol>
								<% 
								String[] dirItem = path.list();
								for(String each:dirItem)
								{
									%>
									<li><a href="download.jsp?id=<%=id %>&file=<c:out value="<%=each %>"></c:out>&by=user"><c:out value="<%=each %>"></c:out></a></li>
									<%
								}
							}
							%>
							</ol>
							<%
								int otherIds;
								String by = "";
								replyingSubject = rs.getString(4);
								ps = conn.prepareStatement("select * from message where repliedToId = ?");
								ps.setInt(1, rs.getInt(2));
								rs = ps.executeQuery();
								while(rs.next())
								{
									otherIds = rs.getInt(2);
									if(rs.getString(7).equals("admin"))
									{
										PreparedStatement ps1 = conn.prepareStatement("select name,data from admin where email = ?");
										ps1.setString(1, rs.getString(1));
										ResultSet rs1 = ps1.executeQuery();
										rs1.next();
										repliedBy = rs1.getString(1);
										data = rs1.getString(2);
										by = rs.getString(1);
									}
									else
									{
										repliedBy = "You";
										data = data1;
										by  = "user";
									}
									dateS = rs.getString(8);
									date = dt1.parse(dateS);
									%>
									<hr style="display: block; height: 1px; border-top: 1px solid #c0cbd6;">
									<p class="senderTitle" style="font-weight:bold;"><a href="#" style="text-decoration: none;"><%=repliedBy %> replied :<i class="fa fa-question-circle" aria-hidden="true"></i></a></p>
									<div class="msgDetails">
										<p style="font-size: 11px;">Date: <%= dt2.format(date) %></p>
										<p style="font-size: 11px;">Time: <%= dt3.format(date) %></p>
									</div>
									<div class="replyMsg">
										<p style="white-space: pre-wrap;"><c:out value="<%=rs.getString(5) %>"></c:out></p>
										<%
										path = new File(storageURL + data + "/" + otherIds);
										if(path.isDirectory() && (path.list().length > 0))
										{
											%>
											<hr style="display: block; height: 1px; border-top: 1px solid #eff0f1;">
											<p style="font-size: 15px;">Attachments are:</p>
											<ol>
											<% 
											String[] dirItem = path.list();
											for(String each:dirItem)
											{
												%>
												<li><a href="download.jsp?id=<%=otherIds %>&file=<c:out value="<%=each %>"></c:out>&by=<%=by%>"><c:out value="<%=each %>"></c:out></a></li>
												<%
											}
										}
										%>
										</ol>
									</div>
									<%
								}
							if(status != 2)
							{
							%>
							
							<form action="replyMsg.jsp" method="post" enctype="multipart/form-data">
								<div class="form-group">
									<input type="hidden" name="replyingSubject" value="<%= replyingSubject%>">
									<input type="hidden" name="type" value="<%= category %>">
									<input type="hidden" name="replyingId" value="<%= id%>">
									<textarea class="form-control" name="reply" rows="5" cols="10" required="required" placeholder="Enter your reply here...."><c:out value="${param.reply}" /></textarea>
								</div>
								<div class="form-group">
									<input class="form-control-file" type = "file" name = "file" size = "50" />
								</div>
								<div class="form-group">
									<input class="form-control-file" type = "file" name = "file1" size = "50" />
								</div>
								<div class="form-group">
									<input class="form-control-file" type = "file" name = "file2" size = "50" />
								</div>
								<div class="form-group">
									<button type="submit" class="btn btn-primary">Reply</button>
								</div>
							</form>
							<%
							}
							%>
					</div>
					<div class="modal-footer">
					    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
					</div>
				<%
						if(view == 2)
						{
							ps = conn.prepareStatement("update message set viewed = 1 where msgId = ?");
							ps.setInt(1, Integer.parseInt(tempId));
							ps.executeUpdate();
						}				
					}
				conn.close();
				}
				catch(Exception e){
					%>
					<jsp:forward page="/error/"></jsp:forward>
					<%
				}
			}
		
		%>