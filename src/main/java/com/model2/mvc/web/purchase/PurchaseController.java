package com.model2.mvc.web.purchase;

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
import com.model2.mvc.service.product.ProductService;
import com.model2.mvc.service.purchase.PurchaseService;
import com.model2.mvc.service.purchase.impl.PurchaseServiceImpl;
import com.model2.mvc.service.user.UserService;
import com.model2.mvc.service.user.impl.UserServiceImpl;

//==> ȸ������ Controller
@Controller
@RequestMapping("/purchase/*")
public class PurchaseController {

	/// Field
	@Autowired
	@Qualifier("purchaseServiceImpl")
	private PurchaseService purchaseService;

	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	@Autowired
	@Qualifier("userServiceImpl")
	private UserService userService;
	// setter Method ���� ����

	public PurchaseController() {
		System.out.println(this.getClass());
	}

	// ==> classpath:config/common.properties , classpath:config/commonservice.xml
	// ���� �Ұ�
	// ==> �Ʒ��� �ΰ��� �ּ��� Ǯ�� �ǹ̸� Ȯ�� �Ұ�
	@Value("#{commonProperties['pageUnit']}")
	// @Value("#{commonProperties['pageUnit'] ?: 3}")
	int pageUnit;

	@Value("#{commonProperties['pageSize']}")
	// @Value("#{commonProperties['pageSize'] ?: 2}")
	int pageSize;

	@RequestMapping(value = "addPurchaseView", method = RequestMethod.GET)
	public String addPurchaseView(@RequestParam("prodNo") int prodNo, Model model) throws Exception {

		System.out.println("/purchase/addPurchaseView : GET");

		Product product = productService.getProduct(prodNo);

		model.addAttribute("product", product);

		System.out.println(product);

		return "forward:/purchase/addPurchaseView.jsp";
	}

	@RequestMapping(value = "addPurchase", method = RequestMethod.POST)
	public String addPurchase(@RequestParam("prodNo") int prodNo, @RequestParam("buyerId") String buyerId,
			@ModelAttribute("purchase") Purchase purchase, @RequestParam("quantity") int quantity) throws Exception {

		System.out.println("/purchase/addPurchase : POST");

		Product product = productService.getProduct(prodNo);
		User user = userService.getUser(buyerId);

		purchase.setBuyer(user);
		purchase.setPurchaseProd(product);
		// ���, ����
		product.setStock(product.getStock() - quantity);
		System.out.println("�ٲ� ����? " + product.getStock());
		productService.updateStock(product);

		purchaseService.addPurchase(purchase);

		purchase.setPaymentOption(purchase.getPaymentOption().trim());

		return "forward:/purchase/addPurchaseViewResult.jsp";
	}

	@RequestMapping(value = "getPurchase")
	public String getPurchase(@RequestParam("tranNo") int tranNo, Model model) throws Exception {

		System.out.println("/purchase/getPurchase : GET / POST");

		Purchase purchase = purchaseService.getPurchase(tranNo);

		model.addAttribute("purchase", purchase);

		purchase.setPaymentOption(purchase.getPaymentOption().trim());

		return "forward:/purchase/getPurchaseView.jsp";

	}

	@RequestMapping(value = "listPurchase")
	public String listPurchase(@ModelAttribute("search") Search search, Model model, HttpServletRequest request)
			throws Exception {

		System.out.println("/purchase/listPurchase : GET / POST");

		if (search.getCurrentPage() == 0) {
			search.setCurrentPage(1);
		}
		search.setPageSize(pageSize);

		User user = (User) request.getSession().getAttribute("user");
		String buyerId = user.getUserId();
		// System.out.println("session buyerid : " + buyerId);

		Map<String, Object> map = purchaseService.getPurchaseList(search, buyerId);

		Page resultPage = new Page(search.getCurrentPage(), ((Integer) map.get("totalCount")).intValue(), pageUnit,
				pageSize);
		System.out.println(resultPage);

		List list = (List) map.get("list");

		for (int i = 0; i < list.size(); i++) {
			Purchase purchase = (Purchase) list.get(i);
			int prodNo = purchase.getPurchaseProd().getProdNo();
			Product product = productService.getProduct(prodNo);
			purchase.setPurchaseProd(product);
			list.set(i, purchase);
		}
		model.addAttribute("list", map.get("list"));
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("search", search);
		System.out.println("model :" + model);

		return "forward:/purchase/listPurchase.jsp";
	}

	@RequestMapping(value = "updatePurchase", method = RequestMethod.POST)
	public String updatePurchase(@ModelAttribute("Purchase") Purchase purchase, @RequestParam("tranNo") int tranNo,
			Model model) throws Exception {

		System.out.println("/purchase/updatePurchase : POST");

		purchase.setTranNo(tranNo);
		purchaseService.updatePurchase(purchase);

		model.addAttribute("purchase", purchase);

		return "forward:/purchase/getPurchase";
	}

	@RequestMapping(value = "updatePurchaseView", method = RequestMethod.GET)
	public String updatePurchaseView(@ModelAttribute("Purchase") Purchase purchase, @RequestParam("tranNo") int tranNo,
			Model model) throws Exception {

		System.out.println("/purchase/updatePurchaseView : GET");

		purchase = purchaseService.getPurchase(tranNo);

		model.addAttribute("purchase", purchase);

		return "forward:/purchase/updatePurchaseView.jsp";

	}

	@RequestMapping(value = "updateTranCodeByProd", method = RequestMethod.GET)
	public String updateTranCodeByProd(@ModelAttribute("Purchase") Purchase purchase,
			@ModelAttribute("Product") Product product, @RequestParam("tranCode") String tranCode,
			@RequestParam("prodNo") int prodNo,@RequestParam("tranNo") int tranNo) throws Exception {

		System.out.println("/purchase/updateTranCodeByProd : GET");

		//System.out.println("sotck Ȯ�� !!" + (productService.getProduct(prodNo)).getStock());
	
		System.out.println("trancode Ȯ��:" + tranCode);

		product.setProdNo(prodNo);
		purchase.setPurchaseProd(product);
		purchase.setTranNo(tranNo);
		System.out.println("@@@@@@@"+tranNo);
		//purchase.setQuantity((purchaseService.getPurchase2(prodNo)).getQuantity());
		purchase.setTranCode(tranCode);
		purchase.setQuantity((purchaseService.getPurchase(tranNo)).getQuantity());
		System.out.println("1" + purchase);
		purchaseService.updateTranCode(purchase);

		if (tranCode.equals("4")) {

			System.out.println("���� ��������?");
			product.setStock((productService.getProduct(prodNo)).getStock()
					+ (purchaseService.getPurchase2(prodNo)).getQuantity());
			productService.updateStock(product);

		}

		System.out.println("2" + purchase);
		System.out.println("2" + product);

		return "forward:/purchase/shippingList?prodNo=" + prodNo;
	}

	@RequestMapping(value = "updateTranCode", method = RequestMethod.GET)
	public String updateTranCode(@RequestParam("tranCode") String tranCode, @RequestParam("tranNo") int tranNo,
			@ModelAttribute("Product") Product product) throws Exception {

		System.out.println("/purchase/updateTranCode : GET");

		Purchase purchase = purchaseService.getPurchase(tranNo);

		product.setProdNo(purchase.getPurchaseProd().getProdNo());

		purchase.setTranCode(tranCode);
		purchase.setPurchaseProd(product);

		purchaseService.updateTranCode(purchase);

		return "forward:/purchase/listPurchase?tranNo=" + tranNo;
	}

	@RequestMapping(value = "shippingList")
	public String shippingList(@ModelAttribute("search") Search search, Model model) throws Exception {

		System.out.println("/purchase/shippingList : GET / POST");

		if (search.getCurrentPage() == 0) {
			search.setCurrentPage(1);
		}
		search.setPageSize(pageSize);

		// Business logic ����
		Map<String, Object> map = purchaseService.getShippingList(search);

		System.out.println("map�� : " + map);
		System.out.println("list�� : " + map.get("list"));
		List list = (List) map.get("list");

		for (int i = 0; i < list.size(); i++) {

			Purchase purchase = (Purchase) list.get(i);
			int prodNo = purchase.getPurchaseProd().getProdNo();
			Product product = productService.getProduct(prodNo);
			product.setProTranCode(purchase.getTranCode());
			purchase.setPurchaseProd(product);
			list.set(i, purchase);
			// list.set(i, product);
		}

		Page resultPage = new Page(search.getCurrentPage(), ((Integer) map.get("totalCount")).intValue(), pageUnit,
				pageSize);
		System.out.println(resultPage);

		// Model �� View ����
		model.addAttribute("list", map.get("list"));
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("search", search);

		return "forward:/purchase/shippingList.jsp";
	}

}