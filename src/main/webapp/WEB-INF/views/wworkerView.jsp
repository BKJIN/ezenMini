<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>   
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
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
<title>Insert title here</title>
</head>
<body>

<h3 class="text-center">간단한 web worker</h3>
<p class="text-center" style="font-size:25px;">
	Count numbers: <output id="result"></output>
</p>
<button class="btn btn-info" onclick="startWorker()">Start Worker(단순)</button>&nbsp;&nbsp;
<button class="btn btn-warning" onclick="stopWorker()">Stop Worker(단순)</button>
<br/><br/>

<h3 class="text-center">응용 web worker</h3>
<div class="form-group">
	<label for="ucal">계산</label>
	<input type="number" class="form-control" name="ucal" placeholder="숫자 입력" id="ucal"/>
</div>
<p class="text-center" id="sum" style="font-size:25px;">Sum :</p>
<button class="btn btn-info" onclick="calculate()">Calculate</button>&nbsp;&nbsp;
<button class="btn btn-warning" onclick="stopCalculate()">StopCalculate</button>

<!-- main html이므로 Worker객체를 만들고 워커(백그라운드)테스크를 콘트롤 -->
<script>
let w; //Worker객체 변수
function startWorker() {
	if(typeof(Worker) != "undefined") {
		if(typeof(w) == "undefined") { //Worker객체 생성 안된 경우
			w = new Worker("js/worker1.js"); //워커테스크는 내 프로젝트안에 존재하여야 함
		}
		w.onmessage = function(event) {
			document.getElementById("result").innerHTML = event.data;
			//event는 MessageEvent이고 data는 MessageEvent의 속성 
		};
	}
	else {
		document.getElementById("result").innerHTML =
			"Sorry, your browser does not support Web Workers...";
	}
}

function stopWorker() {
	w.terminate(); //worker종료
	w = undefined; //worker초기화
}
</script>

<script>
var worker;
function calculate() {
	if(worker) {
		worker.terminate();
	}
	var num = document.getElementById("ucal").value; //input에 입력된 값
	worker = new Worker("js/worker2.js");
	worker.onmessage = function(evt) {
		document.getElementById("sum").innerHTML = "Sum : " + evt.data;
	};
	worker.onerror = function(evt) {
		alert("Error : " + evt.message + " (" + evt.filename + ":" + evt.lineno + ")");
	}
	worker.postMessage(num); //백그라운드테스크에 값을 전달함
}

function stopCalculate() {
	if(worker) {
		worker.terminate();
	}
	alert("Worker is Stopped");
}
</script>
</body>
</html>