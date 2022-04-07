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
<title>Pie그래프</title>
</head>
<body>

<canvas id="canvas" class="container" style="min-height:350px;"></canvas>

<script>
$(document).ready(function(){
	let chartLabels = [];
	let chartData1 = [];
	let chartData2 = [];
	
	let PieChartData = {
		labels : chartLabels, //y축
		datasets : [
			{
				label: "월별 PC 판매량",
				fillColor : "rgba(220,220,220,0.2)",
				strokeColor : "rgba(220,220,220,1)",
				pointColor : "rgba(220,220,220,1)",
				pointStrokeColor : "#fff",
				pointHighlightFill : "#fff",
				pointHighlightStroke : "rgba(220,220,220,1)",
				data : chartData1,
				backgroundColor: [
					"#FF6384",
					"#4BC0C0",
					"#FFCE56",
					"#E7E9ED",
					"#36A2EB"
				]
			
			},
			{
				label: "월별 모니터 판매량",
				fillColor : "rgba(151,187,205,0.2)",
				strokeColor : "rgba(151,187,205,1)",
				pointColor : "rgba(151,187,205,1)",
				pointStrokeColor : "#fff",
				pointHighlightFill : "#fff",
				pointHighlightStroke : "rgba(151,187,205,1)",
				data : chartData2,
				backgroundColor: [
					"#FF6384",
					"#4BC0C0",
					"#FFCE56",
					"#E7E9ED",
					"#36A2EB"
				]
			}
		]
	};
	
	function createChart() {
		var ctx = document.getElementById("canvas").getContext("2d");
		new Chart(ctx,{
			type:'pie',
			data: PieChartData,
			options: {
				responsive: true
			}
				
		});
		
	}
	
	$.ajax({
		type : 'POST',
		url : 'dashView',
		data : { //서버로 보내는 값으로 서버에서는 getParameter()로 반환 시킴
			cmd : 'chart',
			subcmd : 'line',
			${_csrf.parameterName}: "${_csrf.token}"
		},
		dataType : 'json', //받는 데이터형
		success : function(result) {
			$.each(result.datas, function(index, obj) {
				chartLabels.push(obj.month);
				chartData1.push(obj.pc);
				chartData2.push(obj.monitor);
			});
			createChart();
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			alert('There is an error : method(group)에 에러가 있습니다.');
		}
	});
});
</script>
</body>
</html>