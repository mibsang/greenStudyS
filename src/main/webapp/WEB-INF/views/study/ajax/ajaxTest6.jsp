<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>ajaxTest6.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script>
  	'use strict';
  	
  	/* function midCheck() {
			$("#demo").html($("#mid").val());
		} */
		
		// 문자열로 받아 back에서 처리
  	function midCheck() {
			let mid = $("#mid").val();
    	if(mid == "") {
    		alert("아이디를 선택하세요");
    		return false;
    	}
    	
    	$.ajax({
    		url  : 'ajaxTest6',
    		type : 'post',
    		data : {mid : mid},
    		success: (res) => {
    			$("#demo").html(res);
    		},
    		error : () => alert('전송오류!')
    	});
    }
		
		// vo로 받아 front에서 처리
  	function midCheck2() {
			let mid = $("#mid2").val();
    	if(mid == "") {
    		alert("아이디를 선택하세요");
    		return false;
    	}
    	
    	$.ajax({
    		url  : 'ajaxTest6_2',
    		type : 'post',
    		data : {mid : mid},
    		success: (res) => {
    			console.log(res);
    			let str = '';
    			str += "<h3>회원정보</h3>";
    			str += "고유번호 : " + res.idx + "<br>";
    			str += "아이디 : " + res.mid + "<br>";
    			str += "이름 : " + res.name + "<br>";
    			str += "나이 : " + res.age + "<br>";
    			str += "성별 : " + res.gender + "<br>";
    			str += "주소 : " + res.address + "<br>";
    			$("#demo2").html(str);
    		},
    		error : () => alert('전송오류!')
    	});
    }
		
		// vos로 받아서 처리
  	function genderCheck() {
			let gender = $("#gender").val();
    	if(gender == "") {
    		alert("성별을 선택하세요");
    		return false;
    	}
    	
    	$.ajax({
    		url  : 'ajaxTest6_3',
    		type : 'post',
    		data : {gender : gender},
    		success: (res) => {
    			let str = '';
    			str += "<h3 class='text-center'>회원정보</h3>";
    			str += "<table class='table table-hover text-center'>";
    			str += "<tr class='table-secondary'>";
    			str += "<th>고유번호</th><th>아이디</th><th>이름</th><th>나이</th><th>성별</th><th>주소</th>";
    			str += "</tr>";
					for(let i=0; i<res.length; i++) {
						str += "<tr>";
						str += "<td>"+res[i].idx+"</td>";
						str += "<td>"+res[i].mid+"</td>";
						str += "<td>"+res[i].name+"</td>";
						str += "<td>"+res[i].age+"</td>";
						str += "<td>"+res[i].gender+"</td>";
						str += "<td>"+res[i].address+"</td>";
						str += "</tr>";
					}
    			str += "</table>"
    			$("#demo3").html(str);
    		},
    		error : () => alert('전송오류!')
    	});
    }
		
  </script>
</head>
<body class="d-flex flex-column min-vh-100">
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container flex-grow-1 py-4">
  <h2>ajaxTest6(DB자료검색:ID)</h2>
  <hr>
  <form>
  	<h4>1.아이디를 선택하세요(문자열로 받아 back에서 처리)</h4>
  	<table class="table">
  		<tr>
  			<td>
  				<select name="mid" id="mid" onchange="midCheck()">
  					<option value="">아이디선택</option>
  					<c:forEach var="mid" items="${midVos}" varStatus="st">
  						<option>${mid}</option>
  					</c:forEach>
  				</select>
  			</td>
  			<td>
  				<div id="demo"></div>
  			</td>
  		</tr>
  	</table>
  	<hr>
  	<h4>2.아이디를 선택하세요(vo로 받아서 front에서 처리)</h4>
  	<table class="table">
  		<tr>
  			<td>
  				<select name="mid" id="mid2" onchange="midCheck2()">
  					<option value="">아이디선택</option>
  					<c:forEach var="mid" items="${midVos}" varStatus="st">
  						<option>${mid}</option>
  					</c:forEach>
  				</select>
  			</td>
  			<td>
  				<div id="demo2"></div>
  			</td>
  		</tr>
  	</table>
  	<hr>
  	<h4>3.성별로 검색하세요(vos받기)</h4>
  	<table class="table">
  		<tr>
  			<td>
  				<select name="gender" id="gender" onchange="genderCheck()">
  					<option value="">성별 선택</option>
  					<c:forEach var="vo" items="${genderVos}" varStatus="st">
  						<option>${vo.gender}</option>
  					</c:forEach>
  				</select>
  			</td>
  			<td>
  				<div id="demo3"></div>
  			</td>
  		</tr>
  	</table>
  	<hr>
  </form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>