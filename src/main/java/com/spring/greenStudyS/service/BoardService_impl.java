package com.spring.greenStudyS.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.spring.greenStudyS.common.ProjectProvide;
import com.spring.greenStudyS.dao.BoardDAO;
import com.spring.greenStudyS.vo.BoardReplyVO;
import com.spring.greenStudyS.vo.BoardVO;

@Service
public class BoardService_impl implements BoardService {

	@Autowired
	BoardDAO boardDAO;

	@Autowired
	ProjectProvide projectProvide;
	
	@Override
	public List<BoardVO> getboardList(int startIndexNo, int pageSize) {
		return boardDAO.getboardList(startIndexNo, pageSize);
	}
	
	@Override
	public int setboardInput(BoardVO vo) {
		return boardDAO.setboardInput(vo);
	}

	@Override
	public BoardVO getBoardContent(int idx) {
		return boardDAO.getBoardContent(idx);
	}

	@Override
	public void imageCheck(String content) {
		// 0         1         2        3
		// 012345678901234567890123456890
		// src="/greenStudyS/ckImage/250101120000_사진.jpg"
		//                           ↑ 26번째부터 파일명
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/");
		
		int position = 26;
		String nextImg = content.substring(content.indexOf("src=\"/") + position);
		boolean sw = true;
		
		while(sw) {
			String imgFile = nextImg.substring(0, nextImg.indexOf("\""));
			
			String originFilePath = realPath + "ckImage/" + imgFile;
			String copyFilePath = realPath + "board/" + imgFile;
			
			fileCopyCheck(originFilePath, copyFilePath, true);
			
			
			if(nextImg.indexOf("src=\"/") == -1) sw = false;
			else nextImg = nextImg.substring(nextImg.indexOf("src=\"/") + position);
		}
	}
	
	// 파일 복사 처리
	private void fileCopyCheck(String originFilePath, String copyFilePath, boolean deleteOrigin) {
		try {
			FileInputStream fis = new FileInputStream(new File(originFilePath));
			FileOutputStream fos = new FileOutputStream(new File(copyFilePath));
	
			byte[] bytes = new byte[2048];
			
			while(fis.read(bytes) != -1) {
				fos.write(bytes);
			}
			fos.flush();
			fos.close();
			fis.close();
			
			if(deleteOrigin) new File(originFilePath).delete();
		} 
		catch (FileNotFoundException e) {
			e.printStackTrace();
		} 
		catch (IOException e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public int setBoardDelete(int idx) {
		return boardDAO.setBoardDelete(idx);
	}

	@Override
	public void imageDelete(String content) {
		// 0         1         2        3
		// 012345678901234567890123456890
		// src="/greenStudyS/board/250101120000_사진.jpg"
		//                         ↑ 24번째부터 파일명
		
		int position = 24;
		String nextImg = content.substring(content.indexOf("src=\"/") + position);
		boolean sw = true;
		
		while(sw) {
			String imgFile = nextImg.substring(0, nextImg.indexOf("\""));
			projectProvide.deleteFile(imgFile, "board");
			
			if(nextImg.indexOf("src=\"/") == -1) sw = false;
			else nextImg = nextImg.substring(nextImg.indexOf("src=\"/") + position);
		}
	}

	@Override
	public void imageBackup(String content) {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/");
		
		int position = 24;
		String nextImg = content.substring(content.indexOf("src=\"/") + position);
		boolean sw = true;
		
		while(sw) {
			String imgFile = nextImg.substring(0, nextImg.indexOf("\""));
			
			String originFilePath = realPath + "board/" + imgFile;
			String copyFilePath = realPath + "ckImage/" + imgFile;
			
			fileCopyCheck(originFilePath, copyFilePath, false);
			
			
			if(nextImg.indexOf("src=\"/") == -1) sw = false;
			else nextImg = nextImg.substring(nextImg.indexOf("src=\"/") + position);
		}
	}

	@Override
	public int setBoardUpdate(BoardVO vo) {
		return boardDAO.setBoardUpdate(vo);
	}

	@Override
	public void setReadNumPlus(int idx) {
		boardDAO.setReadNumPlus(idx);
	}

	@Override
	public void setboardGoodCheck(int idx, int sw) {
		boardDAO.setboardGoodCheck(idx, sw);
	}

	@Override
	public BoardVO getPreNextSearch(int idx, String str) {
		return boardDAO.getPreNextSearch(idx, str);
	}

	@Override
	public List<BoardVO> getBoardSearchList(String search, String searchString) {
		return boardDAO.getBoardSearchList(search, searchString);
	}

	@Override
	public BoardReplyVO getBoardParentReplyCheck(int boardIdx) {
		return boardDAO.getBoardParentReplyCheck(boardIdx);
	}

	@Override
	public int setBoardReplyInput(BoardReplyVO replyVO) {
		return boardDAO.setBoardReplyInput(replyVO);
	}

	@Override
	public List<BoardReplyVO> getBoardReply(int idx) {
		return boardDAO.getBoardReply(idx);
	}

	@Override
	public void setReplyOrderUpdate(int boardIdx, int re_order) {
		boardDAO.setReplyOrderUpdate(boardIdx, re_order);		
	}

	@Override
	public int setBoardReplyUpdate(int idx, String content) {
		return boardDAO.setBoardReplyUpdate(idx, content);	
	}

	@Override
	public int setBoardReplyDeleteChange(int idx) {
		return boardDAO.setBoardReplyDeleteChange(idx);	
	}

}
