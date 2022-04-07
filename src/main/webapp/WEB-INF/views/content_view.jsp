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
<title>게시판 내용 보기</title>
</head>
<body>

<div class="container">
	<h3 class="text-center">게시판 내용 보기 및 수정, 삭제</h3>
	<form action="modify" method="post">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
		<div class="form-group">
			<label for="uId">번호</label>
			<input type="text" class="form-control" id="uId" name="bId" value="${content_view.bId}" readonly>
		</div>
		<div class="form-group">
			<label for="hit">히트수</label>
			<input type="text" class="form-control" id="hit" value="${content_view.bHit}" readonly>
		</div>
		<div class="form-group">
			<label for="uname">아이디</label>
			<input type="text" class="form-control" id="uname" name="bName" 
				value="${content_view.bName}" readonly>
		</div>
		<div class="form-group">
			<label for="title">제목:</label>
			<input type="text" class="form-control" id="title" name="bTitle" 
				value="${content_view.bTitle}">
		</div>
		<div class="form-group">
			<label for="content">내용:</label>
			<textarea class="form-control" id="content" placeholder="Enter Content"
				name="bContent" rows="10">${content_view.bContent}</textarea>
		</div>
		<button type="submit" id="modi" class="btn btn-success">수정</button>
		&nbsp;&nbsp;<a href="board" class="btn btn-primary">목록보기</a>
		&nbsp;&nbsp;<a href="delete?bId=${content_view.bId}" id="del"
			class="btn btn-primary">삭제</a>
		&nbsp;&nbsp;<a id="rv" href="reply_view?bId=${content_view.bId}"
			class="btn btn-primary">댓글</a>			
	</form>
</div>

<script>
$(document).ready(function(){
	//수정버튼 클릭시 bName과 username(이용자) 비교해서 다르면 수정 못하게 함
	//삭제버튼 클릭시 bName과 username(이용자) 비교해서 다르면 삭제 못하게 함
	//자바스크립트 안에서 jsp의 변수나 값을 이용하려면 c:out을 사용
	
    var username = '<c:out value="${user}"/>'; //로그인 이용자, content_view에서 가져옴
    var bname = '<c:out value="${content_view.bName}"/>'; //작성자 아이디
    console.log(bname);
    console.log(username);
    
    //modify
    $("#modi").click(function(event){
    	if(username != bname) {
    		alert("권한이 없습니다.");
    		return false; //클릭동작 해제
    	}
    });

    //delete
    $("#del").click(function(event){
    	if(username != bname) {
    		alert("권한이 없습니다.");
    		return false; //클릭동작 해제
    	}
    });
        
    //댓글창으로 이동
	$("#rv").click(function(event){
		event.preventDefault();
		var x = $("#rv").attr("href");
		$.ajax({
			url : x,
			type : "get",
			success : function(data) {
				$("#main").html(data);
			},
			error : function() {
				alert("reply_view시 에러 발생");
			}
		})
	});
});
</script>
</body>
</html>