<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>pdsList.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <link rel="stylesheet" type="text/css" href="${ctp}/css/linkOrange.css"/>
  <script>
  	'use strict';
  	
  	function partCheck() {
			let part = $("#part").val();
			location.href="pdsList?pag=${pageVO.pag}&pageSize=${pageVO.pageSize}&part="+part;
		}
  	
  	function pdsDeleteCheck(idx, fSName) {
  		let ans = confirm("선택하신 자료를 삭제 하시겠습니까?");
  		
  		if(!ans) return false;
  		
  		$.ajax({
  			url: "${ctp}/pds/pdsDeleteCheck",
  			type: "post",
  			data: {idx:idx, fSName:fSName},
  			success: (res) => {
  				if(res != '0') {
  					alert("자료가 정상적으로 삭제되었습니다.");
  					location.reload();
  				}
  				else alert("자료 삭제에 실패했습니다.");
  			},
  			error: () => alert("전송오류")
  		});
  		
		}

  	function downNumCheck(idx) {
			/* let ans = confirm("선택하신 자료를 다운로드 하시겠습니까?");
			if(!ans) return false; */
			
			$.ajax({
				url: "${ctp}/pds/pdsDownNumCheck",
				type: "post",
				data: {idx:idx},
				success: (res) => {
					location.reload();
				},
				error: () => alert("전송오류")
			});
		}
  	
  	function modalView(title,nickName,fDate,fSName,fName) {
    	fDate = fDate.substring(0,10);
    	
    	$(".modal-title").html(title);
    	$(".modal-body #nickName").html(nickName);
    	$(".modal-body #fDate").html(fDate);
    	/* $(".modal-body #fName").html(fName); */
    	
    	let fNames = fName.split("/");
    	let fSNames = fSName.split("/");
    	let imgs = "";
    	
    	for(let i=0; i<fSNames.length; i++) {
    	  imgs += '<img src="${ctp}/pds/' + fSNames[i] + '" width="100%;"><br><div class="text-end">'+fNames[i]+'</div><br>';
    	}
    	$(".modal-body #imgs").html(imgs);
    	
    }
  </script>
  <style>
   .gb-pager { 
     gap: .25rem; 
   }
   .gb-pager .page-link { 
	   border: 0; border-radius: 50% !important; 
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
      background: #f1f3f5; color: #212529; 
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
<body class="d-flex flex-column min-vh-100">
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container flex-grow-1 py-4">
  <h2 class="text-center">자 료 실 리 스 트 (${pageVO.part})</h2>
  <br>
  <table class="table table-borderless m-0 p-0">
    <tr>
      <td>
        <form name="partForm">
          <select name="part" id="part" onchange="partCheck()" class="mt-1">
            <option ${pageVO.part == '전체' ? 'selected' : ''}>전체</option>
            <option ${pageVO.part == '학습' ? 'selected' : ''}>학습</option>
            <option ${pageVO.part == '여행' ? 'selected' : ''}>여행</option>
            <option ${pageVO.part == '음식' ? 'selected' : ''}>음식</option>
            <option ${pageVO.part == '기타' ? 'selected' : ''}>기타</option>
          </select>
        </form>
      </td>
      <td class="text-end">
        <a href="pdsInput?part=${pageVO.part}" class="btn btn btn-sm btn-outline-dark">자료올리기</a>
      </td>
    </tr>
  </table>
  <table class="table table-hover text-center">
    <tr class="table-secondary">
      <th>번호</th>
      <th>자료제목</th>
      <th>올린이</th>
      <th>올린날짜</th>
      <th>분류</th>
      <th>파일명(크기)</th>
      <th>다운수</th>
      <th>비고</th>
    </tr>
    <c:set var="curScrStartNo" value="${pageVO.curScrStartNo}"/>
    <c:forEach var="vo" items="${vos}" varStatus="st">
      <tr>
        <td>${curScrStartNo}</td>
        <td>
         <a href="pdsContent?idx=${vo.idx}&pag=${pageVO.pag}&pageSize=${pageVO.pageSize}&part=${pageVO.part}">${vo.title}</a>
        </td>
        <td><a href="#" onclick="modalView('${vo.title}','${vo.nickName}','${vo.FDate}','${vo.FSName}','${vo.FName}')" data-bs-toggle="modal" data-bs-target="#myModal">${vo.nickName}</a></td>
        <td>${fn:substring(vo.FDate, 0, 10)}</td>
        <td>${vo.part}</td>
        <td>
	        <c:set var="fNames" value="${fn:split(vo.FName, '/')}" />
	        <c:set var="fSNames" value="${fn:split(vo.FSName, '/')}" />
	        <c:forEach var="fName" items="${fNames}" varStatus="st">
		        <a href="${ctp}/pds/${fSNames[st.index]}" download="${fName}" onclick="downNumCheck(${vo.idx})">${fName}</a><br>
	        </c:forEach>
        </td>
        <td>${vo.downNum}</td>
        <td>
      	  <c:if test="${vo.mid == sMid || sLevel == 0}">
	          <div><a href="javascript:pdsDeleteCheck('${vo.idx}','${vo.FSName}')" class="badge bg-danger" style="text-decoration:none;">삭제</a></div>
	          <div><a href="pdsTotalDown?idx=${vo.idx}" class="badge bg-success" style="text-decoration:none;">압축본</a></div>
	        </c:if>
        </td>
      </tr>
      <c:set var="curScrStartNo" value="${curScrStartNo - 1}"/>
    </c:forEach>
  </table>
  <!-- 페이징처리 -->
  <c:if test="${pageVO.totPage >= 1}">
    <nav class="mt-4">
      <ul class="pagination gb-pager justify-content-center">
        <!-- 이전 -->
        <li class="page-item ${pageVO.pag == 1 ? 'disabled' : ''}">
          <a class="page-link" href="pdsList?pag=${pageVO.pag - 1}&pageSize=${pageVO.pageSize}&part=${pageVO.part}" title="이전"><i class="bi bi-chevron-left"></i></a>
        </li>
        <!-- 맨 앞 1 … -->
        <c:if test="${pageVO.startPage > 1}">
          <li class="page-item"><a class="page-link" href="pdsList?pag=1&pageSize=${pageVO.pageSize}&part=${pageVO.part}">1</a></li>
          <c:if test="${pageVO.startPage > 2}"><li class="page-item gb-dots"><span class="page-link">…</span></li></c:if>
        </c:if>
        <!-- 현재 페이지 중심 번호 -->
        <c:forEach var="i" begin="${pageVO.startPage}" end="${pageVO.endPage}">
          <li class="page-item ${pageVO.pag == i ? 'active' : ''}">
            <a class="page-link" href="pdsList?pag=${i}&pageSize=${pageVO.pageSize}&part=${pageVO.part}">${i}</a>
          </li>
        </c:forEach>
        <!-- … 마지막 -->
        <c:if test="${pageVO.endPage < pageVO.totPage}">
          <c:if test="${pageVO.endPage < pageVO.totPage - 1}"><li class="page-item gb-dots"><span class="page-link">…</span></li></c:if>
          <li class="page-item"><a class="page-link" href="pdsList?pag=${pageVO.totPage}&pageSize=${pageVO.pageSize}&part=${pageVO.part}">${pageVO.totPage}</a></li>
        </c:if>
        <!-- 다음 -->
        <li class="page-item ${pageVO.pag == pageVO.totPage ? 'disabled' : ''}">
          <a class="page-link" href="pdsList?pag=${pageVO.pag + 1}&pageSize=${pageVO.pageSize}&part=${pageVO.part}" title="다음"><i class="bi bi-chevron-right"></i></a>
        </li>
      </ul>
    </nav>
  </c:if>
  <!-- 페이징처리 끝 -->
</div>
<!-- The Modal -->
<div class="modal fade" id="myModal">
  <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content">

      <!-- Modal Header -->
      <div class="modal-header">
        <h4 class="modal-title">Modal Heading</h4>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <!-- Modal body -->
      <div class="modal-body">
				<div id="nickName"></div>
				<div id="fDate"></div>
				<hr>
				<!-- <div id="fName"></div> -->
				<div id="imgs"></div>
				<!-- <img id="imgSrc" width="250px"> -->
      </div>

      <!-- Modal footer -->
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Close</button>
      </div>

    </div>
  </div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>