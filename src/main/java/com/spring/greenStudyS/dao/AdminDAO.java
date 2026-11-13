package com.spring.greenStudyS.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.greenStudyS.vo.MemberVO;

public interface AdminDAO {

	int setmemberLevelUpdate(@Param("idx")int idx, @Param("level")int level);

	int setSelectMemberLevelUpdate(@Param("idx")int idx, @Param("levelItem")int levelItem);

	List<MemberVO> getAdMemberList(@Param("startIndexNo")int startIndexNo, @Param("pageSize")int pageSize, @Param("levels")String levels);

	MemberVO getMemberPhotoName(@Param("idx")int idx);

	int setMemberDelete(@Param("idx")int idx);


}
