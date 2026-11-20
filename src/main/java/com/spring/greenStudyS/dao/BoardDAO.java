package com.spring.greenStudyS.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.greenStudyS.vo.BoardReplyVO;
import com.spring.greenStudyS.vo.BoardVO;

public interface BoardDAO {

	int getTotRecCnt();

	List<BoardVO> getboardList(@Param("startIndexNo")int startIndexNo, @Param("pageSize")int pageSize);

	int setboardInput(@Param("vo")BoardVO vo);
	
	BoardVO getBoardContent(@Param("idx")int idx);

	int setBoardDelete(@Param("idx")int idx);

	int setBoardUpdate(@Param("vo")BoardVO vo);

	void setReadNumPlus(@Param("idx")int idx);

	void setboardGoodCheck(@Param("idx")int idx, @Param("sw")int sw);

	BoardVO getPreNextSearch(@Param("idx")int idx, @Param("str")String str);

	List<BoardVO> getBoardSearchList(@Param("search")String search, @Param("searchString")String searchString);

	BoardReplyVO getBoardParentReplyCheck(@Param("boardIdx")int boardIdx);

	int setBoardReplyInput(@Param("vo")BoardReplyVO replyVO);

	List<BoardReplyVO> getBoardReply(@Param("idx")int idx);

	void setReplyOrderUpdate(@Param("boardIdx")int boardIdx, @Param("re_order")int re_order);

	int setBoardReplyUpdate(@Param("idx")int idx, @Param("content")String content);

	int setBoardReplyDeleteChange(@Param("idx")int idx);



}
