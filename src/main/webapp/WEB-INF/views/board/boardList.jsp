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
  <title>boardList.jsp</title>
  <link rel="stylesheet" type="text/css" href="${ctp}/css/linkOrange.css"/>
  <script>
    'use strict';
    
    function pageChange() {
    	let pageSize = document.getElementById("pageSize").value;
    	location.href = "boardList?pageSize="+pageSize;
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
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2 class="text-center">게 시 판 리 스 트</h2>
  <div class="row">
    <div class="col text-start mt-2">
    	<select name="pageSize" id="pageSize" onchange="pageChange()">
    	  <option ${pageVO.pageSize==5  ? 'selected' : ''}>5</option>
    	  <option ${pageVO.pageSize==10 ? 'selected' : ''}>10</option>
    	  <option ${pageVO.pageSize==15 ? 'selected' : ''}>15</option>
    	  <option ${pageVO.pageSize==20 ? 'selected' : ''}>20</option>
    	  <option ${pageVO.pageSize==30 ? 'selected' : ''}>30</option>
    	</select>
    </div>
    <div class="col text-end"><a href="boardInput" class="btn btn-outline-dark btn-sm mb-2 text-decoration-none">글쓰기</a></div>
  </div>
  <table class="table table-hover">
    <tr class="table-secondary text-center">
      <th>번호</th>
      <th>제목</th>
      <th>닉네임</th>
      <th>작성일</th>
      <th>조회수(추천)</th>
    </tr>
    <c:set var="curScrStartNo" value="${pageVO.curScrStartNo}"/>
    <c:forEach var="vo" items="${vos}" varStatus="st">
      <tr class="text-center">
        <td>${curScrStartNo}</td>
        <td class="text-center">
          <a href="boardContent?idx=${vo.idx}&pag=${pageVO.pag}&pageSize=${pageVO.pageSize}">${vo.title}</a>
          <c:if test="${vo.replyCnt != 0}">[${vo.replyCnt}]</c:if>
          <c:if test="${vo.hour_diff < 24}"><img src="${ctp}/images/new.gif"/></c:if>
        </td>
        <td>${vo.nickName}</td>
        <td>
        	<c:if test="${vo.hour_diff >= 24}">${fn:substring(vo.WDate,0,10)}</c:if>
        	<c:if test="${vo.hour_diff < 24}">${fn:substring(vo.WDate,10,16)}</c:if>
        </td>
        <td>${vo.readNum}(${vo.good})</td>
      </tr>
      <c:set var="curScrStartNo" value="${curScrStartNo - 1}"/>
    </c:forEach>
  </table>
  <br/>
  <!-- 페이지네이션 -->
  <c:if test="${pageVO.totPage >= 1}">
    <nav class="mt-4">
      <ul class="pagination gb-pager justify-content-center">
        <!-- 이전 -->
        <li class="page-item ${pageVO.pag == 1 ? 'disabled' : ''}">
          <a class="page-link" href="boardList?pag=${pageVO.pag - 1}&pageSize=${pageVO.pageSize}" title="이전"><i class="bi bi-chevron-left"></i></a>
        </li>
        <!-- 맨 앞 1 … -->
        <c:if test="${pageVO.startPage > 1}">
          <li class="page-item"><a class="page-link" href="boardList?pag=1&pageSize=${pageVO.pageSize}">1</a></li>
          <c:if test="${pageVO.startPage > 2}"><li class="page-item gb-dots"><span class="page-link">…</span></li></c:if>
        </c:if>
        <!-- 현재 페이지 중심 번호 -->
        <c:forEach var="i" begin="${pageVO.startPage}" end="${pageVO.endPage}">
          <li class="page-item ${pageVO.pag == i ? 'active' : ''}">
            <a class="page-link" href="boardList?pag=${i}&pageSize=${pageVO.pageSize}">${i}</a>
          </li>
        </c:forEach>
        <!-- … 마지막 -->
        <c:if test="${pageVO.endPage < pageVO.totPage}">
          <c:if test="${pageVO.endPage < pageVO.totPage - 1}"><li class="page-item gb-dots"><span class="page-link">…</span></li></c:if>
          <li class="page-item"><a class="page-link" href="boardList?pag=${pageVO.totPage}&pageSize=${pageVO.pageSize}">${pageVO.totPage}</a></li>
        </c:if>
        <!-- 다음 -->
        <li class="page-item ${pageVO.pag == pageVO.totPage ? 'disabled' : ''}">
          <a class="page-link" href="boardList?pag=${pageVO.pag + 1}&pageSize=${pageVO.pageSize}" title="다음"><i class="bi bi-chevron-right"></i></a>
        </li>
      </ul>
    </nav>
  </c:if>
  <br/>
  <!-- 검색기 시작 -->
  <div class="container text-center">
    <form name="searchForm" method="post" action="boardSearchList">
      <select name="search" id="search">
        <option value="title">글제목</option>
        <option value="nickName">글쓴이</option>
        <option value="content">글내용</option>
      </select>
      <input type="text" name="searchString" id="searchString" required />
      <input type="submit" value="검색"/>
    </form>
  </div>
  <!-- 검색기 끝 -->
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>