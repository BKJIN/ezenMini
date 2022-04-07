package com.jim.ezenpj;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.transaction.annotation.Transactional;

import com.jim.ezenpj.dao.MiniDao;
import com.jim.ezenpj.dto.JoinDto;

@WebAppConfiguration
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml")
@Transactional
public class JoinTest {

@Autowired
private MiniDao mdao;

//@Test
//public void join() {
//	
//	JoinDto dto = new JoinDto("pid", "ppw", "paddress", "phobby", "pprofile");
//	
//	String result = mdao.join(dto);
//	
//	System.out.println(result);
//	
//}

@Test
public void login() {
	
	String bId = "jmdh1004@gmail.com";
	JoinDto s = mdao.login(bId);
	System.out.println(s);
} 

}
