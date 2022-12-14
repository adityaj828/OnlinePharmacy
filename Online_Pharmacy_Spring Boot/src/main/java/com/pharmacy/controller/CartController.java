package com.pharmacy.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.pharmacy.model.DistributorItemBean;
import com.pharmacy.service.DistributorItemService;

@Controller
@PreAuthorize("hasRole('USER')")
public class CartController {

	
	private static final String CARTLIST="cartList";
	private static final String MESSAGE="message";

	@Autowired
	private DistributorItemService distributorService;
	
	public List<DistributorItemBean> updateCart(List<DistributorItemBean> items,String []values) {
		int i=0;
		for(DistributorItemBean item:items) {
			item.setQuantity(Integer.parseInt(values[i]));
			items.set(i, item);
			i++;
		}
		return items;
	}
	
	@GetMapping("/addtocart")
	public String addToCart(@RequestParam("id") int id,HttpServletRequest request,Model model) {
		List<DistributorItemBean> items=new ArrayList<>();
		DistributorItemBean item=new DistributorItemBean();
		item.setId(id);
		HttpSession session=request.getSession();
		@SuppressWarnings("unchecked")
		List<DistributorItemBean> existingCart=(ArrayList<DistributorItemBean>)session.getAttribute(CARTLIST);
		if(existingCart==null) {
			item=distributorService.getItemById(id);
			items.add(item);
			session.setAttribute(CARTLIST, items);
			model.addAttribute(MESSAGE, "Added to cart");
		}	
		else {
			items=existingCart;
			boolean  exist=false;
			for(DistributorItemBean i:items) {
				if(i.getId()==id) {
					exist =true;
					model.addAttribute(MESSAGE, "Already existing in cart");
					
				}
			}
			if(!exist) {
				item=distributorService.getItemById(id);
				existingCart.add(item);
				session.setAttribute(CARTLIST, existingCart);
				model.addAttribute(MESSAGE, "Added to cart");		
			}
		}
		return "itemslist";
	}
	
	@PostMapping("/updatecart")
	public String updateCart(HttpServletRequest request) {
		String []values=request.getParameterValues("quantity");
		String check=request.getParameter("checkbox");
		HttpSession session=request.getSession();
		@SuppressWarnings("unchecked")
		List<DistributorItemBean> items=(ArrayList<DistributorItemBean>) session.getAttribute(CARTLIST);
		boolean redirect=false;
		if(check.equals("update")) {
			items=this.updateCart(items, values);
			session.setAttribute(CARTLIST, items);
			redirect=true;
			
		}
		else if(check.equals("clear")) {
			session.setAttribute(CARTLIST, null);
			session.removeAttribute("category");
			session.removeAttribute("distributor");
			redirect=true;
		}
		else if(check.equals("checkout")) {
			items=this.updateCart(items, values);
			session.setAttribute(CARTLIST, items);
			
		}
		
		if(redirect) {
			return "redirect:/yourcart";
		}
		else {
			return "bill";
		}
	}
}
