package com.spring.greenStudyS.service;

import java.util.List;

import com.spring.greenStudyS.vo.BoardVO;

public interface BoardService {

	List<BoardVO> getboardList(int startIndexNo, int pageSize);

}
