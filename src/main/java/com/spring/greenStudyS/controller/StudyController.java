package com.spring.greenStudyS.controller;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.greenStudyS.common.ARIAUtil;
import com.spring.greenStudyS.common.ProjectProvide;
import com.spring.greenStudyS.common.SecurityUtil;
import com.spring.greenStudyS.service.MemberService;
import com.spring.greenStudyS.service.StudyService;
import com.spring.greenStudyS.vo.MailVO;
import com.spring.greenStudyS.vo.MemberVO;
import com.spring.greenStudyS.vo.User2VO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/study")
public class StudyController {
	
	@Autowired
	BCryptPasswordEncoder passwordEncoder;
	
	@Autowired
	ProjectProvide projectProvide;
	
	@Autowired
	StudyService studyService;
	
	@Autowired
	JavaMailSender javaMailSender;
	
	
	@Autowired
	MemberService memberService;
	
	@GetMapping("/ajaxForm")
	public String ajaxFormGet() {
		return "study/ajax/ajaxForm";
	}
	
	@ResponseBody
	@PostMapping("/ajaxTest1")
	public String ajaxTest1Post(int idx) {
		int res = ((int)(Math.random() * 100) + 1) + idx;
		return res + "";
	}
	
	@ResponseBody
	@PostMapping(value = "/ajaxTest2", produces = "application/text; charset=UTF-8") // ajax 한글처리
	public String ajaxTest2Post(String str) {
		int res = ((int)(Math.random() * 100) + 1);
		str += "하세요." + res ;
		System.out.println("str : " + str);
		return str;
	}

	@GetMapping("/ajaxTest3")
	public String ajaxTest3Get() {
		return "study/ajax/ajaxTest3";
	}

	@ResponseBody
	@PostMapping("/ajaxTest3") 
	public String[] ajaxTest3Post(String dodo) {
//		String[] strArray = new String[100];
//		strArray = studyService.getCityStringArray(dodo);
//		return strArray;
		
		return studyService.getCityStringArray(dodo);
	}

	@GetMapping("/ajaxTest4")
	public String ajaxTest4Get() {
		return "study/ajax/ajaxTest4";
	}
	
	@ResponseBody
	@PostMapping("/ajaxTest4")
	public List<String> ajaxTest4Post(String dodo) {
		return studyService.getCityArrayList(dodo);
	}

	@GetMapping("/ajaxTest5")
	public String ajaxTest5Get() {
		return "study/ajax/ajaxTest5";
	}

	@ResponseBody
	@PostMapping("/ajaxTest5")
	public Map<Object, Object> ajaxTest5Post(String dodo) {
		Map<Object, Object> map = new HashMap<Object, Object>();
		map.put("city", studyService.getCityArrayList(dodo));
		return map;
	}

	@GetMapping("/ajaxTest6")
	public String ajaxTest6Get(Model model) {
		List<String> midVos = studyService.getUserMidList();
		model.addAttribute("midVos", midVos);
		List<User2VO> genderVos = studyService.getUserGenderSearch();
		model.addAttribute("genderVos", genderVos);
		return "study/ajax/ajaxTest6";
	}
	
	@ResponseBody
	@PostMapping(value="/ajaxTest6", produces="application/text; charset=utf-8")
	public String ajaxTest6Post(String mid) {
		User2VO vo = studyService.getUserMidSearch(mid);
		String str="<h3>회원정보</h3>";
		str+="회원 고유번호 : " + vo.getIdx() + "<br>";
		str+="회원 아이디 : " + vo.getMid() + "<br>";
		str+="회원 이름 : " + vo.getName() + "<br>";
		str+="회원 나이 : " + vo.getAge() + "<br>";
		str+="회원 성별 : " + vo.getGender() + "<br>";
		str+="회원 주소 : " + vo.getAddress() + "<br>";
		return str;
	}
	
	@ResponseBody
	@PostMapping("/ajaxTest6_2")
	public User2VO ajaxTest6_2Post(String mid) {
		return studyService.getUserMidSearch(mid);
	}
	
	@ResponseBody
	@PostMapping("/ajaxTest6_3")
	public List<User2VO> ajaxTest6_3Post(String gender) {
		return studyService.getUserGenderList(gender);
	}
	
	@ResponseBody
	@PostMapping(value="/ajaxSearch1", produces="application/text; charset=utf-8")
	public String ajaxSearch1Post(String mid) {
		User2VO vo = studyService.getUserSearch(mid);
		String str="<h3>회원정보</h3>";
		if(vo == null) {
			str += "검색된 회원이 없습니다.";
			return str;
		}
		
		str += "회원 고유번호 : " + vo.getIdx() + "<br>";
		str += "회원 아이디 : " + vo.getMid() + "<br>";
		str += "회원 이름 : " + vo.getName() + "<br>";
		str += "회원 나이 : " + vo.getAge() + "<br>";
		str +="회원 성별 : " + vo.getGender() + "<br>";
		str +="회원 주소 : " + vo.getAddress() + "<br>";
		return str;
	}
	
	@ResponseBody
	@PostMapping(value="/ajaxSearch2", produces="application/text; charset=utf-8")
	public String ajaxSearch2Post(String mid) {
		List<User2VO> vos = studyService.getUserSearchList(mid);
		
		String str = "";
		str += "<h3 class='text-center'>회원정보</h3>";

		if(vos.isEmpty()) {
			str += "검색된 회원이 없습니다.";
			return str;
		}
		str += "<table class='table table-hover text-center'>";
		str += "<tr class='table-secondary'>";
		str += "<th>고유번호</th><th>아이디</th><th>이름</th><th>나이</th><th>성별</th><th>주소</th>";
		str += "</tr>";
		for(User2VO vo : vos) {
			str += "<tr>";
			str += "<td>"+vo.getIdx()+"</td>";
			str += "<td>"+vo.getMid()+"</td>";
			str += "<td>"+vo.getName()+"</td>";
			str += "<td>"+vo.getAge()+"</td>";
			str += "<td>"+vo.getGender()+"</td>";
			str += "<td>"+vo.getAddress()+"</td>";
			str += "</tr>";
		}
		str += "</table>";
		return str;
	}

	@GetMapping("/fileUpload")
	public String fileUploadGet() {
		return "study/fileUpload/fileUploadForm";
	}
	
	@PostMapping("/fileUpload")
	public String fileUploadPost(MultipartFile fName, String name, HttpServletRequest request) throws IOException {
//		String realPath = request.getRealPath("");
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/fileUpload/");
		
		String uid = UUID.randomUUID().toString().substring(0, 8);
		
		String originalFilename = fName.getOriginalFilename();
		
		String file = originalFilename.substring(0, originalFilename.lastIndexOf(".")) + uid + originalFilename.substring(originalFilename.lastIndexOf("."));
		
		
		
		FileOutputStream fos = new FileOutputStream(realPath+file);
		
		fos.write(fName.getBytes());
		
		fos.close();
		
		return "redirect:/message/fileUploadOk";
	}
	
	@PostMapping("/fileUpload2")
	public String fileUpload2Post(MultipartFile fName, String name, HttpServletRequest request) {
//		int res = studyService.fileUpload(fName, name, request);
		int res = projectProvide.fileUpload(fName, "fileUpload", name);
		
		if(res != 0) return "redirect:/message/fileUploadOk";
		else return "redirect:/message/fileUploadNo";
		
	}
	
	@GetMapping("/mailForm")
	public String mailFormGet(Model model) {
		List<MemberVO> vos = memberService.getMemberEmailList();
		model.addAttribute("vos", vos);
		return "study/mail/mailForm";
	}
	
	@PostMapping("/mailForm")
	public String mailFormPost(HttpServletRequest request, MailVO vo) throws MessagingException {
		String toMail = vo.getToMail();
		String title = vo.getTitle();
		String content = vo.getContent();
		
		// 메일 전송을 위한 객체 : MimeMessage(), MimeMessageHelper()
		MimeMessage message = javaMailSender.createMimeMessage();
		MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
		
		// 메세지 보관함 정리
		helper.setTo(toMail);
		helper.setSubject(title);
		helper.setText(content);
		
		// 메세지 보관함에 발신자의 필요한 정보를 추가로 포함시킨다.
		content = content.replace("\n", "<br>");
		content += "<br><hr><h3>GreenStudyS에서 보낸 메세지</h3><hr><br>";
		content += "<p><img src=\"cid:main.png\" width='500px'></p>";
		content += "<p>방문하기 : <a href='http://49.142.157.251:9090/cjgreen'>그린아카데미</a></p>";
		content += "<hr>";
		
		
		helper.setText(content, true);
		
//		FileSystemResource resource = new FileSystemResource("/Users/ihyeongjin/Develop/springFramework/workSpace/greenStudyS/src/main/webapp/resources/images/main.png");
		FileSystemResource resource = new FileSystemResource(request.getSession().getServletContext().getRealPath("/resources/images/main.png"));
		helper.addInline("main.png", resource);
		
		// 첨부파일 보내기
		resource = new FileSystemResource(request.getSession().getServletContext().getRealPath("/resources/images/11.jpg"));
		helper.addInline("11.jpg", resource);
		resource = new FileSystemResource(request.getSession().getServletContext().getRealPath("/resources/images/12.jpg"));
		helper.addAttachment("12.jpg", resource);
		
		javaMailSender.send(message);
		
		return "redirect:/message/mailSendOk";
	}
	
	@PostMapping("/mailFormOk")
	public String mailFormOkPost(MailVO vo){
		int res = 0;
		String[] toMails = vo.getToMail().split(",");
		
		try {
			for(int i=0; i<toMails.length; i++) {
				projectProvide.mailSend(toMails[i].trim(), vo.getTitle(), "메일연습");
			}
			res = 1;
		} 
		catch (MessagingException e) {
			e.printStackTrace();
		}
		
		if(res != 0 ) return "redirect:/message/mailSendOk"; 
		else return "redirect:/message/mailSendNo";
	}
	
	@GetMapping("/passwordForm")
	public String passwordFormGet() {
		return "study/password/passwordForm";
	}
	
	// SHA256
	@ResponseBody
	@PostMapping(value="/passwordSha256", produces="application/text; charset=utf-8")
	public String passwordSha256Post(String pwd) {
		UUID uid = UUID.randomUUID();
		String salt = uid.toString().substring(0, 8);
		
		SecurityUtil security = new SecurityUtil();
		String encPwd = security.encryptSHA256(salt + pwd);
		
		pwd = "salt키 : " + salt + " | 암호화된 비밀번호 : " + encPwd;
		
		return pwd;
	}
	
	// ARIA
	@ResponseBody
	@PostMapping(value="/passwordAria", produces="application/text; charset=utf-8")
	public String passwordAriaPost(String pwd) throws InvalidKeyException, UnsupportedEncodingException {
		UUID uid = UUID.randomUUID();
		String salt = uid.toString().substring(0, 8);
		
		String encPwd = ARIAUtil.ariaEncrypt(salt + pwd);
		String decPwd = ARIAUtil.ariaDecrypt(encPwd);
		
		
		pwd = "salt키 : " + salt + " | 암호화된 비밀번호 : " + encPwd + 
					"<br> 복호화한 비밀번호 : " + decPwd.substring(8);
		
		return pwd;
	}
	
	// bCryptPasswordEncoder
	@ResponseBody
	@PostMapping(value="/passwordEncoder", produces="application/text; charset=utf-8")
	public String passwordEncoderPost(String pwd) throws InvalidKeyException, UnsupportedEncodingException {
		
		String encPwd = passwordEncoder.encode(pwd);
		
		pwd = "암호화된 비밀번호 : " + encPwd;
		
		return pwd;
	}
	
}


