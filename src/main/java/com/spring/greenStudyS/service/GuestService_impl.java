package com.spring.greenStudyS.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.greenStudyS.dao.GuestDAO;
import com.spring.greenStudyS.vo.GuestVO;

@Service
public class GuestService_impl implements GuestService {

	@Autowired
	GuestDAO guestDAO;
	
	@Override
	public List<GuestVO> getGuestList(int startIndexNo, int pageSize) {
		return guestDAO.getGuestList(startIndexNo, pageSize);
	}

	@Override
	public void setInputGuest(GuestVO vo) {
		guestDAO.setInputGuest(vo);
	}

	@Override
	public int setGuestDelete(int idx, String pwd) {
		return guestDAO.setGuestDelete(idx, pwd);
	}

	@Override
	public int setGuestUpdate(int idx, String pwd, String content) {
		return guestDAO.setGuestUpdate(idx, pwd, content);
	}

	@Override
	public int getTotRecCnt() {
		return guestDAO.getTotRecCnt();
	}


}
