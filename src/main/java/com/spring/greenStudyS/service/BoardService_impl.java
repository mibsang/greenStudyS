package com.spring.greenStudyS.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.greenStudyS.dao.BoardDAO;
import com.spring.greenStudyS.vo.BoardVO;

@Service
public class BoardService_impl implements BoardService {

	@Autowired
	BoardDAO boardDAO;

	@Override
	public List<BoardVO> getboardList(int startIndexNo, int pageSize) {
		// TODO Auto-generated method stub
		return boardDAO.getboardList(startIndexNo, pageSize);
	}
	
}
