<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<script>
	function userDelCheck() {
		let ans = confirm("회원탈퇴를 진행하시겠습니까?");
		
		if(ans) {
			ans = confirm("탈퇴 후 1개월간 같은 아이디로 재가입이 불가능합니다.\n그래도 탈퇴를 진행하시겠습니까?");
			if(ans) {
				$.ajax({
					url: "${ctp}/member/userDel",
					type: "post",
					success: (res) => {
						if(res != 0) {
							alert("정상적으로 탈퇴되었습니다.");
							location.href="${ctp}/";
						}
						else alert("회원탈퇴 진행중 오류가 발생했습니다.");
					},
					error: () => alert("전송오류")
				});
			}
		}
	}
</script>

<div class="w3-top">
  <div class="w3-bar w3-black w3-card">
    <a class="w3-bar-item w3-button w3-padding-large w3-hide-medium w3-hide-large w3-right" href="javascript:void(0)" onclick="myFunction()" title="Toggle Navigation Menu"><i class="fa fa-bars"></i></a>
    <!-- <a href="http://192.168.50.62:9090/greenStudyS" class="w3-bar-item w3-button w3-padding-large">HOME</a> -->
    <a href="${ctp}/" class="w3-bar-item w3-button w3-padding-large">HOME</a>
    <a href="${ctp}/guest/guest" class="w3-bar-item w3-button w3-padding-large w3-hide-small">GUEST</a>
    <c:if test="${!empty sLevel}">
	    <a href="${ctp}/board/boardList" class="w3-bar-item w3-button w3-padding-large w3-hide-small">BOARD</a>
	    <a href="#contact" class="w3-bar-item w3-button w3-padding-large w3-hide-small">PDS</a>
	    <div class="w3-dropdown-hover w3-hide-small">
	      <button class="w3-padding-large w3-button" title="More">STUDY1<i class="fa fa-caret-down"></i></button>     
	      <div class="w3-dropdown-content w3-bar-block w3-card-4">
	        <a href="${ctp}/study/ajaxForm" class="w3-bar-item w3-button">AJAX</a>
	        <a href="${ctp}/user/userList/idxOrderDesc" class="w3-bar-item w3-button">DB</a>
	        <a href="${ctp}/user2/user2Main" class="w3-bar-item w3-button">MY BATIS</a>
	        <a href="${ctp}/study/fileUpload" class="w3-bar-item w3-button">FileUploadTest</a>
	        <a href="${ctp}/study/mailForm" class="w3-bar-item w3-button">E-MAIL</a>
	        <a href="${ctp}/study/passwordForm" class="w3-bar-item w3-button">PASSWORD</a>
	      </div>
	    </div>
	    <div class="w3-dropdown-hover w3-hide-small">
	      <button class="w3-padding-large w3-button" onclick="location.href='${ctp}/member/memberMain'" title="More">MyPage <i class="fa fa-caret-down"></i></button>     
	      <div class="w3-dropdown-content w3-bar-block w3-card-4">
	      	<c:if test="${sLevel != 3}">
	        	<a href="${ctp}/member/memberList" class="w3-bar-item w3-button">회원리스트</a>
	        </c:if>
	        <a href="${ctp}/member/memberPwdCheck/p" class="w3-bar-item w3-button">비밀번호변경</a>
	        <a href="${ctp}/member/memberPwdCheck/u" class="w3-bar-item w3-button">회원정보수정</a>
	        <a href="javascript:userDelCheck()" class="w3-bar-item w3-button">회원탈퇴</a>
	        <c:if test="${sLevel == 0}">
	        	<a href="${ctp}/admin/adminMain" class="w3-bar-item w3-button">관리자페이지</a>
	        </c:if>
	      </div>
	    </div>
    </c:if>
    <span class="w3-right">
    	<c:if test="${empty sLevel}">
		  <a href="${ctp}/member/memberJoin" class="w3-padding-large w3-button">JOIN</a>     
		  <a href="${ctp}/member/memberLogin" class="w3-padding-large w3-button">LOG-IN</a>  
		  </c:if>
		  <c:if test="${!empty sLevel}">   
		  <a href="${ctp}/member/memberLogout" class="w3-padding-large w3-button">LOG-OUT</a>     
		  </c:if>
		  <!-- <a href="javascript:void(0)" class="w3-padding-large w3-hover-red w3-hide-small w3-right"><i class="fa fa-search"></i></a> -->
	  </span>
  </div>
</div>

<!-- Navbar on small screens (remove the onclick attribute if you want the navbar to always show on top of the content when clicking on the links) -->
<div id="navDemo" class="w3-bar-block w3-black w3-hide w3-hide-large w3-hide-medium w3-top" style="margin-top:46px">
  <a href="#band" class="w3-bar-item w3-button w3-padding-large" onclick="myFunction()">GUEST</a>
  <a href="#tour" class="w3-bar-item w3-button w3-padding-large" onclick="myFunction()">BOARD</a>
  <a href="#contact" class="w3-bar-item w3-button w3-padding-large" onclick="myFunction()">PDS</a>
  <a href="#" class="w3-bar-item w3-button w3-padding-large" onclick="myFunction()">MEMBER</a>
</div>