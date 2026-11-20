package com.spring.greenStudyS.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

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
import com.spring.greenStudyS.service.BoardService;
import com.spring.greenStudyS.vo.BoardReplyVO;
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

	@Autowired
	ProjectProvide projectProvide;
	
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
	
	@GetMapping("/boardInput")
	public String boardInputGet() {
		return "board/boardInput";
	}

	@PostMapping("/boardInput")
	public String boardInputPost(BoardVO vo) {
		// 1.글을 올리기 전에 글 안에 이미지가 포함되어 있는지를 판별 후 이미지가 있다면 저장된 이미지만 골라내서(ckImage폴더) board폴더로 복사처리
		if(vo.getContent().indexOf("src=\"/") != -1) {
			boardService.imageCheck(vo.getContent());
		}
		
		// 2.이미지 복사 작업 완료 시 DB 안의 이미지 경로를 ckImage에서 board로 변경
		vo.setContent(vo.getContent().replace("/ckImage/", "/board/"));
		
		
		// 3.변경 후 처리된 내용들을 vo에 담아 DB에 저장
		int res = boardService.setboardInput(vo);

		if(res != 0) return "redirect:/message/boardInputOk";
		else return "redirect:/message/boardInputNo";
	}

	@SuppressWarnings("unchecked")
	@GetMapping("/boardContent")
	public String boardContentGet(
			int idx,
			Model model,
			HttpSession session,
			@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "10", required = false) int pageSize
		) {
		// 조회 수 증가처리
		List<String> contentReadNum = (List<String>)session.getAttribute("sContentIdx");
		if(contentReadNum == null) contentReadNum = new ArrayList<String>();
		
		String tempContentNum = "board" + idx;
		if(!contentReadNum.contains(tempContentNum)) {
			boardService.setReadNumPlus(idx);
			contentReadNum.add(tempContentNum);
		}
		session.setAttribute("sContentIdx", contentReadNum);
		
		// 이전글과 다음글 처리
		BoardVO preVO = boardService.getPreNextSearch(idx, "preVO");
		BoardVO nextVO = boardService.getPreNextSearch(idx, "NextVO");
		
		
		BoardVO vo = boardService.getBoardContent(idx);
		
		// 댓글 추가 입력 처리
		List<BoardReplyVO> replyVos = boardService.getBoardReply(idx);
		
		model.addAttribute("vo", vo);
		model.addAttribute("pag", pag);
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("preVO", preVO);
		model.addAttribute("nextVO", nextVO);
		model.addAttribute("replyVos", replyVos);

		return "board/boardContent";
	}
	
	@GetMapping("/boardDelete")
	public String boardDeleteGet(int idx) {
		// 1. 서버에 저장 되어있는 사진데이터 삭제
		BoardVO vo = boardService.getBoardContent(idx);
		if(vo.getContent().indexOf("src=\"/") != -1) {
			boardService.imageDelete(vo.getContent());
		}
		// 2. 사진 작업 후 DB 데이터 삭제
		int res = boardService.setBoardDelete(idx);
		
		if(res != 0) return "redirect:/message/boardDeleteOk";
		else return "redirect:/message/boardDeleteNo?idx=" + idx;
	}
	
	@GetMapping("/boardUpdate")
	public String boardUpdateGet(
			int idx,
			Model model,
			@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "10", required = false) int pageSize
		) {
		BoardVO vo = boardService.getBoardContent(idx);
		
		if(vo.getContent().indexOf("src=\"/") != -1) {
			boardService.imageBackup(vo.getContent());
			vo.setContent(vo.getContent().replace("/board/", "/ckImage/"));
		}
		model.addAttribute("vo", vo);
		model.addAttribute("pag", pag);
		model.addAttribute("pageSize", pageSize);
		return "board/boardUpdate";
	}
	
	@PostMapping("/boardUpdateOk")
	public String boardUpdateOkPost(BoardVO vo, HttpSession session) {
		BoardVO originVo = boardService.getBoardContent(vo.getIdx());
		
		String sMid = (String)session.getAttribute("sMid");
		if(originVo == null || !originVo.getMid().equals(sMid)) {
			return "redirect:/message/boardUpdateNo?idx=" + vo.getIdx();
		}
		
		if(originVo.getContent().indexOf("src=\"/") != -1) {
			boardService.imageDelete(originVo.getContent());
		}
		
		if(vo.getContent().indexOf("src=\"/") != -1) {
			boardService.imageCheck(vo.getContent());
		}
		
		vo.setContent(vo.getContent().replace("/ckImage/", "/board/"));
		
		int res = boardService.setBoardUpdate(vo);

		if(res != 0) return "redirect:/message/boardUpdateOk?idx=" + vo.getIdx();
		else return "redirect:/message/boardUpdateNo?idx=" + vo.getIdx();
	}
	
	@ResponseBody
	@PostMapping("/boardGoodCheck")
	public void boardGoodCheckPost(int idx, int sw) {
		boardService.setboardGoodCheck(idx,sw);
	}
	
	@PostMapping("/boardSearchList")
	public String boardSearchListPost(Model model, String search, String searchString) {
		List<BoardVO> vos = boardService.getBoardSearchList(search, searchString);
		model.addAttribute("vos", vos);
		model.addAttribute("search", search);
		model.addAttribute("searchString", searchString);
		return "board/boardSearchList";
	}

	@ResponseBody
	@PostMapping("/boardReplyInput")
	public String boardReplyInputPost(BoardReplyVO replyVO) {
		BoardReplyVO replyParentVO = boardService.getBoardParentReplyCheck(replyVO.getBoardIdx());
		
		if(replyParentVO == null) {
			replyVO.setRe_order(1);
		}
		else {
			replyVO.setRe_order(replyParentVO.getRe_order()+1);
		}
		replyVO.setRe_step(0);
		
		int res = boardService.setBoardReplyInput(replyVO);
		
		return res + "";
	}
	
	@ResponseBody
	@PostMapping("/boardReplyInputRe")
	public String boardReplyInputRePost(BoardReplyVO replyVO) {
		
		replyVO.setRe_step(replyVO.getRe_step() + 1); // 부모 step + 1
		// 부모보다 큰 re_order 자료들은 모두 +1 처리 
		boardService.setReplyOrderUpdate(replyVO.getBoardIdx(), replyVO.getRe_order());
		
		replyVO.setRe_order(replyVO.getRe_order() + 1);
		
		int res = boardService.setBoardReplyInput(replyVO);
		
		return res + "";
	}
	
	@ResponseBody
	@PostMapping("/boardReplyUpdateOk")
	public String boardReplyUpdateOkPost(int idx, String content) {
		return boardService.setBoardReplyUpdate(idx, content)+"";
	}
	
	@ResponseBody
	@PostMapping("/boardReplyDelete")
	public String boardReplyDeletePost(int idx) {
		return boardService.setBoardReplyDeleteChange(idx)+"";
	}
}
