package com.spring.greenStudyS.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

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
import com.spring.greenStudyS.service.GuestService;
import com.spring.greenStudyS.vo.GuestVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/guest")
public class GuestController {
	
	@Autowired
	GuestService guestService;
	
	@Autowired
	PagiNation pagiNation;
	
	@GetMapping("/guest")
	public String guestListGet(
			Model model,
			PageVO vo,
			@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "3", required = false) int pageSize
		) {
		vo.setPag(pag);
		vo.setPageSize(pageSize);
		vo.setSection("guest");
		vo = pagiNation.getTotRecCnt(vo);
		
		List<GuestVO> vos = guestService.getGuestList(vo.getStartIndexNo(), pageSize);
		
		model.addAttribute("vos", vos);
		model.addAttribute("vo", vo);
		
		return "guest/guest";
	}
	
//	
//	@GetMapping("/guest")
//	public String guestListGet(
//			Model model,
//			@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
//			@RequestParam(name = "pageSize", defaultValue = "3", required = false) int pageSize
//			) {
//		
//		int totRecCnt = guestService.getTotRecCnt();
//		int totPage = (totRecCnt % pageSize) == 0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize) + 1;
//		int startIndexNo = (pag - 1) * pageSize;
//		int curScrStartNo = totRecCnt - startIndexNo;
//		
//		int blockSize = 3;
//		int startPage = pag - (blockSize / 2);
//		if(startPage < 1) startPage = 1;                 
//		int endPage = startPage + blockSize - 1;
//		if(endPage > totPage) {                           
//			endPage = totPage;
//			startPage = Math.max(1, endPage - blockSize + 1);
//		}
//		int curBlock = (pag - 1) / blockSize;
//		int lastBlock = (totPage - 1) / blockSize;
//		
//		List<GuestVO> vos = guestService.getGuestList(startIndexNo, pageSize);
//		model.addAttribute("vos", vos);
//		model.addAttribute("pag", pag);
//		model.addAttribute("pageSize", pageSize);
//		model.addAttribute("totRecCnt", totRecCnt);
//		model.addAttribute("totPage", totPage);
//		model.addAttribute("curScrStartNo", curScrStartNo);
//		model.addAttribute("blockSize", blockSize);
//		model.addAttribute("curBlock", curBlock);
//		model.addAttribute("lastBlock", lastBlock);
//		model.addAttribute("startPage", startPage);
//		model.addAttribute("endPage", endPage);
//		return "guest/guest";
//	}
//	
	@PostMapping("/guest")
	public String guestInputPost(Model model, GuestVO vo, HttpServletRequest request) {
		vo.setHostIP(request.getRemoteAddr());
		if (vo.getEmail() == null) vo.setEmail("");
		
		guestService.setInputGuest(vo);
		return "redirect:/guest/guest";
	}
	
	@ResponseBody
	@PostMapping("/guestDelete")
	public String guestDeletePost(int idx, String pwd) {
		return guestService.setGuestDelete(idx, pwd) + "";
	}
	
	@ResponseBody
	@PostMapping("/guestUpdateOk")
	public String guestUpdatePost(int idx, String pwd, String content) {
		return guestService.setGuestUpdate(idx, pwd, content) + "";
	}
	
	
}
