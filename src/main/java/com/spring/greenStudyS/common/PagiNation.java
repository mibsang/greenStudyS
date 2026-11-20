package com.spring.greenStudyS.common;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.spring.greenStudyS.dao.BoardDAO;
import com.spring.greenStudyS.dao.MemberDAO;
import com.spring.greenStudyS.dao.PdsDAO;
import com.spring.greenStudyS.service.GuestService;

@Component
public class PagiNation {
	
	@Autowired
	GuestService guestService;
	
	@Autowired
	MemberDAO memberDAO;
	
	@Autowired
	BoardDAO boardDAO;
	
	@Autowired
	PdsDAO pdsDAO;
	
	public PageVO getTotRecCnt(PageVO vo) {
		int totRecCnt = 0;
		
		if(vo.getSection().equals("guest")) {
			totRecCnt = guestService.getTotRecCnt();
		}
		else if(vo.getSection().equals("member")) {
			totRecCnt = memberDAO.getTotRecCnt();
		}
		else if(vo.getSection().equals("adMember")) {
			totRecCnt = memberDAO.getAdTotRecCnt(vo.getPart());
		}
		else if(vo.getSection().equals("board")) {
			totRecCnt = boardDAO.getTotRecCnt();
		}
		else if(vo.getSection().equals("pds")) {
			totRecCnt = pdsDAO.getTotRecCnt(vo.getPart());
		}
		
		int totPage = (totRecCnt % vo.getPageSize()) == 0 ? (totRecCnt / vo.getPageSize()) : (totRecCnt / vo.getPageSize()) + 1;
		int startIndexNo = (vo.getPag() - 1) * vo.getPageSize();
		int curScrStartNo = totRecCnt - startIndexNo;
		
		int blockSize = 3;
		int startPage = vo.getPag() - (blockSize / 2);
		if(startPage < 1) startPage = 1;                 
		int endPage = startPage + blockSize - 1;
		if(endPage > totPage) {                           
			endPage = totPage;
			startPage = Math.max(1, endPage - blockSize + 1);
		}
		int curBlock = (vo.getPag() - 1) / blockSize;
		int lastBlock = (totPage - 1) / blockSize;
		
		vo.setPag(vo.getPag());
		vo.setPageSize(vo.getPageSize());
		vo.setTotRecCnt(totRecCnt);
		vo.setTotPage(totPage);
		vo.setStartIndexNo(startIndexNo);
		vo.setCurScrStartNo(curScrStartNo);
		vo.setBlockSize(blockSize);
		vo.setCurBlock(curBlock);
		vo.setLastBlock(lastBlock);
		vo.setStartPage(startPage);
		vo.setEndPage(endPage);
		vo.setSearch(vo.getSearch());
		vo.setSearchString(vo.getSearchString());
		vo.setSearchStr(vo.getSearchStr());
		vo.setPart(vo.getPart());
		return vo;
	}
}
