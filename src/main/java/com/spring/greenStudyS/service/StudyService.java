package com.spring.greenStudyS.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.spring.greenStudyS.vo.User2VO;

public interface StudyService {

	String[] getCityStringArray(String dodo);

	List<String> getCityArrayList(String dodo);

	List<String> getUserMidList();

	User2VO getUserMidSearch(String mid);

	List<User2VO> getUserGenderSearch();

	List<User2VO> getUserGenderList(String gender);

	User2VO getUserSearch(String mid);

	List<User2VO> getUserSearchList(String mid);

	int fileUpload(MultipartFile fName, String name, HttpServletRequest request);

	int multiFileUpload(MultipartHttpServletRequest mFile);

}
