<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page trimDirectiveWhitespaces="true" %>
<%@ include file="jspConfig.jsp" %>
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
		String id = request.getParameter("id");
		String by = request.getParameter("by");
		System.out.println(request.getHeader("User-Agent"));
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
		PreparedStatement ps;
		ResultSet rs;
		ps = conn.prepareStatement("select data from student where email = ?");
		ps.setString(1, roll);
		rs = ps.executeQuery();
		rs.next();
		String data = "";
		String data1 = rs.getString(1);
		if(by.equals("user") == false)
		{
			PreparedStatement ps1 = conn.prepareStatement("select data from admin where email = ?");
			ps1.setString(1, by);
			ResultSet rs1 = ps1.executeQuery();
			rs1.next();
			data = rs1.getString(1);
		}
		else
			data = data1;
		//PrintWriter out = response.getWriter();
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