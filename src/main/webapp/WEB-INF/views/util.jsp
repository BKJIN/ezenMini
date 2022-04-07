<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>   
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta id="_csrf" name="_csrf" content="${_csrf.token}"/>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/all.css" 
 integrity="sha384-UHRtZLI+pbxtHCWp1t77Bi1L4ZtiqrqD80Kn4Z8NTSRyMA2Fd33n5dQ8lWUE00s/" 
 crossorigin="anonymous">
<link rel="stylesheet" 
 href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<!--
<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js"></script>
-->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
<title>Insert title here</title>
<style>
html,body {
height : 100%;
margin : 0;
padding : 0;
}
#main {
height : auto;
}
h3 {
color : white;
text-shadow: 1px 1px 2px black, 0 0 25px blue, 0 0 5px darkblue;
}
</style>
</head>
<body>

<%@ include file="nav.jsp" %>
<%@ include file="carousel.jsp" %>

<div class="container mt-5 mb-5"> <!-- 내부 메뉴 -->
	<a id="sse" href="sse" class="btn btn-primary">서버이벤트</a>&nbsp;&nbsp;
	<a id="wstorage" href="wstorage" class="btn btn-danger">웹스토리지</a>&nbsp;&nbsp;
	<a id="wworker" href="wworker" class="btn btn-success">웹워커</a>&nbsp;&nbsp;
</div>

<!-- main -->
<div id="main" class="container mt-5">
</div>
<%@ include file="footer.jsp" %>

<script>
$("#sse").click(function(event){
	event.preventDefault();
	$.ajax({
		url : "sse",
		type : "get",
		success : function(data) {
			$("#main").html(data);
		},
		error : function() {
			alert("서버이벤트 에러 발생");
		}
	});
});

$("#wstorage").click(function(event){
	event.preventDefault();
	$.ajax({
		url : "wstorage",
		type : "get",
		success : function(data) {
			$("#main").html(data);
		},
		error : function() {
			alert("웹스토리지 에러 발생");
		}
	});
});

$("#wworker").click(function(event){
	event.preventDefault();
	$.ajax({
		url : "wworker",
		type : "get",
		success : function(data) {
			$("#main").html(data);
		},
		error : function() {
			alert("웹서버 에러 발생");
		}
	});
});
</script>
</body>
</html>