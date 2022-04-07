package com.jim.ezenpj.miniCommand;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.ui.Model;

import com.jim.ezenpj.util.Constant;
import com.jim.ezenpj.dao.MiniDao;
import com.jim.ezenpj.dto.JoinDto;

public class JoinCommand implements MiniCommand {

	@Override
	public void execute(Model model, HttpServletRequest request) {
		BCryptPasswordEncoder passwordEncoder = Constant.passwordEncoder;
		String bId = request.getParameter("pid");
		String bPw = request.getParameter("ppw");
		String baddress = request.getParameter("paddress");
		String bhobby = request.getParameter("phobby");
		String bprofile = request.getParameter("pprofile");
	
		String bPw_org = bPw; //bpw는 암호화 되기전 password인데 bPw_org에 저장
		bPw = passwordEncoder.encode(bPw_org); //여기서 bPw는 암호화됨
		System.out.println(bPw + " size " + bPw.length());
		
		JoinDto dto = new JoinDto(bId,bPw,baddress,bhobby,bprofile);
		
		MiniDao mdao = Constant.mdao;
		
		String result = mdao.join(dto);
		
		request.setAttribute("result", result); //controller에서 결과 사용
		
	} 

}
