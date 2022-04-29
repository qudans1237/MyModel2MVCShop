package com.model2.mvc.web.pick;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;

import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.domain.User;
import com.model2.mvc.service.domain.Pick;

import com.model2.mvc.service.pick.PickService;
import com.model2.mvc.service.pick.impl.PickServiceImpl;
import com.model2.mvc.service.product.ProductService;
import com.model2.mvc.service.user.UserService;

//==> Âò°ü¸®
@Controller
@RequestMapping("/pick/*")
public class PickController {
	
	@Autowired
	@Qualifier("pickServiceImpl")
	private PickService pickService;

	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	@Autowired
	@Qualifier("userServiceImpl")
	private UserService userService;
	
	public PickController() {
		System.out.println(this.getClass());
	}
	
	@Value("#{commonProperties['pageUnit']}")
	// @Value("#{commonProperties['pageUnit'] ?: 3}")
	int pageUnit;

	@Value("#{commonProperties['pageSize']}")
	// @Value("#{commonProperties['pageSize'] ?: 2}")
	int pageSize;
	
	@RequestMapping(value = "addPick", method = RequestMethod.GET)
	public String addPurchase(@RequestParam("prodNo") int prodNo, HttpServletRequest request,
			@ModelAttribute("pick") Pick pick) throws Exception {

		System.out.println("/pick/addPick : GET");

		Product product = productService.getProduct(prodNo);
		User user = (User) request.getSession().getAttribute("user");

		pick.setBuyer(user);
		pick.setPickProd(product);
		
		pickService.addPick(pick);

		return "forward:/pick/listPick";
	}
	
	@RequestMapping(value="listPick")
	public String listPick(@ModelAttribute("search") Search search, Model model , HttpServletRequest request) throws Exception{
		System.out.println("/pick/listPick : GET / POST");

		if (search.getCurrentPage() == 0) {
			search.setCurrentPage(1);
		}
		search.setPageSize(pageSize);

		User user = (User) request.getSession().getAttribute("user");
		String buyerId = user.getUserId();
		// System.out.println("session buyerid : " + buyerId);

		Map<String, Object> map = pickService.getPickList(search, buyerId);

		Page resultPage = new Page(search.getCurrentPage(), ((Integer) map.get("totalCount")).intValue(), pageUnit,
				pageSize);
		System.out.println(resultPage);
		
		List list = (List) map.get("list");
		for (int i = 0; i < list.size(); i++) {
			Pick pick = (Pick) list.get(i);
			int prodNo = pick.getPickProd().getProdNo();
			Product product = productService.getProduct(prodNo);
			pick.setPickProd(product);
			list.set(i, pick);
		}
		model.addAttribute("list", map.get("list"));
		System.out.println("############"+map);
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("search", search);
		System.out.println("@@@@@@@@@model :" + model);
		
		return "forward:/pick/listPick.jsp";
	}
	
	@RequestMapping(value="deletePick", method = RequestMethod.GET)
	public String deletePick(@ModelAttribute("pick") Pick pick, @RequestParam("prodNo") int prodNo) throws Exception {
		
		System.out.println("/pick/deletePick : GET");
		System.out.println("@@@@@@@@@@"+prodNo);
		Product product = productService.getProduct(prodNo);
		
		pick.setPickProd(product);
		pickService.deletePick(prodNo);
		
		return "forward:/pick/listPick";
	}
}
