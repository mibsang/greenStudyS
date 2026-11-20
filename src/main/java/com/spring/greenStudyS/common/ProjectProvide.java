package com.spring.greenStudyS.common;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.UUID;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

import com.spring.greenStudyS.vo.MailVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class ProjectProvide {

	@Autowired
	JavaMailSender javaMailSender;
	
	// ajax용
	public int fileUpload(MultipartFile fName, String path, String name) {
		int res = 0;
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/"+path+"/");
		String uid = UUID.randomUUID().toString().substring(0, 8);
		String originalFilename = fName.getOriginalFilename();
		String file = originalFilename.substring(0, originalFilename.lastIndexOf(".")) + uid + originalFilename.substring(originalFilename.lastIndexOf("."));
		
		FileOutputStream fos = null;
		try {
			fos = new FileOutputStream(realPath+file);
			if(fName.getBytes().length != -1) {
				fos.write(fName.getBytes());
				res = 1;
			}
		} 
		catch (IOException e) {
			System.out.println("파일업로드 실패 : " + e.getMessage());
		}
		finally {
			try {
				fos.close();
			} 
			catch (IOException e) {}
		}
		log.info("파일업로더 : {}", name);
		return res;
	}
	
	// 일반적 파일처리
	public String uploadFile(MultipartFile fName, String path, String name) {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/"+path+"/");
		String uid = UUID.randomUUID().toString().substring(0, 8);
		String originalFilename = fName.getOriginalFilename();
		String file = originalFilename.substring(0, originalFilename.lastIndexOf(".")) + uid + originalFilename.substring(originalFilename.lastIndexOf("."));
		
		FileOutputStream fos = null;
		try {
			fos = new FileOutputStream(realPath+file);
			if(fName.getBytes().length != -1) {
				fos.write(fName.getBytes());
			}
		} 
		catch (IOException e) {
			System.out.println("파일업로드 실패 : " + e.getMessage());
		}
		finally {
			try {
				fos.close();
			} 
			catch (IOException e) {}
		}
		log.info("파일업로더 : {}", name);
		
		return file;
	}
	
	
	public String mailSend(String eMail, String title, String flag) throws MessagingException {
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		
		String content = "";
		// 메일 전송을 위한 객체 : MimeMessage(), MimeMessageHelper()
		MimeMessage message = javaMailSender.createMimeMessage();
		MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
		
		// 메세지 보관함 정리
		helper.setTo(eMail);
		helper.setSubject(title);
		helper.setText(content);
		
		// 메세지 보관함에 발신자의 필요한 정보를 추가로 포함시킨다.(예_발신자가 임시 비밀번호를 요청할 때)
		content = content.replace("\n", "<br>");
		content += "<br><hr><h3>GreenStudyS에서 보낸 메세지</h3><hr><br>";
		content += flag + "<br>";
		content += "<p><img src=\"cid:main.png\" width='100%' height='160px'></p>";
		content += "<hr>";
		content += "<p>방문하기 : <a href='http://49.142.157.251:9090/cjgreen'>그린아카데미</a></p>";
		
		
		helper.setText(content, true);
		
		FileSystemResource resource = new FileSystemResource(request.getSession().getServletContext().getRealPath("/resources/images/main.png"));
		helper.addInline("main.png", resource);
		
//		첨부파일 보내기
//		resource = new FileSystemResource(request.getSession().getServletContext().getRealPath("/resources/images/11.jpg"));
//		helper.addInline("11.jpg", resource);
		
		javaMailSender.send(message);
		
		return "redirect:/message/mailSendOk";
	}

	public void deleteFile(String fileName, String path) {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/"+path+"/");
		File file = new File(realPath + fileName);
		if(file.exists()) file.delete();
	}

	public void writeFile(MultipartFile file, String sFileName, String path) {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/"+path+"/");
		
		FileOutputStream fos = null;
		try {
			fos = new FileOutputStream(realPath+sFileName);
			if(file.getBytes().length != -1) {
				fos.write(file.getBytes());
			}
		} 
		catch (IOException e) {
			System.out.println("파일업로드 실패 : " + e.getMessage());
		}
		finally {
			try {
				fos.close();
			} 
			catch (IOException e) {}
		}
	}
	
}
