package com.jim.ezenpj.miniCommand;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.jim.ezenpj.dao.MiniDao;
import com.jim.ezenpj.dto.ProductDto;
import com.jim.ezenpj.util.Constant;

public class ProductListCommand implements MiniCommand {

	@Override
	public void execute(Model model, HttpServletRequest request) {
		MiniDao mdao = Constant.mdao;
		ArrayList<ProductDto> dtos = mdao.productList();
		request.setAttribute("productList", dtos);
		
	}

}
