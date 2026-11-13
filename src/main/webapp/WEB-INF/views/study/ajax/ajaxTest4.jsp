<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>ajaxTest4.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <jsp:include page="/WEB-INF/views/include/w3.jsp" />
  <script src="${ctp}/js/pointerSpectrum.js" ></script>
  <script>
  'use strict';
 
  function dodoCheck() {
	  let dodo = $("#dodo").val();
		if(dodo.trim() == "") {
			alert("지역을 선택해주세요.");
			return false;
		}
		
		$.ajax({
			url: "ajaxTest4",
			type: "post",
			data: {dodo : dodo},
			success: (res) => {
				let str = '<option>도시선택</option>';
				for(let i=0; i<res.length; i++) {
					str += '<option>' + res[i] + '</option>';
				}
				$("#city").html(str);
			},
			error: () => alert("전송오류")
		});
	}
  
  function fCheck() {
		let dodo = $("#dodo").val();
		let city = $("#city").val();
		
		let address = "";
		
		if(dodo === "서울") address = dodo + "시 " + city;
		else if (dodo === "경기") address = dodo + "도 " + city;
		else address = dodo + " " + city;
		
		$("#demo").html(address);
	}
  </script>
</head>
<body class="d-flex flex-column min-vh-100">
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container flex-grow-1 py-4">
	<h2>ajaxTest4(ArrayList)</h2>
	<form>
	<h2>도시를 입력하세요</h2>
	<select name="dodo" id="dodo" onchange="dodoCheck()">
		<option value="">지역선택</option>
		<option>서울</option>
		<option>경기</option>
		<option>충북</option>
		<option>충남</option>
	</select>
	<select name="city" id="city">
		<option>도시선택</option>
	</select>
	<input type="button" value="선택" onclick="fCheck()" class="btn btn-sm btn-info ms-2 mb-3">
	<input type="button" value="돌아가기" onclick="location.href='ajaxForm'" class="btn btn-sm btn-warning ms-2 mb-3">
	</form>
	<div id="demo"></div>
	<hr>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>