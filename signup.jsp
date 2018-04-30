<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="javax.xml.bind.DatatypeConverter"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.io.File"%>
<%@page import="java.math.BigInteger"%>
<%@page import="java.security.SecureRandom"%>
<%@page import="javax.crypto.SecretKeyFactory"%>
<%@page import="javax.crypto.spec.PBEKeySpec"%>
<%@page import="java.security.spec.InvalidKeySpecException"%>
<%@page import="java.security.NoSuchAlgorithmException"%>
<%@page import="java.util.UUID"%>
<%@page import="com.sun.mail.smtp.SMTPTransport"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.Session"%>
<%@page import="java.util.Properties"%>
<%@page import="java.util.Random"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ include file="jspConfig.jsp" %>
<%@ include file="mail.jsp" %>
<%!

public static String MD5(String str) throws Exception {
		MessageDigest md = MessageDigest.getInstance("MD5");
		md.update(str.getBytes());
		byte[] digest = md.digest();
		String hash = DatatypeConverter.printHexBinary(digest).toUpperCase();
		return hash;
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
	try{
		if("POST".equals(request.getMethod()))
		{
			String alert ="";
			String roll = request.getParameter("roll");
			String pass = request.getParameter("pass");
			String rollno = request.getParameter("rollno").toUpperCase();
			String name = request.getParameter("fname") + " " + request.getParameter("lname");
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection(mysqlURL,mysqlUser,mysqlPass);
			PreparedStatement ps1;
			ResultSet rs;
				if(rollno.substring(0, 1).equals("C"))
				{
					if(rollno.substring(7, 8).equals("C") || rollno.substring(7, 8).equals("A"))
					{
						if(rollno.length() != 13)
							alert = "Your Roll No. seems to be invalid";
					}
					else if(rollno.substring(7, 8).equals("F") || rollno.substring(7, 8).equals("E") || rollno.substring(7, 8).equals("M"))
					{
						if(rollno.length() != 14)
							alert = "Your Roll No. seems to be invalid";
					}
				}
				else if(rollno.substring(0, 1).equals("G"))
				{
					if(rollno.substring(9, 10).equals("L"))
					{
						if(rollno.length() != 14)
							alert = "Your Roll No. seems to be invalid";
					}
					else 
					{
						if(rollno.length() != 12)
							alert = "Your Roll No. seems to be invalid";
					}
				}
				else
					alert = "Your Roll No. seems to be invalid";
				if(alert.equals("") == false)
				{
					session.setAttribute("alert", alert);
					%>
					<jsp:forward page="index.jsp"></jsp:forward>
					<%
				}
				if(pass.length()<8)
				{
					alert = "Password must be of atleast 8 characters";
					session.setAttribute("alert", alert);
					%>
					<jsp:forward page="index.jsp"></jsp:forward>
					<%
				}
				if(roll.length()<6 || roll.length() < 7 || roll.equals("student") || roll.equals("registrar") || roll.equals("director"))
				{
					alert = "Invalid Email...";
					session.setAttribute("alert", alert);
					conn.close();
					%>
					<jsp:forward page="index.jsp"></jsp:forward>
					<%
				}
					ps1 = conn.prepareStatement("select * from student where rollNo = ? and email != '-1'");
					ps1.setString(1, rollno);
					rs = ps1.executeQuery();
					if(rs.next())
					{
						alert = "You are already registered. Please login.";
						session.setAttribute("alert", alert);
						%>
						<jsp:forward page="/"></jsp:forward>
						<%
						conn.close();
					}
					else
					{
						final String uid = UUID.randomUUID().toString().replace("-", "");
						final String data = MD5(roll);
						File path = new File(storageURL + data);
						path.mkdir();
						File source = new File(storageURL + "noprofile.jpg");
						File dest = new File(storageURL + data + "/noprofile.jpg");
						Files.copy(source.toPath(), dest.toPath());
						/* InputStream is = new FileInputStream(storageURL + "noprofile.jpg");
						OutputStream os = new FileOutputStream(storageURL + data + "/noprofile.jpg");
						byte[] buffer = new byte[2048];
						int length;
						while ((length = is.read(buffer)) > 0) {
				            os.write(buffer, 0, length);
						}
						*/
						String user = request.getParameter("roll");
						String to = user + "@cit.ac.in";
						Date  ct = new Date();
						long time = ct.getTime();
						String generatePass = generateStorngPasswordHash(pass);
						String subject = "[Hostel Feedback System] Email Verification";
						String msg = "Someone (hopefully you) tried to create an account in our portal. Please click the link below to verify yourself.\n";
						msg += "http://"+ mailRedirectURL +"/activation/?id=" + uid + "&user=" + user;
						msg += "\n\nIf u can't click the link then copy the link in the address bar and then press enter.\n";
						msg += "If u have not requested for registration then please disregard this mail and no action will be taken.\n\n";
						msg += "Hostel Feedback System";
						ps1 = conn.prepareStatement("insert into student(rollNo,email,name,branch,module,pass,otp,otpTime,data,hostel,roomNo) values (?,?,?,?,?,?,?,?,?,?,?)");
						ps1.setString(1, rollno);
						ps1.setString(2, roll);
						ps1.setString(3, name);
						ps1.setString(4, request.getParameter("branch"));
						ps1.setString(5, request.getParameter("module"));
						ps1.setString(6, generatePass);
						ps1.setString(7, uid);
						ps1.setLong(8, time);
						ps1.setString(9, data);
						ps1.setString(10, request.getParameter("hostel"));
						ps1.setInt(11, Integer.parseInt(request.getParameter("roomNo")));
						ps1.executeUpdate();
						//sendMail(to, subject, msg);
						sendMail("b15cs154@cit.ac.in", subject, msg);
						conn.close();
						session.setAttribute("status", "inProcess");
						%>
						<script>document.location = "/hostelFeedback/activation.jsp"</script>
						<%
					}
		}
		else
		{
			%>
			<script>document.location = "/hostelFeedback/"</script>
			<%
		}
	}
	catch(Exception e) {
		%>
		<%= e.toString() %>
		<%
	}
		
%>