package com.spring.greenStudyS.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.greenStudyS.common.PageVO;
import com.spring.greenStudyS.common.PagiNation;
import com.spring.greenStudyS.common.ProjectProvide;
import com.spring.greenStudyS.service.AdminService;
import com.spring.greenStudyS.service.MemberService;
import com.spring.greenStudyS.vo.MemberVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/admin")
public class AdminController {
	
	@Autowired
	AdminService adminService;
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	PagiNation pagiNation;
	
	@Autowired
	ProjectProvide projectProvide; 
	
	@GetMapping("/adminMain")
	public String adminMainGet() {
		return "admin/adminMain";
	}
	
	@GetMapping("/adminLeft")
	public String adminLeftGet() {
		return "admin/adminLeft";
	}
	
	@GetMapping("/adminRight")
	public String adminRightGet() {
		return "admin/adminRight";
	}
	
	@GetMapping("/adMemberList")
	public String memberListGet(Model model,
			PageVO vo,
			@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "5", required = false) int pageSize,
			@RequestParam(name = "levels", defaultValue = "", required = false) String levels
		) {
		
		vo.setPag(pag);
		vo.setPageSize(pageSize);
		vo.setSection("adMember");
		vo.setParts(levels);
		vo = pagiNation.getTotRecCnt(vo);
		
		List<MemberVO> vos = adminService.getAdMemberList(vo.getStartIndexNo(), pageSize, levels);
		model.addAttribute("vos", vos);
		model.addAttribute("vo", vo);
		model.addAttribute("levels", levels);
		return "admin/member/adMemberList";
	}
	
	@GetMapping("/adMemberContent")
	public String memberContentGet(Model model, String mid) {
		MemberVO vo = memberService.getMemberCheckId(mid);
		model.addAttribute("vo", vo);
		return "admin/member/adMemberContent";
	}
	
	@ResponseBody
	@PostMapping("/adMemberLevelChange")
	public String memberLevelChangePost(int idx, int level) {
		
		return adminService.setmemberLevelUpdate(idx,level)+"";
	}
	
	@ResponseBody
	@PostMapping("/adMemberLevelSelectCheck")
	public String adMemberLevelSelectCheckPost(String idxSelectArray, int levelItem) {
		String[] idxSelectArrays = idxSelectArray.split("/");
		int res = 0;
		
		for(int i=0; i<idxSelectArrays.length; i++) {
			int idx = Integer.parseInt(idxSelectArrays[i]);
			res = adminService.setSelectMemberLevelUpdate(idx,levelItem);
		}
		return res+"";
	}
	
	
	@ResponseBody
	@PostMapping("/memberDeleteOk")
	public String memberDeleteOkPost(String idxSelectArray) {
		String[] idxSelectArrays = idxSelectArray.split("/");
		int res = 0;
		
		for(int i=0; i<idxSelectArrays.length; i++) {
			int idx = Integer.parseInt(idxSelectArrays[i]);
			
			// 1. 회원 정보 꺼내서 사진 삭제
			MemberVO vo = adminService.getMemberPhotoName(idx);
			if(!vo.getPhoto().equals("noimage.png")) {
				projectProvide.deleteFile(vo.getPhoto(), "member");
			}
			
			// 2. DB에서 회원 삭제
			res = adminService.setMemberDelete(idx);
		}
		return res+"";
	}
	

}
