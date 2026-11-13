<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>memberPwdCheck.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script>
  	'use strict';

  	$(() => {
	  	$("#pwdDemo").hide();
  	});
  	
  	function pwdCheck() {
			let pwd = $("#pwd").val().trim();
			if(pwd == "") {
				alert("현재 비밀번호를 입력하세요.");
				$("#pwd").focus();
				return false;
			}
			
			$.ajax({
				url: "${ctp}/member/memberPwdCheckOk",
				type: "post",
				data: {pwd:pwd, mid:'${sMid}'},
				success: (res) => {
					if(res != "0") {
						if('${pwdFlag}' == 'p') {
							$("#pwdCheckForm").hide();
							$("#pwdDemo").show();
						}
						else location.href="${ctp}/member/memberUpdate";
					}
					else alert("비밀번호 오류")
				},
				error: () => alert("전송오류")
			});
		}
  	
  	function pwdChange() {
			let changePwd = $("#changePwd").val();
			let reChangePwd = $("#reChangePwd").val();
			
			if(changePwd.trim() == "" || reChangePwd.trim() == "") {
				alert("변경할 비밀번호를 입력하세요.");
				$("#changePwd").focus();
				return false;
			}
			else if(changePwd != reChangePwd) {
				alert("비밀번호가 서로 다릅니다 확인 후 다시 입력하세요.");
				$("#reChangePwd").focus();
				return false;
			}

			$.ajax({
    		url  : '${ctp}/member/memberPwdChangeOk',
    		type : 'post',
    		data : {pwd:changePwd, mid:'${sMid}'},
    		success: (res) => {
    			if(res != "0") {
    				alert("비밀번호가 변경되었습니다.\n다시 로그인 하세요.");
    				location.href = '${ctp}/member/memberLogout';
    			}
    			else alert("비밀번호 변경오류!!!");
    		},
    		error : () => alert('전송오류')
    	});

		}
  </script>
</head>
<body class="d-flex flex-column min-vh-100">
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container flex-grow-1 py-4">
  <form name="pwdCheckForm" id="pwdCheckForm" onsubmit="pwdCheck(); return false;" method="post">
	  <h2 class="text-center">비밀번호확인</h2>
  	<table class="table table-bordered text-center">
  		<tr>
  			<td>비밀번호 입력</td>
  			<td><input type="password" name="pwd" id="pwd" class="form-control" autofocus required></td>
  		</tr>
  		<tr>
  			<td colspan="2">
  				<input type="button" value="확인" onclick="pwdCheck()" class="btn btn-outline-success">
  				<input type="reset" value="다시입력" class="btn btn-outline-warning">
  				<input type="button" value="돌아가기" onclick="location.href='${ctp}/member/memberMain'" class="btn btn-outline-info" >
  			</td>
  		</tr>
  	</table>
  </form>
  <div id="pwdDemo">
  	<h2 class="text-center">비밀번호변경</h2>
  	<form name="pwdChangeForm" method="post">
	  	<table class="table table-bordered text-center">
	  		<tr>
	  			<td>새 비밀번호 입력</td>
	  			<td><input type="password" name="changePwd" id="changePwd" class="form-control" placeholder="변경할 비밀번호를 입력하세요" required></td>
	  		</tr>
	  		<tr>
	  			<td>비밀번호 확인</td>
	  			<td><input type="password" name="reChangePwd" id="reChangePwd" class="form-control" placeholder="비밀번호 재입력" required></td>
	  		</tr>
	  		<tr>
	  			<td colspan="2">
	  				<input type="button" value="확인" onclick="pwdChange()" class="btn btn-outline-success">
	  				<input type="reset" value="다시입력" class="btn btn-outline-warning">
	  				<input type="button" value="돌아가기" onclick="location.href='${ctp}/member/memberMain'" class="btn btn-outline-info" >
	  			</td>
	  		</tr>
	  	</table>
	  </form>
  </div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>