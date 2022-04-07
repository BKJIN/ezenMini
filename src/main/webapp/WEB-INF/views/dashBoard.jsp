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
<!--
<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js"></script>
-->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.3/Chart.js"></script>
<!-- Cart.js API 라이브러리 추가 -->
<title>dashBoard</title>
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
<br/><br/>
<div class="container">
	<a id="bar" href="bar" class="btn btn-primary">Bar그래프</a>&nbsp;&nbsp;
	<a id="pie" href="pie" class="btn btn-danger">Pie그래프</a>&nbsp;&nbsp;
	<a id="line" href="dash" class="btn btn-success">Line그래프</a>
</div>

<!-- 그래픽표시 공간 -->
<div id="main" class="container mt-5">
	<canvas id="canvas" style="min-height:350px;"></canvas>
</div>

<%@ include file="footer.jsp" %>

<script>
$(document).ready(function(){
	//변수들 선언
	var chartLabels = []; //월표시 배열 초기화
	var chartData1 = []; //pc판매량
	var chartData2 = []; //모니터 판매량
	//그래프를 그릴 수 있도록 가공해둔 변수
	let lineChartData = {
		labels : chartLabels, //그래프의 기본축인 x에 들어 가는 값
		datasets : [ //그래프에 표시할 데이터 값 charData1, chartData2를 수용
			{
				label : "월별 PC 판매량", //데이터 종류 이름
				fillColor : "rgba(220,220,220,0.2)", //채울색
				strokeColor : "rgba(220,220,220,1)", //선색
				pointColor : "rgba(220,220,220,1)",
				pointStrokeColor : "#fff",
				pointHightlightFill : "#fff",
				pointHightlightStroke : "rgba(220,220,220,1)",
				data : chartData1
			},	
			{
				label : "월별 모니터 판매량",
				fillColor : "rgba(151,187,205,0.2)",
				strokeColor : "rgba(151,187,205,1)",
				pointColor : "rgba(151,187,205,1)",
				pointStrokeColor : "#fff",
				pointHightlightFill : "#fff",
				pointHightlightStroke : "rgba(151,187,205,1)",
				data : chartData2
			}
		]
	};
	
	function createChart() {
		var ctx = document.getElementById("canvas").getContext("2d"); //그림그리기 객체
		//Chart.Line()메서드는 Chartjs에서 제공한 막대그래프그리기 메서드
		LineChartDemo = Chart.Line(ctx,{
			data : lineChartData, //사용할 데이터
			options : {
				scales : { //눈금표시
					yAxes : [
						{
							ticks : {
								beginAtZero : true
							}
						}	
					]
				}
			}
		});
	}
	
	$.ajax({
		type : "POST",
		url : "dashView", //서버에서 그래프용 데이터 처리 요청
		data : { //서버로 보내는 데이터(여러개 보낼시 객체형으로 보냄)
			cmd : "chart", //getParameter로 처리
			subcmd : "line",
			${_csrf.parameterName}: "${_csrf.token}"
		},
		dataType : "json", //서버에서 오는 데이터형
		success : function(result) { //result는 서버에서 오는 json형태 값
			//.each함수는 자바의 enhanced for문을 생각 할 것
			//result.datas는 배열형 객체, index는 색인번호,obj는 현재 객체
			$.each(result.datas,function(index, obj) {
				chartLabels.push(obj.month); //배열 마지막에 값넣어 주는 메서드 push()
				chartData1.push(obj.pc);
				chartData2.push(obj.monitor);
			});
			createChart();
		},
		error : function() {
			alert("There is an error : method(group)에 에러가 있습니다.");
		}
	});
});
</script>

<script>
$("#bar").click(function(event){
	event.preventDefault();
	$.ajax({
		url : "bar",
		type : "get",
		success : function(data) { //data는 jsp가 변환된 html
			$("#main").html(data);
		},
		error : function() {
			alert("bar그래프 에러 발생");
		}
	});
});

$("#pie").click(function(event){
	event.preventDefault();
	$.ajax({
		url : "pie",
		type : "get",
		success : function(data) { //data는 jsp가 변환된 html
			$("#main").html(data);
		},
		error : function() {
			alert("bar그래프 에러 발생");
		}
	});
});
</script>
</body>
</html>