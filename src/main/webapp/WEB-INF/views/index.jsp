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
<title>index</title>

<style>
html,body {
/*브라우져별로 차이가 있는 값을 통일 시킴 */
height: 100%;
margin: 0; /* 0px은 단위 생략 가능 */
padding : 0;
}

h3 {
color: white;
text-shadow: 1px 1px 2px black, 0 0 25px blue, 0 0 5px darkblue;
}

#main {
height: auto;
}
</style>
</head>
<body>

<!-- 
메뉴부 캐러셀부 본문 footer로 구성 
메뉴,캐러셀,footer는 모든 페이지에서 공통으로 사용 
공통부는 각각의 jsp를 include로 포함
include시 include되는 jsp의 jquery CDN는 주석 처리 한다.
그래야만 드롭다운메뉴 등의 동작이 안되는 것을 예방
-->
<%@ include file="nav.jsp" %>
<%@ include file="carousel.jsp" %>

<!-- 이 페이지의 독자적인 내용 -->
<div id="main" class="container mt-5">
	<div class="row">
		<div class="col-sm-4">
			<h3 class="text-center">BLACK FRIDAY DEAL</h3>
			<div class="card" style="width:350px;">
				<img class="card-img-top" src="images/deals1.jpg" alt="Card image" style="width:100%"/>
				<div class="card-body">
					<h4 class="card-title">신상품01</h4>
					<p class="card-text">Buy 50 mobiles and get a gift card</p>
					<a href="#" class="btn btn-primary">See Details</a>
				</div>
			</div>
		</div>
		<div class="col-sm-4">
			<h3 class="text-center">BLACK FRIDAY DEAL</h3>
			<div class="card" style="width:350px;">
				<img class="card-img-top" src="images/deals2.jpg" alt="Card image" style="width:100%"/>
				<div class="card-body">
					<h4 class="card-title">신상품02</h4>
					<p class="card-text">Buy 50 mobiles and get a gift card</p>
					<a href="#" class="btn btn-primary">See Details</a>
				</div>
			</div>
		</div>
		<div class="col-sm-4">
			<h3 class="text-center">BLACK FRIDAY DEAL</h3>
			<div class="card" style="width:350px;">
				<img class="card-img-top" src="images/deals3.jpg" alt="Card image" style="width:100%"/>
				<div class="card-body">
					<h4 class="card-title">신상품03</h4>
					<p class="card-text">Buy 50 mobiles and get a gift card</p>
					<a href="#" class="btn btn-primary">See Details</a>
				</div>
			</div>
		</div>
	</div>
</div>

<%@ include file="footer.jsp" %>
</body>
</html>