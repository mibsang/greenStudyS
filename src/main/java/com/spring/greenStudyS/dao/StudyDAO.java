package com.spring.greenStudyS.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.greenStudyS.vo.User2VO;

public interface StudyDAO {

	List<String> getUserMidList();

	User2VO getUserMidSearch(@Param("mid") String mid);

	List<User2VO> getUserGenderSearch();

	List<User2VO> getUserGenderList(@Param("gender") String gender);

	User2VO getUserSearch(@Param("mid") String mid);

	List<User2VO> getUserSearchList(@Param("mid") String mid);


}
