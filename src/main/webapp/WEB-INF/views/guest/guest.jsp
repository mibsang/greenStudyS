<%-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<% pageContext.setAttribute("newLine", "\n"); %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>guest.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <script src="${ctp}/js/pointerSpectrum.js" ></script>
  <link rel="stylesheet" type="text/css" href="${ctp}/css/linkOrange.css" />
  <script>
  	'use strict';
  	
  	function guestDelete(idx) {
			let ans = confirm("작성한 글을 삭제하시겠습니까?") ;
			if(!ans) return false;
			let pwd = prompt("글 작성 시 입력한 비밀번호를 입력하세요.");
			if(pwd == null || pwd.trim() == "") return false;
			
			$.ajax({
				url: "guestDelete",
				type: "post",
				data: {idx:idx, pwd:pwd},
				success: (res) => {
					if(res != '0') {
						alert("삭제되었습니다.");
						location.reload();
					}
					else alert("비밀번호가 맞지 않습니다.");
				},
				error: () => alert("전송실패")
			});
		}
  	function guestUpdate(idx) {
  		if($("#demo"+idx).is(":visible")) {
				$("#demo"+idx).hide();                     
			}
			else {
				$(".guestInnerContent").hide();
				$("#demo"+idx).show(); 
			}
		}
  	
  	function guestUpdateOk(idx) {
  		let ans = confirm("수정 하시겠습니까?") ;
			if(!ans) return false;
			let pwd = prompt("글 작성 시 입력한 비밀번호를 입력하세요.");
			if(pwd == null || pwd.trim() == "") return false;
			
  		let content = $("#guestUpdateContent"+idx).val();
  		
			$.ajax ({
				url: "guestUpdateOk",
				type: "post",
				data: {idx:idx, pwd:pwd, content:content},
				success: (res) => {
					if(res != 0) {
						alert("수정 되었습니다.");
						location.reload();
					}
					else alert("수정에 실패했습니다.");
				},
				error: () => alert("전송오류")
			});
  	}
  </script>
  <style>
    .pagination-dark .page-link {
		  background-color: #000;
		  color: #fff;
		  border-color: #000;
		}
		.pagination-dark .page-link:hover {
		  background-color: #333;
		  color: #fff;
		}
		.pagination-dark .page-item.active .page-link {
		  background-color: #fff;
		  color: #000;
		  font-weight: bold;
		}
  </style>
</head>
<body class="d-flex flex-column min-vh-100">
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container flex-grow-1 py-4">
	<div class="row">
		<div class="col"><h3>방명록 작성</h3></div>
		<div class="col text-end mt-4">
			<c:if test="${pag > 1}">
			 <a href="guest?pag=1&pageSize=${pageSize}" title="첫페이지">&laquo;</a>
			 <a href="guest?pag=${pag-1}&pageSize=${pageSize}" title="이전페이지">&lsaquo;</a>
			</c:if>
			${pag} / ${totPage}
			<c:if test="${pag < totPage}">
				<a href="guest?pag=${pag+1}&pageSize=${pageSize}" title="다음페이지">&rsaquo;</a>
				<a href="guest?pag=${totPage}&pageSize=${pageSize}" title="마지막페이지">&raquo;</a>
			</c:if>
		</div>
	</div>
	<hr>
  <form method="post">
    <div class="row">
	    <div class="mb-3 col">
	      <label for="name" class="form-label">닉네임</label>
	      <input type="text" id="nickName" name="nickName" class="form-control" placeholder="닉네임을 입력하세요.(필수입력)" required>
	    </div>
	    <div class="mb-3 col">
	      <label for="pwd" class="form-label">비밀번호</label>
	      <input type="password" id="pwd" name="pwd" class="form-control" placeholder="비밀번호를 입력하세요.(필수입력)" required>
	    </div>
	    <div class="mb-3 col">
	      <label for="email" class="form-label">E-mail</label>
	      <input type="text" id="email" name="email" class="form-control" placeholder="E-mail을 입력하세요.(선택사항)">
	    </div>
    </div>
    <div class="mb-3">
      <label for="content" class="form-label">내용</label>
      <div class="input-group">
	      <textarea id="content" name="content" class="form-control" rows="4" placeholder="내용을 입력하세요.&#10;비밀번호는 내용 수정 및 삭제 시 사용됩니다." required></textarea>
		    <button type="submit" class="btn btn-outline-dark btn-sm">등록</button>
	    </div>
    </div>
  </form>
	<hr>  
	<h4>작성글 목록 : ${totRecCnt}건</h4>
  <c:if test="${empty vos}">
    <p class="text-muted">아직 등록된 글이 없습니다.</p>
  </c:if>
  <c:forEach var="vo" items="${vos}">
	  <c:set var="curScrStartNo" value="${curScrStartNo}"/>
    <div class="border-bottom py-3 d-flex justify-content-between align-items-start">
      <div>
      	<div class="text-muted small">No. ${curScrStartNo}</div>
        <div class="fw-bold">${vo.nickName} <c:if test="${!empty vo.email}"> | ${vo.email}</c:if> (${vo.hostIP})</div>
        <div>${fn:replace(vo.content, newLine, "<br/>")}</div>
        <div class="text-muted small">
        	${fn:substring(vo.WDate, 0, 16)}
        </div>
      </div>
      <div>
      	<input type="button" class="btn btn-outline-primary btn-sm" onclick="guestUpdate(${vo.idx})" value="🔧">
	      <input type="button" class="btn btn-outline-danger btn-sm" onclick="guestDelete(${vo.idx})" value="🗑">
    	</div>
    </div>
    <div id="demo${vo.idx}" class="guestInnerContent mt-2" style="display:none;">
      <div class="input-group">
        <textarea rows="3" id="guestUpdateContent${vo.idx}" class="form-control">${vo.content}</textarea>
        <input type="button" value="수정" onclick="guestUpdateOk(${vo.idx})" class="btn btn-outline-dark btn-sm">
        <hr>
      </div>
    </div>
     <c:set var="curScrStartNo" value="${curScrStartNo - 1}"/>
  </c:forEach>
	<c:if test="${totPage >= 1}">
		<ul class="pagination pagination-sm justify-content-center mt-3 pagination-dark">
		  <c:if test="${pag > 1}"><li class="page-item"><a class="page-link" href="guest?pag=1">&laquo;</a></li></c:if>
		  <c:if test="${pag > 1}"><li class="page-item"><a class="page-link" href="guest?pag=${pag - 1}">&lsaquo;</a></li></c:if>
		  <c:forEach var="i" begin="${(curBlock * blockSize) + 1}" end="${(curBlock * blockSize) + blockSize}" varStatus="st">
		  	<c:if test="${i <= totPage}"><li class="page-item ${pag == i ? 'active' : ''}"><a class="page-link" href="guest?pag=${i}">${i}</a></li></c:if>
	  	</c:forEach>
	  	<c:forEach var="i" begin="${startPage}" end="${endPage}">
				<li class="page-item ${pag == i ? 'active' : ''}"><a class="page-link" href="guest?pag=${i}">${i}</a></li>
			</c:forEach>
	  	<c:if test="${pag < totPage}"><li class="page-item"><a class="page-link" href="guest?pag=${pag + 1}">&rsaquo;</a></li></c:if>
		  <c:if test="${pag < totPage}"><li class="page-item"><a class="page-link" href="guest?pag=${totPage}">&raquo;</a></li></c:if>
		</ul>
	</c:if>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html> --%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<% pageContext.setAttribute("newLine", "\n"); %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>guest.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs5.jsp" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <script src="${ctp}/js/pointerSpectrum.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.10.5/dist/sweetalert2.all.min.js"></script>
  <style>
    .gb-wrap { 
      max-width: 860px; 
    }
    .gb-card { 
	    border: 1px solid #e9ecef; 
	    border-radius: 14px; 
    }
    .gb-card .form-control:focus { 
      box-shadow: 0 0 0 .2rem rgba(13,110,253,.12); 
    }
    .gb-label { 
	    font-size: .85rem; 
	    color: #6c757d;
	    margin-bottom: .3rem; 
    }
    .gb-label .req { 
      color: #dc3545; 
    }
    .gb-item { 
	    padding: 1rem 0; 
	    border-bottom: 1px solid #f1f3f5; 
    }
    .gb-avatar { 
	    width: 42px; 
	    height: 42px; 
	    border-radius: 50%; 
	    flex-shrink: 0;
	    display: flex; 
	    align-items: center; 
	    justify-content: center; 
	    font-weight: 600; 
    }
    .gb-av0 { 
	    background:#e7f1ff; 
	    color:#0b5ed7; 
    }
    .gb-av1 { 
	    background:#e6f6ee; 
	    color:#198754; 
    }
    .gb-av2 { 
	    background:#fff3e0; 
	    color:#c76a00; 
    }
    .gb-av3 { 
	    background:#f3e8ff; 
	    color:#7e3bd6; 
    }
    .gb-av4 { 
	    background:#ffe9ec; 
	    color:#c2185b; 
    }
    .gb-meta { 
	    font-size: .82rem; 
	    color: #adb5bd; 
    }
    .gb-bubble { 
	    background: #f8f9fa; 
	    border-radius: 10px; 
	    padding: .7rem .9rem; 
	    margin-top: .4rem; 
	    line-height: 1.6; 
	    word-break: break-all; 
    }
    .gb-icon-btn { 
	    padding: .15rem .45rem; 
	    font-size: .85rem; 
    }
    .gb-no { 
	    font-size: .75rem; 
	    color: #ced4da; 
	    font-weight: 600; 
    }

    /* 페이지네이션 */
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
  <script>
  	'use strict';

  	function guestDelete(idx) {
  		Swal.fire({
  			title: "글을 삭제할까요?",
  			text: "삭제한 글은 되돌릴 수 없습니다.",
  			icon: "warning",
  			input: "password",
  			inputPlaceholder: "글 작성 시 입력한 비밀번호",
  			showCancelButton: true,
  			confirmButtonText: "삭제",
  			cancelButtonText: "취소",
  			confirmButtonColor: "#dc3545",
  			inputValidator: (value) => {
  				if(!value || value.trim() == "") return "비밀번호를 입력하세요.";
  			}
  		}).then((result) => {
  			if(!result.isConfirmed) return;

  			$.ajax({
  				url: "guestDelete",
  				type: "post",
  				data: {idx: idx, pwd: result.value},
  				success: (res) => {
  					if(res != '0') {
  						Swal.fire({ title: "삭제되었습니다.", icon: "success" })
  							.then(() => location.reload());
  					}
  					else Swal.fire({ title: "비밀번호가 맞지 않습니다.", icon: "error" });
  				},
  				error: () => Swal.fire({ title: "전송실패", icon: "error" })
  			});
  		});
  	}

  	function guestUpdate(idx) {
  		if($("#demo"+idx).is(":visible")) {
				$("#demo"+idx).hide();
			}
			else {
				$(".guestInnerContent").hide();
				$("#demo"+idx).show();
			}
		}

  	function guestUpdateOk(idx) {
  		let content = $("#guestUpdateContent"+idx).val();
  		if(content.trim() == "") {
  			Swal.fire({ title: "내용을 입력하세요.", icon: "warning" });
  			return;
  		}

  		Swal.fire({
  			title: "글을 수정할까요?",
  			icon: "question",
  			input: "password",
  			inputPlaceholder: "글 작성 시 입력한 비밀번호",
  			showCancelButton: true,
  			confirmButtonText: "수정",
  			cancelButtonText: "취소",
  			confirmButtonColor: "#212529",
  			inputValidator: (value) => {
  				if(!value || value.trim() == "") return "비밀번호를 입력하세요.";
  			}
  		}).then((result) => {
  			if(!result.isConfirmed) return;

  			$.ajax({
  				url: "guestUpdateOk",
  				type: "post",
  				data: {idx: idx, pwd: result.value, content: content},
  				success: (res) => {
  					if(res != 0) {
  						Swal.fire({ title: "수정되었습니다.", icon: "success" })
  							.then(() => location.reload());
  					}
  					else Swal.fire({ title: "비밀번호가 맞지 않습니다.", icon: "error" });
  				},
  				error: () => Swal.fire({ title: "전송오류", icon: "error" })
  			});
  		});
  	}

  	// 글자 수 카운터
  	$(function() {
  		$("#content").on("input", function() {
  			$("#contentCount").text($(this).val().length);
  		});
  	});
  	
  	function emailCheck() {
  		let email1 = $("#email1").val().trim();
  		let email2 = $("#email2").val();

  		if(email1 == "") $("#email").val("");               
  		else $("#email").val(email1 + "@" + email2);
  		return true;                                           
  	}
  </script>
</head>
<body class="d-flex flex-column min-vh-100">
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<div class="container gb-wrap flex-grow-1 py-5">

  <!-- 제목 -->
  <div class="d-flex align-items-center gap-2 mb-1">
    <i class="bi bi-journal-text fs-3 text-primary"></i>
    <h3 class="m-0 fw-semibold">방명록</h3>
  </div>
  <p class="text-secondary small mb-4">누구나 자유롭게 남길 수 있어요. 비밀번호는 수정·삭제할 때 사용됩니다.</p>

  <!-- 입력 폼 -->
  <div class="card gb-card shadow-sm mb-5">
    <div class="card-body p-4">
      <form method="post" onsubmit="emailCheck()">
        <div class="row g-3 mb-3">
          <div class="col">
            <label for="nickName" class="gb-label"><i class="bi bi-person"></i> 닉네임 <span class="req">*</span></label>
            <input type="text" id="nickName" name="nickName" class="form-control" placeholder="닉네임을 입력해주세요." maxlength="20" required>
          </div>
          <div class="col">
            <label for="pwd" class="gb-label"><i class="bi bi-lock"></i> 비밀번호 <span class="req">*</span></label>
            <input type="password" id="pwd" name="pwd" class="form-control" placeholder="수정·삭제용" required>
          </div>
          <div>
					  <label for="email1" class="gb-label"><i class="bi bi-envelope"></i> E-mail</label>
					  <div class="input-group">
					    <input type="text" id="email1" class="form-control" placeholder="(선택사항)">
					    <span class="input-group-text">@</span>
					    <select id="email2" class="form-select">
					      <option>naver.com</option>
					      <option>nate.com</option>
					      <option>daum.net</option>
					      <option>gmail.com</option>
					      <option>kakao.com</option>
					    </select>
					  </div>
					  <input type="hidden" id="email" name="email">
					</div>
        </div>
        <label for="content" class="gb-label"><i class="bi bi-chat-left-text"></i> 내용 <span class="req">*</span></label>
        <textarea id="content" name="content" class="form-control" rows="4" maxlength="500"
          placeholder="따뜻한 한마디를 남겨 주세요." required></textarea>
        <div class="d-flex justify-content-between align-items-center mt-2">
          <span class="small text-muted"><span id="contentCount">0</span> / 500</span>
          <button type="submit" class="btn btn-dark px-4"><i class="bi bi-send"></i> 등록</button>
        </div>
      </form>
    </div>
  </div>
  <!-- 목록 -->
  <div class="d-flex align-items-center gap-2 mb-2">
    <h5 class="m-0 fw-semibold">작성글</h5>
    <span class="badge rounded-pill text-bg-primary bg-opacity-75">${vo.totRecCnt}건</span>
    <span class="gb-meta ms-auto">${vo.pag} / ${vo.totPage} 페이지</span>
  </div>
  <div class="border-top">
    <c:if test="${empty vos}">
      <div class="text-center text-muted py-5">
        <i class="bi bi-chat-square-dots fs-1 d-block mb-2"></i>
        첫 번째 방명록을 남겨 보세요.
      </div>
    </c:if>
    <c:set var="no" value="${vo.curScrStartNo}"/>
    <c:forEach var="vo" items="${vos}">
      <div class="gb-item d-flex gap-3">
        <div class="gb-avatar gb-av${vo.idx % 5}">${fn:substring(vo.nickName, 0, 1)}</div>
        <div class="flex-grow-1" style="min-width:0;">
          <div class="d-flex justify-content-between align-items-start">
            <div>
              <div class="gb-no">No. ${no}</div>
              <span class="fw-semibold">${vo.nickName}</span>
              <span class="gb-meta"><c:if test="${!empty vo.email}"> · ${vo.email}</c:if> · ${vo.hostIP}</span>
            </div>
            <div class="d-flex gap-1">
              <button type="button" class="btn btn-outline-secondary gb-icon-btn" onclick="guestUpdate(${vo.idx})" title="수정"><i class="bi bi-pencil"></i></button>
              <button type="button" class="btn btn-outline-danger gb-icon-btn" onclick="guestDelete(${vo.idx})" title="삭제">
                <i class="bi bi-trash3"></i>
              </button>
            </div>
          </div>

          <div class="gb-bubble">${fn:replace(vo.content, newLine, "<br/>")}</div>
          <!-- 수정 입력창 (처음엔 숨김) -->
          <div id="demo${vo.idx}" class="guestInnerContent mt-2" style="display:none;">
            <div class="input-group">
              <textarea rows="3" id="guestUpdateContent${vo.idx}" class="form-control">${vo.content}</textarea>
              <button type="button" class="btn btn-outline-dark btn-sm" onclick="guestUpdateOk(${vo.idx})">수정</button>
            </div>
          </div>
          <div class="gb-meta mt-2"><i class="bi bi-clock"></i> ${fn:substring(vo.WDate, 0, 16)}</div>
        </div>
      </div>
      <c:set var="no" value="${no - 1}"/>
    </c:forEach>
  </div>

  <!-- 페이지네이션 -->
  <c:if test="${vo.totPage >= 1}">
    <nav class="mt-4">
      <ul class="pagination gb-pager justify-content-center">
        <!-- 이전 -->
        <li class="page-item ${vo.pag == 1 ? 'disabled' : ''}">
          <a class="page-link" href="guest?pag=${vo.pag - 1}&pageSize=${vo.pageSize}" title="이전"><i class="bi bi-chevron-left"></i></a>
        </li>
        <!-- 맨 앞 1 … -->
        <c:if test="${vo.startPage > 1}">
          <li class="page-item"><a class="page-link" href="guest?pag=1&pageSize=${vo.pageSize}">1</a></li>
          <c:if test="${vo.startPage > 2}"><li class="page-item gb-dots"><span class="page-link">…</span></li></c:if>
        </c:if>
        <!-- 현재 페이지 중심 번호 -->
        <c:forEach var="i" begin="${vo.startPage}" end="${vo.endPage}">
          <li class="page-item ${vo.pag == i ? 'active' : ''}">
            <a class="page-link" href="guest?pag=${i}&pageSize=${vo.pageSize}">${i}</a>
          </li>
        </c:forEach>
        <!-- … 마지막 -->
        <c:if test="${vo.endPage < vo.totPage}">
          <c:if test="${vo.endPage < vo.totPage - 1}"><li class="page-item gb-dots"><span class="page-link">…</span></li></c:if>
          <li class="page-item"><a class="page-link" href="guest?pag=${vo.totPage}&pageSize=${vo.pageSize}">${vo.totPage}</a></li>
        </c:if>
        <!-- 다음 -->
        <li class="page-item ${vo.pag == vo.totPage ? 'disabled' : ''}">
          <a class="page-link" href="guest?pag=${vo.pag + 1}&pageSize=${vo.pageSize}" title="다음"><i class="bi bi-chevron-right"></i></a>
        </li>
      </ul>
    </nav>
  </c:if>
</div>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>