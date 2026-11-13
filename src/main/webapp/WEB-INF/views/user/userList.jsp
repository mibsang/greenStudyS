<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>userList.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script src="${ctp}/js/pointerSpectrum.js" ></script>
  <script>
  	'use strict';
  	
  	function orderListCheck() {
			let orderList = $("#orderList").val();
			location.href = orderList;
		}
  	
  	function formSearch() {
			let mid = $("#mid").val();
			if(mid.trim() === "") {
				alert("아이디를 입력해주세요.");
				return false;
			}
			location.href = "${ctp}/user/userSearch?mid="+mid;
		}
  	
  	function userDeleteCheck(idx) {
			let ans = confirm("선택하신 회원정보를 삭제하시겠습니까?");
			if(!ans) return false;
			
  		$.ajax({
				url: "${ctp}/user/userDelete",
				type: "post",
				success: (res) => {
					if(res != '0') {
						alert("삭제 되었습니다.");
						location.href="${ctp}/user/userList/idxOrderDesc";
					}
					else alert("삭제에 실패했습니다.");
				},
				error: () => alert("전송오류")
			});
		}
  	
  	function joinCheck() {
			$("#userInput").show();
		}
  </script>
</head>
<body class="d-flex flex-column min-vh-100">
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container flex-grow-1 py-4">
	<h2 class="text-center">회원 리스트</h2>
	<div class="row orderList">
		<div class="col"> 
			<input type="button" value="회원가입" onclick="joinCheck()" class="btn btn-dark btn-sm" >
		</div>
		<div class="col-auto ms-auto mb-2">
			<select name="orderList" id="orderList" onchange="orderListCheck()" class="form-select">
				<option value="idxOrderDesc" ${orderList == 'idxOrderDesc' ? 'selected' : ''}>내림차순 번호</option>
				<option value="midOrderAsc" ${orderList == 'midOrderAsc' ? 'selected' : ''}>오름차순 아이디</option>
				<option value="nameOrderAsc" ${orderList == 'nameOrderAsc' ? 'selected' : ''}>오름차순 성명</option>
			</select>
		</div>
	</div>
	<div id="userList">
		<table class="table table-hover text-center">
			<tr class="table-secondary">
				<th>번호</th>
				<th>아이디</th>
				<th>성명</th>
				<th>나이</th>
				<th>주소</th>
				<th>비고</th>
			</tr>
			<c:forEach var="vo" items="${vos}" varStatus="st">
				<tr>
					<td>${st.count}</td>
					<td>${vo.mid}</td>
					<td>${vo.name}</td>
					<td>${vo.age}</td>
					<td>${vo.address}</td>
					<td><a href="javascript:userDeleteCheck(${vo.idx})" class="badge badge-sm bg-danger" style="text-decoration:none;">삭제</a></td>
				</tr>
			</c:forEach>
		</table>
	</div>
  <div id="searchForm" class="input-group mb-4">
  	<div class="input-group-text bg-dark text-white">아이디검색</div>
  	<input type="text" name="mid" id="mid" placeholder="검색할 ID를 입력하세요" class="form-control">
  	<input type="button" value="검색" onclick="formSearch()" class="btn btn-dark">
  </div>
  <div id="userInput" style="display:none;">
  	<form method="post">
  		<table class="table table-bordered text-center">
  			<tr>
  				<th>아이디</th>
  				<td><input type="text" name="mid" placeholder="아이디를 입력하세요." class="form-control"></td>
  			</tr>
  			<tr>	
  				<th>성명</th>
  				<td><input type="text" name="name" placeholder="성명을 입력하세요." class="form-control"></td>
  			</tr>
  			<tr>	
  				<th>나이</th>
  				<td><input type="number" name="age" value="20" class="form-control"></td>
  			</tr>
  			<tr>	
  				<th>주소</th>
  				<td><input type="text" name="address" placeholder="주소를 입력하세요. ex)_서울시 관악구" class="form-control"></td>
  			</tr>
  			<tr>
  				<td colspan="8" class="text-center">
  					<input type="submit" value="가입" class="btn btn-dark me-2">
  					<input type="reset" value="다시입력" class="btn btn-dark me-2">
  					<input type="button" value="닫기" onclick="location.reload()" class="btn btn-dark">
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