package com.spring.greenStudyS.vo;

import lombok.Data;

@Data
public class GuestVO {
	private int idx;
	private String nickName;
	private String pwd;
	private String content;
	private String email;
	private String hostIP;
	private String wDate;
}
