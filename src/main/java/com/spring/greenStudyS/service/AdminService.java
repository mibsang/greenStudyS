package com.spring.greenStudyS.service;

import java.util.List;

import com.spring.greenStudyS.vo.MemberVO;

public interface AdminService {

	int setmemberLevelUpdate(int idx, int level);

	int setSelectMemberLevelUpdate(int idx, int levelItem);

	List<MemberVO> getAdMemberList(int startIndexNo, int pageSize, String levels);

	MemberVO getMemberPhotoName(int idx);

	int setMemberDelete(int idx);


}
