package com.spring.greenStudyS.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.greenStudyS.vo.MemberVO;

public interface MemberDAO {

	int getMemberIdCheck(@Param("mid")String mid);

	int getMemberNickNameCheck(@Param("nickName")String nickName);

	int setMemberJoin(@Param("vo")MemberVO vo);

	void setMemberInfoUpdate(@Param("vo")MemberVO vo);

	MemberVO getMemberCheckId(@Param("mid")String mid);

	List<MemberVO> getMemberList(@Param("startIndexNo")int startIndexNo, @Param("pageSize")int pageSize);

	int getTotRecCnt();

	int setMemberPwdUpdate(@Param("mid")String mid, @Param("pwd")String pwd);

	void setMemberLevelUpdate(@Param("mid")String mid);

	List<MemberVO> getAdMemberList(@Param("startIndexNo")int startIndexNo, @Param("pageSize")int pageSize, @Param("levels")String levels);

	int getAdTotRecCnt(@Param("levels")String levels);

	int setMemberUpdateOk(@Param("vo")MemberVO vo);

	int setUserDel(@Param("mid")String mid);
	
	List<MemberVO> getMemberEmailList();



}
