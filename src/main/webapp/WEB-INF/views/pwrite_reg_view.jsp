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
<title>제품등록</title>
<style>
h3 {
	color: white;
	text-shadow: 1px 1px 2px black, 0 0 25px blue, 0 0 5px darkblue;
}
</style>
</head>
<body>

<div class="container">
	<h3 class="text-center">요리 등록</h3>
	<!-- file보내기시는 csrf를 action뒤에 주고 enctype을 주어야 함 -->
	<form action="product_write?${_csrf.parameterName}=${_csrf.token}" method="POST" enctype="multipart/form-data">
		요리구분<br/>
		<div class="form-check-inline"> <!-- 체크박스나 라디오버튼을 일렬배치 -->
			<label class="form-check-label" for="radio1">
				<input type="radio" class="form-check-input" id="radio1" name="rCusine" value="Korean" checked>한식
			</label>
		</div>
		<div class="form-check-inline">
			<label class="form-check-label" for="radio2">
				<input type="radio" class="form-check-input" id="radio2" name="rCusine" value="Japanese">일식
			</label>
		</div>
		<div class="form-check-inline">
			<label class="form-check-label" for="radio3">
				<input type="radio" class="form-check-input" id="radio3" name="rCusine" value="Chinese">중식
			</label>
		</div>
		<div class="form-check-inline">
			<label class="form-check-label" for="radio4">
				<input type="radio" class="form-check-input" id="radio4" name="rCusine" value="European">양식
			</label>
		</div>
		<br/><br/>
		<div class="form-group">
			<label for="rname">식당명</label>
			<input type="text" class="form-control" id="rname" placeholder="식당명" name="rName" required>
		</div>
		<div class="form-group">
			<label for="title">요리명</label>
			<input type="text" class="form-control" id="title" placeholder="요리명" name="rTitle" required>
		</div>
		<div class="form-group">
			<label for="photo">요리사진</label>
			<input type="file" class="form-control" id="photo" placeholder="요리사진" name="rFile" required>
		</div>
		<div class="form-group">
			<label for="content">요리설명</label>
			<textarea class="form-control" id="content" placeholder="요리설명" name="rContent" rows="10" required></textarea>
		</div>
		<button type="submit" class="btn btn-success">요리등록</button>
		&nbsp;&nbsp;<a href="product" class="btn btn-primary">목록보기</a>
	</form>
</div>
</body>
</html>