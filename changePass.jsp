<%@page import="java.io.StringReader"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.DataOutputStream"%>
<%@page import="javax.net.ssl.HttpsURLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.IOException"%>
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
<%@ include file="jspConfig.jsp" %>
<%!
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

 private static boolean validatePassword(String originalPassword, String storedPassword) throws NoSuchAlgorithmException, InvalidKeySpecException
    {
        String[] parts = storedPassword.split(":");
        int iterations = Integer.parseInt(parts[0]);
        byte[] salt = fromHex(parts[1]);
        byte[] hash = fromHex(parts[2]);
         
        PBEKeySpec spec = new PBEKeySpec(originalPassword.toCharArray(), salt, iterations, hash.length * 8);
        SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
        byte[] testHash = skf.generateSecret(spec).getEncoded();
         
        int diff = hash.length ^ testHash.length;
        for(int i = 0; i < hash.length && i < testHash.length; i++)
        {
            diff |= hash[i] ^ testHash[i];
        }
        return diff == 0;
    }
    private static byte[] fromHex(String hex) throws NoSuchAlgorithmException
    {
        byte[] bytes = new byte[hex.length() / 2];
        for(int i = 0; i<bytes.length ;i++)
        {
            bytes[i] = (byte)Integer.parseInt(hex.substring(2 * i, 2 * i + 2), 16);
        }
        return bytes;
    }
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
%>
<%
	try{
		if("POST".equals(request.getMethod()) && session.getAttribute("user") != null)
		{
			String roll = (String)session.getAttribute("user");
			String oldPass = request.getParameter("oldPass");
			String alert = "";
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
			PreparedStatement ps;
			ResultSet rs;
			ps = conn.prepareStatement("select pass from student where email = ?");
			ps.setString(1, roll);
			rs = ps.executeQuery();
			rs.next();
			if(validatePassword(oldPass, rs.getString(1)))
			{
				ps = conn.prepareStatement("update student set pass = ? where email = ?");
				ps.setString(1, generateStorngPasswordHash(request.getParameter("newPass")));
				ps.setString(2, roll);
				ps.executeUpdate();
				alert = "Password updated....";
				session.setAttribute("alert", alert);
				%>
				<script type="text/javascript">document.location = "/hostelFeedback/";</script>
				<%
			}
			else
			{
				alert = "Your current password was not correct";
				session.setAttribute("alert", alert);
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