<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>   
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix ="sec" uri = "http://www.springframework.org/security/tags" %>
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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<title>contact</title>
<style>
html,body {
	width : 100%;
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
#search-panel {
	width:65%;
	position: relative;
	top: 60px;
	z-index: 5;
	background-color: #FFFFFF;
	padding: 5px;
	margin: auto;
}
#address {
	padding : 10px;
}
#google-map {
	width: 100%;
	height: 600px;
	margin: 0;
	padding: 0;
}
</style>
</head>
<body>

<%@ include file="nav.jsp" %>
<%@ include file="carousel.jsp" %>

<div id="main" class="container mt-5">
	<h3 class="text-center">Contacts</h3>
	<div id="search-panel"> <!-- ????????? ?????? ?????? -->
		<input id="address" type="text" placeholder="????????? ???????????????" size="70px"/>
		<button id="submit" type="button" class="btn btn-primary" value="Geocode">?????? ??????</button>
	</div>
	<div id="google-map" class="mx-auto mb-5"> <!-- ?????? ?????? ?????? ?????? -->
	</div>
	
	<!-- ????????? ?????? -->
	<div class="row">
		<div class="col-4 d-flex flex-column">
			<div class="d-flex flex-row">
				<div>
					<i class="fa fa-home" aria-hidden="true"></i>										
				</div>
				<div>
					<h5>Binghamton, New York</h5>
					<p>
						4343 Hinkle Deegan Lake Road
					</p>						
				</div>	
			</div>
			<div class="d-flex flex-row">
				<div>
					<i class="fa fa-headphones" aria-hidden="true"></i>					
				</div>
				<div>
					<h5>00 (958) 9865 562</h5>
					<p>Mon to Fri 9am to 6 pm</p>												
				</div>
			</div>
			<div class="d-flex flex-row">
				<div>
					<i class="fa fa-envelope" aria-hidden="true"></i>
				</div>
				<div>
					<h5>support@colorlib.com</h5>
					<p>Send us your query anytime!</p>						
				</div>
			</div>
		</div>
		<div class="col-8">
			<form class="text-right" id="myForm" action="" method="post">
				<div class="row">
					<div class="col-6 form-group">
						<input name="name" placeholder="Enter your name" onfocus="this.placeholder = ''" 
							onblur="this.placeholder = 'Enter your name'" class="mb-20 form-control" type="text">
						<input name="email" placeholder="Enter email address" pattern="[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{1,63}$"
							 onfocus="this.placeholder = ''" onblur="this.placeholder = 'Enter email address'" class="mb-20 form-control"
							 type="email">
						<input name="subject" placeholder="Enter subject" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Enter subject'"
							 class="mb-20 form-control" type="text">							
					</div>
					<div class="col-6 form-group">
						<textarea class="form-control" name="message" placeholder="Enter Messege" onfocus="this.placeholder = ''"
							 onblur="this.placeholder = 'Enter Messege'" rows="5"></textarea>							
					</div>
					<div class="col-12">
						<div style="text-align: left;"></div>
						<button class="btn btn-primary" style="float: right;">Send Message</button>														
					</div>
				</div>	
			</form> 
		</div>
	</div>
</div>

<%@ include file="footer.jsp" %>

<script>
//Google Map API ????????? callback ??????????????? ????????? ????????? ????????????.
//Google Map API?????? ???????????? ???????????????.
function initMap() {
	console.log('Map is initialized.');
	let map;
	getLocation();
	function getLocation() {
		if(navigator.geolocation) {
			navigator.geolocation.watchPosition(showPosition);
			//watchPosition(showPosition)??? ????????? ???????????? ????????? ???????????? ???????????? ?????? ??????
			//getCurrentPosition(showPosition)??? ???????????? ????????????
			//???????????? ??????????????? showPosition()????????? ????????? ????????? ??????
			//clearWatch()??? ??????
		}
		else {
			map = $("#google-map");
			map.text("Geolocation is not supported by this browser.");
		}
	}	
	
	function showPosition(position) { //watchPosition(showPosition)??? ????????????
		console.log(position);
		lati = position.coords.latitude; //??????
		longi = position.coords.longitude; //??????
		//????????? ???????????? ???????????? ??????
		map = new google.maps.Map(document.getElementById('google-map'),{
	    	zoom : 16, //??????
	    	center : new google.maps.LatLng(lati, longi)
	    });

		var marker = new google.maps.Marker({
			position: new google.maps.LatLng(lati,longi),
			map: map,
			title: 'Hellow World!' //????????? ?????? ??????
		});
	}
	
	//Google Geocoding. Google Map API??? ???????????? ????????? ????????? ????????? ????????? ??????
	var geocoder = new google.maps.Geocoder();
	//?????? ????????? submit ?????? ?????? ????????? ??????
	document.getElementById('submit').addEventListener('click',function(){
		console.log('submit ?????? ?????? ????????? ??????');
		geocodeAddress(geocoder, map);
	});
	
	function geocodeAddress(geocoder, resultMap) {
		console.log('geocodeAddress ?????? ??????');
		let address = document.getElementById('address').value;
		//geocode()???????????? ???????????? ????????? ????????? ??? ????????? ?????????.
		//??????????????? ???????????? ???????????? ????????????
		geocoder.geocode({'address':address},function(result, status){
			console.log(result);
			console.log(status);
			if (status === 'OK') {
				//?????? ?????? ????????? ????????????.
				resultMap.setCenter(result[0].geometry.location);
				//resultMap??? ??????????????? ?????? map
				//?????? ?????? ????????? ????????????.
				resultMap.setZoom(18);
				//??? ??????
				var marker = new google.maps.Marker({
					map: resultMap,
					position: result[0].geometry.location
				});
				console.log('??????(latitude): ' + marker.position.lat());
				console.log('??????(longitude): ' + marker.position.lng());
			}
			else {
				alert('??????????????? ????????? ????????? ???????????? ??????????????? : ' + status);
			}
		});
	}	
}
</script>

<script async defer
 src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCl3troictldoLX7-RsH7NiFiGVzUWGgv8&callback=initMap&v=weekly&channel=2">
</script>
<!-- 
async??? defer??? ????????????????????? ??????????????? ?????? html????????? ?????? ????????? defer??? ?????? script?????? ??????
defer??? html????????? ??????????????? ????????? ????????? async??? ??????????????? html????????? ??????, ????????? ????????? ????????????
??????????????? ???????????? ????????? ??????
key??? ???????????? ?????? ?????? ????????????????????? map api??? ???????????? ?????? ??????
 -->

</body>
</html>