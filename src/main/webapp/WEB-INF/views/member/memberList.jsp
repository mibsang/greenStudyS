<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <title>memberList.jsp</title>
  <style>
    .gb-pager { gap: .25rem; }
    .gb-pager .page-link { border: 0; border-radius: 50% !important; width: 36px; height: 36px;
                           display: flex; align-items: center; justify-content: center;
                           color: #495057; background: transparent; font-size: .9rem; }
    .gb-pager .page-link:hover { background: #f1f3f5; color: #212529; }
    .gb-pager .page-item.active .page-link { background: #212529; color: #fff; font-weight: 600; }
    .gb-pager .page-item.disabled .page-link { color: #dee2e6; background: transparent; }
    .gb-pager .gb-dots .page-link { width: auto; color: #adb5bd; cursor: default; }
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2 class="text-center mb-3">회 원 리 스 트</h2>
  <table class="table table-hover text-center">
  	<tr class="table-secondary">
  		<th>번호</th>
  		<th>닉네임</th>
  		<th>아이디</th>
  		<th>성명</th>
  		<th>이메일</th>
  		<th>생년월일</th>
  		<th>직업</th>
  	</tr>
  	<c:forEach var="vo" items="${vos}" varStatus="st">
	  	<tr>
	  		<td>${vo.idx}</td>
	  		<td>${vo.nickName}</td>
	  		<c:if test="${sLevel == 0 || vo.mid == sMid || vo.userInfor == '공개'}">
	  		<td><a href="memberContent?mid=${vo.mid}">${vo.mid}</a></td>
		  		<td>${vo.name}</td>
		  		<td>${vo.email}</td>
		  		<td>${fn:substring(vo.birthday, 0, 10)}</td>
		  		<td>${vo.job}</td>
	  		</c:if>
	  		<c:if test="${sLevel != 0 && vo.mid != sMid && vo.userInfor != '공개'}">
	  			<td colspan="4">정보비공개</td>
	  		</c:if>
	  	</tr>
  	</c:forEach>
  </table>
  <c:if test="${vo.totPage > 1}">
    <nav class="mt-4">
      <ul class="pagination gb-pager justify-content-center">
        <!-- 이전 -->
        <li class="page-item ${vo.pag == 1 ? 'disabled' : ''}">
          <a class="page-link" href="memberList?pag=${vo.pag - 1}&pageSize=${vo.pageSize}" title="이전"><i class="bi bi-chevron-left"></i></a>
        </li>
        <!-- 맨 앞 1 … -->
        <c:if test="${vo.startPage > 1}">
          <li class="page-item"><a class="page-link" href="memberList?pag=1&pageSize=${vo.pageSize}">1</a></li>
          <c:if test="${vo.startPage > 2}"><li class="page-item gb-dots"><span class="page-link">…</span></li></c:if>
        </c:if>
        <!-- 현재 페이지 중심 번호 -->
        <c:forEach var="i" begin="${vo.startPage}" end="${vo.endPage}">
          <li class="page-item ${vo.pag == i ? 'active' : ''}">
            <a class="page-link" href="memberList?pag=${i}&pageSize=${vo.pageSize}">${i}</a>
          </li>
        </c:forEach>
        <!-- … 마지막 -->
        <c:if test="${vo.endPage < vo.totPage}">
          <c:if test="${vo.endPage < vo.totPage - 1}"><li class="page-item gb-dots"><span class="page-link">…</span></li></c:if>
          <li class="page-item"><a class="page-link" href="memberList?pag=${vo.totPage}&pageSize=${vo.pageSize}">${vo.totPage}</a></li>
        </c:if>
        <!-- 다음 -->
        <li class="page-item ${vo.pag == vo.totPage ? 'disabled' : ''}">
          <a class="page-link" href="memberList?pag=${vo.pag + 1}&pageSize=${vo.pageSize}" title="다음"><i class="bi bi-chevron-right"></i></a>
        </li>
      </ul>
    </nav>
  </c:if>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>