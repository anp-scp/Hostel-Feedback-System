<%@page import="java.util.Date"%>
<%@page import="com.sun.mail.smtp.SMTPTransport"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.Session"%>
<%@page import="java.util.Properties"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.security.cert.CertPathValidatorException.Reason"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page import = "java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import = "javax.servlet.http.*" %>
<%@ page import = "org.apache.commons.fileupload.*" %>
<%@ page import = "org.apache.commons.fileupload.disk.*" %>
<%@ page import = "org.apache.commons.fileupload.servlet.*" %>
<%@ page import = "org.apache.commons.io.output.*" %>
<%@ include file="jspConfig.jsp" %>
<%@ include file="mail.jsp" %>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
	
		try {
			if(session.getAttribute("user") == null && "POST".equals(request.getMethod()) == false)
			{
			%>
			<script>document.location = "/hostelFeedback/"</script>
			<% 
			}
			else
			{	
				String roll = (String)session.getAttribute("user");
				String subject = "";
				String msg = "";
				//String hostel = "";
				//String room = "";
				String type = "";
				String alert = "";
				String hostel = "";
				String contentType1 = request.getContentType();
				int maxFileSize = 5000 * 1024;
				int maxMemSize = 5000 * 1024;
				ServletContext context = pageContext.getServletContext();
				   if ((contentType1.indexOf("multipart/form-data") >= 0)) {
				      DiskFileItemFactory factory1 = new DiskFileItemFactory();
				   	  // maximum size that will be stored in memory
				      factory1.setSizeThreshold(maxMemSize);
				      // Location to save data that is larger than maxMemSize.
				      //factory1.setRepository(new File("c:\\temp"));
				      
				      // Create a new file upload handler
				      ServletFileUpload upload1 = new ServletFileUpload(factory1);
				      
				   // maximum file size to be uploaded.
				      upload1.setSizeMax( maxFileSize );
				       
				         // Parse the request to get file items.
				         List fileItems1 = upload1.parseRequest(request);

				         // Process the uploaded file items
				          Iterator i1 = fileItems1.iterator();

				         FileItem fi1;
				         String name = "";
				         String param = "";
				         while ( i1.hasNext () ) {
				            fi1 = (FileItem)i1.next();
				            if ( fi1.isFormField () ) {
				               // Get the uploaded file parameters
				              name = fi1.getFieldName();
				              param = fi1.getString();
				              //if(name.equals("hostel"))
				            	//  hostel = param;
				              //else if(name.equals("roomNo"))
				            	//  room = param;
				              if(name.equals("type"))
				            	  type = param;
				              else if(name.equals("subject"))
				            	  subject = param;
				              else if(name.equals("message"))
				            	  msg = param;
				            	  
				            }
				            if(name.equals("message"))
				            	break;
				         }
				      
				  // 
				
				
				
				String to = "";
				
				//msg += "\n\nStudent's Hostel: " + hostel + "\nRoom No.: " + room;
				Class.forName("com.mysql.jdbc.Driver");
				Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
				PreparedStatement ps;
				ResultSet rs;
				ps = conn.prepareStatement("select data,hostel from student where email = ?");
				ps.setString(1, roll);
				rs = ps.executeQuery();
				rs.next();
				String data = rs.getString(1);
				hostel = rs.getString(2);
				//ps = conn.prepareStatement("select email from hostelAdmin where hostel = ? union select email from typeOfMessageAdmin where type = ?");
				//ps.setString(1, hostel);
				//ps.setString(2, type);
				//rs = ps.executeQuery();
				//while(rs.next())
				//{
				//	to = rs.getString(1);
					//sendMail(to,"[Hostel Feedback System] New message recieved","There is an update. Please check your account" + "\n\n\nNote:This message was sent via the Hostel Feedback System by " + session.getAttribute("name") + "\nEmail ID:" + roll + "@cit.ac.in");
				//}
				ps = conn.prepareStatement("insert into message (user,type,subject,msg,ref_group) values (?,?,?,?,?)");
				ps.setString(1, roll);
				ps.setString(2, type);
				ps.setString(3, subject);
				ps.setString(4, msg);
				ps.setString(5, "student");
				ps.executeUpdate();
				//ps = conn.prepareStatement("update student set hostel = ? where email = ?");
				//ps.setString(1, hostel);
				//ps.setString(2, roll);
				//ps.executeUpdate();
				ps = conn.prepareStatement("select msgId from message where user = ? order by msgId desc");
				ps.setString(1, roll);
				rs = ps.executeQuery();
				rs.next();
				int id = rs.getInt(1);
				ps.close();
				
				/*  
					code to sent parallel mails to site admin
					sendMail(to,"[Hostel Feedback System] New message recieved",subject + "\n\n\n" +  msg + "\n\n\nNote:This message was semt via the Hostel Feedback System by " + session.getAttribute("name") + "\nEmail ID:" + roll + "@cit.ac.in");
				*/
				
				 File file ;
				   
				   File newPath = new File(storageURL + data + "/" + id);
				   if(newPath.isDirectory() == false)
					   newPath.mkdir();
				   String filePath = storageURL + data + "/" + id + "/";

				   
				   
				   //if ((contentType1.indexOf("multipart/form-data") >= 0)) 
				      DiskFileItemFactory factory = new DiskFileItemFactory();
				      try { 
				         // Parse the request to get file items.
				         //List fileItems = upload.parseRequest(request);

				         // Process the uploaded file items
				         //Iterator i = fileItems.iterator();

				         
				         
				         while(i1.hasNext()) {
				            fi1 = (FileItem)i1.next();
				            if ( !fi1.isFormField () ) {
				               // Get the uploaded file parameters
				               String fieldName = fi1.getFieldName();
				               String fileName = fi1.getName();
				               fileName = fileName.replace(" ", "");
				               if(fileName.equals("") == false )
				               {
				            	   boolean isInMemory = fi1.isInMemory();
					               long sizeInBytes = fi1.getSize();
					            
					               // Write the file
					               
					               if( fileName.lastIndexOf("/") >= 0 ) {
					                  file = new File( filePath + 
					                  fileName.substring( fileName.lastIndexOf("/"))) ;
					               } else {
					                  file = new File( filePath + 
					                  fileName.substring(fileName.lastIndexOf("/")+1)) ;
					               }
					               fi1.write( file ) ;
				               }
				            }
				         }
				      } catch(Exception ex) {
				      }
				   } else {
				      
				   }
				
				alert = "Message Sent...";
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