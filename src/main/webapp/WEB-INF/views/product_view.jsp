<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page session="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>   
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta id="_csrf" name="_csrf" content="${_csrf.token}"/>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/all.css" 
 integrity="sha384-UHRtZLI+pbxtHCWp1t77Bi1L4ZtiqrqD80Kn4Z8NTSRyMA2Fd33n5dQ8lWUE00s/" 
 crossorigin="anonymous">
<!--
<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js"></script>
-->
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<title>Insert title here</title>

<style>
html,body {
	height: 100%;
	margin: 0; 
	padding : 0;
}

h3 {
	color: white;
	text-shadow: 1px 1px 2px black, 0 0 25px blue, 0 0 5px darkblue;
}

#main {
	height: auto;
}

h5 {
	color: white;
	text-shadow: 1px 1px 2px blue, 0 0 25px blue, 0 0 5px darkblue;
}

</style>
</head>
<body>

<%@ include file="nav.jsp" %>
<%@ include file="carousel.jsp" %>

<div id="main" class="container mt-5">
	<!-- 이페이지는 product의 첫페이지 이므로 요리 리스트를 보여줌 -->
	<h3 class="text-center text-info">Cuisine</h3>
	<div class="row mb-3">
		<c:forEach items="${productList}" var="dto">
			<!-- 카드 한장으로 하나의 요리 정보 -->
			<div class="card" style="width:300px;">
				<h5>${dto.rCusine}</h5> <!-- 요리구분 -->
				<img class="card-img-top" src="images/${dto.rPhoto}" alt="Card image"
					style="max-width:280px; height:280px">
				<div class="card-body">
					<h5 class="card-title">식당명 : ${dto.rName}</h5>
					<h5 class="card-text">요리명 : ${dto.rTitle}</h5>
					<a href="productDetails?rPhoto=${dto.rPhoto}"
						class="pd btn btn-primary stretched-link">
						자세히 보기	
					</a>
				</div>
			</div>
		</c:forEach>
	</div>
	<a id="pwrite_view" class="btn btn-success" href="pwrite_view">요리등록</a>
	
</div>

<script>
$(document).ready(function(){
	$("#pwrite_view").click(function(){
		event.preventDefault();
		$.ajax({
			url : "pwrite_view",
			type : "get",
			success : function(data) {
				$("#main").html(data);
			},
			error : function() {
				alert("pwrite_view시 에러 발생");
			}
		});
	});
	
	//세부요리정보 보기
	$(".pd").click(function(event){
		event.preventDefault();
		var eo = event.target; //자바스크립트 객체
		var x = eo.getAttribute("href");
		$.ajax({
			url : x,
			type : "get",
			success : function(data) {
				$("#main").html(data); //세부정보페이지
			},
			error : function() {
				alert("product_view시 에러 발생");
			}
		});
	});
	
});
</script>

</body>
</html>