
<%
	try{
	
		session.invalidate();
	
	
%>
<script>document.location = "/hostelFeedback/admin"</script>
<%
}
catch(Exception e) {
%>
<jsp:forward page="/error/"></jsp:forward>
<%
}
%>