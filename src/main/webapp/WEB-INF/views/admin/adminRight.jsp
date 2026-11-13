<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <title>adminLeft.jsp</title>
</head>
<body>
<p><br/></p>
<div class="container">
  <h2>관리자 대시보드</h2>
  <hr/>
  <div><img src="${ctp}/images/11.jpg" width="300px"/></div>
  <hr/>  
  <div><iframe src="https://www.naver.com" width="500px" height="450px"></iframe></div>
  <hr/>
</div>
<p><br/></p>
</body>
</html>