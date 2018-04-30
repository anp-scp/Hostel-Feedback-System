<%@page import="java.nio.file.Files"%>
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
			if(session.getAttribute("user") == null)
			{
			%>
			<script>document.location = "/hostelFeedback/"</script>
			<% 
			}
			else
			{	
				String roll = (String)session.getAttribute("user");
				String pname = "";
				int room = 0;
				String hostel = "";
				String alert = "";
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
				              if(name.equals("name"))
					              	pname = param;
				              else if(name.equals("roomNo"))
					              	room = Integer.parseInt(param);
				              else if(name.equals("hostel"))
				              	hostel = param; 
				            }
				            if(name.equals("hostel"))
				            	break;
				         }
				      
				  // 
				
				Class.forName("com.mysql.jdbc.Driver");
				Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
				PreparedStatement ps;
				ResultSet rs;
				ps = conn.prepareStatement("select data from student where email = ?");
				ps.setString(1, roll);
				rs = ps.executeQuery();
				rs.next();
				String data = rs.getString(1);
				ps = conn.prepareStatement("update student set name = ?,hostel = ?,roomNo = ? where email = ?");
				ps.setString(1, pname);
				ps.setString(2, hostel);
				ps.setInt(3, room);
				ps.setString(4, roll);
				ps.executeUpdate();
				ps.close();
				 File file ;
				   
				   File newPath = new File(storageURL + data + "/");
				   if(newPath.isDirectory() == false)
					   newPath.mkdir();
				   String filePath = storageURL + data + "/";

				   // delete other profile image before uploading a new one
				    String filepath = storageURL + data + "/";
					File profilePath = new File(filepath);
					File profileImage = new File("");
					if(profilePath.isDirectory()) 
					{
						for(String each:profilePath.list()) 
						{
							profileImage = new File(filePath + each);
							if(profileImage.isFile())
							{
								if(each.substring(0,each.lastIndexOf(".")).equals("profile"))
								{
									Files.delete(profileImage.toPath());
								}
							}
						}				
					}
				   
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
				            	   String ext = fileName.substring(fileName.lastIndexOf("."));
				            	   fileName = "profile" + ext;
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
				
				alert = "Profile Updated...";
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