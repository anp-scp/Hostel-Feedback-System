<%@page import="java.math.BigInteger"%>
<%@page import="java.security.SecureRandom"%>
<%@page import="javax.crypto.SecretKeyFactory"%>
<%@page import="javax.crypto.spec.PBEKeySpec"%>
<%@page import="java.security.spec.InvalidKeySpecException"%>
<%@page import="java.security.NoSuchAlgorithmException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ include file="/jspConfig.jsp" %>
<%!
private static String generateStorngPasswordHash(String password) throws NoSuchAlgorithmException, InvalidKeySpecException
{
	int iterations = 1000;
	char[] chars = password.toCharArray();
	byte[] salt = getSalt();
	
	PBEKeySpec spec = new PBEKeySpec(chars, salt, iterations, 64 * 8);
	SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
	byte[] hash = skf.generateSecret(spec).getEncoded();
	return iterations + ":" + toHex(salt) + ":" + toHex(hash);
}

private static byte[] getSalt() throws NoSuchAlgorithmException
{
	SecureRandom sr = SecureRandom.getInstance("SHA1PRNG");
	byte[] salt = new byte[16];
	sr.nextBytes(salt);
	return salt;
}

private static String toHex(byte[] array) throws NoSuchAlgorithmException
{
	BigInteger bi = new BigInteger(1, array);
	String hex = bi.toString(16);
	int paddingLength = (array.length * 2) - hex.length();
	if(paddingLength > 0)
	{
		return String.format("%0"  +paddingLength + "d", 0) + hex;
	}else{
		return hex;
	}
}
%>
<%
	try {
		if( "POST".equals(request.getMethod())  && session.getAttribute("key") != null)
		{
			String uid = (String)session.getAttribute("key");
			String user = (String)session.getAttribute("keyUser");
			String pass = request.getParameter("pass");
			String alert = "";
			session.removeAttribute("key");
			session.removeAttribute("keyUser");
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
			PreparedStatement ps = conn.prepareStatement("select * from admin where email = ? and otp = ?");
			ps.setString(1, user);
			ps.setString(2, uid);
			ResultSet rs = ps.executeQuery();
			if(rs.next())
			{
				ps = conn.prepareStatement("update admin set pass = ?,otp = '-1',otpTime = -1 where email = ?");
				ps.setString(1, generateStorngPasswordHash(pass));
				ps.setString(2, user);
				ps.executeUpdate();
				alert = "Your password was set successfully. Login now to continue...";
				session.setAttribute("alert", alert);
				%>
				<script>document.location = "/hostelFeedback/admin";</script>
				<%
			}
			else
			{
				alert = "Something went wrong...";
				session.setAttribute("alert", alert);
				%>
				<script>document.location = "/hostelFeedback/admin";</script>
				<%
			}
		}
		else
		{
			String alert = "Something went wrong...";
			session.setAttribute("alert", alert);
			%>
			<script>document.location = "/hostelFeedback/admin";</script>
			<%
		}
	}
	catch(Exception e) {
		%>
		<jsp:forward page="/error/"></jsp:forward>
		<%
	}

%>