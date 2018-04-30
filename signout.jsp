
<%
	try{
	
		session.invalidate();
	
%>
<script>document.location = "/hostelFeedback/"</script>
<%
	}
	catch(Exception e) {
%>
<jsp:forward page="/error/"></jsp:forward>
<%
}
%>