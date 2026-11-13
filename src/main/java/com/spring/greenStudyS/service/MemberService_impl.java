package com.spring.greenStudyS.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.greenStudyS.dao.MemberDAO;
import com.spring.greenStudyS.vo.MemberVO;

@Service
public class MemberService_impl implements MemberService {

	@Autowired
	MemberDAO memberDAO;
	
	@Override
	public int getMemberIdCheck(String mid) {
		return memberDAO.getMemberIdCheck(mid);
	}

	@Override
	public int getMemberNickNameCheck(String nickName) {
		return memberDAO.getMemberNickNameCheck(nickName);
	}

	@Override
	public int setMemberJoin(MemberVO vo) {
		return memberDAO.setMemberJoin(vo);
	}

	@Override
	public void setMemberInfoUpdate(MemberVO vo) {
		memberDAO.setMemberInfoUpdate(vo);
	}

	@Override
	public MemberVO getMemberCheckId(String mid) {
		return memberDAO.getMemberCheckId(mid);
	}

	@Override
	public List<MemberVO> getMemberList(int startIndexNo, int pageSize) {
		return memberDAO.getMemberList(startIndexNo, pageSize);
	}

	@Override
	public int setMemberPwdUpdate(String mid, String pwd) {
		return memberDAO.setMemberPwdUpdate(mid, pwd);
	}

	@Override
	public void setMemberLevelUpdate(String mid) {
		memberDAO.setMemberLevelUpdate(mid);
		
	}

	@Override
	public List<MemberVO> getAdMemberList(int startIndexNo, int pageSize, String levels) {
		return memberDAO.getAdMemberList(startIndexNo, pageSize, levels);
	}

	@Override
	public int setMemberUpdateOk(MemberVO vo) {
		return memberDAO.setMemberUpdateOk(vo);
	}

	@Override
	public int setUserDel(String mid) {
		return memberDAO.setUserDel(mid);
	}
	
	@Override
	public List<MemberVO> getMemberEmailList() {
		return memberDAO.getMemberEmailList();
	}
}
