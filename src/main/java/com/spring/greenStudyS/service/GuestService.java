package com.spring.greenStudyS.service;

import java.util.List;

import com.spring.greenStudyS.vo.GuestVO;

public interface GuestService {

	List<GuestVO> getGuestList(int startIndexNo, int pageSize);

	void setInputGuest(GuestVO vo);

	int setGuestDelete(int idx, String pwd);

	int setGuestUpdate(int idx, String pwd, String content);

	int getTotRecCnt();

}
