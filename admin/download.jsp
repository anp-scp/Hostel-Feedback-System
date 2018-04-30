<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ include file="/jspConfig.jsp" %>
<%@page trimDirectiveWhitespaces="true" %>
<%    
try {
	if("admin".equals((String)session.getAttribute("type")) == false)
	{
	%>
	<script>document.location = "/hostelFeedback/admin"</script>
	<% 
	}
	else
	{	
		String id = request.getParameter("id");
		String by = request.getParameter("by");
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
		PreparedStatement ps;
		ResultSet rs;
		String data = "";
		ps = conn.prepareStatement("select data from (select data,email from admin union select data,email from student) a where email = ?");
		ps.setString(1, by);
		rs = ps.executeQuery();
		rs.next();
		data = rs.getString(1);
		String filename = request.getParameter("file");
		String filepath = "";
		if(id.equals("noId"))
		{
			filename = "noprofile.jpg";
			filepath = storageURL + data + "/";
			File profilePath = new File(filepath);
			File profileImage = null;
			if(profilePath.isDirectory()) 
			{
				for(String each:profilePath.list()) 
				{
					profileImage = new File(filepath + each);
					if(profileImage.isFile())
					{
						if(each.substring(0,each.lastIndexOf(".")).equals("profile"))
						{
							filename = each;
							break;
						}
					}
				}				
			}
		}
		else
			filepath = storageURL + data + "/" + id + "/";
		response.setContentType("APPLICATION/OCTET-STREAM");   
		response.setHeader("Content-Disposition","attachment; filename=" + filename);   
		File file = new File(filepath + filename);
		FileInputStream fileIn = new FileInputStream(file);
		ServletOutputStream out1 = response.getOutputStream();
		byte[] outputByte = new byte[(int)file.length()];
        //copy binary contect to output stream
        while(fileIn.read(outputByte, 0, (int)file.length()) != -1)
        {
        out1.write(outputByte, 0, (int)file.length());
        }
        fileIn.close();
	}
}
catch(Exception e) {
%>
<jsp:forward page="/error/"></jsp:forward>
<%
}
%>    