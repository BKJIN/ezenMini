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
<title>write창</title>
<style>
h3 {
	color: white;
	text-shadow: 1px 1px 2px black, 0 0 25px blue, 0 0 5px darkblue;
}
</style>
</head>
<body>

<div class="container">
	<h3 class="text-center">게시판 작성</h3>
	<form action="write" method="post">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
		<div class="form-group">
			<label for="uname">이름:</label>
			<input type="text" class="form-control" id="uname" placeholder="Enter email"
				name="bName" required value="${bName}" readonly>
		</div>
		<div class="form-group">
			<label for="title">제목:</label>
			<input type="text" class="form-control" id="title" placeholder="Enter Title"
				name="bTitle" required>
		</div>
		<div class="form-group">
			<label for="content">내용:</label>
			<textarea class="form-control" id="content" placeholder="Enter Content"
				name="bContent" rows="10" required></textarea>
		</div>
		<button type="submit" class="btn btn-success">작성</button>
		&nbsp;&nbsp;<a href="board" class="btn btn-primary">목록보기</a>
	</form> 
</div>

</body>
</html>