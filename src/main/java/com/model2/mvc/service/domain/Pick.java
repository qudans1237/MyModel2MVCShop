package com.model2.mvc.service.domain;

import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.domain.User;

public class Pick {
	private User buyer;
	private Product pickProd;

	
	public User getBuyer() {
		return buyer;
	}

	public void setBuyer(User buyer) {
		this.buyer = buyer;
	}

	public Product getPickProd() {
		return pickProd;
	}

	public void setPickProd(Product pickProd) {
		this.pickProd = pickProd;
	}
	@Override
	public String toString() {
		return "Pick [buyer=" + buyer + ", pickProd=" + pickProd + "]";
	}

}
