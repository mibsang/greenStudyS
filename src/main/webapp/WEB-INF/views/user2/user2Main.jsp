<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>user2Main.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<script src="${ctp}/js/pointerSpectrum.js" ></script>
	<script>
		'use strict';
		
		if('${res}' != '') alert("가입이 완료 되었습니다.")
	</script>
</head>
<body class="d-flex flex-column min-vh-100">
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container flex-grow-1 py-4">
	<h2>회 원 관 리2</h2>
	<hr>
	<div>전체회원수 : ${userCnt}</div>
	<hr>
	<div class="row">
		<div class="col">
			<input type="button" value="신규등록" onclick="location.href='userInput'" class="btn btn-dark"/>
		</div>
		<div class="col">
			<input type="button" value="개별조회" onclick="location.href='user2Search'" class="btn btn-dark"/>
		</div>
		<div class="col">
			<input type="button" value="전체조회" onclick="location.href='user2List'" class="btn btn-dark"/>
		</div>
	</div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>