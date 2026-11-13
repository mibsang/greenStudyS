package com.spring.greenStudyS.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.greenStudyS.vo.GuestVO;

public interface GuestDAO {

	List<GuestVO> getGuestList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	void setInputGuest(GuestVO vo);

	int setGuestDelete(@Param("idx") int idx, @Param("pwd") String pwd);

	int setGuestUpdate(@Param("idx") int idx, @Param("pwd") String pwd, @Param("content") String content);

	int getTotRecCnt();

}
