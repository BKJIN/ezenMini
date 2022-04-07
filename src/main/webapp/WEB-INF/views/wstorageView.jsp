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
<title>Web Storage</title>
</head>
<body>

<div class="container mt-5">
	<button id="wsbtn1" onclick="clickCounter1()" type="button" class="btn btn-primary">
		문자열저장
	</button>&nbsp;&nbsp;
	<button id="wsbtn2" onclick="clickCounter2()" type="button" class="btn btn-danger">
		객체형저장
	</button>&nbsp;&nbsp;
</div>

<div class="container mt-5">
	<h3 class="text-center">문자열저장버튼클릭시 저장된 값</h3>
	<div id="ws1result" class="text-center" style="font-size:25px;"></div><br/>
	<h3 class="text-center">객체형저장버튼클릭시 저장된 값</h3>
	<div id="ws2result" class="text-center" style="font-size:25px;"></div>
	<div id="ws2div1" class="text-center" style="font-size:25px;"></div>
	<div id="ws2div2" class="text-center" style="font-size:25px;"></div>
	<div id="ws2div3" class="text-center" style="font-size:25px;"></div>
</div>

<script>
//저장된 webstorage는 개발자도구의 application tab에 있음
function clickCounter1() {
	if (typeof(Storage) !== "undefined") { //브라우져가 Storage를 지원
		if(localStorage.clickcount) { //clickcount속성이 있으면 true
			localStorage.clickcount = Number(localStorage.clickcount)+1;
			//localStorage객체의 clickcount속성값(문자열)을 가져와 숫자화해서 1을 더한것을 clickcount에 저장
		}
		else {
			localStorage.clickcount = 1; //clickcount속성을 만들고 값을 1로 저장
		}
		document.getElementById("ws1result").innerHTML="You have clicked the button " + localStorage.clickcount + " time(s).";
	}
	else {
		document.getElementById("ws1result").innerHTML = "Sorry, your browser does not support web storage...";
	}
}

function clickCounter2() {
	if(typeof(Storage) !== "undefined") {
		//store
		localStorage.setItem("lastname", "Smith");
		//Retrieve
		$("#ws2result").text(localStorage.getItem("lastname"));
		//object저장을 위한 메서드를 Storage객체에 추가(prototype을 이용하여 메서드를 추가)
		Storage.prototype.setObject = function(key,value) {
			this.setItem(key,JSON.stringify(value));
			//객체형인 value를 JSON.stringify를 이용하여 문자열화하여 저장
		}
		//object형을 반환하기 위한 메서드를 추가
		Storage.prototype.getObject = function(key) {
			return this.getItem(key) && JSON.parse((this.getItem(key)));
			//getItem(key)로 검색하여 결과가 있을시만 문자열로 저장된 값을 JSON.parse를 이용하여 객체화
		}
		
		//자바스크립트 object
		let objectA = {
			stringValue : new String("okTest"),
			arrayValue : new Array("A","B","C")
		}
		
		//localStorage에 objectA를 저장
		localStorage.setObject("key1",objectA);
		//저장된 object를 반환
		let item1 = localStorage.getObject("key1");
		$("#ws2div1").text(item1.stringValue);
		$("#ws2div2").text(item1.arrayValue.join());
		//join()은 배열원소를 연결하여 문자열로 반환
		
		$("#ws2div3").text(localStorage.length);
		for(var i = 0 ; i < localStorage.length ; i++) {
			console.log(localStorage.key(i)); //key name을 인덱스 별로 구함
			//key를 알면 value를 getItem으로 알 수 있음
		}
	}
	else {
		$("#ws2result").text("browser not support");
	}
}
</script>
</body>
</html>