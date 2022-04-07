package com.jim.ezenpj.miniCommand;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.jim.ezenpj.dao.MiniDao;
import com.jim.ezenpj.dto.BoardDto;
import com.jim.ezenpj.util.Constant;

public class BoardContentCommand implements MiniCommand {

	@Override
	public void execute(Model model, HttpServletRequest request) {
		MiniDao mdao = Constant.mdao;
		String bid = request.getParameter("bId");
		System.out.println(bid);
		BoardDto dto = mdao.contentView(bid);
		if(dto != null) {
			model.addAttribute("content_view",dto);
		}
	
	}

}
