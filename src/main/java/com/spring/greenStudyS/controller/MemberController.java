package com.spring.greenStudyS.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

import com.spring.greenStudyS.common.PageVO;
import com.spring.greenStudyS.common.PagiNation;
import com.spring.greenStudyS.common.ProjectProvide;
import com.spring.greenStudyS.service.MemberService;
import com.spring.greenStudyS.vo.MemberVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/member")
public class MemberController {

	@Autowired
	BCryptPasswordEncoder passwordEncoder;
	
	@Autowired
	ProjectProvide projectProvide;
	
	@Autowired
	MemberService memberService;
	
	@GetMapping("/memberLogin")
	public String memberLoginGet() {
		return "member/memberLogin";
	}

	@Autowired
	PagiNation pagiNation;
	
	
	@GetMapping("/memberLogout")
	public String memberLogoutGet(HttpSession session) {
		String mid = (String) session.getAttribute("sMid");
		session.invalidate();
		return "redirect:/message/memberLogout?mid=" + mid;
	}
	
	@GetMapping("/memberJoin")
	public String memberJoinGet() {
		return "member/memberJoin";
	}
	
	@ResponseBody
	@PostMapping("/memberIdCheck")
	public String memberIdCheckPost(String mid) {
		return memberService.getMemberIdCheck(mid)+"";
	}
	
	@ResponseBody
	@PostMapping("/memberNickNameCheck")
	public String memberNickNameCheckPost(String nickName) {
		return memberService.getMemberNickNameCheck(nickName)+"";
	}
	
	@PostMapping("/memberJoinOk")
	public String memberJoinOkPost(MemberVO vo, MultipartFile fName, HttpServletRequest request) throws IOException {
		
		
		if(vo.getPwd() != null) {
			vo.setPwd(passwordEncoder.encode(vo.getPwd()));
		}
		
		if(vo.getHobby() != null) {
			vo.setHobby(vo.getHobby().replace(",", "/"));
		}
		
		if(fName != null && !fName.isEmpty()) {
			vo.setPhoto(projectProvide.uploadFile(fName, "member", ""));
		}
		else vo.setPhoto("noimage.png");
		
		int res = memberService.setMemberJoin(vo);
		
		if(res != 0) return "redirect:/message/memberJoinOk";
		else return "redirect:/message/memberJoinNo";
		
	}
	
	@PostMapping("/memberLogin")
	public String memberLoginPost(HttpSession session,
			HttpServletRequest request, HttpServletResponse response,
			@RequestParam(name="mid", required = false) String mid,
			@RequestParam(name="pwd", required = false) String pwd,
			@RequestParam(name="idSave", required = false) String idSave
		) {
		MemberVO vo = memberService.getMemberCheckId(mid);
		
		if(vo != null && vo.getUserDel().equals("NO") && passwordEncoder.matches(pwd, vo.getPwd())) {
			
			
			// 5회 이상 방문
//			if(vo.getLevel() == 3) {
//				if(vo.getVisitCnt() + 1 >= 5) {
//					memberService.setMemberLevelUpdate(mid);
//					vo.setLevel(2);
//				}
//			}
			// 가입일 보다 하루 이 후 방문
			Boolean levelUp = false;
			LocalDate startDay = LocalDate.parse(vo.getStartDate().substring(0, 10));
			if(vo.getLevel() == 3) {
				if(LocalDate.now().isAfter(startDay)) {
					memberService.setMemberLevelUpdate(mid);
					vo.setLevel(2);
					levelUp = true;
				}
			}
			
			// 세션처리
			String strLv = "";
			if(vo.getLevel() == 0) strLv = "관리자";
			else if(vo.getLevel() == 1) strLv = "우수회원";
			else if(vo.getLevel() == 2) strLv = "정회원";
			else if(vo.getLevel() == 3) strLv = "준회원";
			
			session.setAttribute("sMid", mid);
			session.setAttribute("sNickName", vo.getNickName());
			session.setAttribute("sLevel", vo.getLevel());
			session.setAttribute("strLv", strLv);
			session.setAttribute("sLastDate", vo.getLastDate());
			session.setAttribute("sPhoto", vo.getPhoto());

			// 쿠키 저장/삭제
			if(idSave.equals("on")) {
				Cookie cookieMid = new Cookie("cMid", mid);
				cookieMid.setPath("/");
				cookieMid.setMaxAge(60*60*24*7);		// 쿠키의 만료시간을 7일로 지정
				response.addCookie(cookieMid);
			}
			else {
				Cookie[] cookies = request.getCookies();
				if(cookies != null) {
					for(int i=0; i<cookies.length; i++) {
						if(cookies[i].getName().equals("cMid")) {
							cookies[i].setPath("/");
							cookies[i].setMaxAge(0);
							response.addCookie(cookies[i]);
							break;
						}
					}
				}
			}
			
			// 기타처리(방문카운트 증가, 포인트, 하루동안 5회까지 방문시 각 방문마다 10point씩 지급한다.
			if(!LocalDateTime.now().toString().substring(0,10).equals(vo.getLastDate().substring(0,10))) {
				vo.setTodayCnt(0);
			}
			vo.setTodayCnt(vo.getTodayCnt()+1);
		
			// 방문포인트는 1일 5회까지 가능(1회방문시 10point씩 부여한다.)
			vo.setPoint(vo.getPoint() + (vo.getTodayCnt() <= 5 ? 10 : 0));
			
			// 조건에 대한 처리가 완료되면 변경된 모든 내용들을 업데이트 처리한다.
			memberService.setMemberInfoUpdate(vo);
			
			if(levelUp) return "redirect:/message/memberLevelUpOk?mid=" + mid;
			return "redirect:/message/memberLoginOk?mid=" + mid;
		}
		else return "redirect:/message/memberLoginNo";	
	}
	
	@ResponseBody
	@PostMapping("/emailCheck")
	public String emailCheckPost(String email) {
		// 체크 사항을 충분히 확인 체크 완료 후 메일 서비스를 호출
		String uuid = UUID.randomUUID().toString().substring(0, 8).toUpperCase();
		
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		HttpSession session = request.getSession();
		session.setAttribute("sAuthKey", uuid);
		
		
		String title = "[greenStudyS] 이메일 인증번호";
		String flag = "<p>인증번호는 : <b>"+uuid+"</b> 입니다.</p>";
		
		try {
			projectProvide.mailSend(email, title, flag);
			return "1";
		} 
		catch (Exception e) {
			e.printStackTrace();
			return "0";
		}
	}
	
	@ResponseBody
	@PostMapping("/authCheck")
	public String authCheckPost(String authId) {
		
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		HttpSession session = request.getSession();
		
		String sAuthKey = (String) session.getAttribute("sAuthKey");
		
		if(sAuthKey != null && sAuthKey.equals(authId.trim())) {
			session.removeAttribute("sAuthKey");
			return "1";
		}
		else return "0";
		
	}
	
	@GetMapping("/memberMain")
	public String memberMainGet(Model model, HttpSession session) {
		return "member/memberMain";
	}
	
	@GetMapping("/memberList")
	public String memberListGet(Model model,
			PageVO vo,
			@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "5", required = false) int pageSize
		) {
		vo.setPag(pag);
		vo.setPageSize(pageSize);
		vo.setSection("member");
		vo = pagiNation.getTotRecCnt(vo);
		
		List<MemberVO> vos = memberService.getMemberList(vo.getStartIndexNo(), pageSize);
		model.addAttribute("vos", vos);
		model.addAttribute("vo", vo);
		return "member/memberList";
	}
	
	@GetMapping("/memberContent")
	public String memberContentGet(Model model, String mid) {
		MemberVO vo = memberService.getMemberCheckId(mid);
		model.addAttribute("vo", vo);
		return "member/memberContent";
	}
	
	@GetMapping("/memberPwdCheck/{pwdFlag}")  //{pwdFlag}에 p를 받으면 비밀번호변경, u를 받으면 회원정보수정
	public String memberPwdCheckGet(Model model, @PathVariable String pwdFlag) {
		model.addAttribute("pwdFlag", pwdFlag);
		return "member/memberPwdCheck";
	}
	
	@ResponseBody
	@PostMapping("/memberPwdCheckOk")  //{pwdFlag}에 p를 받으면 비밀번호변경, u를 받으면 회원정보수정
	public String memberPwdCheckPost(String mid, String pwd) {
		MemberVO vo = memberService.getMemberCheckId(mid);
		
		if(vo != null && passwordEncoder.matches(pwd, vo.getPwd())) return "1";
		else return "0";
	}
	
	@ResponseBody
	@PostMapping("/memberPwdChangeOk")  
	public String memberPwdChangeOkPost(String mid, String pwd) {
		return memberService.setMemberPwdUpdate(mid, passwordEncoder.encode(pwd)) + "";
	}
	
	@GetMapping("/memberUpdate")  
	public String memberUpdateGet(Model model, HttpSession session) {
		String mid = (String) session.getAttribute("sMid");
		MemberVO vo = memberService.getMemberCheckId(mid);
		model.addAttribute("vo", vo);
		return "member/memberUpdate";
	}
	
	@PostMapping("/memberUpdate")  
	public String memberUpdatePost(MemberVO vo, MultipartFile fName, HttpSession session) {
		// 닉네임 변경 유무 (닉네임 중복체크)
		String nickName = (String) session.getAttribute("sNickName");
		if(!nickName.equals(vo.getNickName()) && memberService.getMemberNickNameCheck(vo.getNickName()) != 0) {
			return "redirect:/message/nickNameUpdateError";
		}
		
		String previPhoto = memberService.getMemberCheckId(vo.getMid()).getPhoto();
		
		if(fName.getOriginalFilename() != null && !fName.getOriginalFilename().equals("")) {
			if(!previPhoto.equals("noimage.png")) {
				projectProvide.deleteFile(previPhoto, "member");
			}
			vo.setPhoto(projectProvide.uploadFile(fName, "member", ""));
		}
		else {
			vo.setPhoto(previPhoto);
		}
		// 처리된 결과를 DB에 저장하기
		int res = memberService.setMemberUpdateOk(vo);
		
		if(res != 0) {
			session.setAttribute("sNickName", vo.getNickName());
			return "redirect:/message/memberUpdateOk";
		}
		else return "redirect:/message/memberUpdateNo";
		
	}
	
	@ResponseBody
	@PostMapping("/userDel")  
	public String userDelPost(HttpSession session) {
		String mid = (String) session.getAttribute("sMid");
		int res = memberService.setUserDel(mid);
		
		if(res != 0) {
			session.invalidate();
			return "1";
		}
		else return "0";
	}
	
	
	
}

