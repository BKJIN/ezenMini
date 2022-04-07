package com.jim.ezenpj.miniCommand;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.jim.ezenpj.dao.MiniDao;
import com.jim.ezenpj.dto.ProductDto;
import com.jim.ezenpj.util.Constant;

public class ProductWriteCommand implements MiniCommand {

	@Override
	public void execute(Model model, HttpServletRequest request) {
		MiniDao mdao = Constant.mdao;
		ProductDto pdto = (ProductDto) request.getAttribute("pdto");
		
		String result = mdao.productWrite(pdto);
		
		model.addAttribute("result",result);
	}

}
