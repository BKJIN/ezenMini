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
<!-- 페이지 처리 js라이브러리 -->
<script src="js/jquery.twbsPagination.js"></script>
<title>게시판 목록</title>
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
</style>
</head>
<body>

<%@ include file="nav.jsp" %>
<%@ include file="carousel.jsp" %>

<!-- #main은 페이지 리스트 처리 -->
<div id = "main" class="container mt-5">
	<h3 class="text-center text-danger">게시판</h3>
	<table id="searchTable" class="table table-bordered table-hober">
		<thead>
			<tr>
				<th>번호</th>
				<th>작성자</th>
				<th>제목</th>
				<th>날짜</th>
				<th>히트수</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${listContent}" var="dto">
				<tr>
					<td id="bid">${dto.bId}</td> <!-- bId는 게시판목록 번호 -->
					<td>${dto.bName}</td> <!-- bName은 user id -->
					<td>
						<c:forEach begin="1" end="${dto.bIndent}">-</c:forEach> <!-- 댓글차수 -->
						<a class="content_view" href="content_view?bId=${dto.bId}">${dto.bTitle}</a>
					</td>
					<td>${dto.bDate}</td>
					<td>${dto.bHit}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>

<!-- #boardOnly는 페이지표시 및 글작성 메뉴 표시 -->
<div class="container" id="boardOnly">
	<nav aria-label="Page navigation"> <!-- aria-label은 라벨표시가 안되는것 예방 -->
		<ul class="pagination justify-content-center" id="pagination" style="margin:20px 0">
		</ul>
	</nav>
	<a id="write" class="btn btn-primary" href="write_view">글작성</a>
</div>

<%@ include file="footer.jsp" %>

<script>
$(document).ready(function(){
	$("#searchForm").css("visibility","visible"); //검색메뉴를 보이게 함
	//글작성
	$("#write").click(function(event){
		$("#searchForm").css("visibility","hidden");
		event.preventDefault(); //ajax를 사용하기 위해 글작성이 링크a로 된것을 막음
		//창이동 없이 board메뉴 창안에 글작성창을 로딩
		$.ajax({
			url : "write_view",
			type : "get", //링크 a를 ajax시는 get방식이어야 함
			success : function(data) {
				$("#main").html(data); //data는 콘트롤라에서 보내준 jsp
				$("#boardOnly").css("display","none"); //글작성창에서는 페이지와 write버튼 필요 없음
			},
			error : function() {
				alert("write_view시 에러 발생");
			}
		});
	});
	
	//내용보기
	$(".content_view").click(function(event){
		$("#searchForm").css("visibility","hidden");
		//.content_view는 여러개이므로 클래스 처리
		event.preventDefault();
		let eo = event.target; //자바스크립트객체로 이벤트 발생 엘리먼트
		var x = eo.getAttribute("href"); //클릭한 eo객체(제목 항목)의 속성이 href인것의 값
		$.ajax({
			url : x,
			type : "get", //a의 방식은 get
			success : function(data) {
				$("#main").html(data); //data는 content_view창
				$("#boardOnly").css("display","none"); //페이지표시 엘리먼트
			},
			error : function() {
				alert("content_view시 에러 발생");
			}
			
		});
	});
	
	$("#serchInput").on("keyup",function(){
		var value= $(this).val().toLowerCase(); //입력창값을 소문자로 변환
		$("#searchTable tbody tr").filter(function(){
			$(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
			//일치하지 않는 tr은 제거를 하고 일치하는 것이 있는 tr만 남겨두는 것이 toggle메서드
		});
	});
});
</script>

<script>
//pagination만들기
$(function(){
	window.pagObj = $('#pagination').twbsPagination({
		totalPages: 35, //총 페이지 수
		visiblePages: 10, //가시 페이지 수
		onPageClick : function(event, page) {
			console.info(page + ' (from options)');
			$(".page-link").on("click",function(event){
				event.preventDefault();
				var peo = event.target; //이벤트 발생 자바스크립트 객체
				var pageNo = peo.innerHTML; //페이지 번호
				var purl;
				if(pageNo != "First" && pageNo != "Previous" && pageNo != "Next" && pageNo != "Last") {
					purl = "plist?pageNo=" + pageNo;
				}
				else {
					return;
				}
				$.ajax({
					url : purl,
					type : "get",
					success : function(data) {
						$("#main").html(data);
					},
					error : function() {
						alert("plist시 에러 발생");	
					}
				}); //".ajax"
			}); //".page-link"
		} //onPageclick
	}) //window.pagObj
	.on('page', function(event, page){ //chaining
		console.info(page + ' (from event listening)');
	}); //on
}); //function()
</script>
</body>
</html>