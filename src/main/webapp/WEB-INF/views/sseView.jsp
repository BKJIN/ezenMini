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
</head>
<body>

<div class="container mt-5">
	<h3 class="text-center">서버 센트 이벤트</h3>
	<!-- 이벤트 내용이 하나인 경우와 다수개인 경우 -->
	<button type="button" id="sebtn" class="btn btn-primary">싱글이벤트</button>&nbsp;&nbsp;
	<button type="button" id="mebtn" class="btn btn-success">멀티이벤트</button>&nbsp;&nbsp;
	<br/><br/>
	<div id="sseDisp1"></div>
	<div id="sseDisp2"></div>
	<div id="sseDisp3"></div>
</div>

<script>
$(document).ready(function(){
	$("#sebtn").click(function(){
		//이벤트를 받기 위한 이벤트소스 객체 생성
		let eventSource = new EventSource("seventEx"); //서버 요청경로 seventEx로 연결
		eventSource.onmessage = function(event) { //이벤트 업데이트시마다 message이벤트 발생
			$("#sseDisp1").text(event.data); //event객체에 발생한 업데이트된 데이터 data가 실려옴
		}
	});
	
	$("#mebtn").click(function(){
		let eventSource = new EventSource("meventEx");
		//이벤트 종류 up_vote와 down_vote는 서버에서 지정한 이벤트 종류
		eventSource.addEventListener("up_vote", function(event){
			$("#sseDisp2").text(event.data);
		},false);
		//up_vote는 이벤트 종류,이벤트 처리 함수, false는 캡쳐링으로 버블링 방식
		
		eventSource.addEventListener("down_vote",function(event){
			$("#sseDisp3").text(event.data);
		},false);
	});
});
</script>
</body>
</html>