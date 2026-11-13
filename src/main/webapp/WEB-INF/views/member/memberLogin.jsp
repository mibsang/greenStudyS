<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <title>memberLogin.jsp</title>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
	<form name="myform" method="post" action="memberLogin">
		<table class="table table-bordered text-center">
			<tr>
				<td colspan="2"><font size="5">로그인</font></td>
			</tr>
			<tr>
				<th>아이디</th>
				<td><input type="text" name="mid" id="mid" value="${cookie.cMid.value}" autofocus required class="form-control" /></td>
			</tr>
			<tr>
				<th>비밀번호</th>
				<td><input type="password" name="pwd" id="pwd" required class="form-control" /></td>
			</tr>
			<tr>
				<td colspan="2">
					<label class="input-check-label"><input type="checkbox" name="idSave" class="me-2 mt-2 mb-3" checked />아이디저장</label> <!-- 쿠키에 저장 처리 해야함 -->
					<br>
					<input type="submit" value="Login" class="btn btn-success me-2" />
					<input type="reset" value="Reset" class="btn btn-warning me-2" />
					<input type="button" value="Join" onclick="location.href='memberJoin'" class="btn btn-primary me-2" />
				</td>
			</tr>
		</table>
	</form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>