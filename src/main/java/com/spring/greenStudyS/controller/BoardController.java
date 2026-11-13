package com.spring.greenStudyS.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.greenStudyS.common.PageVO;
import com.spring.greenStudyS.common.PagiNation;
import com.spring.greenStudyS.service.BoardService;
import com.spring.greenStudyS.vo.BoardVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/board")
public class BoardController {
	
	@Autowired
	BoardService boardService;
	
	@Autowired
	PagiNation pagiNation;
	
	@GetMapping("/boardList")
	public String boardListGet(
			Model model,
			PageVO pageVO,
			@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "10", required = false) int pageSize
		) {
		pageVO.setPag(pag);
		pageVO.setPageSize(pageSize);
		pageVO.setSection("board");
		pageVO = pagiNation.getTotRecCnt(pageVO);
		
		List<BoardVO> vos = boardService.getboardList(pageVO.getStartIndexNo(), pageSize);
		
		model.addAttribute("vos", vos);
		model.addAttribute("pageVO", pageVO);
		
		return "board/boardList";
	}
	
	@GetMapping("/boardContent")
	public String boardContentGet(int idx) {
		return "board/boardContent";
	}
	
	@GetMapping("/boardInput")
	public String boardInputGet() {
		return "board/boardInput";
	}
	
}
