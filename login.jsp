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

public static boolean verify(String gRecaptchaResponse, String USER_AGENT) throws IOException {
	if (gRecaptchaResponse == null || "".equals(gRecaptchaResponse)) {
		return false;
	}
	
	try{
	String googleRecaptchaSecretkey = "";//specify google recaptcha secret key
	URL obj = new URL("https://www.google.com/recaptcha/api/siteverify");
	HttpsURLConnection con = (HttpsURLConnection) obj.openConnection();

	// add reuqest header
	con.setRequestMethod("POST");
	con.setRequestProperty("User-Agent", USER_AGENT);
	con.setRequestProperty("Accept-Language", "en-US,en;q=0.5");

	String postParams = "secret=" + googleRecaptchaSecretkey + "&response="
			+ gRecaptchaResponse;

	// Send post request
	con.setDoOutput(true);
	DataOutputStream wr = new DataOutputStream(con.getOutputStream());
	wr.writeBytes(postParams);
	wr.flush();
	wr.close();

	int responseCode = con.getResponseCode();
	//System.out.println("\nSending 'POST' request to URL : " + "https://www.google.com/recaptcha/api/siteverify");
	//System.out.println("Post parameters : " + postParams);
	//System.out.println("Response Code : " + responseCode);

	BufferedReader in = new BufferedReader(new InputStreamReader(
			con.getInputStream()));
	String inputLine;
	StringBuffer response = new StringBuffer();

	while ((inputLine = in.readLine()) != null) {
		response.append(inputLine);
	}
	in.close();

	// print result
	//System.out.println(response.toString());
	
	//parse JSON response and return 'success' value
	String res = response.toString();
	
	
	return res.contains("\"success\": true");
	}catch(Exception e){
		return false;
	}
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
%>
<%
	try{
		if("POST".equals(request.getMethod()))
		{
			String alert = "";
			String storedPass ="";
			boolean verify = verify(request.getParameter("g-recaptcha-response"), request.getHeader("User-Agent"));
			if(verify)
			{
				Class.forName("com.mysql.jdbc.Driver");
				Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
				PreparedStatement ps = conn.prepareStatement("select * from student where email = ?");
				ps.setString(1, request.getParameter("roll"));
				ResultSet rs = ps.executeQuery();
				if(rs.next())
				{
					storedPass = rs.getString(6);
					
					if(validatePassword(request.getParameter("pass"), storedPass))
					{
						if(rs.getInt(8) == 0)
						{
							alert = "You are not verified yet...";
							session.setAttribute("alert", alert);
							conn.close();
							%>
							<jsp:forward page="/"></jsp:forward>
							<%
						}
						else
						{
							session.setAttribute("user", request.getParameter("roll"));
							session.setAttribute("name", rs.getString(3));
							session.setAttribute("type", "student");
							%>	
							<script type="text/javascript">document.location = "/hostelFeedback/";</script>
							<%
						}
					}
					else 
					{
						alert = "Wrong Password";
						session.setAttribute("alert", alert);
						conn.close();
						%>
						<script type="text/javascript">document.location = "/hostelFeedback/";</script>
						<%
					}
				conn.close();
				}
				else
				{
				alert = "Account not found. Please sign up below...";
				session.setAttribute("alert", alert);
				conn.close();
				%>
				<script type="text/javascript">document.location = "/hostelFeedback/";</script>
				<%
				
				}
			}
			else
			{
				alert = "captcha not verified";
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