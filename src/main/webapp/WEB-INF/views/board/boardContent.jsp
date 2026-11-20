<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<% pageContext.setAttribute("newLine", "\n"); %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <title>boardContent.jsp</title>
  <link rel="stylesheet" type="text/css" href="${ctp}/css/linkOrange.css"/>
  <script>
    'use strict';
    
    $(function() {
	    $(".replyInnerContent").hide();
	    $(".replyCloseBtn").hide();
    });
    
    function deleteCheck() {
    	let ans = confirm("현재 자료를 삭제하시겠습니까?");
    	if(!ans) return false;
    	
    	location.href = 'boardDelete?idx=${vo.idx}';
    }
    
    // 좋아요수 증감처리(중복허용)
    let sw = -1;
    function goodCheck() {
    	if(sw == -1) sw = 1;
    	else sw = -1;
    	
    	$.ajax({
    		url  : "boardGoodCheck",
    		type : "post",
    		data : {
    			idx : ${vo.idx},
    			sw : sw
    	},
    		success: () => {
    			$("#boardContent").load(location.href + ' #boardContent');
    		},
    		error : () => alert("전송오류!!!")
    	});
    }
    // 댓글달기
    function replyCheck() {
    	let content = $("#content").val();
    	if(content.trim() == "") {
    		alert("댓글을 입력하세요");
    		return false;
    	}
    	let query = {
    			boardIdx : ${vo.idx},
    			mid : '${sMid}',
    			nickName : '${sNickName}',
    			hostIp : '${pageContext.request.remoteAddr}',
	    		content : content
    	}
    	
    	$.ajax({
    		url  : "${ctp}/board/boardReplyInput",
    		type : "post",
    		data : query,
    		success: (res) => {
    			if(res != '0') {
    				alert("댓글이 입력되었습니다.");
    				location.reload();
    			}
    			else alert('댓글 입력 실패~~');
    		},
    		error : () => alert("전송오류~")
    	});
    }
    
    // 댓글 삭제
    function replyDelete(idx) {
    	let ans = confirm("선택한 댓글을 삭제하시겠습니까?");
    	if(!ans) return false;
    	
    	$.ajax({
    		url  : 'boardReplyDelete',
    		type : 'post',
    		data : {idx : idx},
    		success: (res) => {
    			if(res != '0') {
    				alert("댓글이 삭제 되었습니다.");
    				location.reload();
    			}
    			else alert("삭제 실패~~");
    		},
    		error : () => alert("전송오류")
    	});
    }
    
    // 댓글 수정 동적폼 보여주기
    function replyUpdate(idx) {
    	if($("#demo"+idx).is(":visible")) {
    		$("#demo"+idx).hide();
    		return;
    	}
    	
    	$(".replyDemo").hide();
    	$(".replyInnerContent").hide();
    	$(".replyShowBtn").show();
    	$(".replyCloseBtn").hide();

    	$("#demo"+idx).show();
    }
    
    // 댓글 수정 처리
    function replyUpdateOk(idx) {
    	let content = $("#replyUpdateContent"+idx).val();
    	
    	$.ajax({
    		url  : 'boardReplyUpdateOk',
    		type : 'post',
    		data : {
    			idx : idx,
    			content : content
    		},
    		success: (res) => {
    			if(res != '0') {
    				alert("댓글이 수정 되었습니다.");
    				location.reload();
    			}
    			else alert("수정 실패~~");
    		},
    		error : () => alert("전송오류")
    	});
    }
    
    function replyShow(idx) {
    	$(".replyDemo").hide();
    	$(".replyInnerContent").hide();
    	$(".replyShowBtn").show();
    	$(".replyCloseBtn").hide();
    	
    	$("#replyShowBtn"+idx).hide();
    	$("#replyCloseBtn"+idx).show();
    	$("#replyDemo"+idx).show();
		}
    
    function replyClose(idx) {
    	$("#replyShowBtn"+idx).show();
    	$("#replyCloseBtn"+idx).hide();
    	$("#replyDemo"+idx).hide();
		}
    
    function replyCheckRe(idx, re_step, re_order) {
			let content = $("#contentRe"+idx).val();
			if(content == "") {
				alert("내용을 입력하세요.");
				$("#contentRe"+idx).focus();
				return false;
			}
			
			let query = {
					boardIdx : ${vo.idx},
					re_step : re_step,
					re_order : re_order,
					mid : '${sMid}',
					nickName : '${sNickName}',
					hostIp : '${pageContext.request.remoteAddr}',
					content : content
			}
			$.ajax({
				url: "${ctp}/board/boardReplyInputRe",
				type: "post",
				data: query,
				success: (res) => {
					if(res != '0') {
						alert("댓글이 등되었습니다.");
						location.reload();
					}
					else alert("등록오류");
				},
				error: () => alert("전송오류")
			});
		}
    function replyDisable() {
			alert("이미 삭제된 댓글입니다.");
		}
  </script>
  <style>
    th {
      background-color: #eee !important;
      text-align: center;
    }
   .board-content p {
		  margin-bottom: 0;
		}
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
  <h2 class="text-center mb-4">글 내 용 보 기</h2>
  <table class="table table-bordered" id="boardContent">
    <tr>
      <th>작성자</th>
      <td>${vo.nickName}</td>
      <th>작성일</th>
      <td>${fn:substring(vo.WDate, 0, 16)}</td>
    </tr>
    <tr>
      <th>조회수</th>
      <td>${vo.readNum}</td>
      <th>접속IP</th>
      <td>${vo.hostIp}</td>
    </tr>
    <tr>
      <th>제목</th>
      <td colspan="3">
        ${vo.title} 
        (
          <a href="javascript:goodCheck()" title="추천 수 증가">👍</a> : ${vo.good}
        )
      </td>
    </tr>
    <tr>
      <th>내용</th>
      <td colspan="3" style="height:220px" class="board-content">${vo.content}</td>
    </tr>
  </table>
  <div class="row text-center">
    <c:if test="${sMid == vo.mid || sLevel == 0}">
    	<div class="col text-start">
    	  <c:if test="${sMid == vo.mid}"><a href="boardUpdate?idx=${vo.idx}" class="btn btn-outline-primary">수정</a></c:if>
    	  <a href="javascript:deleteCheck()" class="btn btn-outline-danger">삭제</a>
    	</div>
    </c:if>
    <div class="col text-end">
      <c:if test="${empty flag}"><a href="boardList?pag=${pag}&pageSize=${pageSize}" class="btn btn-outline-warning">돌아가기</a></c:if>
      <c:if test="${flag == 'S'}"><a href="boardSearchList?search=${search}&searchString=${searchString}" class="btn btn-outline-warning">돌아가기</a></c:if>
    </div>
    <br/><br/>
    <hr/>
    <!-- 이전글/다음글 시작 -->
    <table class="table table-borderless">
      <tr>
        <td class="text-start">
          <c:if test="${!empty nextVO.title}">
          	👆 : <a href="boardContent?idx=${nextVO.idx}&pag=${pag}&pageSize=${pageSize}">${nextVO.title}</a><br/>
          </c:if>
          <c:if test="${!empty preVO.title}">
          	👇 : <a href="boardContent?idx=${preVO.idx}&pag=${pag}&pageSize=${pageSize}">${preVO.title}</a><br/>
          </c:if>
        </td>
      </tr>
    </table>
    <!-- 이전글/다음글 끝 -->
  </div>
</div>
  
<!-- 댓글처리(리스트/입력) 시작 -->
<div class="container">
  <!-- 댓글 리스트 보여주기 -->
  <table class="table table-bordered text-center">
    <tr class="table-secondary">
      <th>작성자[IP]</th>
      <th class="">내용</th>
      <th>작성일</th>
      <th>답글</th>
    </tr>
    <c:if test="${empty replyVos}"><td colspan="4">아직 작성된 댓글이 없습니다.</td></c:if>
    <c:forEach var="replyVo" items="${replyVos}" varStatus="st">
    	<c:if test="${replyVo.delCheck != 'OK'}">
     		<tr>
	        <td class="text-start"  style="width:30%;">
	        	<c:if test="${replyVo.re_step >= 1}">
	        		<c:forEach var="i" begin="1" end="${replyVo.re_step}">&nbsp;&nbsp;&nbsp;</c:forEach>↳
		      	</c:if>    
	          ${replyVo.nickName} [${replyVo.hostIp}]
	        	<c:if test="${sMid == replyVo.mid || sLevel == 0}">
		          (
		          <c:if test="${sMid == replyVo.mid}"><a href="javascript:replyUpdate(${replyVo.idx})" title="댓글수정">✓</a>,</c:if>
		          <a href="javascript:replyDelete(${replyVo.idx})" title="댓글삭제" class="text-danger">x</a>
		          )
	          </c:if>
	        </td>
	        <td class="text-start" style="width:50%;">${fn:replace(replyVo.content, newLine, "<br/>")}</td>
	        <td style="width:15%;">
					  <c:choose>
					    <c:when test="${replyVo.time_diff < 1}">방금 전</c:when>
					    <c:when test="${replyVo.time_diff < 60}">${replyVo.time_diff}분 전</c:when>
					    <c:when test="${replyVo.time_diff < 1440}">
					      <fmt:parseNumber value="${replyVo.time_diff / 60}" integerOnly="true" />시간 전
					    </c:when>
					    <c:otherwise>${fn:substring(replyVo.WDate, 0, 10)}</c:otherwise>
					  </c:choose>
					</td>
       		<td style="width:5%;">
	        	<a href="javascript:replyShow(${replyVo.idx})" id="replyShowBtn${replyVo.idx}" class="badge bg-dark replyShowBtn">답글</a>
	        	<a href="javascript:replyClose(${replyVo.idx})" id="replyCloseBtn${replyVo.idx}" class="badge bg-warning replyCloseBtn">닫기</a>
        	</td>
	      </tr>  
      </c:if>
      <c:if test="${replyVo.delCheck == 'OK'}">
      	<tr>	 
      		<td class="text-start text-muted" style="width:30%;">
	        	<c:if test="${replyVo.re_step >= 1}">
	        		<c:forEach var="i" begin="1" end="${replyVo.re_step}">&nbsp;&nbsp;&nbsp;</c:forEach>↳
		        </c:if>    
	          - [${replyVo.hostIp}]
        	</td>
        	<td class="text-start text-muted" style="width:50%;">삭제된 댓글입니다.</td>
        	<td class="text-muted" style="width:15%;">
					  <c:choose>
					    <c:when test="${replyVo.time_diff < 1}">방금 전</c:when>
					    <c:when test="${replyVo.time_diff < 60}">${replyVo.time_diff}분 전</c:when>
					    <c:when test="${replyVo.time_diff < 1440}">
					      <fmt:parseNumber value="${replyVo.time_diff / 60}" integerOnly="true" />시간 전
					    </c:when>
					    <c:otherwise>${fn:substring(replyVo.WDate, 0, 10)}</c:otherwise>
					  </c:choose>
					</td>
       		<td style="width:5%;">
	        	<a href="javascript:replyDisable()" class="badge bg-secondary-subtle" >답글</a>
        	</td>
        </tr>	
    	</c:if>
      <!-- 댓글수정 -->
      <c:if test="${replyVo.delCheck != 'OK'}">
	      <tr id="demo${replyVo.idx}" class="replyInnerContent">
	        <td colspan="4" class="text-center p-2">
	          <form>
	            <div class="input-group">
		            <textarea rows="5" name="replyUpdateContent" id="replyUpdateContent${replyVo.idx}" class="form-control">${replyVo.content}</textarea>
		            <input type="button" value="댓글수정" onclick="replyUpdateOk(${replyVo.idx})" class="btn btn-outline-dark btn-sm" />
		          </div>
	          </form>
	        </td>
	      </tr>
      </c:if>
      <!-- 답글 -->
      <c:if test="${replyVo.delCheck != 'OK'}">
	      <tr>
	        <td colspan="4" class="text-center p-0 m-0" >
	        	<form class="replyDemo" id="replyDemo${replyVo.idx}" style="display:none;">
	            <div class="input-group">
		            <div class="input-group-text text-bg-dark"><label for="contentRe${replyVo.idx}">답글</label></div>
		            <textarea rows="5" name="contentRe" id="contentRe${replyVo.idx}" class="form-control">@${replyVo.nickName} </textarea>
		            <input type="button" value="답글달기" onclick="replyCheckRe(${replyVo.idx}, ${replyVo.re_step}, ${replyVo.re_order})" class="btn btn-outline-dark btn-sm" />
		          </div>
	        		<div class="text-end mt-1">작성자 : ${sNickName}</div>
	          </form>
	        </td>
	      </tr>
      </c:if>
    </c:forEach>
  </table>
  <hr/>
  <!-- 댓글 입력창 -->
  <form name="replyForm">
    <table class="table table-borderless text-center">
      <tr class="text-end">
        <td>작성자 : ${sNickName}</td>
      </tr>
      <tr>
        <td class="text-start m-0 p-0">
          <div class="input-group">
            <textarea rows="4" name="content" id="content" class="form-control" placeholder="댓글을 입력하세요"></textarea>
            <input type="button" value="댓글달기" onclick="replyCheck()" class="btn btn-secondary btn-sm" />
          </div>
        </td>
      </tr>
    </table>
  </form>
</div>
<!-- 댓글처리(리스트/입력) 끝 -->
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>