package com.spring.greenStudyS.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.greenStudyS.dao.AdminDAO;
import com.spring.greenStudyS.vo.MemberVO;

@Service
public class AdminService_impl implements AdminService {

	@Autowired
	AdminDAO adminDAO;

	@Override
	public int setmemberLevelUpdate(int idx, int level) {
		return adminDAO.setmemberLevelUpdate(idx, level);
	}

	@Override
	public int setSelectMemberLevelUpdate(int idx, int levelItem) {
		return adminDAO.setSelectMemberLevelUpdate(idx, levelItem);
	}

	@Override
	public List<MemberVO> getAdMemberList(int startIndexNo, int pageSize, String levels) {
		return adminDAO.getAdMemberList(startIndexNo, pageSize, levels);
	}

	@Override
	public MemberVO getMemberPhotoName(int idx) {
		return adminDAO.getMemberPhotoName(idx);
	}

	@Override
	public int setMemberDelete(int idx) {
		return adminDAO.setMemberDelete(idx);
	}
}
