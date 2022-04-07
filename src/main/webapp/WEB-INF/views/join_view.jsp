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
<title>join창</title>
<style>
html,body {
	height: 100%;
	margin: 0;
	padding : 0;
}
#main {
	height: auto;
}

h3 {
	color: white;
	text-shadow: 1px 1px 2px black, 0 0 25px blue, 0 0 5px darkblue;
}

</style>
</head>
<body>

<%@ include file="nav.jsp" %>
<%@ include file="carousel.jsp" %>

<div id="main" class="container mt-5">
	<!-- 모달은 회원가입 성공 여부에 따른 메세지 출력,서버에서 응답 도착시 자동 모달버튼 클릭 -->
	<!-- modal button -->
	<input id="modalBtn" type="hidden" class="btn btn-info btn-lg" data-toggle="modal"
		data-target="#myModal" value="modal">
	<!-- modal창 -->
	<div class="modal fade" id="myModal" role="dialog">
		<div class="modal-dialog modal-dialog-centered modal-sm text-center">
			<div class="modal-content">
				<div class="modal-header bg-light">
					<h4 class="modal-title">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;회원가입</h4>
				</div>
				<div class="modal-body bg-light">
					<h4>회원 가입을 축하 합니다.</h4>
				</div> 
				<div class="modal-footer bg-light">
					<button id="closeBtn" type="button" class="btn btn-default btn-success"
						data-dismiss="modal">Close</button>
				</div> 
			</div>
		</div>
	</div>
	<!-- 회원 가입 창 -->
	<h3 class="text-center text-danger">회원가입</h3>
	<form action="join" method="post" id="frm1" name="frm1">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
		<div class="form-group">
			<label for="uId">아이디</label>
			<input type="email" class="form-control" name="pid" placeholder="E-Mail주소 입력"
				id="uId" required />
		</div>
		<div class="form-group">
			<label for="uPw">비밀번호</label>
			<input type="password" class="form-control" name="ppw" id="uPw"
				placeholder="비밀번호 입력"	required />
		</div>
		<div class="form-group">
			<label for="uAddress">주소</label>
			<input type="text" class="form-control" name="paddress" id="uAddress"
				placeholder="주소 입력" required />
		</div>
		<div class="form-group">
			<label for="uHobby">취미</label>
			<input type="text" class="form-control" name="phobby" id="uHobby"
				placeholder="취미 입력" required />
		</div>
		<div class="form-group">
			<label for="uProfile">프로필:</label>
			<textarea class="form-control" name="pprofile" id="uProfile" rows="20"
				placeholder="자기소개를 작성하세요" required></textarea>
		</div>
		<button type="submit" class="btn btn-success">회원가입</button>&nbsp;&nbsp;
		<button type="reset" class="btn btn-danger">취 소</button>
	</form>
</div>

<%@ include file="footer.jsp" %>

<script>
$(document).ready(function(){
	$("#frm1").submit(function(event){
		event.preventDefault(); //html의 submit이벤트 처리를 중단
		$.ajax({
			type : $("#frm1").attr("method"),
			url :  $("#frm1").attr("action"),
			data : $("#frm1").serialize(), //form의 입력 내용을 문자열로 변환
			success : function(data) {
				if(data.search("join-success") > -1) {
					$(".modal-body").text("회원가입을 축하합니다.");
					//$("#modalBtn")[0].click(); //자동클릭
					$("#modalBtn").trigger("click"); //자동클릭
					$("#closeBtn").click(function(event){
						event.preventDefault();
						location.href = "login_view";
					});
				}
				else {
					$(".modal-body").text("동일한 아이디가 존재합니다.");
					$("#modalBtn").trigger("click");
				}
			},
			error : function(data) {
				$(".modal-body").text("동일한 아이디가 존재하거나 전송 실패입니다. 다시 시도해 주세요.");
				$("#modalBtn").trigger("click");
			}
		});
	});
});
</script>
</body>
</html>