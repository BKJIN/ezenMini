/**
 * Worker.js made by Jim 2022/04/07
   워커테스크용 자바스크립트 파일
*/
let i = 0;
function timedCount() {
	i += 1;
	postMessage(i); //main html의 Worker객체로 전달
	//window의 postMessage임
	//메인 html의 Worker객체는 message이벤트를 발생
	setTimeout("timedCount()",500);
	//timedCount()콜백함수를 0.5초후에 실행
}

timedCount();