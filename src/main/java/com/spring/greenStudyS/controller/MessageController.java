package com.spring.greenStudyS.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/message")
public class MessageController {
	
	@RequestMapping(value="/{msgFlag}", method=RequestMethod.GET)
	public String messageGet(@PathVariable String msgFlag, Model model,
			@RequestParam(name="idx", defaultValue = "0", required = false) int idx,
			@RequestParam(name="mid", defaultValue = "" , required = false) String mid
		) {
		
		if(msgFlag.equals("fileUploadOk")) {
			model.addAttribute("message", "파일 업로드가 완료되었습니다.");
			model.addAttribute("url", "/study/fileUpload");
		}
		else if(msgFlag.equals("fileUploadNo")) {
			model.addAttribute("message", "파일 업로드에 실패했습니다.");
			model.addAttribute("url", "/study/fileUpload");
		}
		else if(msgFlag.equals("mailSendOk")) {
			model.addAttribute("message", "메일이 전송되었습니다.");
			model.addAttribute("url", "/study/mailForm");
		}
		else if(msgFlag.equals("mailSendNo")) {
			model.addAttribute("message", "메일 전송에 실패했습니다.");
			model.addAttribute("url", "/study/mailForm");
		}
		else if(msgFlag.equals("memberJoinOk")) {
			model.addAttribute("message", "회원가입에 성공했습니다.");
			model.addAttribute("url", "/member/memberLogin");
		}
		else if(msgFlag.equals("memberJoinNo")) {
			model.addAttribute("message", "회원가입에 실패했습니다.");
			model.addAttribute("url", "/member/memberJoin");
		}
		else if(msgFlag.equals("memberLoginOk")) {
			model.addAttribute("message", mid + "님 방문을 환영합니다.");
			model.addAttribute("url", "/member/memberMain");
		}
		else if(msgFlag.equals("memberLevelUpOk")) {
			model.addAttribute("message", mid + "님 등업조건 만족으로 등업되셨습니다.\\n축하드립니다!!🎉🎉");
			model.addAttribute("url", "/member/memberMain");
		}
		else if(msgFlag.equals("memberLoginNo")) {
			model.addAttribute("message", "로그인에 실패했습니다.");
			model.addAttribute("url", "/member/memberLogin");
		}
		else if(msgFlag.equals("memberLogout")) {
			model.addAttribute("message", mid + "님 로그아웃 되었습니다.");
			model.addAttribute("url", "/member/memberLogin");
		}
		else if(msgFlag.equals("nickNameUpdateError")) {
			model.addAttribute("message", "이미 사용중인 닉네임 입니다.");
			model.addAttribute("url", "/member/memberUpdate");
		}
		else if(msgFlag.equals("memberUpdateOk")) {
			model.addAttribute("message", "회원정보가 수정되었습니다.");
			model.addAttribute("url", "/member/memberUpdate");
		}
		else if(msgFlag.equals("memberNo")) {
			model.addAttribute("message", "접근 권한이 없습니다.\\n로그인 후 다시 시도해주세요.");
			model.addAttribute("url", "/member/memberLogin");
		}
		else if(msgFlag.equals("levelNotMatch")) {
			model.addAttribute("message", "접근 권한이 없습니다.\\n확인 후 다시 시도해주세요.");
			model.addAttribute("url", "/member/memberMain");
		}
		else if(msgFlag.equals("boardInputOk")) {
			model.addAttribute("message", "게시판 글작성이 정상적으로 처리되었습니다.");
			model.addAttribute("url", "/board/boardList");
		}
		else if(msgFlag.equals("boardInputNo")) {
			model.addAttribute("message", "게시판 글작성에 실패했습니다.\\n다시 시도해주세요.");
			model.addAttribute("url", "/board/boardInput");
		}
		else if(msgFlag.equals("boardDeleteOk")) {
			model.addAttribute("message", "게시글이 정상적으로 삭제되었습니다.");
			model.addAttribute("url", "/board/boardList");
		}
		else if(msgFlag.equals("boardDeleteNo")) {
			model.addAttribute("message", "게시글 삭제에 실패했습니다.\\n다시 시도해주세요.");
			model.addAttribute("url", "/board/boardContent?idx=" + idx);
		}
		else if(msgFlag.equals("boardUpdateOk")) {
			model.addAttribute("message", "게시글이 정상적으로 수정되었습니다.");
			model.addAttribute("url", "/board/boardContent?idx=" + idx);
		}
		else if(msgFlag.equals("boardUpdateNo")) {
			model.addAttribute("message", "게시글 수정에 실패했습니다.\\n다시 시도해주세요.");
			model.addAttribute("url", "/board/boardUpdate?idx=" + idx);
		}
		else if(msgFlag.equals("multiFileUploadOk")) {
			model.addAttribute("message", "파일이 정상적으로 업로드 되었습니다.");
			model.addAttribute("url", "/study/fileUpload/multiFile");
		}
		else if(msgFlag.equals("multiFileUploadNo")) {
			model.addAttribute("message", "파일 업로드에 실패했습니다.\\n다시 시도해주세요.");
			model.addAttribute("url", "/study/fileUpload/multiFile");
		}
		else if(msgFlag.equals("pdsInputOk")) {
			model.addAttribute("message", "자료실에 업로드가 완료되었습니다.");
			model.addAttribute("url", "/study/pds/pdsList");
		}
		else if(msgFlag.equals("pdsInputNo")) {
			model.addAttribute("message", "업로드에 실패했습니다.\\n다시 시도해주세요.");
			model.addAttribute("url", "/study/pds/pdsInput");
		}
		
		return "include/message";
	}
}
