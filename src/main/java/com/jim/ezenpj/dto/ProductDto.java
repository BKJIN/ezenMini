package com.jim.ezenpj.dto;

//cusine db�� ���εǴ� dto(�޴� product��)
public class ProductDto {
	private String rPhoto; //�丮�����̸�(��Ű)
	private String rCusine; //�丮 ī�װ�
	private String rName; //�Ĵ��
	private String rTitle; //�丮��
	private String rContent; //�丮����
	
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
