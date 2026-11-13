<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>mailForm.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script>
  	'use strict';
  	
  	function mailCheck() {
  		$("#spinner").css("display", "flex");
  		
  		myform.submit();
  	}
  	
  	function memberSearch() {
  	  let searchString = document.getElementById("searchString").value.trim();
  	  let memberRow = document.getElementsByName("memberRow");

  	  for(let i=0; i<memberRow.length; i++) {
  	    let text = memberRow[i].innerText;   // 그 줄의 이름 + 이메일 글자
  	    if(text.indexOf(searchString) != -1) memberRow[i].style.display = "";
  	    else memberRow[i].style.display = "none";
  	  }
  	}

  	// 선택한 이메일을 받는사람 목록으로
  	function mailSelect() {
  	  let mailFlag = document.getElementsByName("mailFlag");
  	  let toMail = "";

  	  for(let i=0; i<mailFlag.length; i++) {
  	    if(mailFlag[i].checked) toMail += mailFlag[i].value + ", ";
  	  }

  	  if(toMail == "") {
  	    alert("받는 사람을 선택해주세요.");
  	    return false;
  	  }
  	  toMail = toMail.substring(0, toMail.lastIndexOf(","));

  	  document.getElementById("toMail").value = toMail;
  	  bootstrap.Modal.getInstance(document.getElementById("contactModal")).hide();
  	}
  </script>
  <style>
	.spinner-overlay {
		display: none;                    /* 처음엔 숨김 */
		position: fixed;                  /* 스크롤과 상관없이 화면에 고정 */
		inset: 0;                         /* top/right/bottom/left 0 → 화면 전체 */
		background: rgba(0, 0, 0, 0.5);   /* 반투명 검정 */
		z-index: 9999;                    /* nav, 슬라이드보다 위 */
		flex-direction: column;
		justify-content: center;          /* 세로 가운데 */
		align-items: center;              /* 가로 가운데 */
	}
</style>
</head>
<body class="d-flex flex-column min-vh-100">
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container flex-grow-1 py-4">
  <h2 class="text-center">메일발송</h2>
  <div class="text-end">(받는 사람의 메일 주소를 정확히 입력하셔야 합니다.)</div>
  <!-- <form name="myform" method="post">	 -->
  <form name="myform" method="post" action="mailFormOk">	
  	<table class="table table-bordered">
  		<tr>
  			<th>받는사람</th>
  			<td>
  				<div class="input-group">
  					<input type="text" name="toMail" id="toMail" placeholder="받는사람의 메일주소를 입력하세요." autofocus required class="form-control">
  					<input type="button" value="주소록" class="btn btn-dark" data-bs-toggle="modal" data-bs-target="#contactModal">
  				</div>
  			</td>
  		</tr>
  		<tr>
  			<th>제목</th>
  			<td><input type="text" name="title" id="title" placeholder="메일 제목을 입력하세요." required class="form-control"></td>
  		</tr>
  		<tr>
  			<th>내용</th>
  			<td><textarea rows="7" name="content" id="content" placeholder="메일 내용을 입력하세요." required class="form-control"></textarea></td>
  		</tr>
  		<tr>
  			<td colspan="2" class="text-center">
  				<input type="button" value="전송" onclick="mailCheck()" class="btn btn-success me-2">
  				<input type="reset" value="다시쓰기" class="btn btn-warning me-2">
  			</td>
  		</tr>
  	</table>
  </form>	
  <!-- 주소록 모달 -->
	<div class="modal fade" id="contactModal">
	  <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
	    <div class="modal-content">
	      <div class="modal-header bg-dark">
	        <h5 class="modal-title text-white">주소록</h5>
	        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
	      </div>
	      <div class="modal-body">
	        <input type="text" id="searchString" onkeyup="memberSearch()" placeholder="이름 또는 이메일 검색" class="form-control mb-2">
	        <table class="table table-hover text-center">
	          <tr class="table-secondary">
	            <th>선택</th>
	            <th>이름</th>
	            <th>이메일</th>
	          </tr>
	          <c:forEach var="vo" items="${vos}">
	            <tr name="memberRow">
	              <td><input type="checkbox" name="mailFlag" value="${vo.email}"></td>
	              <td>${vo.name}</td>
	              <td>${vo.email}</td>
	            </tr>
	          </c:forEach>
	        </table>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-success" onclick="mailSelect()">확인</button>
	        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
	      </div>
	    </div>
	  </div>
	</div>
	<!-- 주소록 모달 끝 -->
  <div id="spinner" class="spinner-overlay">
		<div class="spinner-border text-light" style="width: 5rem; height: 5rem; border-width: 0.4rem;" role="status">
			<span class="visually-hidden">메일 전송 중...</span>
		</div>
		<div class="mt-3 text-white">메일 전송 중입니다...</div>
	</div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>