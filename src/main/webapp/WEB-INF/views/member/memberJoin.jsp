<%@page import="java.time.LocalDate"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<jsp:include page="/WEB-INF/views/include/bs5.jsp" />
	<script src="//t1.kakaocdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script src="${ctp}/js/zip.js"></script>
	<title>memberJoin.jsp</title>
	<script>
		'use strict';

		let checkedMid = "";
		let checkedNickName = "";
		
		// 정규식
		let regEmail = /^[a-zA-Z0-9._-]{4,20}$/;
		let regName = /^[가-힣]{2,12}$/;
		let regMid = /^[a-zA-Z0-9_]{4,20}$/;
		let regNickName = /^[a-zA-Z가-힣0-9]{2,12}$/;
		let regTel2 = /^[0-9]{3,4}$/;
		let regTel3 = /^[0-9]{4}$/;


		// 회원가입 처리
		function fCheck() {
			
			// 입력값
			let mid = document.myform.mid.value.trim();
			let nickName = document.myform.nickName.value.trim();
			let name = document.myform.name.value.trim();

			let email1 = document.myform.email1.value.trim();
			let email2 = document.myform.email2.value.trim();

			let tel1 = document.myform.tel1.value;
			let tel2 = document.myform.tel2.value.trim();
			let tel3 = document.myform.tel3.value.trim();

			let postcode = document.getElementById("sample6_postcode").value.trim();
			let mainAddress = document.getElementById("sample6_address").value.trim();
			let detailAddress = document.getElementById("sample6_detailAddress").value.trim();
			let extraAddress = document.getElementById("sample6_extraAddress").value.trim();

			let fName = document.getElementById("fName").value;
			let ext = fName.substring(fName.lastIndexOf(".") + 1).toLowerCase();
			let maxSize = 1024 * 1024 * 30;

			// 정규식 검사
			if(!regMid.test(mid)) {
				alert("아이디는  영문자(대,소문자)와 숫자, _로 구성된 4~20자 내외만 가능합니다.");
				document.myform.mid.focus();
				return false;
			}
			else if(!regEmail.test(email1)) {
				alert("이메일은  영문자(대,소문자)와 숫자, _로 구성된 4~20자 내외만 가능합니다.");
				document.myform.email1.focus();
				return false;
			}
			else if(!regNickName.test(nickName)) {
				alert("닉네임에 사용할 수 없는 문자가 포함 되어있습니다.");
				document.myform.nickName.focus();
				return false;
			}
			else if(!regName.test(name)) {
				alert("성명은 한글로 2글자 이상 입력해주세요.");
				document.myform.name.focus();
				return false;
			}
			else if (!regTel2.test(tel2)) {
				alert("전화번호를 정확히 입력해주세요.");
				document.myform.tel2.focus();
				return false;
			}
			else if (!regTel3.test(tel3)) {
				alert("전화번호를 정확히 입력해주세요.");
				document.myform.tel3.focus();
				return false;
			}
			else {
				// 중복확인 검사
				if(mid !== checkedMid) {
					alert("아이디 중복확인을 해주세요.");
					myform.mid.focus();
					return false;
				}
				if(nickName !== checkedNickName) {
					alert("닉네임 중복확인을 해주세요.");
					myform.nickName.focus();
					return false;
				}

				// 파일 검사
				if(fName.trim() != "") {
					let fileSize = document.getElementById("fName").files[0].size;
					if(fileSize > maxSize) {
						alert("업로드할 파일의 최대용량은 30MByte입니다.");
						return false;
					}
					if(ext != "jpg" && ext != "jpeg" && ext != "png" && ext != "tiff" && ext != "raw" && ext != "psd" && ext != "pdf" && ext != "eps" && ext != "ai") {
						alert("업로드 가능한 파일은 '.jpg/.jpeg/.png/.tiff/.raw/.psd/.pdf/.eps/.ai'파일 입니다.");
						return false;
					}
				}

				// 이메일, 전화번호, 주소 묶기
				let email = email1 + "@" + email2;
				myform.email.value = email;

				if(tel2 == "") tel2 = " ";
				if(tel3 == "") tel3 = " ";
				let tel = tel1 + "-" + tel2 + "-" + tel3;
				myform.tel.value = tel;

				if(postcode == "") postcode = "None";
				else if(mainAddress == "") mainAddress = " ";
				else if(detailAddress == "") detailAddress = " ";
				else if(extraAddress == "") extraAddress = " ";
				
				let address = "(" + postcode + ")" + "/" + mainAddress + "/" + detailAddress + "/" + extraAddress;
				myform.address.value = address;
			}
			myform.submit();
		}

		// 아이디 중복체크
		function idCheck() {
			let mid = myform.mid.value;

			if(mid.trim() == "") {
				alert("아이디를 입력하세요.");
				myform.mid.focus();
				return false;
			}
			if(!regMid.test(mid)) {
				alert("아이디는  영문자(대,소문자)와 숫자, _로 구성된 4~20자 내외만 가능합니다.");
				document.myform.mid.focus();
				return false;
			}

			$.ajax({
				url : "memberIdCheck",
				type : "post",
				data : {"mid" : mid},
				success : (res) => {
					if(res == "0") {
						alert("사용가능한 아이디 입니다.");
						checkedMid = mid;
						myform.pwd.focus();
					}
					else {
						alert("이미 사용중인 아이디입니다.");
						checkedMid = "";
						myform.mid.focus();
					}
				},
				error : () => alert("전송오류")
			});
		}

		// 닉네임 중복체크
		function nickCheck() {
			let nickName = myform.nickName.value;

			if(nickName.trim() == "") {
				alert("닉네임을 입력하세요.");
				myform.nickName.focus();
				return false;
			}
			if(!regNickName.test(nickName)) {
				alert("닉네임에 사용할 수 없는 문자가 포함 되어있습니다.");
				document.myform.nickName.focus();
				return false;
			}

			$.ajax({
				url : "memberNickNameCheck",
				type : "post",
				data : {"nickName" : nickName},
				success : (res) => {
					if(res == "0") {
						alert("사용가능한 닉네임 입니다.");
						checkedNickName = nickName;
						myform.name.focus();
					}
					else {
						alert("이미 사용중인 닉네임입니다.");
						checkedNickName = "";
						myform.nickName.focus();
					}
				},
				error : () => alert("전송오류")
			});
		}

		// 이메일 인증번호 발송
		function emailCheck() {
			let pwd = $("#pwd").val();
			let name = $("#name").val();
			let mid = $("#mid").val();
			let nickName = $("#nickName").val();
			let email1 = $("#email1").val();

			if(mid === "") {
				alert("아이디를 입력해주세요.");
				myform.mid.focus();
				return false;
			}
			else if(mid !== checkedMid) {
				alert("아이디 중복확인을 해주세요.");
				myform.mid.focus();
				return false;
			}
			else if(pwd === "") {
				alert("비밀번호를 입력해 해주세요.");
				myform.pwd.focus();
				return false;
			}
			else if(nickName === "") {
				alert("닉네임을 입력해주세요.");
				myform.nickName.focus();
				return false;
			}
			else if(nickName !== checkedNickName) {
				alert("닉네임 중복확인을 해주세요.");
				myform.nickName.focus();
				return false;
			}
			else if(name === "") {
				alert("성명을 입력해주세요.");
				myform.name.focus();
				return false;
			}
			else if(!regName.test(name)) {
				alert("성명은 한글로 2글자 이상 입력해주세요.");
				document.myform.name.focus();
				return false;
			}
			else if(email1 === "") {
				alert("이메일을 입력해주세요.");
				document.myform.email1.focus();
				return false;
			}
			else if(!regEmail.test(email1)) {
				alert("이메일은  영문자(대,소문자)와 숫자, _로 구성된 4~20자 내외만 가능합니다.");
				document.myform.email1.focus();
				return false;
			}

			let email = email1 + "@" + $("#email2").val();
			$("#spinner").css("display", "flex");

			$.ajax({
				url : "emailCheck",
				type : "post",
				data : {email : email},
				success : (res) => {
					if(res != '0') {
						alert("인증번호를 이메일로 보냈습니다.");
						$("#emailId").hide();
						$("#emailId2").show();
						$("#auth").show();
						myform.authId.focus();
					}
				},
				error : () => {
					$("#spinner").hide();
					alert("전송오류");
				},
				complete : () => $("#spinner").hide()
			});
		}

		// 인증번호 확인
		function authCheck() {
			let authId = $("#authId").val();

			if(authId === "") {
				alert("인증번호를 입력해주세요.");
				return false;
			}

			$.ajax({
				url : "authCheck",
				type : "post",
				data : {authId : authId},
				success : (res) => {
					if(res != 0) {
						alert("인증이 완료되었습니다.");
						$("#addContent").show();
					}
					else alert("인증에 실패했습니다.\n인증번호 확인 후 다시 입력해주세요.");
				},
				error : () => alert("전송오류")
			});
		}
		
		function resetCheck() {
			let ans = confirm("처음부터 다시 작성하시겠습니까?");
			
			if(!ans) return false;
			
			location.reload();
		}
	</script>
	<style>
		/* 메일 전송 스피너 */
		.spinner-overlay {
			display: none;
			position: fixed;
			inset: 0;
			background: rgba(0, 0, 0, 0.5);
			z-index: 9999;
			flex-direction: column;
			justify-content: center;
			align-items: center;
		}

		/* 왼쪽 라벨 칸 너비 통일 */
		.join-form .input-group > .input-group-text:first-child {
			width: 120px;
			justify-content: center;
		}
		/* 오른쪽 버튼 너비 통일 */
		.join-form .input-group > .btn {
			width: 130px;
		}
		/* 이메일 도메인 / 전화번호 앞자리 select 고정 */
		.join-form #email2 { flex: 0 0 160px; }
		.join-form .tel-select { flex: 0 0 110px; }
		/* 주소 2,3번째 줄 들여쓰기 (라벨 칸 너비와 동일) */
		.join-form .addr-indent { padding-left: 120px; }
	</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<jsp:include page="/WEB-INF/views/include/slide2.jsp" />
<p><br/></p>
<div class="container">
	<form name="myform" method="post" action="memberJoinOk" class="was-validated join-form" enctype="multipart/form-data">
		<h2>회 원 가 입</h2>
		<br/>
		<!-- 아이디 -->
		<div class="input-group mb-3">
			<div class="input-group-text"><label for="mid">아이디</label></div>
			<input type="text" class="form-control" name="mid" id="mid" placeholder="아이디를 입력하세요." required autofocus/>
			<input type="button" value="아이디 중복체크" id="midBtn" class="btn btn-secondary btn" onclick="idCheck()"/>
		</div>
		<!-- 비밀번호 -->
		<div class="input-group mb-3">
			<div class="input-group-text"><label for="pwd">비밀번호</label></div>
			<input type="password" class="form-control" name="pwd" id="pwd" placeholder="비밀번호를 입력하세요." required />
		</div>
		<!-- 닉네임 -->
		<div class="input-group mb-3">
			<div class="input-group-text"><label for="nickName">닉네임</label></div>
			<input type="text" class="form-control" name="nickName" id="nickName" placeholder="별명을 입력하세요." required />
			<input type="button" value="닉네임 중복체크" id="nickNameBtn" class="btn btn-secondary" onclick="nickCheck()"/>
		</div>
		<!-- 성명 -->
		<div class="input-group mb-3">
			<div class="input-group-text"><label for="name">성명</label></div>
			<input type="text" class="form-control" name="name" id="name" placeholder="성명을 입력하세요." required />
		</div>
		<!-- 이메일 -->
		<div class="input-group mb-3">
			<div class="input-group-text"><label for="email1">이메일</label></div>
			<input type="text" class="form-control" name="email1" id="email1" placeholder="Email을 입력하세요." required />
			<div class="input-group-text">@</div>
			<select name="email2" id="email2" class="form-select">
				<option value="naver.com" selected>naver.com</option>
				<option value="hanmail.net">hanmail.net</option>
				<option value="hotmail.com">hotmail.com</option>
				<option value="gmail.com">gmail.com</option>
				<option value="nate.com">nate.com</option>
				<option value="yahoo.com">yahoo.com</option>
			</select>
			<input type="button" value="인증코드받기" onclick="emailCheck()" id="emailId" class="btn btn-dark">
			<input type="button" value="코드다시받기" onclick="emailCheck()" id="emailId2" class="btn btn-dark" style="display:none;">
		</div>
		<!-- 인증번호 -->
		<div id="auth" class="input-group mb-3" style="display:none;">
			<div class="input-group-text"><label for="authId">인증번호</label></div>
			<input type="text" class="form-control" name="authId" id="authId" placeholder="인증번호를 입력하세요." oninput="this.value = this.value.toUpperCase()">
			<input type="button" value="인증코드확인" onclick="authCheck()" class="btn btn-outline-dark">
		</div>

		<!-- 인증 후 표시되는 추가 입력 영역 -->
		<div id="addContent" style="display:none;">
			<!-- 성별 -->
			<div class="input-group mb-3">
				<span class="input-group-text">성별</span>
				<div class="form-control d-flex align-items-center gap-4">
					<div class="form-check mb-0">
						<input type="radio" name="gender" value="남자" id="male" class="form-check-input" checked />
						<label for="male" class="form-check-label">남자</label>
					</div>
					<div class="form-check mb-0">
						<input type="radio" name="gender" value="여자" id="female" class="form-check-input" />
						<label for="female" class="form-check-label">여자</label>
					</div>
				</div>
			</div>
			<!-- 생일 -->
			<div class="input-group mb-3">
				<div class="input-group-text"><label for="birthday">생일</label></div>
				<input type="date" name="birthday" id="birthday" value="<%= LocalDate.now() %>" class="form-control"/>
			</div>
			<!-- 전화번호 -->
			<div class="input-group mb-3">
				<span class="input-group-text">전화번호</span>
				<select name="tel1" class="form-select tel-select">
					<option value="010" selected>010</option>
					<option value="02">서울</option>
					<option value="031">경기</option>
					<option value="032">인천</option>
					<option value="041">충남</option>
					<option value="042">대전</option>
					<option value="043">충북</option>
					<option value="051">부산</option>
					<option value="052">울산</option>
					<option value="061">전북</option>
					<option value="062">광주</option>
				</select>
				<span class="input-group-text">-</span>
				<input type="number" name="tel2" class="form-control"/>
				<span class="input-group-text">-</span>
				<input type="number" name="tel3" class="form-control"/>
			</div>
			<!-- 주소 -->
			<div class="input-group mb-1">
				<span class="input-group-text">주소</span>
				<input type="text" id="sample6_postcode" placeholder="우편번호" class="form-control" readonly>
				<input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기" class="btn btn-outline-dark">
			</div>
			<div class="input-group mb-1 addr-indent">
				<input type="text" id="sample6_address" placeholder="주소" class="form-control" readonly>
			</div>
			<div class="input-group mb-3 addr-indent">
				<input type="text" id="sample6_detailAddress" placeholder="상세주소" class="form-control">
				<input type="text" id="sample6_extraAddress" placeholder="참고항목" class="form-control" readonly>
			</div>
			<!-- 홈페이지 -->
			<div class="input-group mb-3">
				<div class="input-group-text"><label for="homePage">홈페이지</label></div>
				<input type="text" class="form-control" name="homePage" id="homePage" value="http://" placeholder="홈페이지를 입력하세요." />
			</div>
			<!-- 직업 -->
			<div class="input-group mb-3">
				<div class="input-group-text"><label for="job">직업</label></div>
				<select class="form-select" id="job" name="job">
					<option>학생</option>
					<option>회사원</option>
					<option>공무원</option>
					<option>군인</option>
					<option>의사</option>
					<option>법조인</option>
					<option>세무인</option>
					<option>자영업</option>
					<option selected>기타</option>
				</select>
			</div>
			<!-- 취미 -->
			<div class="input-group mb-3">
				<span class="input-group-text">취미</span>
				<div class="form-control d-flex flex-wrap align-items-center gap-3">
					<div class="form-check mb-0"><input type="checkbox" name="hobby" value="등산" id="h1" class="form-check-input"/><label for="h1" class="form-check-label">등산</label></div>
					<div class="form-check mb-0"><input type="checkbox" name="hobby" value="낚시" id="h2" class="form-check-input"/><label for="h2" class="form-check-label">낚시</label></div>
					<div class="form-check mb-0"><input type="checkbox" name="hobby" value="수영" id="h3" class="form-check-input"/><label for="h3" class="form-check-label">수영</label></div>
					<div class="form-check mb-0"><input type="checkbox" name="hobby" value="독서" id="h4" class="form-check-input"/><label for="h4" class="form-check-label">독서</label></div>
					<div class="form-check mb-0"><input type="checkbox" name="hobby" value="영화감상" id="h5" class="form-check-input"/><label for="h5" class="form-check-label">영화감상</label></div>
					<div class="form-check mb-0"><input type="checkbox" name="hobby" value="바둑" id="h6" class="form-check-input"/><label for="h6" class="form-check-label">바둑</label></div>
					<div class="form-check mb-0"><input type="checkbox" name="hobby" value="축구" id="h7" class="form-check-input"/><label for="h7" class="form-check-label">축구</label></div>
					<div class="form-check mb-0"><input type="checkbox" name="hobby" value="기타" id="h8" class="form-check-input" checked/><label for="h8" class="form-check-label">기타</label></div>
				</div>
			</div>
			<!-- 자기소개 -->
			<div class="input-group mb-3">
				<div class="input-group-text"><label for="content">자기소개</label></div>
				<textarea rows="5" class="form-control" id="content" name="content" placeholder="자기소개를 입력하세요."></textarea>
			</div>
			<!-- 정보공개 -->
			<div class="input-group mb-3">
				<span class="input-group-text">정보공개</span>
				<div class="form-control d-flex align-items-center gap-4">
					<div class="form-check mb-0">
						<input type="radio" name="userInfor" value="공개" id="infoY" class="form-check-input" checked />
						<label for="infoY" class="form-check-label">공개</label>
					</div>
					<div class="form-check mb-0">
						<input type="radio" name="userInfor" value="비공개" id="infoN" class="form-check-input" />
						<label for="infoN" class="form-check-label">비공개</label>
					</div>
				</div>
			</div>
			<!-- 회원 사진 -->
			<div class="input-group">
				<div class="input-group-text">회원사진</div>
				<input type="file" name="fName" id="fName" class="form-control" accept=".jpg, .jpeg, .png, .tiff, .raw, .psd, .pdf, .eps, .ai"/>
			</div>
			<div class="form-text mb-3">파일용량 30MByte 이내</div>
			<!-- 버튼 -->
			<button type="button" class="btn btn-outline-success" onclick="fCheck()">회원가입</button> &nbsp;
			<button type="button" class="btn btn-outline-danger" onclick="resetCheck()">다시작성</button> &nbsp;
			<button type="button" class="btn btn-outline-secondary" onclick="location.href='memberLogin';">돌아가기</button>
		</div>
		<input type="hidden" name="tel">
		<input type="hidden" name="email">
		<input type="hidden" name="address">
	</form>

	<!-- 메일 전송 스피너 -->
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