<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <title>adadadMemberList.jsp(관리자)</title>
  <script>
    'use strict';
    
    function levelChange(idx) {
    	let level = document.getElementById("level"+idx).value;
    	let strLv = "";
    	if(level == 0) strLv = "관리자";
    	else if(level == 1) strLv = "우수회원";
    	else if(level == 2) strLv = "정회원";
    	else if(level == 3) strLv = "준회원";
    	else if(level == 99) strLv = "탈퇴회원";
    	
    	let ans = confirm("현재 등급을 "+strLv+"으로 변경하시겠습니까?");
    	
    	if(!ans){ 
    		location.reload();
    		return false;
    	}
    	
      $.ajax({
    	  url: "adMemberLevelChange",
    	  type: "post",
    	  data: {
    		  idx : idx,
    		  level : level
    	  },
    	  success: (res) => {
    		  if(res != '0') {
    			  alert('회원등급이 변경 되었습니다.');
    			  location.reload();
    		  }
    		  else alert('회원등급 변경 오류');
    	  },
    	  error: () => alert("전송오류")
      });
    }
    // 전체선택
    function allCheck() {
      for(let i=0; i<myform.idxFlag.length; i++) {
        myform.idxFlag[i].checked = true;
      }
    }

    // 전체취소
    function allReset() {
      for(let i=0; i<myform.idxFlag.length; i++) {
        myform.idxFlag[i].checked = false;
      }
    }

    // 선택반전
    function reverseCheck() {
      for(let i=0; i<myform.idxFlag.length; i++) {
        myform.idxFlag[i].checked = !myform.idxFlag[i].checked;
      }
    }
    
    function levelSelectCheck() {
			let idxSelectArray = "";
			let levelItemText = $("#levelItem option:selected").text();
			let levelItem = $("#levelItem").val();
			
			if(levelItem == "") {
				alert("변경하려는 등급을 선택 후 시도해주세요.");
				return false;
			}
			
			if($("input[name='idxFlag']:checked").length == 0) {
			  alert("변경하려는 회원을 선택 후 시도해주세요.");
			  return false;
			}
			
			for(let i=0; i<myform.idxFlag.length; i++) {
				if(myform.idxFlag[i].checked) idxSelectArray += myform.idxFlag[i].value + "/";
			}
			idxSelectArray = idxSelectArray.substring(0, idxSelectArray.lastIndexOf("/"));

			let query = {idxSelectArray : idxSelectArray, levelItem : levelItem};
			
			$.ajax({
				url: "adMemberLevelSelectCheck",
				type: "post",
				data: query,
				success: (res) => {
					if(res != 0) alert("선택한 항목이 '" + levelItemText + "' (으)로 변경되었습니다.");
					else alert("등급변경 실패");
					location.reload();
				},
				error: () => alert("전송오류")
			});
    }
    
    function selectPageSize() {
  		let pageSize = $("#pageSize").val();
  		location.href = "adMemberList?pageSize=" + pageSize;
  	}
    
    
    $(() => {
      let levels = "${levels}";
      let levelFlag = document.getElementsByName("levelFlag");
      for(let i=0; i<levelFlag.length; i++) {
        if(levels.indexOf(levelFlag[i].value) != -1) levelFlag[i].checked = true;
      }
    });

    function selectPageSize() {
      let pageSize = $("#pageSize").val();
      location.href = "adMemberList?pageSize=" + pageSize + "&levels=${levels}";
    }

    function levelFilter() {
      let levelFlag = document.getElementsByName("levelFlag");
      let levels = "";
      for(let i=0; i<levelFlag.length; i++) {
        if(levelFlag[i].checked) levels += levelFlag[i].value + ",";
      }
      levels = levels.substring(0, levels.lastIndexOf(","));

      let pageSize = $("#pageSize").val();
      location.href = "adMemberList?pageSize=" + pageSize + "&levels=" + levels;
    }
    
    function memberDeleteOk() {
    	let idxSelectArray = "";
    	
    	if($("input[name='idxFlag']:checked").length == 0) {
        alert("삭제하려는 회원을 선택 후 시도해주세요.");
        return false;
      }

      let ans = confirm("선택하신 회원을 영구삭제 하시겠습니까?");
      if(!ans) return false;

      for(let i=0; i<myform.idxFlag.length; i++) {
        if(myform.idxFlag[i].checked) idxSelectArray += myform.idxFlag[i].value + "/";
      }
      idxSelectArray = idxSelectArray.substring(0, idxSelectArray.lastIndexOf("/"));
      
    	$.ajax({
				url: "${ctp}/admin/memberDeleteOk",
				type: "post",
				data: {idxSelectArray : idxSelectArray},
				success: (res) => {
					if(res != 0) alert("선택한 회원 정보가 정상적으로 삭제되었습니다.");
					else alert("삭제 실패");
					location.reload();
				},
				error: () => alert("전송오류")
			});
			
		}
  </script>
  <style>
    .gb-pager { 
      gap: .25rem; 
    }
    .gb-pager .page-link { 
      border: 0; 
      border-radius: 50% !important; 
      width: 36px; 
      height: 36px;
      display: flex; 
      align-items: center; 
      justify-content: center;
      color: #495057; 
      background: transparent; 
      font-size: .9rem; 
    }
    .gb-pager .page-link:hover { 
      background: #f1f3f5; 
      color: #212529; 
    }
    .gb-pager .page-item.active .page-link { 
      background: #212529; 
      color: #fff; 
      font-weight: 600; 
    }
    .gb-pager .page-item.disabled .page-link { 
      color: #dee2e6; 
      background: transparent; 
    }
    .gb-pager .gb-dots .page-link { 
      width: auto; 
      color: #adb5bd; 
      cursor: default; 
    }
  </style>
</head>
<body>
<p><br/></p>
<div class="container">
  <h2 class="text-center mb-3">회 원 리 스 트</h2>
  <div class="mb-2">
	  <input type="checkbox" name="levelFlag" value="99" onchange="levelFilter()"> 탈퇴회원
	  <input type="checkbox" name="levelFlag" value="3" onchange="levelFilter()"> 준회원
		<input type="checkbox" name="levelFlag" value="2" onchange="levelFilter()"> 정회원
		<input type="checkbox" name="levelFlag" value="1" onchange="levelFilter()"> 우수회원
		<input type="checkbox" name="levelFlag" value="0" onchange="levelFilter()"> 관리자
	</div>
  <div class="row mb-2">
	  <div class="col text-start">
	    <input type="button" value="전체선택" onclick="allCheck()" class="btn btn-outline-success btn-sm">
	    <input type="button" value="전체해제" onclick="allReset()" class="btn btn-outline-warning btn-sm">
	    <input type="button" value="선택반전" onclick="reverseCheck()" class="btn btn-outline-danger btn-sm">
	    <select name="levelItem" id="levelItem" class="form-select form-select-sm w-auto d-inline-block">
	      <option value="" selected>-- --</option>
	      <option value="1">우수회원</option>
	      <option value="2">정회원</option>
	      <option value="3">준회원</option>
	      <option value="99">탈퇴회원</option>
	    </select>
	    <input type="button" value="선택항목일괄변경" onclick="levelSelectCheck()" class="btn btn-outline-primary btn-sm">
	  </div>
	  <div class="col text-end">
	    <input type="button" value="선택회원삭제" onclick="memberDeleteOk()" class="btn btn-outline-danger btn-sm">
	    <select name="pageSize" id="pageSize" onchange="selectPageSize()" class="form-select form-select-sm w-auto d-inline-block">
	      <option value="5" ${vo.pageSize == 5 ? 'selected' : ''}>5</option>
	      <option value="10" ${vo.pageSize == 10 ? 'selected' : ''}>10</option>
	      <option value="15" ${vo.pageSize == 15 ? 'selected' : ''}>15</option>
	      <option value="20" ${vo.pageSize == 20 ? 'selected' : ''}>20</option>
	    </select>
	  </div>
	</div>
  <form name="myform">
	  <table class="table table-hover text-center">
	    <tr class="table-secondary">
	      <th>비고</th>
	      <th>번호</th>
	      <th>닉네임</th>
	      <th>아이디</th>
	      <th>성명</th>
	      <th>이메일</th>
	      <th>생일</th>
	      <th>마지막접속기록</th>
	      <th>회원등급</th>
	    </tr>
	    <c:forEach var="vo" items="${vos}" varStatus="st">
		    <tr>
		    	<c:if test="${vo.level != 0}">
			    	<td>
			    		<input type="checkbox" name="idxFlag" id="idxFlag${vo.idx}" value="${vo.idx}">
			    	</td>
		    	</c:if>
		    	<c:if test="${vo.level == 0}">
			    	<td>
			    		<input type="checkbox" disabled>
			    	</td>
		    	</c:if>
		      <td>${st.count}</td>
		      <td>${vo.nickName}</td>
		      <td><a href="adMemberContent?mid=${vo.mid}">${vo.mid}</a></td>
		      <td>
		      	<c:if test="${vo.userDel == 'OK' && vo.deleteDiff >= 30}"><font color="red">${vo.name}</font></c:if>
		      	<c:if test="${vo.userDel == 'OK' && vo.deleteDiff < 30}"><font color="black">${vo.name}</font></c:if>
		      	<c:if test="${vo.userDel == 'NO'}"><font color="black">${vo.name}</font></c:if>
		      </td>
		      <td>${vo.email}</td>
		      <td>${fn:substring(vo.birthday, 0, 10)}</td>
		      <td>
		      	<c:if test="${vo.userDel == 'OK' && vo.deleteDiff >= 30}"><font color="red">${vo.deleteDiff}일전</font></c:if>
		      	<c:if test="${vo.userDel == 'OK' && vo.deleteDiff < 30}"><font color="black">${vo.deleteDiff}일전</font></c:if>
		      	<c:if test="${vo.userDel == 'NO'}"><font color="black">${vo.deleteDiff}일전</font></c:if>
		      </td>
		      <td>
		      	<c:if test="${vo.level != 0}">
			      	<select name="level" id="level${vo.idx}" onchange="levelChange(${vo.idx})">
			      	  <option value="0" ${vo.level == 0 ? 'selected' : ''}>관리자</option>
			      	  <option value="1" ${vo.level == 1 ? 'selected' : ''}>우수회원</option>
			      	  <option value="2" ${vo.level == 2 ? 'selected' : ''}>정회원</option>
			      	  <option value="3" ${vo.level == 3 ? 'selected' : ''}>준회원</option>
			      	  <option value="99" ${vo.level == 99 ? 'selected' : ''}>탈퇴회원</option>
			      	</select>
		      	</c:if>
		      	<c:if test="${vo.level == 0}">
			      	<select disabled>
			      	  <option value="0" ${vo.level == 0 ? 'selected' : ''}>관리자</option>
			      	  <option value="1" ${vo.level == 1 ? 'selected' : ''}>우수회원</option>
			      	</select>
		      	</c:if>
		      </td>
		    </tr>
	    </c:forEach>
	  </table>
	  <c:if test="${vo.totPage >= 1}">
    <nav class="mt-4">
      <ul class="pagination gb-pager justify-content-center">
        <!-- 이전 -->
        <li class="page-item ${vo.pag == 1 ? 'disabled' : ''}">
          <a class="page-link" href="adMemberList?pag=${vo.pag - 1}&pageSize=${vo.pageSize}&levels=${levels}" title="이전"><i class="bi bi-chevron-left"></i></a>
        </li>
        <!-- 맨 앞 1 … -->
        <c:if test="${vo.startPage > 1}">
          <li class="page-item"><a class="page-link" href="adMemberList?pag=1&pageSize=${vo.pageSize}&levels=${levels}">1</a></li>
          <c:if test="${vo.startPage > 2}"><li class="page-item gb-dots"><span class="page-link">…</span></li></c:if>
        </c:if>
        <!-- 현재 페이지 중심 번호 -->
        <c:forEach var="i" begin="${vo.startPage}" end="${vo.endPage}">
          <li class="page-item ${vo.pag == i ? 'active' : ''}">
            <a class="page-link" href="adMemberList?pag=${i}&pageSize=${vo.pageSize}&levels=${levels}">${i}</a>
          </li>
        </c:forEach>
        <!-- … 마지막 -->
        <c:if test="${vo.endPage < vo.totPage}">
          <c:if test="${vo.endPage < vo.totPage - 1}"><li class="page-item gb-dots"><span class="page-link">…</span></li></c:if>
          <li class="page-item"><a class="page-link" href="adMemberList?pag=${vo.totPage}&pageSize=${vo.pageSize}&levels=${levels}">${vo.totPage}</a></li>
        </c:if>
        <!-- 다음 -->
        <li class="page-item ${vo.pag == vo.totPage ? 'disabled' : ''}">
          <a class="page-link" href="adMemberList?pag=${vo.pag + 1}&pageSize=${vo.pageSize}&levels=${levels}" title="다음"><i class="bi bi-chevron-right"></i></a>
        </li>
      </ul>
    </nav>
  </c:if>
  </form>
</div>
<p><br/></p>
</body>
</html>