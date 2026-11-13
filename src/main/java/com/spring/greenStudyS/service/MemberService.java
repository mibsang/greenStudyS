package com.spring.greenStudyS.service;

import java.util.List;

import com.spring.greenStudyS.vo.MemberVO;

public interface MemberService {

	int getMemberIdCheck(String mid);

	int getMemberNickNameCheck(String nickName);

	int setMemberJoin(MemberVO vo);

	void setMemberInfoUpdate(MemberVO vo);

	MemberVO getMemberCheckId(String mid);

	List<MemberVO> getMemberList(int startIndexNo, int pageSize);

	int setMemberPwdUpdate(String mid, String pwd);

	void setMemberLevelUpdate(String mid);

	List<MemberVO> getAdMemberList(int startIndexNo, int pageSize, String levels);

	int setMemberUpdateOk(MemberVO vo);

	int setUserDel(String mid);
	
	List<MemberVO> getMemberEmailList();

}
