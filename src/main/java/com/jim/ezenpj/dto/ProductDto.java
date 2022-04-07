package com.jim.ezenpj.dto;

//cusine db와 매핑되는 dto(메뉴 product용)
public class ProductDto {
	private String rPhoto; //요리사진이름(주키)
	private String rCusine; //요리 카테고리
	private String rName; //식당명
	private String rTitle; //요리명
	private String rContent; //요리정보
	
	public ProductDto() {
		super();
	}

	public ProductDto(String rPhoto, String rCusine, String rName, String rTitle, String rContent) {
		super();
		this.rPhoto = rPhoto;
		this.rCusine = rCusine;
		this.rName = rName;
		this.rTitle = rTitle;
		this.rContent = rContent;
	}

	public String getrPhoto() {
		return rPhoto;
	}

	public void setrPhoto(String rPhoto) {
		this.rPhoto = rPhoto;
	}

	public String getrCusine() {
		return rCusine;
	}

	public void setrCusine(String rCusine) {
		this.rCusine = rCusine;
	}

	public String getrName() {
		return rName;
	}

	public void setrName(String rName) {
		this.rName = rName;
	}

	public String getrTitle() {
		return rTitle;
	}

	public void setrTitle(String rTitle) {
		this.rTitle = rTitle;
	}

	public String getrContent() {
		return rContent;
	}

	public void setrContent(String rContent) {
		this.rContent = rContent;
	}
	
}
