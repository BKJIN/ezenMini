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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/all.css" 
 integrity="sha384-UHRtZLI+pbxtHCWp1t77Bi1L4ZtiqrqD80Kn4Z8NTSRyMA2Fd33n5dQ8lWUE00s/" 
 crossorigin="anonymous">
<link rel="stylesheet" 
 href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<!-- include시 dropdown 오동작 예방 -->
<!--
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
-->
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<title>menu</title>
<style>
/*브라우져별 상이함을 통일 */
html,body {
height : 100%;
margin : 0;
padding : 0;
}

.navbar {
border-radius: 0;
margin-bottom : 0px;
}

#searchForm {
/*검색창을 기본으로 안보이게 해줌(검색창 필요 메뉴시만 보이게 함) */
visibility : hidden;
}
</style>
</head>
<body>

<!-- 메뉴바 -->
<nav class="navbar navbar-expand-md bg-dark navbar-dark fixed-top font-weight-bold">
	<a class="navbar-brand" href="#"> <!-- logo표시 -->
		<img src="images/bird.jpg" alt="logo" style="width:40px"/>
	</a>
	<!-- RWD시 화면 축소시 메뉴(상병 계급장 형식) -->
	<button class="navbar-toggler" type="button" data-toggle="collapse"
		data-target="#collapsibleNavbar">
		<span class="navbar-toggler-icon"></span>
	</button>
	<!-- RWD를 구현하는 주 메뉴 -->
	<div class="collapse navbar-collapse" id="collapsibleNavbar">
		<ul class="navbar-nav">
			<li class="nav-item">
				<a class="nav-link" href="home">Home</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" href="product">Products</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" href="util">Utils</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" href="store">Stores</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" href="contact">Contact</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" href="folio">Portfolio</a>
			</li>
			<!-- Dropdown -->
			<li class="nav-item dropdown">
				<a class="nav-link dropdown-toggle" href="#" id="navbardrop" data-toggle="dropdown">
					알림판
				</a>
				<div class="dropdown-menu">
					<a class="dropdown-item" href="notice">공지사항</a>
					<a class="dropdown-item" href="board">게시판</a>
					<a class="dropdown-item" href="qna">Q&A</a>
				</div>
			</li>
			<li class="nav-item">
				<a class="nav-link" href="dash">DashBoard</a>
			</li>
			<li class="nav-item invisible">
				<a class="nav-link btn disabled" href="#">space</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" href="login_view">LogIn</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" href="logout_view">LogOut</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" href="join_view">Join</a>
			</li>
		</ul>
	</div>
	<!-- 검색창(메뉴바에 포함) -->
	<form id = "searchForm" class="form-inline" action="#">
		<button class="btn btn-success" type="button" disabled>
			<i class="fa fa-search"></i> <!-- serach(돋보기)아이콘 -->
		</button>
		<input id="searchInput" class="form-control mr-sm-2" type="text" placeholder="Serach">
	</form>
</nav>
</body>
</html>